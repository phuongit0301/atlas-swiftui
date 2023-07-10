//
//  FuelTaxiList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 10/07/2023.
//
//

import Foundation
import CoreData


extension FuelTaxiList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FuelTaxiList> {
        return NSFetchRequest<FuelTaxiList>(entityName: "FuelTaxi")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var type: String?
    @NSManaged public var aveTime: Int
    @NSManaged public var aveDiff: Int
    @NSManaged public var ymax: Int
    @NSManaged public var times: NSSet?
    
    public var unwrappedType: String {
        type ?? ""
    }
}

// MARK: Generated accessors for times
extension FuelTaxiList {

    @objc(addTimesObject:)
    @NSManaged public func addToTimes(_ value: FuelTaxiRefList)

    @objc(removeTimesObject:)
    @NSManaged public func removeFromTimes(_ value: FuelTaxiRefList)

    @objc(addTimes:)
    @NSManaged public func addToTimes(_ values: NSSet)

    @objc(removeTimes:)
    @NSManaged public func removeFromTimes(_ values: NSSet)

}

extension FuelTaxiList : Identifiable {

}
