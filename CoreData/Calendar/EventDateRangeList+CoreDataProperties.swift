//
//  EventDateRangeList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 10/10/2023.
//
//

import Foundation
import CoreData


extension EventDateRangeList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EventDateRangeList> {
        return NSFetchRequest<EventDateRangeList>(entityName: "EventDateRange")
    }

    @NSManaged public var endDate: String?
    @NSManaged public var id: UUID?
    @NSManaged public var startDate: String?
    @NSManaged public var events: EventList?
    
    public var unwrappedStartDate: String {
        startDate ?? ""
    }
    
    public var unwrappedEndDate: String {
        endDate ?? ""
    }
}

extension EventDateRangeList : Identifiable {

}
