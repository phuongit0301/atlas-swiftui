//
//  ScratchPadList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 21/07/2023.
//
//

import Foundation
import CoreData


extension ScratchPadList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ScratchPadList> {
        return NSFetchRequest<ScratchPadList>(entityName: "ScratchPad")
    }

    @NSManaged public var content: String
    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var orderNum: Int16
    
    public var unwrappedTitle: String {
        title ?? ""
    }
}

extension ScratchPadList : Identifiable {

}
