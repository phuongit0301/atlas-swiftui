//
//  MetarTafDataList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 03/10/2023.
//
//

import Foundation
import CoreData


extension MetarTafDataList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MetarTafDataList> {
        return NSFetchRequest<MetarTafDataList>(entityName: "MetarTafData")
    }

    @NSManaged public var type: String?
    @NSManaged public var taf: String?
    @NSManaged public var metar: String?
    @NSManaged public var std: String?
    @NSManaged public var airport: String?
    @NSManaged public var id: UUID?
    
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

extension MetarTafDataList : Identifiable {

}
