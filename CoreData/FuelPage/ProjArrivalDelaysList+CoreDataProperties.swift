//
//  ProjArrivalDelaysList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 04/07/2023.
//
//

import Foundation
import CoreData


extension ProjArrivalDelaysList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProjArrivalDelaysList> {
        return NSFetchRequest<ProjArrivalDelaysList>(entityName: "ProjArrivalDelays")
    }

    @NSManaged public var id: String?
    @NSManaged public var time: Date?
    @NSManaged public var delay: Int64
    @NSManaged public var mindelay: Int64
    @NSManaged public var maxdelay: Int64

}

extension ProjArrivalDelaysList : Identifiable {

}
