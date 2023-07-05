//
//  EnrWXTrackMilesList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 04/07/2023.
//
//

import Foundation
import CoreData


extension EnrWXTrackMilesList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EnrWXTrackMilesList> {
        return NSFetchRequest<EnrWXTrackMilesList>(entityName: "EnrWXTrackMiles")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var condition: String?
    @NSManaged public var trackMilesDiff: Int64

}

extension EnrWXTrackMilesList : Identifiable {

}
