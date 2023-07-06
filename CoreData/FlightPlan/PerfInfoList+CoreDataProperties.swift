//
//  PerfInfoList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 04/07/2023.
//
//

import Foundation
import CoreData


extension PerfInfoList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PerfInfoList> {
        return NSFetchRequest<PerfInfoList>(entityName: "PerfInfo")
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
}

extension PerfInfoList : Identifiable {

}
