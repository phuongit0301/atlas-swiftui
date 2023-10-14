//
//  EventSectorList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 14/10/2023.
//
//

import Foundation
import CoreData


extension EventSectorList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EventSectorList> {
        return NSFetchRequest<EventSectorList>(entityName: "EventSector")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var depLat: String?
    @NSManaged public var depLong: String?
    @NSManaged public var depTimeDiff: String?
    @NSManaged public var depSunriseTime: String?
    @NSManaged public var depSunsetTime: String?
    @NSManaged public var depNextSunriseTime: String?
    @NSManaged public var arrLat: String?
    @NSManaged public var arrLong: String?
    @NSManaged public var arrTimeDiff: String?
    @NSManaged public var arrSunriseTime: String?
    @NSManaged public var arrSunsetTime: String?
    @NSManaged public var arrNextSunriseTime: String?
    @NSManaged public var event: EventList?
    
    public var unwrappedDepLat: String {
        depLat ?? ""
    }
    
    public var unwrappedDepLong: String {
        depLong ?? ""
    }
    
    public var unwrappedDepTimeDiff: String {
        depTimeDiff ?? ""
    }
    
    public var unwrappedDepSunriseTime: String {
        depSunriseTime ?? ""
    }
    
    public var unwrappedDepSunsetTime: String {
        depSunsetTime ?? ""
    }
    
    public var unwrappedDepNextSunriseTime: String {
        depNextSunriseTime ?? ""
    }
    
    public var unwrappedArrLat: String {
        arrLat ?? ""
    }
    
    public var unwrappedArrLong: String {
        arrLong ?? ""
    }
    
    public var unwrappedArrTimeDiff: String {
        arrTimeDiff ?? ""
    }
    
    public var unwrappedArrSunriseTime: String {
        arrSunriseTime ?? ""
    }
    
    public var unwrappedArrSunsetTime: String {
        arrSunsetTime ?? ""
    }
    
    public var unwrappedArrNextSunriseTime: String {
        arrNextSunriseTime ?? ""
    }
}

extension EventSectorList : Identifiable {

}
