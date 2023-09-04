//
//  TaxiTimesList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 09/07/2023.
//
//

import Foundation
import CoreData


extension TaxiTimesList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaxiTimesList> {
        return NSFetchRequest<TaxiTimesList>(entityName: "TaxiTimes")
    }

    @NSManaged public var months3: Data?
    @NSManaged public var week1: Data?
    @NSManaged public var id: UUID?
    @NSManaged public var flights3: Data?

}

extension TaxiTimesList : Identifiable {

}
