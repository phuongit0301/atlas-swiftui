//
//  ScratchPadList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 27/06/2023.
//
//

import Foundation
import CoreData


extension ScratchPadList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ScratchPadList> {
        return NSFetchRequest<ScratchPadList>(entityName: "ScratchPad")
    }

    @NSManaged public var content: String
    @NSManaged public var id: UUID
    @NSManaged public var title: String?

    public var unwrappedTitle: String {
        title ?? ""
    }
}

extension ScratchPadList : Identifiable {

}
