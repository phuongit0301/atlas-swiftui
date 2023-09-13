//
//  AirportMapList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 13/09/2023.
//
//

import Foundation
import CoreData


extension AirportMapList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AirportMapList> {
        return NSFetchRequest<AirportMapList>(entityName: "AirportMap")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?

}

extension AirportMapList : Identifiable {

}
