//
//  SectionDateUpdateList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 18/10/2023.
//
//

import Foundation
import CoreData


extension SectionDateUpdateList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SectionDateUpdateList> {
        return NSFetchRequest<SectionDateUpdateList>(entityName: "SectionDateUpdate")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var metarTaf: String?
    @NSManaged public var notam: String?
    @NSManaged public var noteRelevant: String?
    
    public var unwrappedNotam: String {
        notam ?? ""
    }
    
    public var unwrappedMetarTaf: String {
        metarTaf ?? ""
    }
    
    public var unwrappedNoteRelevant: String {
        noteRelevant ?? ""
    }
}

extension SectionDateUpdateList : Identifiable {

}
