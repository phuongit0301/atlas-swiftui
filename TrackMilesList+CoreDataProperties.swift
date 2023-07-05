//
//  TrackMilesList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 04/07/2023.
//
//

import Foundation
import CoreData


extension TrackMilesList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrackMilesList> {
        return NSFetchRequest<TrackMilesList>(entityName: "TrackMiles")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var phase: String?
    @NSManaged public var condition: String?
    @NSManaged public var trackMilesDiff: String?
    
    public var unwrappedPhase: String {
        phase ?? ""
    }
    
    public var unwrappedCondition: String {
        condition ?? ""
    }
    
    public var unwrappedTrackMilesDiff: String {
        trackMilesDiff ?? ""
    }
}

extension TrackMilesList : Identifiable {

}
