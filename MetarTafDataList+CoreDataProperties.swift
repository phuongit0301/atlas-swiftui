//
//  MetarTafDataList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 06/07/2023.
//
//

import Foundation
import CoreData


extension MetarTafDataList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MetarTafDataList> {
        return NSFetchRequest<MetarTafDataList>(entityName: "MetarTafData")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var depMetar: String?
    @NSManaged public var depTaf: String?
    @NSManaged public var arrMetar: String?
    @NSManaged public var arrTaf: String?
    
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
}

extension MetarTafDataList : Identifiable {

}
