//
//  TaxiTimesList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 04/07/2023.
//
//

import Foundation
import CoreData


extension TaxiTimesList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaxiTimesList> {
        return NSFetchRequest<TaxiTimesList>(entityName: "TaxiTimes")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var condition: String?
    @NSManaged public var taxiTime: Int64

}

extension TaxiTimesList : Identifiable {

}
