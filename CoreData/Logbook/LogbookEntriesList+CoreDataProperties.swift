//
//  LogbookEntriesList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 07/10/2023.
//
//

import Foundation
import CoreData


extension LogbookEntriesList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LogbookEntriesList> {
        return NSFetchRequest<LogbookEntriesList>(entityName: "LogbookEntries")
    }

    @NSManaged public var aircraft: String?
    @NSManaged public var aircraftCategory: String?
    @NSManaged public var aircraftType: String?
    @NSManaged public var comments: String?
    @NSManaged public var date: String?
    @NSManaged public var departure: String?
    @NSManaged public var destination: String?
    @NSManaged public var exam: String?
    @NSManaged public var id: UUID?
    @NSManaged public var instr: String?
    @NSManaged public var logId: String?
    @NSManaged public var p1Day: String?
    @NSManaged public var p1Night: String?
    @NSManaged public var p2Day: String?
    @NSManaged public var p2Night: String?
    @NSManaged public var picDay: String?
    @NSManaged public var picNight: String?
    @NSManaged public var picUUsDay: String?
    @NSManaged public var picUUsNight: String?
    @NSManaged public var signFileName: String?
    @NSManaged public var signFileUrl: String?
    @NSManaged public var licenseNumber: String?
    
    public var unwrappedLogId: String {
        logId ?? ""
    }
    
    public var unwrappedDate: String {
        date ?? ""
    }
    
    public var unwrappedAircraftCategory: String {
        aircraftCategory ?? ""
    }
    
    public var unwrappedAircraftType: String {
        aircraftType ?? ""
    }
    
    public var unwrappedAircraft: String {
        aircraft ?? ""
    }
    
    public var unwrappedDeparture: String {
        departure ?? ""
    }
    
    public var unwrappedDestination: String {
        destination ?? ""
    }
    
    public var unwrappedPicDay: String {
        picDay ?? ""
    }
    
    public var unwrappedPicUUsDay: String {
        picUUsDay ?? ""
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
    
    public var unwrappedPicUUsNight: String {
        picUUsNight ?? ""
    }
    
    public var unwrappedP1Night: String {
        p1Night ?? ""
    }
    
    public var unwrappedP2Night: String {
        p2Night ?? ""
    }
    
    public var unwrappedInstr: String {
        instr ?? ""
    }
    
    public var unwrappedExam: String {
        exam ?? ""
    }
    
    public var unwrappedComments: String {
        comments ?? ""
    }
    
    public var unwrappedSignFileName: String {
        signFileName ?? ""
    }
    
    public var unwrappedSignFileUrl: String {
        signFileUrl ?? ""
    }
    
    public var unwrappedLicenseNumber: String {
        licenseNumber ?? ""
    }
}

extension LogbookEntriesList : Identifiable {

}
