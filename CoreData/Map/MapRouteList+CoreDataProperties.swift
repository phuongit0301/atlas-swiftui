//
//  MapRouteList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 07/10/2023.
//
//

import Foundation
import CoreData


extension MapRouteList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MapRouteList> {
        return NSFetchRequest<MapRouteList>(entityName: "MapRoute")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?
    @NSManaged public var name: String?

}

extension MapRouteList : Identifiable {

}
