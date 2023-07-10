//
//  HistoricalDelaysList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 10/07/2023.
//
//

import Foundation
import CoreData


extension HistoricalDelaysList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HistoricalDelaysList> {
        return NSFetchRequest<HistoricalDelaysList>(entityName: "HistoricalDelays")
    }

    @NSManaged public var arrTimeDelayWX: Int
    @NSManaged public var arrTimeDelay: Int
    @NSManaged public var id: UUID?
    @NSManaged public var ymax: Int
    @NSManaged public var type: String?
    @NSManaged public var eta: String?
    @NSManaged public var delays: NSSet?
    
    public var unwrappedType: String {
        type ?? "" // flight3, week1, months3
    }
    
    public var unwrappedEta: String {
        eta ?? ""
    }
}

// MARK: Generated accessors for delays
extension HistoricalDelaysList {

    @objc(addDelaysObject:)
    @NSManaged public func addToDelays(_ value: HistorycalDelaysRefList)

    @objc(removeDelaysObject:)
    @NSManaged public func removeFromDelays(_ value: HistorycalDelaysRefList)

    @objc(addDelays:)
    @NSManaged public func addToDelays(_ values: NSSet)

    @objc(removeDelays:)
    @NSManaged public func removeFromDelays(_ values: NSSet)

}

extension HistoricalDelaysList : Identifiable {

}
