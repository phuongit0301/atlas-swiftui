//
//  TagList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 26/06/2023.
//
//

import Foundation
import CoreData


extension TagList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TagList> {
        return NSFetchRequest<TagList>(entityName: "Tag")
    }

    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var isChecked: Bool
    @NSManaged public var notes: NSSet?

}

// MARK: Generated accessors for notes
extension TagList {

    @objc(addNotesObject:)
    @NSManaged public func addToNotes(_ value: NoteList)

    @objc(removeNotesObject:)
    @NSManaged public func removeFromNotes(_ value: NoteList)

    @objc(addNotes:)
    @NSManaged public func addToNotes(_ values: NSSet)

    @objc(removeNotes:)
    @NSManaged public func removeFromNotes(_ values: NSSet)

}

extension TagList : Identifiable {

}
