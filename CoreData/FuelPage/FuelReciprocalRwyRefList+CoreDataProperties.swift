//
//  FuelReciprocalRwyRefList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 11/07/2023.
//
//

import Foundation
import CoreData


extension FuelReciprocalRwyRefList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FuelReciprocalRwyRefList> {
        return NSFetchRequest<FuelReciprocalRwyRefList>(entityName: "FuelReciprocalRwyRef")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var date: String?
    @NSManaged public var condition: String?
    @NSManaged public var trackMilesDiff: Int
    @NSManaged public var trackMilesRef: FuelReciprocalRwyList?
    
    public var unwrappedDate: String {
        date ?? ""
    }
    
    public var unwrappedCondition: String {
        condition ?? ""
    }
}

extension FuelReciprocalRwyRefList : Identifiable {

}
