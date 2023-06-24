//
//  TagList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 23/06/2023.
//
//

import Foundation
import CoreData


extension TagList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TagList> {
        return NSFetchRequest<TagList>(entityName: "Tag")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?

}

extension TagList : Identifiable {

}
