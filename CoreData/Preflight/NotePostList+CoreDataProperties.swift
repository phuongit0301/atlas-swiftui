//
//  NotePostList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 28/09/2023.
//
//

import Foundation
import CoreData


extension NotePostList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NotePostList> {
        return NSFetchRequest<NotePostList>(entityName: "NotePost")
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
    @NSManaged public var upvoteCount: String?
    @NSManaged public var userId: String?
    @NSManaged public var userName: String?
    @NSManaged public var type: String?
    @NSManaged public var favourite: Bool
    @NSManaged public var blue: Bool
    @NSManaged public var canDelete: Bool
    @NSManaged public var fromParent: Bool
    @NSManaged public var parentId: UUID?
    @NSManaged public var comments: NSSet?
    @NSManaged public var lists: NoteAabbaPostList?

}

// MARK: Generated accessors for comments
extension NotePostList {

    @objc(addCommentsObject:)
    @NSManaged public func addToComments(_ value: NoteCommentList)

    @objc(removeCommentsObject:)
    @NSManaged public func removeFromComments(_ value: NoteCommentList)

    @objc(addComments:)
    @NSManaged public func addToComments(_ values: NSSet)

    @objc(removeComments:)
    @NSManaged public func removeFromComments(_ values: NSSet)
    
    public var unwrappedCategory: String {
        category ?? ""
    }
    
    public var unwrappedCommentCount: String {
        commentCount ?? ""
    }
    
    public var unwrappedLocation: String {
        location ?? ""
    }
    
    public var unwrappedPostDate: String {
        postDate ?? ""
    }
    
    public var unwrappedPostText: String {
        postText ?? ""
    }
    
    public var unwrappedPostTitle: String {
        postTitle ?? ""
    }
    
    public var unwrappedUpvoteCount: String {
        upvoteCount ?? ""
    }
    
    public var unwrappedUserName: String {
        userName ?? ""
    }
}

extension NotePostList : Identifiable {

}
