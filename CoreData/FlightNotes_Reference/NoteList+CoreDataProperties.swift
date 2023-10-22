//
//  NoteList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 22/10/2023.
//
//

import Foundation
import CoreData


extension NoteList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NoteList> {
        return NSFetchRequest<NoteList>(entityName: "Note")
    }

    @NSManaged public var canDelete: Bool
    @NSManaged public var createdAt: String?
    @NSManaged public var fromParent: Bool
    @NSManaged public var id: UUID?
    @NSManaged public var includeCrew: Bool
    @NSManaged public var isDefault: Bool
    @NSManaged public var name: String?
    @NSManaged public var parentId: UUID?
    @NSManaged public var type: String?
    @NSManaged public var shareAabba: Bool
    @NSManaged public var events: NSSet?
    @NSManaged public var tags: NSSet?
    
    public var unwrappedName: String {
        name ?? ""
    }
    
    public var unwrappedCreatedAt: String {
        createdAt ?? ""
    }
    
    public var unwrappedType: String {
        type ?? ""
    }
}

// MARK: Generated accessors for events
extension NoteList {

    @objc(addEventsObject:)
    @NSManaged public func addToEvents(_ value: EventList)

    @objc(removeEventsObject:)
    @NSManaged public func removeFromEvents(_ value: EventList)

    @objc(addEvents:)
    @NSManaged public func addToEvents(_ values: NSSet)

    @objc(removeEvents:)
    @NSManaged public func removeFromEvents(_ values: NSSet)

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
