//
//  SearchOffline.swift
//  ATLAS
//
//  Created by phuong phan on 25/05/2023.
//

import SwiftUI
import SimilaritySearchKit
import SimilaritySearchKitDistilbert
import UIKit
import MobileCoreServices
import PDFKit
import QuickLookThumbnailing
import Foundation
import CoreML


struct SearchOfflineView: View {
    //@State private var documentText: String = ""
    @State private var documentText: [String: String] = [:]
    @State private var fileName: String = ""
    @State private var fileIcon: UIImage? = nil
    @State private var totalCharacters: Int = 0
    @State private var totalTokens: Int = 0
    @State private var progress: Double = 0
    //@State private var chunks: [String] = []
    @State private var chunks: [SimilarityIndex.IndexItem] = []
    @State private var embeddings: [[Float]] = []
    @State private var searchText: String = ""
    @State private var searchResults: [String] = []
    @State private var isLoading: Bool = false

    @State private var similarityIndex: SimilarityIndex?
    
    //app view wrapper
    var body: some View {
        VStack {
            Text("🔍 PDF Search") //not required search view, to auto load the PDF files, and perform embedding
                .font(.largeTitle)
                .bold()
                .padding()

            Button(action: selectFromFiles) {
                Text("📂 Select PDF to Search")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: 500)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding()

            if !fileName.isEmpty {
                HStack {
                    if let fileIcon = fileIcon {
                        Image(uiImage: fileIcon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .cornerRadius(8)
                    }

                    VStack(alignment: .leading) {
                        Text("File: \(fileName)")
                            .font(.headline)
                        Text("🔡 Total Tokens: \(totalTokens)")
                    }
                }
                .padding()

                Button("🤖 Create Embedding Vectors") {
                    vectorizeChunksbyPages()
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: 500)
                .padding()
                .background(Color.blue)
                .cornerRadius(8)
                .padding()
            }

            if !embeddings.isEmpty {
                Text("🔢 Total Embeddings: \(embeddings.count)")
                    .font(.headline)
                    .padding()
                //if embeddings.count != chunks.count
                if embeddings.count != 131 {
                    //ProgressView(value: Double(embeddings.count), total: Double(chunks.count))
                    ProgressView(value: Double(embeddings.count), total: 131)
                        .frame(height: 10)
                        .frame(maxWidth: 500)
                        .padding()
                } else {
                    TextField("🔍 Search document", text: $searchText, onCommit: searchDocument)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .frame(maxWidth: 500)

                    List(searchResults, id: \.self) { result in
                        Text(result)
                    }
                    .frame(maxWidth: 500)
                }
            }
            Spacer()
        }
        .onAppear {
            loadIndex()
        }
    }
    
    func loadIndex() {
        Task {
            similarityIndex = await SimilarityIndex(name: "PDFIndex", model: DistilbertEmbeddings(), metric: DotProduct())
        }
    }

    // no need document picker
    func selectFromFiles() {
        let picker = DocumentPicker(document: $documentText, fileName: $fileName, fileIcon: $fileIcon, totalCharacters: $totalCharacters, totalTokens: $totalTokens)
        let hostingController = UIHostingController(rootView: picker)
        UIApplication.shared.connectedScenes
            .map { ($0 as? UIWindowScene)?.windows.first?.rootViewController }
            .compactMap { $0 }
            .first?
            .present(hostingController, animated: true, completion: nil)
    }
    
    func vectorizeChunksbyPages() {
        guard let index = similarityIndex else { return }
        chunks = index.indexItems
        embeddings = []

        Task {
            let splitter = RecursiveTokenSplitter(withTokenizer: BertTokenizer())
            var idx = 0
            for (pageKey, chunk) in documentText {
                let (splitText, _) = splitter.split(text: chunk, chunkSize: 510)
                var embeddingsSplit: [[Float]] = []
                if let miniqa = index.indexModel as? DistilbertEmbeddings {
                    for split in splitText {
                        if let embedding = await miniqa.encode(sentence: split) {
                            embeddings.append(embedding)
                            embeddingsSplit.append(embedding)
                        }
                    }
                }
                for (idy, splitChunk) in splitText.enumerated() {
                    let chunkPageKey = "\(pageKey)"
                    let metadata = ["source": chunkPageKey]
                    await index.addItem(id: "id\(idx + idy)", text: splitChunk, metadata: metadata, embedding: embeddingsSplit[idy])
                }
                idx = idx + 1
            }
        }
    }


    func rankResults(_ results: [SimilarityIndex.SearchResult]) -> [SimilarityIndex.SearchResult] {
        let sortedResults = results.sorted { (result1, result2) -> Bool in
            if let score1 = result1.score as? Float, let score2 = result2.score as? Float {
                return score1 > score2
            }
            return false
        }
        
        let rankedResults = Array(sortedResults.prefix(3))
        return rankedResults
    }

    func extractAnswer(from refinedLLMPrompt: String, SearchText: String) -> [String : String] {
        let bert = BERT()
        let sentenceSplitter = SentenceSplitter()
        let refinedChunks = sentenceSplitter.split(text: refinedLLMPrompt)
        var answer = ""
        var selectedChunk = ""
        
        for chunk in refinedChunks {
            answer = String(bert.findAnswer(for: SearchText, in: chunk))
            
            if answer != "Couldn't find a valid answer. Please try again." || answer != "The BERT model is unable to make a prediction." {
                selectedChunk = chunk
                break
            }
        }
        
        return ["answer": answer, "selectedChunk": selectedChunk]
    }

    func reindexAndRefineSearch(results: [SimilarityIndex.SearchResult], searchText: String) async -> [SimilarityIndex.SearchResult] {
        guard let newIndex = similarityIndex else { return [] }
        newIndex.removeAll()
        let splitter = RecursiveTokenSplitter(withTokenizer: BertTokenizer())
        var idx = 0
        var embeddings: [[Float]] = []
        
        for result in results {
            let (splitText, _) = splitter.split(text: result.text, chunkSize: 40)
            let chunks = splitText
            
            if let miniqa = newIndex.indexModel as? DistilbertEmbeddings {
                for chunk in chunks {
                    if let embedding = await miniqa.encode(sentence: chunk) {
                        embeddings.append(embedding)
                    }
                }
            }
            
            for (idy, chunk) in chunks.enumerated() {
                await newIndex.addItem(id: "id\(idx + idy)", text: chunk, metadata: result.metadata, embedding: embeddings[idy])
            }
            idx += chunks.count
        }
        
        let refinedResults = await newIndex.search(searchText, top: 1)
        
        return refinedResults
    }
    

    func searchDocument() {
        guard let index = similarityIndex else { return }

        Task {
            let results = await index.search(searchText, top: 6)
            print("INITIAL RESULTS: ", results)
            // Sort by top 3
            let rankedResults = rankResults(results)
            print("\nRANKED RESULTS: ", rankedResults)

            let llmPrompt = SimilarityIndex.combinedResultsString(rankedResults)
            print(llmPrompt)

            // Reindex and refine the search
            let refinedResults = await reindexAndRefineSearch(results: rankedResults, searchText: searchText)
            print("\nREFINED RESULTS: ", refinedResults)

            processRefinedResults(refinedResults)
        }
    }

    func processRefinedResults(_ refinedResults: [SimilarityIndex.SearchResult]) {
        if let firstResult = refinedResults.first {
            let title = firstResult.metadata
            let refinedLLMPrompt = SimilarityIndex.combinedResultsString(refinedResults)
            print(refinedLLMPrompt)

            let extractedAnswer = extractAnswer(from: refinedLLMPrompt, SearchText: searchText)
            let answer = extractedAnswer["answer"] ?? ""
            let selectedChunk = extractedAnswer["selectedChunk"] ?? ""

            handleAnswerResult(answer, selectedChunk, title)
        } else {
            print("No refined results found.")
            searchResults = ["No refined results found."]
        }
    }

    func handleAnswerResult(_ answer: String, _ selectedChunk: String, _ title: [String:String]) {
        // If answer found, return source and title
        if !answer.isEmpty {
            let docsource = title["source"]
            // Print the generated text
            print("Final generated answer:", answer)
            print("Source:", selectedChunk)
            print("Document:", docsource ?? "")
            let finalResult = generateFinalResult(answer: answer, selectedChunk: selectedChunk, docsource: docsource ?? "")
            searchResults = finalResult
        } else {
            print("Couldn't find a valid answer. Please try again.")
            searchResults = ["Couldn't find a valid answer. Please try again."]
        }
    }

    func generateFinalResult(answer: String, selectedChunk: String, docsource: String) -> [String] {
        let finalResult = ["Final generated answer: \(answer)\n\nSource: \(selectedChunk)\n\nDocument: \(docsource)"]
        return finalResult
    }
}

struct DocumentPicker: UIViewControllerRepresentable {
    //@Binding var document: String
    @Binding var document: [String: String]
    @Binding var fileName: String
    @Binding var fileIcon: UIImage?
    @Binding var totalCharacters: Int
    @Binding var totalTokens: Int

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf])
        picker.delegate = context.coordinator
        picker.shouldShowFileExtensions = true
        return picker
    }

    func updateUIViewController(_: UIDocumentPickerViewController, context _: Context) {}

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPicker

        init(_ parent: DocumentPicker) {
            self.parent = parent
        }

        func documentPicker(_: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first, let _ = PDFDocument(url: url) else { return }
            //let pdfText = Files.extractTextFromPDF(url: url) ?? ""
            let pdfText = extractTextFromPDFbyPages(url: url)

            parent.document = pdfText ?? [:]
            parent.fileName = url.lastPathComponent
            parent.totalCharacters = 0
            parent.totalTokens = 0
            
//            parent.document = pdfText
//            parent.fileName = url.lastPathComponent
//            parent.totalCharacters = pdfText.count
//            parent.totalTokens = BertTokenizer().tokenize(text: pdfText).count

            // Create the thumbnail
            let size: CGSize = CGSize(width: 60, height: 60)
            let scale = UIScreen.main.scale
            let request = QLThumbnailGenerator.Request(fileAt: url, size: size, scale: scale, representationTypes: .all)
            let generator = QLThumbnailGenerator.shared
            generator.generateRepresentations(for: request) { thumbnail, _, error in
                DispatchQueue.main.async {
                    guard thumbnail?.uiImage != nil, error == nil else { return }
                    self.parent.fileIcon = thumbnail?.uiImage
                }
            }
        }
    }
}


