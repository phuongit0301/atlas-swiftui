//
//  FuelEnrWXRefList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 30/07/2023.
//
//

import Foundation
import CoreData


extension FuelEnrWXRefList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FuelEnrWXRefList> {
        return NSFetchRequest<FuelEnrWXRefList>(entityName: "FuelEnrWXRef")
    }

    @NSManaged public var condition: String?
    @NSManaged public var date: String?
    @NSManaged public var id: UUID?
    @NSManaged public var trackMilesDiff: Int
    @NSManaged public var order: Int16
    @NSManaged public var trackMilesRef: FuelEnrWXList?
    
    public var unwrappedDate: String {
        date ?? ""
    }
    
    public var unwrappedCondition: String {
        condition ?? ""
    }
}

extension FuelEnrWXRefList : Identifiable {

}
