//
//  NotamsDataList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 04/10/2023.
//
//

import Foundation
import CoreData


extension NotamsDataList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NotamsDataList> {
        return NSFetchRequest<NotamsDataList>(entityName: "NotamsData")
    }

    @NSManaged public var category: String?
    @NSManaged public var date: String?
    @NSManaged public var id: UUID?
    @NSManaged public var isChecked: Bool
    @NSManaged public var notam: String?
    @NSManaged public var rank: String?
    @NSManaged public var type: String?
    @NSManaged public var airport: String?
    
    public var unwrappedType: String {
        type ?? ""
    }
    
    public var unwrappedNotam: String {
        notam ?? ""
    }
    
    public var unwrappedDate: String {
        date ?? ""
    }
    
    public var unwrappedRank: String {
        rank ?? ""
    }
    
    public var unwrappedCategory: String {
        category ?? ""
    }
    
    public var unwrappedAirport: String {
        airport ?? ""
    }
}

extension NotamsDataList : Identifiable {

}
