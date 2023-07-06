//
//  ArrivalATCList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 06/07/2023.
//
//

import Foundation
import CoreData


extension ArrivalATCList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArrivalATCList> {
        return NSFetchRequest<ArrivalATCList>(entityName: "ArrivalATC")
    }

    @NSManaged public var atcDest: String?
    @NSManaged public var atcArr: String?
    @NSManaged public var atcRwy: String?
    @NSManaged public var atcTransLvl: String?
    @NSManaged public var id: UUID?
    
    public var unwrappedAtcDest: String {
       atcDest ?? ""
    }

    public var unwrappedAtcArr: String {
       atcArr ?? ""
    }

    public var unwrappedAtcRwy: String {
       atcRwy ?? ""
    }

    public var unwrappedAtcTransLvl: String {
       atcTransLvl ?? ""
    }
}

extension ArrivalATCList : Identifiable {

}
