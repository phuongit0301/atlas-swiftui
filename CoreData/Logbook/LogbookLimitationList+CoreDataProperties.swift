//
//  LogbookLimitationList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 08/10/2023.
//
//

import Foundation
import CoreData


extension LogbookLimitationList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LogbookLimitationList> {
        return NSFetchRequest<LogbookLimitationList>(entityName: "LogbookLimitation")
    }

    @NSManaged public var end: String?
    @NSManaged public var id: UUID?
    @NSManaged public var limit: String?
    @NSManaged public var remoteId: String?
    @NSManaged public var requirement: String?
    @NSManaged public var start: String?
    @NSManaged public var text: String?
    @NSManaged public var type: String?
    @NSManaged public var status: String?
    @NSManaged public var colour: String?
    @NSManaged public var periodText: String?
    @NSManaged public var statusText: String?
    
    public var unwrappedType: String {
        type ?? ""
    }
    
    public var unwrappedRequirement: String {
        requirement ?? ""
    }
    
    public var unwrappedLimit: String {
        limit ?? ""
    }
    
    public var unwrappedStart: String {
        start ?? ""
    }
    
    public var unwrappedEnd: String {
        end ?? ""
    }
    
    public var unwrappedText: String {
        text ?? ""
    }
    
    public var unwrappedStatus: String {
        status ?? ""
    }
    
    public var unwrappedColour: String {
        colour ?? ""
    }
    
    public var unwrappedPeriodText: String {
        periodText ?? ""
    }
    
    public var unwrappedStatusText: String {
        statusText ?? ""
    }
}

extension LogbookLimitationList : Identifiable {

}
