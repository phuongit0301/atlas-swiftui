//
//  PerfWeightList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 04/07/2023.
//
//

import Foundation
import CoreData


extension PerfWeightList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PerfWeightList> {
        return NSFetchRequest<PerfWeightList>(entityName: "PerfWeight")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var weight: String?
    @NSManaged public var plan: String?
    @NSManaged public var actual: String?
    @NSManaged public var max: String?
    @NSManaged public var limitation: String?
    
    public var unwrappedWeight: String {
        weight ?? ""
    }
    
    public var unwrappedPlan: String {
        plan ?? ""
    }
    
    public var unwrappedActual: String {
        actual ?? "0"
    }
    
    public var unwrappedMax: String {
        max ?? ""
    }
    
    public var unwrappedLimitation: String {
        limitation ?? ""
    }
}

extension PerfWeightList : Identifiable {

}
