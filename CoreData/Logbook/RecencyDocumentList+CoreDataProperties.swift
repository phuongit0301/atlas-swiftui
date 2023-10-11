//
//  RecencyDocumentList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 11/10/2023.
//
//

import Foundation
import CoreData


extension RecencyDocumentList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecencyDocumentList> {
        return NSFetchRequest<RecencyDocumentList>(entityName: "RecencyDocument")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var type: String?
    @NSManaged public var expiredDate: String?
    @NSManaged public var requirement: String?
    
    public var unwrappedType: String {
        type ?? ""
    }
    
    public var unwrappedExpiredDate: String {
        expiredDate ?? ""
    }
    
    public var unwrappedRequirement: String {
        requirement ?? ""
    }
}

extension RecencyDocumentList : Identifiable {

}
