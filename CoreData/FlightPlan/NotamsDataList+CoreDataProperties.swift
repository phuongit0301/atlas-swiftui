//
//  NotamsDataList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 10/10/2023.
//
//

import Foundation
import CoreData


extension NotamsDataList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NotamsDataList> {
        return NSFetchRequest<NotamsDataList>(entityName: "NotamsData")
    }

    @NSManaged public var airport: String?
    @NSManaged public var category: String?
    @NSManaged public var date: String?
    @NSManaged public var id: UUID?
    @NSManaged public var isChecked: Bool
    @NSManaged public var notam: String?
    @NSManaged public var rank: String?
    @NSManaged public var type: String?
    @NSManaged public var events: NSSet?
    
    public var unwrappedType: String {
        type ?? ""
    }
    
    public var unwrappedNotam: String {
        notam ?? ""
    }
    
    public var unwrappedDate: String {
        date ?? ""
    }
    
    public var unwrappedRank: String {
        rank ?? ""
    }
    
    public var unwrappedCategory: String {
        category ?? ""
    }
    
    public var unwrappedAirport: String {
        airport ?? ""
    }
}

// MARK: Generated accessors for events
extension NotamsDataList {

    @objc(addEventsObject:)
    @NSManaged public func addToEvents(_ value: EventList)

    @objc(removeEventsObject:)
    @NSManaged public func removeFromEvents(_ value: EventList)

    @objc(addEvents:)
    @NSManaged public func addToEvents(_ values: NSSet)

    @objc(removeEvents:)
    @NSManaged public func removeFromEvents(_ values: NSSet)

}

extension NotamsDataList : Identifiable {

}
