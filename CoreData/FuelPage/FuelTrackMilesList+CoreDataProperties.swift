//
//  FuelTrackMilesList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 11/07/2023.
//
//

import Foundation
import CoreData


extension FuelTrackMilesList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FuelTrackMilesList> {
        return NSFetchRequest<FuelTrackMilesList>(entityName: "FuelTrackMiles")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var sumMINS: Int
    @NSManaged public var sumNM: Int
    @NSManaged public var type: String?
    @NSManaged public var trackMiles: NSSet?
    
    public var unwrappedType: String {
        type ?? "" // flight3, week1, months3
    }
}

// MARK: Generated accessors for trackMiles
extension FuelTrackMilesList {

    @objc(addTrackMilesObject:)
    @NSManaged public func addToTrackMiles(_ value: FuelTrackMilesRefList)

    @objc(removeTrackMilesObject:)
    @NSManaged public func removeFromTrackMiles(_ value: FuelTrackMilesRefList)

    @objc(addTrackMiles:)
    @NSManaged public func addToTrackMiles(_ values: NSSet)

    @objc(removeTrackMiles:)
    @NSManaged public func removeFromTrackMiles(_ values: NSSet)

}

extension FuelTrackMilesList : Identifiable {

}
