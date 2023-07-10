//
//  ProjDelaysListRef+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 10/07/2023.
//
//

import Foundation
import CoreData


extension ProjDelaysListRef {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProjDelaysListRef> {
        return NSFetchRequest<ProjDelaysListRef>(entityName: "ProjDelaysRef")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var time: String?
    @NSManaged public var delay: Double
    @NSManaged public var mindelay: Double
    @NSManaged public var maxdelay: Double
    @NSManaged public var delayRef: ProjDelaysList?
    
    public var unwrappedTime: String {
        time ?? ""
    }
}

extension ProjDelaysListRef : Identifiable {

}
