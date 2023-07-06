//
//  PerfDataList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 05/07/2023.
//
//

import Foundation
import CoreData


extension PerfDataList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PerfDataList> {
        return NSFetchRequest<PerfDataList>(entityName: "PerfData")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var fltRules: String?
    @NSManaged public var gndMiles: String?
    @NSManaged public var airMiles: String?
    @NSManaged public var crzComp: String?
    @NSManaged public var apd: String?
    @NSManaged public var ci: String?
    @NSManaged public var zfwChange: String?
    @NSManaged public var lvlChange: String?
    @NSManaged public var planZFW: String?
    @NSManaged public var maxZFW: String?
    @NSManaged public var limZFW: String?
    @NSManaged public var planTOW: String?
    @NSManaged public var maxTOW: String?
    @NSManaged public var limTOW: String?
    @NSManaged public var planLDW: String?
    @NSManaged public var maxLDW: String?
    @NSManaged public var limLDW: String?
    
    public var unwrappedFltRules: String {
        fltRules ?? ""
    }
    
    public var unwrappedGndMiles: String {
        gndMiles ?? ""
    }
    
    public var unwrappedAirMiles: String {
        airMiles ?? ""
    }
    
    public var unwrappedCrzComp: String {
        crzComp ?? ""
    }
    
    public var unwrappedApd: String {
        apd ?? ""
    }
    
    public var unwrappedCi: String {
        ci ?? ""
    }
    
    public var unwrappedZfwChange: String {
        zfwChange ?? ""
    }
    
    public var unwrappedLvlChange: String {
        lvlChange ?? ""
    }
    
    public var unwrappedPlanZFW: String {
        planZFW ?? ""
    }
    
    public var unwrappedMaxZFW: String {
        maxZFW ?? ""
    }
    
    public var unwrappedLimZFW: String {
        limZFW ?? ""
    }
    
    public var unwrappedPlanTOW: String {
        planTOW ?? ""
    }
    
    public var unwrappedMaxTOW: String {
        maxTOW ?? ""
    }
    
    public var unwrappedLimTOW: String {
        limTOW ?? ""
    }
    
    public var unwrappedPlanLDW: String {
        planLDW ?? ""
    }
    
    public var unwrappedMaxLDW: String {
        airMiles ?? ""
    }
    
    public var unwrappedLimLDW: String {
        limLDW ?? ""
    }
}

extension PerfDataList : Identifiable {

}
