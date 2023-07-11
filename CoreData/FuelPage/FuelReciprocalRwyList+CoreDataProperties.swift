//
//  FuelReciprocalRwyList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 11/07/2023.
//
//

import Foundation
import CoreData


extension FuelReciprocalRwyList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FuelReciprocalRwyList> {
        return NSFetchRequest<FuelReciprocalRwyList>(entityName: "FuelReciprocalRwy")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var aveNM: Int
    @NSManaged public var aveMINS: Int
    @NSManaged public var type: String?
    @NSManaged public var trackMiles: NSSet?
    
    public var unwrappedType: String {
        type ?? "" // flight3, week1, months3
    }
}

// MARK: Generated accessors for trackMiles
extension FuelReciprocalRwyList {

    @objc(addTrackMilesObject:)
    @NSManaged public func addToTrackMiles(_ value: FuelReciprocalRwyRefList)

    @objc(removeTrackMilesObject:)
    @NSManaged public func removeFromTrackMiles(_ value: FuelReciprocalRwyRefList)

    @objc(addTrackMiles:)
    @NSManaged public func addToTrackMiles(_ values: NSSet)

    @objc(removeTrackMiles:)
    @NSManaged public func removeFromTrackMiles(_ values: NSSet)

}

extension FuelReciprocalRwyList : Identifiable {

}
