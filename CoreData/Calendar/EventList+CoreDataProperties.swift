//
//  EventList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 11/09/2023.
//
//

import Foundation
import CoreData


extension EventList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EventList> {
        return NSFetchRequest<EventList>(entityName: "Event")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var status: Int32
    @NSManaged public var startDate: String?
    @NSManaged public var endDate: String?
    @NSManaged public var name: String?
    @NSManaged public var location: String?
    @NSManaged public var type: String?
    @NSManaged public var dep: String?
    @NSManaged public var dest: String?
    
    public var unwrappedStartDate: String {
        startDate ?? ""
    }
    
    public var unwrappedEndDate: String {
        endDate ?? ""
    }
    
    public var unwrappedName: String {
        name ?? ""
    }
    
    public var unwrappedLocation: String {
        location ?? ""
    }
    
    public var unwrappedType: String {
        type ?? ""
    }
    
    public var unwrappedDep: String {
        dep ?? ""
    }
    
    public var unwrappedDest: String {
        dest ?? ""
    }
}

extension EventList : Identifiable {

}
