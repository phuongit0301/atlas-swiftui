//
//  AirportMapColorList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 06/10/2023.
//
//

import Foundation
import CoreData


extension AirportMapColorList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AirportMapColorList> {
        return NSFetchRequest<AirportMapColorList>(entityName: "AirportMapColor")
    }

    @NSManaged public var airportId: String?
    @NSManaged public var colour: String?
    @NSManaged public var id: UUID?
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?
    @NSManaged public var metar: String?
    @NSManaged public var notams: Data?
    @NSManaged public var selection: String?
    @NSManaged public var taf: String?
    
    public var unwrappedAirportId: String {
        airportId ?? ""
    }
    
    public var unwrappedLatitude: String {
        latitude ?? ""
    }
    
    public var unwrappedLongitude: String {
        longitude ?? ""
    }
    
    public var unwrappedSelection: String {
        selection ?? ""
    }
    
    public var unwrappedColour: String {
        colour ?? ""
    }
    
    public var unwrappedMetar: String {
        metar ?? ""
    }
    
    public var unwrappedTaf: String {
        taf ?? ""
    }
    
    public var unwrappedNotams: [String] {
        do {
            if let data = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSArray.self, from: notams!) as? [String] {
                return data
            }
        } catch {
            print("could not unarchive array: \(error)")
        }
        
        return []
    }
}

extension AirportMapColorList : Identifiable {

}
