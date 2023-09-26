//
//  NoteList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 26/09/2023.
//
//

import Foundation
import CoreData


extension NoteList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NoteList> {
        return NSFetchRequest<NoteList>(entityName: "Note")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var isDefault: Bool
    @NSManaged public var name: String?
    @NSManaged public var createdAt: String?
    @NSManaged public var tags: NSSet?
    
    public var unwrappedName: String {
        name ?? ""
    }
    
    public var unwrappedCreatedAt: String {
        createdAt ?? ""
    }
}

// MARK: Generated accessors for tags
extension NoteList {

    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: TagList)

    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: TagList)

    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSSet)

    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSSet)

}

extension NoteList : Identifiable {

}
