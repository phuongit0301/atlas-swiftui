//
//  NoteList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 23/06/2023.
//
//

import Foundation
import CoreData


extension NoteList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NoteList> {
        return NSFetchRequest<NoteList>(entityName: "Note")
    }

    @NSManaged public var canDelete: Bool
    @NSManaged public var fromParent: Bool
    @NSManaged public var id: UUID?
    @NSManaged public var isDefault: Bool
    @NSManaged public var name: String?
    @NSManaged public var tags: TagList?

}

extension NoteList : Identifiable {

}
