//
//  HistorycalDelaysRefList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 22/08/2023.
//
//

import Foundation
import CoreData


extension HistorycalDelaysRefList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HistorycalDelaysRefList> {
        return NSFetchRequest<HistorycalDelaysRefList>(entityName: "HistorycalDelaysRef")
    }

    @NSManaged public var condition: String?
    @NSManaged public var delay: Int
    @NSManaged public var id: UUID?
    @NSManaged public var order: Int16
    @NSManaged public var time: String?
    @NSManaged public var type: String?
    @NSManaged public var weather: String?
    @NSManaged public var delaysRef: NSSet?
    
    public var unwrappedCondition: String {
        condition ?? "" // flight3, week1, months3
    }
    
    public var unwrappedTime: String {
        time ?? ""
    }
    
    public var unwrappedWeather: String {
        weather ?? ""
    }
}

// MARK: Generated accessors for delaysRef
extension HistorycalDelaysRefList {

    @objc(addDelaysRefObject:)
    @NSManaged public func addToDelaysRef(_ value: HistoricalDelaysList)

    @objc(removeDelaysRefObject:)
    @NSManaged public func removeFromDelaysRef(_ value: HistoricalDelaysList)

    @objc(addDelaysRef:)
    @NSManaged public func addToDelaysRef(_ values: NSSet)

    @objc(removeDelaysRef:)
    @NSManaged public func removeFromDelaysRef(_ values: NSSet)

}

extension HistorycalDelaysRefList : Identifiable {

}
