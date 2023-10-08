//
//  AabbaPostList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 07/10/2023.
//
//

import Foundation
import CoreData


extension AabbaPostList {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<AabbaPostList> {
        return NSFetchRequest<AabbaPostList>(entityName: "AabbaPost")
    }
    
    @NSManaged public var category: String?
    @NSManaged public var commentCount: String?
    @NSManaged public var id: UUID?
    @NSManaged public var location: String?
    @NSManaged public var postDate: String?
    @NSManaged public var postId: String?
    @NSManaged public var postText: String?
    @NSManaged public var postTitle: String?
    @NSManaged public var postUpdated: Date?
    @NSManaged public var upvoteCount: Int32
    @NSManaged public var userId: String?
    @NSManaged public var userName: String?
    @NSManaged public var voted: Bool
    @NSManaged public var comments: NSSet?
    @NSManaged public var list: AabbaMapList?
    
    public var unwrappedPostId: String {
        postId ?? ""
    }
    
    public var unwrappedUserId: String {
        userId ?? ""
    }
    
    public var unwrappedPostDate: String {
        postDate ?? ""
    }
    
    public var unwrappedPostTitle: String {
        postTitle ?? ""
    }
    
    public var unwrappedPostText: String {
        postText ?? ""
    }
    
    public var unwrappedCommentCount: String {
        commentCount ?? ""
    }
    
    public var unwrappedCategory: String {
        category ?? ""
    }
    
    public var unwrappedUserName: String {
        userName ?? ""
    }
    
    public var unwrappedLocation: String {
        location ?? ""
    }
}

// MARK: Generated accessors for comments
extension AabbaPostList {

    @objc(addCommentsObject:)
    @NSManaged public func addToComments(_ value: AabbaCommentList)

    @objc(removeCommentsObject:)
    @NSManaged public func removeFromComments(_ value: AabbaCommentList)

    @objc(addComments:)
    @NSManaged public func addToComments(_ values: NSSet)

    @objc(removeComments:)
    @NSManaged public func removeFromComments(_ values: NSSet)

}

extension AabbaPostList : Identifiable {

}
