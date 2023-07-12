//
//  FlightPlanModel.swift
//  ATLAS
//
//  Created by phuong phan on 17/06/2023.
//

import Foundation
import SwiftUI

enum FuelEnumeration: CustomStringConvertible {
    case ArrivalDelayScreen
    case TaxiTimeScreen
    case TrackMileScreen
    case EnrouteWeatherScreen
    case FlightLevelScreen
    case ReciprocalRunwayScreen
    
    var description: String {
        switch self {
            case .ArrivalDelayScreen:
                return "ArrivalDelay"
            case .TaxiTimeScreen:
                return "TaxiTime"
            case .TrackMileScreen:
                return "TrackMile"
            case .EnrouteWeatherScreen:
                return "EnrouteWeather"
            case .FlightLevelScreen:
                return "FlightLevel"
            case .ReciprocalRunwayScreen:
                return "ReciprocalRunway"
        }
    }
}

let IFuelTabs = [
    FuelTab(title: "Arrival Delay", screenName: FuelEnumeration.ArrivalDelayScreen),
    FuelTab(title: "Taxi Time", screenName: FuelEnumeration.TaxiTimeScreen),
    FuelTab(title: "Track Miles", screenName: FuelEnumeration.TrackMileScreen),
    FuelTab(title: "Enroute Weather", screenName: FuelEnumeration.EnrouteWeatherScreen),
    FuelTab(title: "Flight Level", screenName: FuelEnumeration.FlightLevelScreen),
    FuelTab(title: "Reciprocal Runway", screenName: FuelEnumeration.ReciprocalRunwayScreen)
]

struct FuelTab {
    var icon: Image?
    var title: String
    var screenName: FuelEnumeration
}
