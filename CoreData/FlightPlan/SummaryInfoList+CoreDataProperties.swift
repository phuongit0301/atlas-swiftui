//
//  SummaryInfoList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 04/07/2023.
//
//

import Foundation
import CoreData


extension SummaryInfoList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SummaryInfoList> {
        return NSFetchRequest<SummaryInfoList>(entityName: "SummaryInfo")
    }

    @NSManaged public var blkTime: String?
    @NSManaged public var dep: String?
    @NSManaged public var depICAO: String?
    @NSManaged public var dest: String?
    @NSManaged public var destICAO: String?
    @NSManaged public var flightDate: String?
    @NSManaged public var fltNo: String?
    @NSManaged public var fltTime: String?
    @NSManaged public var id: UUID?
    @NSManaged public var planNo: String?
    @NSManaged public var staLocal: String?
    @NSManaged public var staUTC: String?
    @NSManaged public var stdLocal: String?
    @NSManaged public var stdUTC: String?
    @NSManaged public var tailNo: String?
    @NSManaged public var pob: String?
    
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
}

extension SummaryInfoList : Identifiable {

}
