//
//  NotamsDataList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 15/07/2023.
//
//

import Foundation
import CoreData


extension NotamsDataList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NotamsDataList> {
        return NSFetchRequest<NotamsDataList>(entityName: "NotamsData")
    }

    @NSManaged public var type: String? //arrNotams, depNotams, enrNotams
    @NSManaged public var notam: String?
    @NSManaged public var id: UUID?
    @NSManaged public var isChecked: Bool
    @NSManaged public var date: String?
    @NSManaged public var rank: String?
    
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
}

extension NotamsDataList : Identifiable {

}
