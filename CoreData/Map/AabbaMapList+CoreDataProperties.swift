//
//  AabbaMapList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 18/09/2023.
//
//

import Foundation
import CoreData


extension AabbaMapList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AabbaMapList> {
        return NSFetchRequest<AabbaMapList>(entityName: "AabbaMap")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var postCount: Int16
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?
    @NSManaged public var name: String?
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
    
}

// MARK: Generated accessors for posts
extension AabbaMapList {

    @objc(addPostsObject:)
    @NSManaged public func addToPosts(_ value: AabbaPostList)

    @objc(removePostsObject:)
    @NSManaged public func removeFromPosts(_ value: AabbaPostList)

    @objc(addPosts:)
    @NSManaged public func addToPosts(_ values: NSSet)

    @objc(removePosts:)
    @NSManaged public func removeFromPosts(_ values: NSSet)

}

extension AabbaMapList : Identifiable {

}
