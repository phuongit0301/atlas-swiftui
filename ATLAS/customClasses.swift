//
//  customClasses.swift
//  ATLAS
//
//  Created by Muhammad Adil on 17/5/23.
//

import Foundation

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
