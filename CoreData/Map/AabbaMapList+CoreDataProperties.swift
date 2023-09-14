//
//  AabbaMapList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 14/09/2023.
//
//

import Foundation
import CoreData


extension AabbaMapList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AabbaMapList> {
        return NSFetchRequest<AabbaMapList>(entityName: "AabbaMap")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var userId: String?
    @NSManaged public var postDate: String?
    @NSManaged public var postTitle: String?
    @NSManaged public var postText: String?
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?
    @NSManaged public var category: String?
    @NSManaged public var postId: String?
    @NSManaged public var upvoteCount: Int32
    @NSManaged public var commentCount: Int32
    @NSManaged public var location: String?
    @NSManaged public var username: String?
    @NSManaged public var comments: String?
    
    public var unwrappedUserId: String {
        userId ?? ""
    }
    
    public var unwrappedPostDate: String {
        postDate ?? ""
    }
    
    public var unwrappedPostTitle: String {
        postTitle ?? ""
    }
    
    public var unwrappedLatitude: String {
        latitude ?? ""
    }
    
    public var unwrappedLongitude: String {
        longitude ?? ""
    }
    
    public var unwrappedCategory: String {
        category ?? ""
    }
    
    public var unwrappedPostId: String {
        postId ?? ""
    }
    
    public var unwrappedLocation: String {
        location ?? ""
    }
    
    public var unwrappedUsername: String {
        username ?? ""
    }
    
    public var unwrappedComments: String {
        comments ?? ""
    }
}

extension AabbaMapList : Identifiable {

}
