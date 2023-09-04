//
//  FuelEnrWXList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 11/07/2023.
//
//

import Foundation
import CoreData


extension FuelEnrWXList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FuelEnrWXList> {
        return NSFetchRequest<FuelEnrWXList>(entityName: "FuelEnrWX")
    }

    @NSManaged public var aveNM: Int
    @NSManaged public var aveMINS: Int
    @NSManaged public var id: UUID?
    @NSManaged public var type: String?
    @NSManaged public var trackMiles: NSSet?
    
    public var unwrappedType: String {
        type ?? "" // flight3, week1, months3
    }
}

// MARK: Generated accessors for trackMiles
extension FuelEnrWXList {

    @objc(addTrackMilesObject:)
    @NSManaged public func addToTrackMiles(_ value: FuelEnrWXRefList)

    @objc(removeTrackMilesObject:)
    @NSManaged public func removeFromTrackMiles(_ value: FuelEnrWXRefList)

    @objc(addTrackMiles:)
    @NSManaged public func addToTrackMiles(_ values: NSSet)

    @objc(removeTrackMiles:)
    @NSManaged public func removeFromTrackMiles(_ values: NSSet)

}

extension FuelEnrWXList : Identifiable {

}
