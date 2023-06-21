//
//  Note+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 21/06/2023.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var isDefault: Bool

}

extension Note : Identifiable {

}
