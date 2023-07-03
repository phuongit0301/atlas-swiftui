//
//  DepartureEntriesList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 03/07/2023.
//
//

import Foundation
import CoreData


extension DepartureEntriesList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DepartureEntriesList> {
        return NSFetchRequest<DepartureEntriesList>(entityName: "DepartureEntries")
    }

    @NSManaged public var entOff: String?
    @NSManaged public var entFuelInTanks: String?
    @NSManaged public var entTaxi: String?
    @NSManaged public var entTakeoff: String?
    
    public var unwrappedEntOff: String {
        entOff ?? ""
    }
    
    public var unwrappedEntFuelInTanks: String {
        entFuelInTanks ?? ""
    }
    
    public var unwrappedEntTaxi: String {
        entTaxi ?? ""
    }
    
    public var unwrappedEntTakeoff: String {
        entTakeoff ?? ""
    }
}

extension DepartureEntriesList : Identifiable {

}
