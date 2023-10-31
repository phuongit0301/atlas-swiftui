//
//  AirportMapList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 30/10/2023.
//
//

import Foundation
import CoreData


extension AirportMapList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AirportMapList> {
        return NSFetchRequest<AirportMapList>(entityName: "AirportMap")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?
    @NSManaged public var name: String?
    
    public var unwrappedLatitude: String {
        latitude ?? ""
    }
    
    public var unwrappedLongitude: String {
        longitude ?? ""
    }
    
    public var unwrappedName: String {
        name ?? ""
    }
}

extension AirportMapList : Identifiable {

}
