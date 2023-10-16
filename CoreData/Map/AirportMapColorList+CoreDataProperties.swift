//
//  AirportMapColorList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 15/10/2023.
//
//

import Foundation
import CoreData


extension AirportMapColorList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AirportMapColorList> {
        return NSFetchRequest<AirportMapColorList>(entityName: "AirportMapColor")
    }

    @NSManaged public var airportId: String?
    @NSManaged public var colour: String?
    @NSManaged public var id: UUID?
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?
    @NSManaged public var metar: String?
    @NSManaged public var notams: String?
    @NSManaged public var selection: String?
    @NSManaged public var taf: String?
    @NSManaged public var arrDelay: String?
    @NSManaged public var depDelay: String?
    @NSManaged public var arrDelayColour: String?
    @NSManaged public var depDelayColour: String?
    @NSManaged public var updatedAt: String?
    @NSManaged public var events: NSSet?

    public var unwrappedAirportId: String {
        airportId ?? ""
    }
    
    public var unwrappedLatitude: String {
        latitude ?? ""
    }
    
    public var unwrappedLongitude: String {
        longitude ?? ""
    }
    
    public var unwrappedSelection: String {
        selection ?? ""
    }
    
    public var unwrappedColour: String {
        colour ?? ""
    }
    
    public var unwrappedMetar: String {
        metar ?? ""
    }
    
    public var unwrappedTaf: String {
        taf ?? ""
    }
    
    public var unwrappedNotams: String {
        notams ?? ""
    }
    
    public var unwrappedArrDelay: String {
        arrDelay ?? ""
    }
    
    public var unwrappedDepDelay: String {
        depDelay ?? ""
    }
    
    public var unwrappedArrDelayColour: String {
        arrDelayColour ?? ""
    }
    
    public var unwrappedDepDelayColour: String {
        depDelayColour ?? ""
    }
    
    public var unwrappedUpdatedAt: String {
        updatedAt ?? ""
    }
}

// MARK: Generated accessors for events
extension AirportMapColorList {

    @objc(addEventsObject:)
    @NSManaged public func addToEvents(_ value: EventList)

    @objc(removeEventsObject:)
    @NSManaged public func removeFromEvents(_ value: EventList)

    @objc(addEvents:)
    @NSManaged public func addToEvents(_ values: NSSet)

    @objc(removeEvents:)
    @NSManaged public func removeFromEvents(_ values: NSSet)

}

extension AirportMapColorList : Identifiable {

}
