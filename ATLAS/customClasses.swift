//
//  customClasses.swift
//  ATLAS
//
//  Created by Muhammad Adil on 17/5/23.
//

import Foundation
import PDFKit


public class SentenceSplitter {
    let separator: String

    public init() {
        self.separator = "\n"
    }

    public func split(text: String) -> [String] {
        let sentences = text.components(separatedBy: separator)
        var chunks: [String] = []
        var currentChunk = ""

        for sentence in sentences {
            let sentenceSize = sentence.count
            let chunkSize = currentChunk.count

            if chunkSize + sentenceSize <= 100 {
                if !currentChunk.isEmpty {
                    currentChunk += separator
                }
                currentChunk += sentence
            } else {
                if !currentChunk.isEmpty {
                    chunks.append(currentChunk)
                    currentChunk = ""
                }
                chunks.append(sentence)
            }
        }

        if !currentChunk.isEmpty {
            chunks.append(currentChunk)
        }

        return chunks
    }
}

public func extractTextFromPDFbyPages(url: URL) -> [String: String]? {
    let pdfDocument = PDFDocument(url: url)

    guard let document = pdfDocument else {
        print("Failed to load PDF document.")
        return nil
    }

    let pageCount = document.pageCount
    var extractedText: [String: String] = [:]

    for pageIndex in 0..<pageCount {
        if let page = document.page(at: pageIndex) {
            if let pageContent = page.string {
                let key = "\(url.lastPathComponent)_\(pageIndex + 1)"
                extractedText[key] = pageContent
            }
        }
    }

    return extractedText
}
