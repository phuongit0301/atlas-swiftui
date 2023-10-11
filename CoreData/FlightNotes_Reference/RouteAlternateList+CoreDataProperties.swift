//
//  RouteAlternateList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 10/10/2023.
//
//

import Foundation
import CoreData


extension RouteAlternateList {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<RouteAlternateList> {
        return NSFetchRequest<RouteAlternateList>(entityName: "RouteAlternate")
    }
    
    @NSManaged public var altn: String?
    @NSManaged public var eta: String?
    @NSManaged public var id: UUID?
    @NSManaged public var minima: String?
    @NSManaged public var type: String?
    @NSManaged public var vis: String?
    @NSManaged public var events: NSSet?
    
    public var unwrappedAltn: String {
        altn ?? ""
    }
    
    public var unwrappedVis: String {
        vis ?? ""
    }
    
    public var unwrappedMinima: String {
        minima ?? ""
    }
    
    public var unwrappedEta: String {
        eta ?? ""
    }
    
    public var unwrappedType: String {
        type ?? ""
    }
    
}

// MARK: Generated accessors for events
extension RouteAlternateList {

    @objc(addEventsObject:)
    @NSManaged public func addToEvents(_ value: EventList)

    @objc(removeEventsObject:)
    @NSManaged public func removeFromEvents(_ value: EventList)

    @objc(addEvents:)
    @NSManaged public func addToEvents(_ values: NSSet)

    @objc(removeEvents:)
    @NSManaged public func removeFromEvents(_ values: NSSet)

}

extension RouteAlternateList : Identifiable {

}
