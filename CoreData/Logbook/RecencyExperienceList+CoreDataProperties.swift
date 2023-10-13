//
//  RecencyExperienceList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 12/10/2023.
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
    @NSManaged public var picDay: String?
    @NSManaged public var picUsDay: String?
    @NSManaged public var p1Day: String?
    @NSManaged public var p2Day: String?
    @NSManaged public var totalTime: String?
    @NSManaged public var picUsNight: String?
    @NSManaged public var picNight: String?
    @NSManaged public var p1Night: String?
    @NSManaged public var p2Night: String?
    
    public var unwrappedModel: String {
        model ?? ""
    }
    
    public var unwrappedPicDay: String {
        picDay ?? ""
    }
    
    public var unwrappedPicUsDay: String {
        picUsDay ?? ""
    }
    
    public var unwrappedP1Day: String {
        p1Day ?? ""
    }
    
    public var unwrappedP2Day: String {
        p2Day ?? ""
    }
    
    public var unwrappedPicNight: String {
        picNight ?? ""
    }
    
    public var unwrappedPicUsNight: String {
        picUsNight ?? ""
    }
    
    public var unwrappedP1Night: String {
        p1Night ?? ""
    }
    
    public var unwrappedP2Night: String {
        p2Night ?? ""
    }
    
    public var unwrappedTotalTime: String {
        totalTime ?? ""
    }
}

extension RecencyExperienceList : Identifiable {

}
