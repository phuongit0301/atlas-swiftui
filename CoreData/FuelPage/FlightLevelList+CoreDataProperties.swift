//
//  FlightLevelList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 04/07/2023.
//
//

import Foundation
import CoreData


extension FlightLevelList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FlightLevelList> {
        return NSFetchRequest<FlightLevelList>(entityName: "FlightLevel")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var waypoint: String?
    @NSManaged public var condition: String?
    @NSManaged public var flightLevel: String?

}

extension FlightLevelList : Identifiable {

}
