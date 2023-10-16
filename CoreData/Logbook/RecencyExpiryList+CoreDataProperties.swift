//
//  RecencyExpiryList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 16/10/2023.
//
//

import Foundation
import CoreData


extension RecencyExpiryList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecencyExpiryList> {
        return NSFetchRequest<RecencyExpiryList>(entityName: "RecencyExpiry")
    }

    @NSManaged public var expiredDate: String?
    @NSManaged public var id: UUID?
    @NSManaged public var requirement: String?
    @NSManaged public var type: String?
    
    public var unwrappedType: String {
        type ?? ""
    }
    
    public var unwrappedExpiredDate: String {
        expiredDate ?? ""
    }
    
    public var unwrappedRequirement: String {
        requirement ?? ""
    }
}

extension RecencyExpiryList : Identifiable {

}
