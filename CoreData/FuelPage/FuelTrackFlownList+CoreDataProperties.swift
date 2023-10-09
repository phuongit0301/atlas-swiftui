//
//  FuelTrackFlownList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 09/10/2023.
//
//

import Foundation
import CoreData


extension FuelTrackFlownList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FuelTrackFlownList> {
        return NSFetchRequest<FuelTrackFlownList>(entityName: "FuelTrackFlown")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var latitude: String?
    @NSManaged public var type: String?
    @NSManaged public var longitude: String?
    
    public var unwrappedName: String {
        name ?? ""
    }
    
    public var unwrappedLatitude: String {
        latitude ?? ""
    }
    
    public var unwrappedLongitude: String {
        longitude ?? ""
    }
    
    public var unwrappedType: String {
        type ?? ""
    }
}

extension FuelTrackFlownList : Identifiable {

}
