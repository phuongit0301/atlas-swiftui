//
//  RecencyList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 22/09/2023.
//
//

import Foundation
import CoreData


extension RecencyList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecencyList> {
        return NSFetchRequest<RecencyList>(entityName: "Recency")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var recencyType: String?
    @NSManaged public var expiredDate: String?
    @NSManaged public var requirement: String?

}

extension RecencyList : Identifiable {

}
