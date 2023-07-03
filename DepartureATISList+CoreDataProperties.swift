//
//  DepartureATISList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 03/07/2023.
//
//

import Foundation
import CoreData


extension DepartureATISList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DepartureATISList> {
        return NSFetchRequest<DepartureATISList>(entityName: "DepartureATIS")
    }

    @NSManaged public var code: String?
    @NSManaged public var time: String?
    @NSManaged public var rwy: String?
    @NSManaged public var translvl: String?
    @NSManaged public var wind: String?
    @NSManaged public var vis: String?
    @NSManaged public var wx: String?
    @NSManaged public var cloud: String?
    @NSManaged public var temp: String?
    @NSManaged public var dp: String?
    @NSManaged public var qnh: String?
    @NSManaged public var remarks: String?
    
    public var unwrappedCode: String {
        code ?? ""
    }
    
    public var unwrappedTime: String {
        time ?? ""
    }
    
    public var unwrappedRwy: String {
        rwy ?? ""
    }
    
    public var unwrappedRranslvl: String {
        translvl ?? ""
    }
    
    public var unwrappedWind: String {
        wind ?? ""
    }
    
    public var unwrappedVis: String {
        vis ?? ""
    }
    
    public var unwrappedWx: String {
        wx ?? ""
    }
    
    public var unwrappedCloud: String {
        cloud ?? ""
    }
    
    public var unwrappedTemp: String {
        temp ?? ""
    }
    
    public var unwrappedDp: String {
        dp ?? ""
    }
    
    public var unwrappedQnh: String {
        qnh ?? ""
    }
    
    public var unwrappedRemarks: String {
        remarks ?? ""
    }
}

extension DepartureATISList : Identifiable {

}
