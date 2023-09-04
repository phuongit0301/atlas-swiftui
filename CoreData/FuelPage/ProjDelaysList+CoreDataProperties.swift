//
//  ProjDelaysList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 28/07/2023.
//
//

import Foundation
import CoreData


extension ProjDelaysList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProjDelaysList> {
        return NSFetchRequest<ProjDelaysList>(entityName: "ProjDelays")
    }

    @NSManaged public var eta: String?
    @NSManaged public var expectedDelay: Int
    @NSManaged public var id: UUID?
    @NSManaged public var delays: NSSet?
    
    public var unwrappedEta: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.date(from: eta ?? "00:00") ?? dateFormatter.date(from: "00:00")!
    }

}

// MARK: Generated accessors for delays
extension ProjDelaysList {

    @objc(addDelaysObject:)
    @NSManaged public func addToDelays(_ value: ProjDelaysListRef)

    @objc(removeDelaysObject:)
    @NSManaged public func removeFromDelays(_ value: ProjDelaysListRef)

    @objc(addDelays:)
    @NSManaged public func addToDelays(_ values: NSSet)

    @objc(removeDelays:)
    @NSManaged public func removeFromDelays(_ values: NSSet)

}

extension ProjDelaysList : Identifiable {

}
