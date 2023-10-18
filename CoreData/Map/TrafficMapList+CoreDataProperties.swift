//
//  TrafficMapList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 18/10/2023.
//
//

import Foundation
import CoreData


extension TrafficMapList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrafficMapList> {
        return NSFetchRequest<TrafficMapList>(entityName: "TrafficMap")
    }

    @NSManaged public var aircraftType: String?
    @NSManaged public var baroAltitude: String?
    @NSManaged public var callsign: String?
    @NSManaged public var colour: String?
    @NSManaged public var id: UUID?
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?
    @NSManaged public var trueTrack: String?
    @NSManaged public var events: NSSet?
    
    public var unwrappedCallsign: String {
        callsign ?? ""
    }
    
    public var unwrappedColour: String {
        colour ?? ""
    }
    
    public var unwrappedBaroAltitude: String {
        baroAltitude ?? ""
    }
    
    public var unwrappedTrueTrack: String {
        trueTrack ?? ""
    }
    
    public var unwrappedLatitude: String {
        latitude ?? ""
    }
    
    public var unwrappedLongitude: String {
        longitude ?? ""
    }
    
    public var unwrappedaircraftType: String {
        aircraftType ?? ""
    }
}

// MARK: Generated accessors for events
extension TrafficMapList {

    @objc(addEventsObject:)
    @NSManaged public func addToEvents(_ value: EventList)

    @objc(removeEventsObject:)
    @NSManaged public func removeFromEvents(_ value: EventList)

    @objc(addEvents:)
    @NSManaged public func addToEvents(_ values: NSSet)

    @objc(removeEvents:)
    @NSManaged public func removeFromEvents(_ values: NSSet)

}

extension TrafficMapList : Identifiable {

}
