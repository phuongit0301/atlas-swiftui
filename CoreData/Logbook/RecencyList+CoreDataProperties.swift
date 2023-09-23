//
//  RecencyList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 23/09/2023.
//
//

import Foundation
import CoreData


extension RecencyList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecencyList> {
        return NSFetchRequest<RecencyList>(entityName: "Recency")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var type: String?
    @NSManaged public var limit: String?
    @NSManaged public var requirement: String?
    @NSManaged public var text: String?
    
    public var unwrappedType: String {
        type ?? ""
    }
    
    public var unwrappedLimit: String {
        limit ?? ""
    }
    
    public var unwrappedRequirement: String {
        requirement ?? ""
    }
    
    public var unwrappedText: String {
        text ?? ""
    }
}

extension RecencyList : Identifiable {

}
