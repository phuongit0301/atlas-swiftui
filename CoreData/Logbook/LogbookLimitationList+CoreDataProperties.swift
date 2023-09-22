//
//  LogbookLimitationList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 22/09/2023.
//
//

import Foundation
import CoreData


extension LogbookLimitationList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LogbookLimitationList> {
        return NSFetchRequest<LogbookLimitationList>(entityName: "LogbookLimitation")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var remoteId: String?
    @NSManaged public var limitationType: String?
    @NSManaged public var limitation: String?
    @NSManaged public var limitationDays: String?
    @NSManaged public var limitationPeriod: String?
    @NSManaged public var limitationStatus: String?
    
    public var unwrappedLimitation: String {
        limitation ?? ""
    }
    
    public var unwrappedLimitationPeriod: String {
        limitationPeriod ?? ""
    }
    
    public var unwrappedLimitationStatus: String {
        limitationStatus ?? ""
    }
}

extension LogbookLimitationList : Identifiable {

}
