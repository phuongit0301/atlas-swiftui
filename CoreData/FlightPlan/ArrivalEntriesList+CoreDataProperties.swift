//
//  ArrivalEntriesList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 06/07/2023.
//
//

import Foundation
import CoreData


extension ArrivalEntriesList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArrivalEntriesList> {
        return NSFetchRequest<ArrivalEntriesList>(entityName: "ArrivalEntries")
    }

    @NSManaged public var entLdg: String?
    @NSManaged public var entOn: String?
    @NSManaged public var entFuelOnChocks: String?
    @NSManaged public var id: UUID?

    public var unwrappedEntLdg: String {
        entLdg ?? ""
    }
    
    public var unwrappedEntOn: String {
        entOn ?? ""
    }
    
    public var unwrappedEntFuelOnChocks: String {
        entFuelOnChocks ?? ""
    }
}

extension ArrivalEntriesList : Identifiable {

}
