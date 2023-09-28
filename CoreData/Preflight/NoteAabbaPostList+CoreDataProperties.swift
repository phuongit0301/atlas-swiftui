//
//  NoteAabbaPostList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 28/09/2023.
//
//

import Foundation
import CoreData


extension NoteAabbaPostList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NoteAabbaPostList> {
        return NSFetchRequest<NoteAabbaPostList>(entityName: "NoteAabbaPost")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?
    @NSManaged public var name: String?
    @NSManaged public var postCount: String?
    @NSManaged public var type: String?
    @NSManaged public var includeCrew: Bool
    @NSManaged public var posts: NSSet?
    
    public var unwrappedLatitude: String {
        latitude ?? ""
    }
    
    public var unwrappedLongitude: String {
        longitude ?? ""
    }
    
    public var unwrappedName: String {
        name ?? ""
    }
    
    public var unwrappedPostCount: String {
        postCount ?? ""
    }
    
    public var unwrappedType: String {
        type ?? ""
    }
}

// MARK: Generated accessors for posts
extension NoteAabbaPostList {

    @objc(addPostsObject:)
    @NSManaged public func addToPosts(_ value: NotePostList)

    @objc(removePostsObject:)
    @NSManaged public func removeFromPosts(_ value: NotePostList)

    @objc(addPosts:)
    @NSManaged public func addToPosts(_ values: NSSet)

    @objc(removePosts:)
    @NSManaged public func removeFromPosts(_ values: NSSet)

}

extension NoteAabbaPostList : Identifiable {

}
