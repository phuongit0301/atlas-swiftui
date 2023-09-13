//
//  WaypointMapList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 13/09/2023.
//
//

import Foundation
import CoreData


extension WaypointMapList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WaypointMapList> {
        return NSFetchRequest<WaypointMapList>(entityName: "WaypointMap")
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

extension WaypointMapList : Identifiable {

}
