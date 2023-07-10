//
//  FuelTaxiRefList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 10/07/2023.
//
//

import Foundation
import CoreData


extension FuelTaxiRefList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FuelTaxiRefList> {
        return NSFetchRequest<FuelTaxiRefList>(entityName: "FuelTaxiRef")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var date: String?
    @NSManaged public var condition: String?
    @NSManaged public var taxiTime: Int
    @NSManaged public var timesRef: FuelTaxiList?
    
    public var unwrappedDate: String {
        date ?? ""
    }
    
    public var unwrappedCondition: String {
        condition ?? ""
    }
}

extension FuelTaxiRefList : Identifiable {

}
