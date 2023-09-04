//
//  FuelFlightLevelList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 11/07/2023.
//
//

import Foundation
import CoreData


extension FuelFlightLevelList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FuelFlightLevelList> {
        return NSFetchRequest<FuelFlightLevelList>(entityName: "FuelFlightLevel")
    }

    @NSManaged public var aveDiff: Int
    @NSManaged public var type: String?
    @NSManaged public var id: UUID?
    @NSManaged public var flightLevels: NSSet?
    
    public var unwrappedType: String {
        type ?? "" // flight3, week1, months3
    }
}

// MARK: Generated accessors for flightLevels
extension FuelFlightLevelList {

    @objc(addFlightLevelsObject:)
    @NSManaged public func addToFlightLevels(_ value: FuelFlightLevelRefList)

    @objc(removeFlightLevelsObject:)
    @NSManaged public func removeFromFlightLevels(_ value: FuelFlightLevelRefList)

    @objc(addFlightLevels:)
    @NSManaged public func addToFlightLevels(_ values: NSSet)

    @objc(removeFlightLevels:)
    @NSManaged public func removeFromFlightLevels(_ values: NSSet)

}

extension FuelFlightLevelList : Identifiable {

}
