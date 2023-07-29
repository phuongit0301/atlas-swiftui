//
//  AISearchList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 29/07/2023.
//
//

import Foundation
import CoreData


extension AISearchList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AISearchList> {
        return NSFetchRequest<AISearchList>(entityName: "AISearch")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var question: String?
    @NSManaged public var answer: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var creationDate: Date?

}

extension AISearchList : Identifiable {

}
