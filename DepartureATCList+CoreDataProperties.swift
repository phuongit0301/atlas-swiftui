//
//  DepartureATCList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 03/07/2023.
//
//

import Foundation
import CoreData


extension DepartureATCList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DepartureATCList> {
        return NSFetchRequest<DepartureATCList>(entityName: "DepartureATC")
    }

    @NSManaged public var atcDep: String?
    @NSManaged public var atcSQ: String?
    @NSManaged public var atcRte: String?
    @NSManaged public var atcFL: String?
    @NSManaged public var atcRwy: String?
    
    public var unwrappedAtcDep: String {
        atcDep ?? ""
    }
    
    public var unwrappedAtcSQ: String {
        atcSQ ?? ""
    }
    
    public var unwrappedAtcRte: String {
        atcRte ?? ""
    }
    
    public var unwrappedAtcFL: String {
        atcFL ?? ""
    }
    
    public var unwrappedAtcRwy: String {
        atcRwy ?? ""
    }
}

extension DepartureATCList : Identifiable {

}
