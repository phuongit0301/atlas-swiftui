//
//  SummaryInfoList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 03/10/2023.
//
//

import Foundation
import CoreData


extension SummaryInfoList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SummaryInfoList> {
        return NSFetchRequest<SummaryInfoList>(entityName: "SummaryInfo")
    }

    @NSManaged public var blkTime: String?
    @NSManaged public var cm1: String?
    @NSManaged public var cm2: String?
    @NSManaged public var crewCA: String?
    @NSManaged public var crewFO: String?
    @NSManaged public var dep: String?
    @NSManaged public var depICAO: String?
    @NSManaged public var dest: String?
    @NSManaged public var destICAO: String?
    @NSManaged public var flightDate: String?
    @NSManaged public var fltNo: String?
    @NSManaged public var fltTime: String?
    @NSManaged public var id: UUID?
    @NSManaged public var planNo: String?
    @NSManaged public var pob: String?
    @NSManaged public var staLocal: String?
    @NSManaged public var staUTC: String?
    @NSManaged public var stdLocal: String?
    @NSManaged public var stdUTC: String?
    @NSManaged public var tailNo: String?
    @NSManaged public var timeDiffArr: String?
    @NSManaged public var timeDiffDep: String?
    @NSManaged public var model: String?
    @NSManaged public var aircraft: String?
    @NSManaged public var flightTime: String?
    @NSManaged public var route: String?
    
    public var unwrappedBlkTime: String {
        blkTime ?? ""
    }
    
    public var unwrappedDep: String {
        dep ?? ""
    }
    
    public var unwrappedDepICAO: String {
        depICAO ?? ""
    }
    
    public var unwrappedDest: String {
        dest ?? ""
    }
    
    public var unwrappedDestICAO: String {
        destICAO ?? ""
    }
    
    public var unwrappedFlightDate: String {
        flightDate ?? ""
    }
    
    public var unwrappedFltNo: String {
        fltNo ?? ""
    }
    
    public var unwrappedFltTime: String {
        fltTime ?? ""
    }
    
    public var unwrappedPlanNo: String {
        planNo ?? ""
    }
    
    public var unwrappedStaLocal: String {
        staLocal ?? ""
    }
    
    public var unwrappedStaUTC: String {
        staUTC ?? ""
    }
    
    public var unwrappedStdLocal: String {
        stdLocal ?? ""
    }
    
    public var unwrappedStdUTC: String {
        stdUTC ?? ""
    }
    
    public var unwrappedTailNo: String {
        tailNo ?? ""
    }
    
    public var unwrappedPob: String {
        pob ?? ""
    }
    
    public var unwrappedTimeDiffArr: String {
        timeDiffArr ?? ""
    }
    
    public var unwrappedTimeDiffDep: String {
        timeDiffDep ?? ""
    }
    
    public var unwrappedCm1: String {
        cm1 ?? ""
    }
    
    public var unwrappedCm2: String {
        cm2 ?? ""
    }
    
    public var unwrappedCrewCA: String {
        crewCA ?? ""
    }
    
    public var unwrappedCrewFO: String {
        crewFO ?? ""
    }
    
    public var unwrappedModel: String {
        model ?? ""
    }
    
    public var unwrappedAircraft: String {
        aircraft ?? ""
    }
    
    public var unwrappedFlightTime: String {
        flightTime ?? "00:00"
    }
    
    public var unwrappedRoute: String {
        route ?? ""
    }
}

extension SummaryInfoList : Identifiable {

}
