//
//  FlightPlanList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 03/07/2023.
//
//

import Foundation
import CoreData


extension FlightPlanList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FlightPlanList> {
        return NSFetchRequest<FlightPlanList>(entityName: "FlightPlan")
    }

    @NSManaged public var flightInfoPob: String?
    @NSManaged public var perActualZFW: Int
    @NSManaged public var perActualTOW: Int
    @NSManaged public var perActualLDW: Int
    @NSManaged public var fuelArrivalDelayRemark: String?
    @NSManaged public var fuelAdditionalTaxiRemark: String?
    @NSManaged public var fuelFlightLevelRemark: String?
    @NSManaged public var fuelTrackShorteningRemark: String?
    @NSManaged public var fuelEnrouteWeatherRemark: String?
    @NSManaged public var fuelReciprocalRemark: String?
    @NSManaged public var fuelZFWChangeRemark: String?
    @NSManaged public var fuelOtherRemark: String?
    
    public var unwrappedFuelOtherRemark: String {
        fuelOtherRemark ?? ""
    }
    
    public var unwrappedFuelZFWChangeRemark: String {
        fuelZFWChangeRemark ?? ""
    }
    
    public var unwrappedFuelReciprocalRemark: String {
        fuelReciprocalRemark ?? ""
    }

    public var unwrappedFuelEnrouteWeatherRemark: String {
        fuelEnrouteWeatherRemark ?? ""
    }

    public var unwrappedFuelTrackShorteningRemark: String {
        fuelTrackShorteningRemark ?? ""
    }

    public var unwrappedFuelFlightLevelRemark: String {
        fuelFlightLevelRemark ?? ""
    }

    public var unwrappedFuelAdditionalTaxiRemark: String {
        fuelAdditionalTaxiRemark ?? ""
    }

    public var unwrappedFuelArrivalDelayRemark: String {
        fuelArrivalDelayRemark ?? ""
    }

    public var unwrappedPerActualLDW: Int {
        perActualLDW
    }

    public var unwrappedPerActualTOW: Int {
        perActualTOW
    }

    public var unwrappedPerActualZFW: Int {
        perActualZFW
    }

    public var unwrappedFlightInfoPob: String {
        flightInfoPob ?? ""
    }
    
}

extension FlightPlanList : Identifiable {

}
