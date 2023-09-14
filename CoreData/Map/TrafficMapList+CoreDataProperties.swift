//
//  TrafficMapList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 13/09/2023.
//
//

import Foundation
import CoreData


extension TrafficMapList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrafficMapList> {
        return NSFetchRequest<TrafficMapList>(entityName: "TrafficMap")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var callsign: String?
    @NSManaged public var colour: String?
    @NSManaged public var baroAltitude: String?
    @NSManaged public var trueTrack: String?
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?
    
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
}

extension TrafficMapList : Identifiable {

}
