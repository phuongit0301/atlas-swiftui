//
//  ProjDelaysListRef+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 28/07/2023.
//
//

import Foundation
import CoreData


extension ProjDelaysListRef {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProjDelaysListRef> {
        return NSFetchRequest<ProjDelaysListRef>(entityName: "ProjDelaysRef")
    }

    @NSManaged public var delay: Int
    @NSManaged public var id: UUID?
    @NSManaged public var maxdelay: Int
    @NSManaged public var mindelay: Int
    @NSManaged public var time: String?
    @NSManaged public var order: Int16
    @NSManaged public var delayRef: ProjDelaysList?
    
    public var unwrappedTime: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.date(from: time ?? "00:00") ?? dateFormatter.date(from: "00:00")
    }
}

extension ProjDelaysListRef : Identifiable {

}
