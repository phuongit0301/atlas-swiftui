//
//  FuelTableList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 04/07/2023.
//
//

import Foundation
import CoreData


extension FuelTableList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FuelTableList> {
        return NSFetchRequest<FuelTableList>(entityName: "FuelTable")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var firstColumn: String?
    @NSManaged public var time: String?
    @NSManaged public var fuel: String?
    @NSManaged public var policyReason: String?
    
    public var unwrappedFirstColumn: String {
        firstColumn ?? ""
    }
    
    public var unwrappedTime: String {
        time ?? ""
    }
    
    public var unwrappedFuel: String {
        fuel ?? ""
    }
    
    public var unwrappedPolicyReason: String {
        policyReason ?? "-"
    }
}

extension FuelTableList : Identifiable {

}
