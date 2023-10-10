//
//  MetarTafDataList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 10/10/2023.
//
//

import Foundation
import CoreData


extension MetarTafDataList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MetarTafDataList> {
        return NSFetchRequest<MetarTafDataList>(entityName: "MetarTafData")
    }

    @NSManaged public var airport: String?
    @NSManaged public var id: UUID?
    @NSManaged public var metar: String?
    @NSManaged public var std: String?
    @NSManaged public var taf: String?
    @NSManaged public var type: String?
    @NSManaged public var events: NSSet?
    
    public var unwrappedType: String {
        type ?? ""
    }
    
    public var unwrappedTaf: String {
        taf ?? ""
    }
    
    public var unwrappedMetar: String {
        metar ?? ""
    }
    
    public var unwrappedStd: String {
        std ?? ""
    }
    
    public var unwrappedAirport: String {
        airport ?? ""
    }
}

// MARK: Generated accessors for events
extension MetarTafDataList {

    @objc(addEventsObject:)
    @NSManaged public func addToEvents(_ value: EventList)

    @objc(removeEventsObject:)
    @NSManaged public func removeFromEvents(_ value: EventList)

    @objc(addEvents:)
    @NSManaged public func addToEvents(_ values: NSSet)

    @objc(removeEvents:)
    @NSManaged public func removeFromEvents(_ values: NSSet)

}

extension MetarTafDataList : Identifiable {

}
