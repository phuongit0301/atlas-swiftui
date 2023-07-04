//
//  FuelDataList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 04/07/2023.
//
//

import Foundation
import CoreData


extension FuelDataList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FuelDataList> {
        return NSFetchRequest<FuelDataList>(entityName: "FuelData")
    }

    @NSManaged public var burnoff: Data?
    @NSManaged public var cont: Data?
    @NSManaged public var id: UUID?
    @NSManaged public var altn: Data?
    @NSManaged public var hold: Data?
    @NSManaged public var topup60: Data?
    @NSManaged public var taxi: Data?
    @NSManaged public var planReq: Data?
    @NSManaged public var dispAdd: Data?

}

extension FuelDataList : Identifiable {

}
