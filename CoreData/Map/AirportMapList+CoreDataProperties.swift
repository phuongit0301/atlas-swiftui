//
//  AirportMapList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 15/10/2023.
//
//

import Foundation
import CoreData


extension AirportMapList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AirportMapList> {
        return NSFetchRequest<AirportMapList>(entityName: "AirportMap")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?
    @NSManaged public var name: String?
    @NSManaged public var events: NSSet?
    
    public var unwrappedLatitude: String {
        latitude ?? ""
    }
    
    public var unwrappedLongitude: String {
        longitude ?? ""
    }
    
    public var unwrappedName: String {
        name ?? ""
    }
}

// MARK: Generated accessors for events
extension AirportMapList {

    @objc(addEventsObject:)
    @NSManaged public func addToEvents(_ value: EventList)

    @objc(removeEventsObject:)
    @NSManaged public func removeFromEvents(_ value: EventList)

    @objc(addEvents:)
    @NSManaged public func addToEvents(_ values: NSSet)

    @objc(removeEvents:)
    @NSManaged public func removeFromEvents(_ values: NSSet)

}

extension AirportMapList : Identifiable {

}
