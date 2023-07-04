//
//  SummaryRouteList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 04/07/2023.
//
//

import Foundation
import CoreData


extension SummaryRouteList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SummaryRouteList> {
        return NSFetchRequest<SummaryRouteList>(entityName: "SummaryRoute")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var routeNo: String?
    @NSManaged public var route: String?
    @NSManaged public var depRwy: String?
    @NSManaged public var arrRwy: String?
    @NSManaged public var levels: String?
    
    public var unwrappedRouteNo: String {
        routeNo ?? ""
    }
    
    public var unwrappedRoute: String {
        route ?? ""
    }
    
    public var unwrappedDepRwy: String {
        depRwy ?? ""
    }
    
    public var unwrappedArrRwy: String {
        arrRwy ?? ""
    }
    
    public var unwrappedLevels: String {
        levels ?? ""
    }
}

extension SummaryRouteList : Identifiable {

}
