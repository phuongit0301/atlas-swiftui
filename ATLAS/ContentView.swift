//
//  ContentView.swift
//  ATLAS
//
//  Created by phuong phan on 15/05/2023.
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


struct ContentView: View {
    @State private var documentText: String = ""
    @State private var fileName: String = ""
    @State private var fileIcon: UIImage? = nil
    @State private var totalCharacters: Int = 0
    @State private var totalTokens: Int = 0
    @State private var progress: Double = 0
    @State private var chunks: [String] = []
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
                    vectorizeChunks()
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

                if embeddings.count != chunks.count {
                    ProgressView(value: Double(embeddings.count), total: Double(chunks.count))
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

    func vectorizeChunks() {
        guard let index = similarityIndex else { return }

        Task {
            let splitter = RecursiveTokenSplitter(withTokenizer: BertTokenizer())

            let (splitText, _) = splitter.split(text: documentText, chunkSize: 510)
            chunks = splitText

            embeddings = []
            if let miniqa = index.indexModel as? DistilbertEmbeddings {
                for chunk in chunks {
                    if let embedding = await miniqa.encode(sentence: chunk) {
                        embeddings.append(embedding)
                    }
                }
            }

            for (idx, chunk) in chunks.enumerated() {
                await index.addItem(id: "id\(idx)", text: chunk, metadata: ["source": fileName], embedding: embeddings[idx])
            }
        }
    }

    func searchDocument() {
        guard let index = similarityIndex else { return }

        Task {
            let results = await index.search(searchText, top: 3)

            let llmPrompt = SimilarityIndex.combinedResultsString(results)
            print(llmPrompt)
            
            // re index and refine the search
            guard let newIndex = similarityIndex else { return }
            newIndex.removeAll()
            let splitter = TokenSplitter(withTokenizer: BertTokenizer())
            let (splitText, _) = splitter.split(text: llmPrompt, chunkSize: 50)
            let chunks = splitText
            
            var embeddings: [[Float]] = []
            if let miniqa = newIndex.indexModel as? DistilbertEmbeddings {
                for chunk in chunks {
                    if let embedding = await miniqa.encode(sentence: chunk) {
                        embeddings.append(embedding)
                    }
                }
            }

            for (idx, chunk) in chunks.enumerated() {
                await newIndex.addItem(id: "id\(idx)", text: chunk, metadata: ["source": fileName], embedding: embeddings[idx])
            }
            

            let refinedResults = await newIndex.search(searchText, top: 1)
            let refinedLLMPrompt = SimilarityIndex.combinedResultsString(refinedResults)
            print(refinedLLMPrompt)

            // Use NaturalLanguage to extract relevant information from the search results
            // Use the BERT model to provide an answer.
            let bert = BERT()
            let sentenceSplitter = SentenceSplitter()
            let refinedChunks = sentenceSplitter.split(text: refinedLLMPrompt)
            var answer = ""
            var selectedChunk = ""
            for chunk in refinedChunks {
                answer = String(bert.findAnswer(for: searchText, in: chunk))
                if answer != "Couldn't find a valid answer. Please try again." || answer != "The BERT model is unable to make a prediction." {
                    selectedChunk = chunk
                    break
                }
            }
            
            // If answer found, return source and title
            if answer != "" {
                let title = fileName // Replace "nil" with the actual title
                // Print the generated text
                print("Final generated answer:", answer)
                print("Source:", selectedChunk)
                print("Document:", title)
                let finalResult = ["Final generated answer: " + answer + "\n\nSource: " + selectedChunk + "\n\nDocument: " + title]
                searchResults = finalResult
            }
            else {
                print("Couldn't find a valid answer. Please try again.")
                searchResults = ["Couldn't find a valid answer. Please try again."]
            }
        }
    }
}

struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var document: String
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
            let pdfText = Files.extractTextFromPDF(url: url) ?? ""

            parent.document = pdfText
            parent.fileName = url.lastPathComponent
            parent.totalCharacters = pdfText.count
            parent.totalTokens = BertTokenizer().tokenize(text: pdfText).count

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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
