//
//  FlightPlanModel.swift
//  ATLAS
//
//  Created by phuong phan on 17/06/2023.
//

import Foundation
import SwiftUI

enum FlightPlanEnumeration: CustomStringConvertible {
    case SummaryScreen
    case DepartureScreen
    case EnrouteScreen
    case ArrivalScreen
    case NOTAMScreen
    case METARSScreen
    
    var description: String {
        switch self {
            case .SummaryScreen:
                return "Summary"
            case .DepartureScreen:
                return "Departure"
            case .EnrouteScreen:
                return "Enroute"
            case .ArrivalScreen:
                return "Arrival"
            case .NOTAMScreen:
                return "NOTAM"
            case .METARSScreen:
                return "METARS"
        }
    }
}

struct Tab {
    var icon: Image?
    var title: String
    var screenName: FlightPlanEnumeration
}

let IFlightPlanTabs = [
    Tab(title: "Summary", screenName: FlightPlanEnumeration.SummaryScreen),
    Tab(title: "Departure", screenName: FlightPlanEnumeration.DepartureScreen),
    Tab(title: "Enroute", screenName: FlightPlanEnumeration.EnrouteScreen),
    Tab(title: "Arrival", screenName: FlightPlanEnumeration.ArrivalScreen),
    Tab(title: "NOTAM", screenName: FlightPlanEnumeration.NOTAMScreen),
    Tab(title: "METARS", screenName: FlightPlanEnumeration.METARSScreen)
]
//
//struct IFlightPlanTabs {
//    let ListItem = {
//        let MainItem = [
//            Tab(title: "Summary", screenName: FlightPlanEnumeration.SummaryScreen),
//            Tab(title: "Departure", screenName: FlightPlanEnumeration.DepartureScreen),
//            Tab(title: "Enroute", screenName: FlightPlanEnumeration.EnrouteScreen),
//            Tab(title: "Arrival", screenName: FlightPlanEnumeration.ArrivalScreen),
//            Tab(title: "NOTAM", screenName: FlightPlanEnumeration.NOTAMScreen),
//            Tab(title: "METARS", screenName: FlightPlanEnumeration.METARSScreen)
//        ]
//
//        return MainItem
//    }()
//}

struct IFPSplitModel: Identifiable, Encodable, Decodable {
    var id = UUID()
    var name: String
    var date: String
    var isFavourite: Bool = false
}

// For Flight Plan Split
class FPModelSplitState: ObservableObject {
    
    // Flight Plan Split
    @AppStorage("fpSplitArray") private var fpSplitDataStorage: Data = Data()
    
    @Published var fpSplitArray: [IFPSplitModel] = [] {
        didSet {
            saveFPSplit()
        }
    }
    
    init() {
        loadFPSplit()
    }
    
    private func loadFPSplit() {
        guard let decodedArray = try? JSONDecoder().decode([IFPSplitModel].self, from: fpSplitDataStorage)
        else {
            fpSplitArray = [
                IFPSplitModel(name: "Scheduled Departure", date: "XX:XX", isFavourite: false),
                IFPSplitModel(name: "POB", date: "XX:XX", isFavourite: false),
            ]
            return
        }
        
        fpSplitArray = decodedArray
    }
    
    private func saveFPSplit() {
        guard let encodedArray = try? JSONEncoder().encode(fpSplitArray) else {
            return
        }
        fpSplitDataStorage = encodedArray
    }
}

func calculateWidth(_ width: CGFloat, _ size: Int) -> CGFloat {
    return CGFloat((width - CGFloat(100)) / CGFloat(size))
}

class StepperObject: ObservableObject {
    @Published var hours: Int = 0
    @Published var minutes: Int = 0
    @Published var step: Int = 1
    @Published var range: ClosedRange<Int> = 0...100
}

class ViewModelSummary: ObservableObject {
    @Published var list = [Int: String]()
    @Published var listString = [String: String]()
    @Published var field: String = ""
}

struct Field: View {
    
    // Read the view model, to store the value of the text field
    @EnvironmentObject var viewModel: ViewModelSummary
    
    // Index: where in the dictionary the value will be stored
    let index: Int
    
    // Dedicated state var for each field
    @State private var field = ""
    
    var body: some View {
        TextField("Enter remarks (optional)", text: $field)
    }
    
    // Store the value in the dictionary
    private func store() {
        viewModel.list[index] = field
    }
}

struct FieldString: View {
    // Read the view model, to store the value of the text field
    @EnvironmentObject var viewModel: ViewModelSummary
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController
    
    // Index: where in the dictionary the value will be stored
    let name: String
    
    // Dedicated state var for each field
    @State var field: String = ""
    
    var body: some View {
        TextField("Enter remarks (optional)", text: $field)
            .onAppear {
                let item = coreDataModel.dataFlightPlan
                
                switch name {
                    case "POB":
                        field = item.unwrappedFlightInfoPob
                    case "perActualZFW":
                        field = "\(item.unwrappedPerActualZFW)"
                    case "perActualTOW":
                        field = "\(item.unwrappedPerActualTOW)"
                    case "perActualLDW":
                        field = "\(item.unwrappedPerActualLDW)"
                    case "fuelArrivalDelayRemark":
                        field = item.unwrappedFuelArrivalDelayRemark
                    case "fuelAdditionalTaxiRemark":
                        field = item.unwrappedFuelAdditionalTaxiRemark
                    case "fuelFlightLevelRemark":
                        field = item.unwrappedFuelFlightLevelRemark
                    case "fuelTrackShorteningRemark":
                        field = item.unwrappedFuelTrackShorteningRemark
                    case "fuelEnrouteWeatherRemark":
                        field = item.unwrappedFuelEnrouteWeatherRemark
                    case "fuelReciprocalRemark":
                        field = item.unwrappedFuelReciprocalRemark
                    case "fuelZFWChangeRemark":
                        field = item.unwrappedFuelZFWChangeRemark
                    case "fuelOtherRemark":
                        field = item.unwrappedFuelOtherRemark
                    default:
                        field = ""
                }
            }
            .onSubmit {
                var item = coreDataModel.dataFlightPlan
                
                if !coreDataModel.existDataFlightPlan {
                    item = FlightPlanList(context: persistenceController.container.viewContext)
                }
                
                switch name {
                case "POB":
                    item.flightInfoPob = field
                case "perActualZFW":
                    item.perActualZFW = Int(field) ?? 0
                case "perActualTOW":
                    item.perActualTOW = Int(field) ?? 0
                case "perActualLDW":
                    item.perActualLDW = Int(field) ?? 0
                case "fuelArrivalDelayRemark":
                    item.fuelArrivalDelayRemark = field
                case "fuelAdditionalTaxiRemark":
                    item.fuelAdditionalTaxiRemark = field
                case "fuelFlightLevelRemark":
                    item.fuelFlightLevelRemark = field
                case "fuelTrackShorteningRemark":
                    item.fuelTrackShorteningRemark = field
                case "fuelEnrouteWeatherRemark":
                    item.fuelEnrouteWeatherRemark = field
                case "fuelReciprocalRemark":
                    item.fuelReciprocalRemark = field
                case "fuelZFWChangeRemark":
                    item.fuelZFWChangeRemark = field
                case "fuelOtherRemark":
                    item.fuelOtherRemark = field
                default:
                    item.perActualZFW = Int(field) ?? 0
                }
                
                coreDataModel.save()
                coreDataModel.readFlightPlan()
            }
    }
}
