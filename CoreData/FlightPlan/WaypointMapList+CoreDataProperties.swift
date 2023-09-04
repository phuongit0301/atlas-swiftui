//
//  WaypointMapList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 26/08/2023.
//
//

import Foundation
import CoreData


extension WaypointMapList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WaypointMapList> {
        return NSFetchRequest<WaypointMapList>(entityName: "Map")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?
    @NSManaged public var title: String?
    
    public var unwrappedLatitude: String {
        latitude ?? ""
    }
    
    public var unwrappedLongitude: String {
        longitude ?? ""
    }
    
    public var unwrappedTitle: String {
        title ?? ""
    }
    
}

extension WaypointMapList : Identifiable {

}
