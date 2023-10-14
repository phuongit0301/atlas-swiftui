//
//  RecencyList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 14/10/2023.
//
//

import Foundation
import CoreData


extension RecencyList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecencyList> {
        return NSFetchRequest<RecencyList>(entityName: "Recency")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var limit: String?
    @NSManaged public var requirement: String?
    @NSManaged public var periodStart: String?
    @NSManaged public var type: String?
    @NSManaged public var model: String?
    @NSManaged public var status: String?
    @NSManaged public var text: String?
    @NSManaged public var percentage: String?
    @NSManaged public var blueText: String?
    
    public var unwrappedLimit: String {
        limit ?? ""
    }
    
    public var unwrappedRequirement: String {
        requirement ?? ""
    }
    
    public var unwrappedPeriodStart: String {
        periodStart ?? ""
    }
    
    public var unwrappedType: String {
        type ?? ""
    }
    
    public var unwrappedModel: String {
        model ?? ""
    }
    
    public var unwrappedStatus: String {
        status ?? ""
    }
    
    public var unwrappedText: String {
        text ?? ""
    }
    
    public var unwrappedPercentage: String {
        percentage ?? ""
    }
    
    public var unwrappedBlueText: String {
        blueText ?? ""
    }
}

extension RecencyList : Identifiable {

}
