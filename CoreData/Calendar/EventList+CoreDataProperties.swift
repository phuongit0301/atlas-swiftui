//
//  EventList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 10/10/2023.
//
//

import Foundation
import CoreData


extension EventList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EventList> {
        return NSFetchRequest<EventList>(entityName: "Event")
    }

    @NSManaged public var dep: String?
    @NSManaged public var dest: String?
    @NSManaged public var endDate: String?
    @NSManaged public var id: UUID?
    @NSManaged public var location: String?
    @NSManaged public var name: String?
    @NSManaged public var startDate: String?
    @NSManaged public var status: Int32
    @NSManaged public var type: String?
    @NSManaged public var flightStatus: String?
    @NSManaged public var airportMapColorList: NSSet?
    @NSManaged public var flightOverviewList: NSSet?
    @NSManaged public var mapRouteList: NSSet?
    @NSManaged public var metarTafList: NSSet?
    @NSManaged public var notamsDataList: NSSet?
    @NSManaged public var noteList: NSSet?
    @NSManaged public var notePostList: NSSet?
    @NSManaged public var eventDateRangeList: NSSet?
    @NSManaged public var routeAlternate: NSSet?
    
    public var unwrappedStartDate: String {
        startDate ?? ""
    }
    
    public var unwrappedEndDate: String {
        endDate ?? ""
    }
    
    public var unwrappedName: String {
        name ?? ""
    }
    
    public var unwrappedLocation: String {
        location ?? ""
    }
    
    public var unwrappedType: String {
        type ?? ""
    }
    
    public var unwrappedDep: String {
        dep ?? ""
    }
    
    public var unwrappedDest: String {
        dest ?? ""
    }
}

// MARK: Generated accessors for airportMapColorList
extension EventList {

    @objc(addAirportMapColorListObject:)
    @NSManaged public func addToAirportMapColorList(_ value: AirportMapColorList)

    @objc(removeAirportMapColorListObject:)
    @NSManaged public func removeFromAirportMapColorList(_ value: AirportMapColorList)

    @objc(addAirportMapColorList:)
    @NSManaged public func addToAirportMapColorList(_ values: NSSet)

    @objc(removeAirportMapColorList:)
    @NSManaged public func removeFromAirportMapColorList(_ values: NSSet)

}

// MARK: Generated accessors for flightOverviewList
extension EventList {

    @objc(addFlightOverviewListObject:)
    @NSManaged public func addToFlightOverviewList(_ value: FlightOverviewList)

    @objc(removeFlightOverviewListObject:)
    @NSManaged public func removeFromFlightOverviewList(_ value: FlightOverviewList)

    @objc(addFlightOverviewList:)
    @NSManaged public func addToFlightOverviewList(_ values: NSSet)

    @objc(removeFlightOverviewList:)
    @NSManaged public func removeFromFlightOverviewList(_ values: NSSet)

}

// MARK: Generated accessors for mapRouteList
extension EventList {

    @objc(addMapRouteListObject:)
    @NSManaged public func addToMapRouteList(_ value: MapRouteList)

    @objc(removeMapRouteListObject:)
    @NSManaged public func removeFromMapRouteList(_ value: MapRouteList)

    @objc(addMapRouteList:)
    @NSManaged public func addToMapRouteList(_ values: NSSet)

    @objc(removeMapRouteList:)
    @NSManaged public func removeFromMapRouteList(_ values: NSSet)

}

// MARK: Generated accessors for metarTafList
extension EventList {

    @objc(addMetarTafListObject:)
    @NSManaged public func addToMetarTafList(_ value: MetarTafDataList)

    @objc(removeMetarTafListObject:)
    @NSManaged public func removeFromMetarTafList(_ value: MetarTafDataList)

    @objc(addMetarTafList:)
    @NSManaged public func addToMetarTafList(_ values: NSSet)

    @objc(removeMetarTafList:)
    @NSManaged public func removeFromMetarTafList(_ values: NSSet)

}

// MARK: Generated accessors for notamsDataList
extension EventList {

    @objc(addNotamsDataListObject:)
    @NSManaged public func addToNotamsDataList(_ value: NotamsDataList)

    @objc(removeNotamsDataListObject:)
    @NSManaged public func removeFromNotamsDataList(_ value: NotamsDataList)

    @objc(addNotamsDataList:)
    @NSManaged public func addToNotamsDataList(_ values: NSSet)

    @objc(removeNotamsDataList:)
    @NSManaged public func removeFromNotamsDataList(_ values: NSSet)

}

// MARK: Generated accessors for noteList
extension EventList {

    @objc(addNoteListObject:)
    @NSManaged public func addToNoteList(_ value: NoteList)

    @objc(removeNoteListObject:)
    @NSManaged public func removeFromNoteList(_ value: NoteList)

    @objc(addNoteList:)
    @NSManaged public func addToNoteList(_ values: NSSet)

    @objc(removeNoteList:)
    @NSManaged public func removeFromNoteList(_ values: NSSet)

}

// MARK: Generated accessors for notePostList
extension EventList {

    @objc(addNotePostListObject:)
    @NSManaged public func addToNotePostList(_ value: NotePostList)

    @objc(removeNotePostListObject:)
    @NSManaged public func removeFromNotePostList(_ value: NotePostList)

    @objc(addNotePostList:)
    @NSManaged public func addToNotePostList(_ values: NSSet)

    @objc(removeNotePostList:)
    @NSManaged public func removeFromNotePostList(_ values: NSSet)

}

// MARK: Generated accessors for eventDateRangeList
extension EventList {

    @objc(addEventDateRangeListObject:)
    @NSManaged public func addToEventDateRangeList(_ value: EventDateRangeList)

    @objc(removeEventDateRangeListObject:)
    @NSManaged public func removeFromEventDateRangeList(_ value: EventDateRangeList)

    @objc(addEventDateRangeList:)
    @NSManaged public func addToEventDateRangeList(_ values: NSSet)

    @objc(removeEventDateRangeList:)
    @NSManaged public func removeFromEventDateRangeList(_ values: NSSet)

}

// MARK: Generated accessors for routeAlternate
extension EventList {

    @objc(addRouteAlternateObject:)
    @NSManaged public func addToRouteAlternate(_ value: RouteAlternateList)

    @objc(removeRouteAlternateObject:)
    @NSManaged public func removeFromRouteAlternate(_ value: RouteAlternateList)

    @objc(addRouteAlternate:)
    @NSManaged public func addToRouteAlternate(_ values: NSSet)

    @objc(removeRouteAlternate:)
    @NSManaged public func removeFromRouteAlternate(_ values: NSSet)

}

extension EventList : Identifiable {

}
