//
//  FuelFlightLevelRefList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 30/07/2023.
//
//

import Foundation
import CoreData


extension FuelFlightLevelRefList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FuelFlightLevelRefList> {
        return NSFetchRequest<FuelFlightLevelRefList>(entityName: "FuelFlightLevelRef")
    }

    @NSManaged public var condition: String?
    @NSManaged public var flightLevel: Int
    @NSManaged public var id: UUID?
    @NSManaged public var waypoint: String?
    @NSManaged public var order: Int16
    @NSManaged public var flightLevelsRef: FuelFlightLevelList?
    
    public var unwrappedWaypoint: String {
        waypoint ?? ""
    }
    
    public var unwrappedCondition: String {
        condition ?? ""
    }
}

extension FuelFlightLevelRefList : Identifiable {

}
