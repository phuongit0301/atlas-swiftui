//
//  RouteAlternateList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 26/09/2023.
//
//

import Foundation
import CoreData


extension RouteAlternateList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RouteAlternateList> {
        return NSFetchRequest<RouteAlternateList>(entityName: "RouteAlternate")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var altn: String?
    @NSManaged public var vis: String?
    @NSManaged public var minima: String?
    @NSManaged public var eta: String?
    @NSManaged public var type: String?
    
    public var unwrappedAltn: String {
        altn ?? ""
    }
    
    public var unwrappedVis: String {
        vis ?? ""
    }
    
    public var unwrappedMinima: String {
        minima ?? ""
    }
    
    public var unwrappedEta: String {
        eta ?? ""
    }
    
    public var unwrappedType: String {
        type ?? ""
    }
}

extension RouteAlternateList : Identifiable {

}
