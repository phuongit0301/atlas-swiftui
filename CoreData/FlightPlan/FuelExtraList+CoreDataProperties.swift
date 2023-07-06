//
//  FuelExtraList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 04/07/2023.
//
//

import Foundation
import CoreData


extension FuelExtraList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FuelExtraList> {
        return NSFetchRequest<FuelExtraList>(entityName: "FuelExtra")
    }

    @NSManaged public var includedArrDelays: Bool
    @NSManaged public var id: UUID?
    @NSManaged public var includedFlightLevel: Bool
    @NSManaged public var includedEnrWx: Bool
    @NSManaged public var includedReciprocalRwy: Bool
    @NSManaged public var includedTaxi: Bool
    @NSManaged public var includedTrackShortening: Bool
    @NSManaged public var includedZFWchange: Bool
    @NSManaged public var includedOthers: Bool
    @NSManaged public var selectedArrDelays: Int
    @NSManaged public var selectedTaxi: Int
    @NSManaged public var selectedTrackShortening: Int
    @NSManaged public var selectedFlightLevel000: Int
    @NSManaged public var selectedFlightLevel00: Int
    @NSManaged public var selectedEnrWx: Int
    @NSManaged public var selectedReciprocalRwy: Int
    @NSManaged public var selectedOthers000: Int
    @NSManaged public var selectedOthers00: Int
    @NSManaged public var remarkArrDelays: String?
    @NSManaged public var remarkTaxi: String?
    @NSManaged public var remarkFlightLevel: String?
    @NSManaged public var remarkTrackShortening: String?
    @NSManaged public var remarkEnrWx: String?
    @NSManaged public var remarkReciprocalRwy: String?
    @NSManaged public var remarkZFWChange: String?
    @NSManaged public var remarkOthers: String?
    
    public var unwrappedRemarkArrDelays: String {
        remarkArrDelays ?? ""
    }
    
    public var unwrappedRemarkTaxi: String {
        remarkTaxi ?? ""
    }
    
    public var unwrappedRemarkFlightLevel: String {
        remarkFlightLevel ?? ""
    }
    
    public var unwrappedRemarkTrackShortening: String {
        remarkTrackShortening ?? ""
    }
    
    public var unwrappedRemarkEnrWx: String {
        remarkEnrWx ?? ""
    }
    
    public var unwrappedRemarkReciprocalRwy: String {
        remarkReciprocalRwy ?? ""
    }
    
    public var unwrappedRemarkZFWChange: String {
        remarkZFWChange ?? ""
    }
    
    public var unwrappedRemarkOthers: String {
        remarkOthers ?? ""
    }
}

extension FuelExtraList : Identifiable {

}
