//
//  AabbaCommentList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 18/09/2023.
//
//

import Foundation
import CoreData


extension AabbaCommentList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AabbaCommentList> {
        return NSFetchRequest<AabbaCommentList>(entityName: "AabbaComment")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var commentId: String?
    @NSManaged public var postId: String?
    @NSManaged public var userId: String?
    @NSManaged public var commentDate: String?
    @NSManaged public var commentText: String?
    @NSManaged public var userName: String?
    @NSManaged public var posts: NSSet?
    
    public var unwrappedCommentId: String {
        commentId ?? ""
    }
    
    public var unwrappedPostId: String {
        postId ?? ""
    }
    
    public var unwrappedUserId: String {
        userId ?? ""
    }
    
    public var unwrappedCommentDate: String {
        commentDate ?? ""
    }
    
    public var unwrappedCommentText: String {
        commentText ?? ""
    }
    
    public var unwrappedUserName: String {
        userName ?? ""
    }
}

// MARK: Generated accessors for posts
extension AabbaCommentList {

    @objc(addPostsObject:)
    @NSManaged public func addToPosts(_ value: AabbaPostList)

    @objc(removePostsObject:)
    @NSManaged public func removeFromPosts(_ value: AabbaPostList)

    @objc(addPosts:)
    @NSManaged public func addToPosts(_ values: NSSet)

    @objc(removePosts:)
    @NSManaged public func removeFromPosts(_ values: NSSet)

}

extension AabbaCommentList : Identifiable {

}
