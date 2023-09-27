//
//  NoteCommentList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 27/09/2023.
//
//

import Foundation
import CoreData


extension NoteCommentList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NoteCommentList> {
        return NSFetchRequest<NoteCommentList>(entityName: "NoteComment")
    }

    @NSManaged public var commentDate: String?
    @NSManaged public var commentId: String?
    @NSManaged public var commentText: String?
    @NSManaged public var id: UUID?
    @NSManaged public var postId: String?
    @NSManaged public var userId: String?
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
extension NoteCommentList {

    @objc(addPostsObject:)
    @NSManaged public func addToPosts(_ value: NotePostList)

    @objc(removePostsObject:)
    @NSManaged public func removeFromPosts(_ value: NotePostList)

    @objc(addPosts:)
    @NSManaged public func addToPosts(_ values: NSSet)

    @objc(removePosts:)
    @NSManaged public func removeFromPosts(_ values: NSSet)

}

extension NoteCommentList : Identifiable {

}
