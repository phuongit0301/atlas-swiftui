//
//  RecencyExpiryList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 22/09/2023.
//
//

import Foundation
import CoreData


extension RecencyExpiryList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecencyExpiryList> {
        return NSFetchRequest<RecencyExpiryList>(entityName: "RecencyExpiry")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var expiredDate: String?

}

extension RecencyExpiryList : Identifiable {

}
