//
//  EnrouteList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 22/08/2023.
//
//

import Foundation
import CoreData


extension EnrouteList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EnrouteList> {
        return NSFetchRequest<EnrouteList>(entityName: "Enroute")
    }

    @NSManaged public var actm: String?
    @NSManaged public var adn: String?
    @NSManaged public var afl: String?
    @NSManaged public var afrm: String?
    @NSManaged public var ata: String?
    @NSManaged public var awind: String?
    @NSManaged public var cord: String?
    @NSManaged public var diff: String?
    @NSManaged public var dis: String?
    @NSManaged public var drm: String?
    @NSManaged public var eta: String?
    @NSManaged public var fdiff: String?
    @NSManaged public var fwind: String?
    @NSManaged public var gsp: String?
    @NSManaged public var id: UUID?
    @NSManaged public var imt: String?
    @NSManaged public var msa: String?
    @NSManaged public var oat: String?
    @NSManaged public var pdn: String?
    @NSManaged public var pfl: String?
    @NSManaged public var pfrm: String?
    @NSManaged public var posn: String?
    @NSManaged public var tas: String?
    @NSManaged public var vws: String?
    @NSManaged public var zfrq: String?
    @NSManaged public var ztm: String?
    @NSManaged public var isSkipped: Bool
    
    public var unwrappedPosn: String {
        posn ?? ""
    }
    
    public var unwrappedActm: String {
        actm ?? ""
    }
    
    public var unwrappedZtm: String {
        ztm ?? ""
    }
    
    public var unwrappedEta: String {
        eta ?? ""
    }
    
    public var unwrappedAta: String {
        ata ?? ""
    }
    
    public var unwrappedAfl: String {
        afl ?? ""
    }
    
    public var unwrappedOat: String {
        oat ?? ""
    }
    
    public var unwrappedAdn: String {
        adn ?? ""
    }
    
    public var unwrappedAwind: String {
        awind ?? ""
    }
    
    public var unwrappedTas: String {
        tas ?? ""
    }
    
    public var unwrappedVws: String {
        vws ?? ""
    }
    
    public var unwrappedZfrq: String {
        zfrq ?? ""
    }
    
    public var unwrappedAfrm: String {
        afrm ?? ""
    }
    
    public var unwrappedCord: String {
        cord ?? ""
    }
    
    public var unwrappedMsa: String {
        msa ?? ""
    }
    
    public var unwrappedDis: String {
        dis ?? ""
    }
    
    public var unwrappedDiff: String {
        diff ?? ""
    }
    
    public var unwrappedPfl: String {
        pfl ?? ""
    }
    
    public var unwrappedImt: String {
        imt ?? ""
    }
    
    public var unwrappedPdn: String {
        pdn ?? ""
    }
    
    public var unwrappedFwind: String {
        fwind ?? ""
    }
    
    public var unwrappedGsp: String {
        gsp ?? ""
    }
    
    public var unwrappedDrm: String {
        drm ?? ""
    }
    
    public var unwrappedPfrm: String {
        pfrm ?? ""
    }
    
    public var unwrappedFdiff: String {
        fdiff ?? ""
    }
}

extension EnrouteList : Identifiable {

}
