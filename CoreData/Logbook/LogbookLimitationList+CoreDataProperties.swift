//
//  LogbookLimitationList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 23/09/2023.
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
    @NSManaged public var type: String?
    @NSManaged public var requirement: String?
    @NSManaged public var limit: String?
    @NSManaged public var start: String?
    @NSManaged public var end: String?
    @NSManaged public var text: String?
    
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
}

extension LogbookLimitationList : Identifiable {

}
