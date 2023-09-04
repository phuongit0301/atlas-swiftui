//
//  AltnDataList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 05/07/2023.
//
//

import Foundation
import CoreData


extension AltnDataList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AltnDataList> {
        return NSFetchRequest<AltnDataList>(entityName: "AltnData")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var altnRwy: String?
    @NSManaged public var rte: String?
    @NSManaged public var vis: String?
    @NSManaged public var minima: String?
    @NSManaged public var dist: String?
    @NSManaged public var fl: String?
    @NSManaged public var comp: String?
    @NSManaged public var time: String?
    @NSManaged public var fuel: String?
    
    public var unwrappedAltnRwy: String {
        altnRwy ?? ""
    }
    
    public var unwrappedRte: String {
        rte ?? ""
    }
    
    public var unwrappedVis: String {
        vis ?? ""
    }
    
    public var unwrappedMinima: String {
        minima ?? ""
    }
    
    public var unwrappedDist: String {
        dist ?? ""
    }
    
    public var unwrappedFl: String {
        fl ?? ""
    }
    
    public var unwrappedComp: String {
        comp ?? ""
    }
    
    public var unwrappedTime: String {
        time ?? ""
    }
    
    public var unwrappedFuel: String {
        fuel ?? ""
    }
}

extension AltnDataList : Identifiable {

}
