//
//  RecencyExperienceList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 11/10/2023.
//
//

import Foundation
import CoreData


extension RecencyExperienceList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecencyExperienceList> {
        return NSFetchRequest<RecencyExperienceList>(entityName: "RecencyExperience")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var model: String?
    @NSManaged public var pic: String?
    @NSManaged public var picUs: String?
    @NSManaged public var p1: String?
    @NSManaged public var p2: String?
    @NSManaged public var totalTime: String?
    
    public var unwrappedModel: String {
        model ?? ""
    }
    
    public var unwrappedPic: String {
        pic ?? ""
    }
    
    public var unwrappedPicUs: String {
        picUs ?? ""
    }
    
    public var unwrappedP1: String {
        p1 ?? ""
    }
    
    public var unwrappedP2: String {
        p2 ?? ""
    }
    
    public var unwrappedTotalTime: String {
        totalTime ?? ""
    }
}

extension RecencyExperienceList : Identifiable {

}
