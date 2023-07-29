//
//  SDAISearchModel.swift
//  ATLAS
//
//  Created by phuong phan on 16/07/2023.
//

import Foundation
import SwiftData

class SDAISearchModel {
    var id: UUID = UUID()
    var question: String
    var answer: String
    var isFavorite: Bool = false
    var creationDate: Date = Date()
    
    init(id: UUID = UUID(), question: String, answer: String, isFavorite: Bool = false, creationDate: Date = Date()) {
        self.id = id
        self.question = question
        self.answer = answer
        self.isFavorite = isFavorite
        self.creationDate = creationDate
    }
}
