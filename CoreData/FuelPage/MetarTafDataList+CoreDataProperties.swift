//
//  MetarTafDataList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 07/07/2023.
//
//

import Foundation
import CoreData


extension MetarTafDataList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MetarTafDataList> {
        return NSFetchRequest<MetarTafDataList>(entityName: "MetarTafData")
    }

    @NSManaged public var arrMetar: String?
    @NSManaged public var arrTaf: String?
    @NSManaged public var depMetar: String?
    @NSManaged public var depTaf: String?
    @NSManaged public var id: UUID?
    @NSManaged public var arrAirport: String?
    @NSManaged public var depAirport: String?
    
    public var unwrappedDepMetar: String {
        depMetar ?? ""
    }
    
    public var unwrappedDepTaf: String {
        depTaf ?? ""
    }
    
    public var unwrappedArrMetar: String {
        arrMetar ?? ""
    }
    
    public var unwrappedArrTaf: String {
        arrTaf ?? ""
    }
    
    public var unwrappedArrAirport: String {
        arrAirport ?? ""
    }
    
    public var unwrappedDepAirport: String {
        depAirport ?? ""
    }
}

extension MetarTafDataList : Identifiable {

}
