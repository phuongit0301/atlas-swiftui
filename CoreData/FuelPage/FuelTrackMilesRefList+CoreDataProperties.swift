//
//  FuelTrackMilesRefList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 30/07/2023.
//
//

import Foundation
import CoreData


extension FuelTrackMilesRefList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FuelTrackMilesRefList> {
        return NSFetchRequest<FuelTrackMilesRefList>(entityName: "FuelTrackMilesRef")
    }

    @NSManaged public var condition: String?
    @NSManaged public var id: UUID?
    @NSManaged public var phase: String?
    @NSManaged public var trackMilesDiff: Int
    @NSManaged public var order: Int16
    @NSManaged public var trackMilesRef: FuelTrackMilesList?
    
    public var unwrappedPhase: String {
        phase ?? ""
    }
    
    public var unwrappedCondition: String {
        condition ?? ""
    }
}

extension FuelTrackMilesRefList : Identifiable {

}
