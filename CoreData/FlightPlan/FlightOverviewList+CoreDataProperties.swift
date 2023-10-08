//
//  FlightOverviewList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 08/10/2023.
//
//

import Foundation
import CoreData


extension FlightOverviewList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FlightOverviewList> {
        return NSFetchRequest<FlightOverviewList>(entityName: "FlightOverview")
    }

    @NSManaged public var caName: String?
    @NSManaged public var caPicker: String?
    @NSManaged public var eta: String?
    @NSManaged public var f0Name: String?
    @NSManaged public var f0Picker: String?
    @NSManaged public var aircraft: String?
    @NSManaged public var blockTime: String?
    @NSManaged public var blockTimeFlightTime: String?
    @NSManaged public var callsign: String?
    @NSManaged public var id: UUID?
    @NSManaged public var chockOff: String?
    @NSManaged public var chockOn: String?
    @NSManaged public var day: String?
    @NSManaged public var dep: String?
    @NSManaged public var dest: String?
    @NSManaged public var flightTime: String?
    @NSManaged public var model: String?
    @NSManaged public var night: String?
    @NSManaged public var password: String?
    @NSManaged public var pob: String?
    @NSManaged public var sta: String?
    @NSManaged public var std: String?
    @NSManaged public var timeDiffArr: String?
    @NSManaged public var timeDiffDep: String?
    @NSManaged public var totalTime: String?
    @NSManaged public var route: String?
    
    public var unwrappedCaName: String {
        caName ?? ""
    }
    
    public var unwrappedCaPicker: String {
        caPicker ?? ""
    }
    
    public var unwrappedEta: String {
        eta ?? ""
    }
    
    public var unwrappedF0Name: String {
        f0Name ?? ""
    }
    
    public var unwrappedF0Picker: String {
        f0Picker ?? ""
    }
    
    public var unwrappedAircraft: String {
        aircraft ?? ""
    }
    
    public var unwrappedBlockTime: String {
        blockTime ?? ""
    }
    
    public var unwrappedBlockTimeFlightTime: String {
        blockTimeFlightTime ?? ""
    }
    
    public var unwrappedCallsign: String {
        callsign ?? ""
    }
    
    public var unwrappedChockOff: String {
        chockOff ?? ""
    }
    
    public var unwrappedChockOn: String {
        chockOn ?? ""
    }
    
    public var unwrappedDay: String {
        day ?? ""
    }
    
    public var unwrappedDep: String {
        dep ?? ""
    }
    
    public var unwrappedDest: String {
        dest ?? ""
    }
    
    public var unwrappedFlightTime: String {
        flightTime ?? ""
    }
    
    public var unwrappedModel: String {
        model ?? ""
    }
    
    public var unwrappedNight: String {
        night ?? ""
    }
    
    public var unwrappedPassword: String {
        password ?? ""
    }
    
    public var unwrappedPob: String {
        pob ?? ""
    }
    
    public var unwrappedSta: String {
        sta ?? ""
    }
    
    public var unwrappedStd: String {
        std ?? ""
    }
    
    public var unwrappedTimeDiffArr: String {
        timeDiffArr ?? ""
    }
    
    public var unwrappedTimeDiffDep: String {
        timeDiffDep ?? ""
    }
    
    public var unwrappedTotalTime: String {
        totalTime ?? ""
    }
    
    public var unwrappedRoute: String {
        route ?? ""
    }
}

extension FlightOverviewList : Identifiable {

}
