//
//  AabbaMapList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 13/09/2023.
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

}

extension AabbaMapList : Identifiable {

}
