//
//  AltnTafDataList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 06/07/2023.
//
//

import Foundation
import CoreData


extension AltnTafDataList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AltnTafDataList> {
        return NSFetchRequest<AltnTafDataList>(entityName: "AltnTafData")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var altnRwy: String?
    @NSManaged public var eta: String?
    @NSManaged public var taf: String?
    
    public var unwrappedAltnRwy: String {
        altnRwy ?? ""
    }
    
    public var unwrappedEta: String {
        eta ?? ""
    }
    
    public var unwrappedTaf: String {
        taf ?? ""
    }
}

extension AltnTafDataList : Identifiable {

}
