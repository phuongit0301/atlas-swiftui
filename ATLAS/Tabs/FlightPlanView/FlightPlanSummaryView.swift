//
//  FlightPlanSummaryView.swift
//  ATLAS
//
//  Created by Muhammad Adil on 22/6/23.
//

import Foundation
import SwiftUI

// creating flight info table structure
struct flightInfo: Identifiable, Equatable {
    let flightNo: String
    let aircraft: String
    let depDest: String
    let date: String
    let stdUTC: String
    let staUTC: String
    let stdLocal: String
    let staLocal: String
    let blkTime: String
    let fltTime: String
    let id = UUID()
}

// creating perf info table structure
struct perfInfo: Identifiable {
    let fltRules: String
    let gndMiles: String
    let airMiles: String
    let crzComp: String
    let apd: String
    let ci: String
    let id = UUID()
}

// creating perf changes table structure
struct perfChanges: Identifiable {
    let zfwChange: String
    let lvlChange: String
    let id = UUID()
}

// creating perf weights table structure
struct perfWeights: Identifiable {
    let weight: String
    let plan: String
    let actual: String
    let max: String
    let limitation: String
    let id = UUID()
}

// creating fuel info table structure
struct fuel: Identifiable {
    let firstColumn: String
    let time: String
    let fuel: String
    let policy_reason: String
    let id = UUID()
}

// creating altn table structure
struct altn: Identifiable {
    let altnRwy: String
    let rte: String
    let vis: String
    let minima: String
    let dist: String
    let fl: String
    let comp: String
    let time: String
    let fuel: String
    let id = UUID()
}


struct FlightPlanSummaryView: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var viewModelSummary: ViewModelSummary
    @EnvironmentObject var persistenceController: PersistenceController
    
    @ObservedObject var globalResponse = GlobalResponse.shared
    
    // initialise state variables
    @State private var showUTC = true
    
    @State private var isShowModal: Bool = false
    @State private var isShowModalMultiple: Bool = false
    @State private var target: String = "ArrDelays"
    @State private var header: String = "Arrival Delays"
    @State private var items: ClosedRange<Int> = 0...120
    @State private var selectionOutput: Int = 0
    @State private var selectionOutputMultiple: String = ""
    
    @State private var isShowArrDelays: Bool = false
    @State private var dataArrDelays: ClosedRange<Int> = 0...120
    
    @State private var dataIncludedTaxi: ClosedRange<Int> = 0...60
    @State private var dataTrackShortening: ClosedRange<Int> = -30...0

    @State private var collapsed = false
    @State private var selection: Int = 0
    @State private var selection1: Int = 0
    @State private var selection2: Int = 0
    
    // for these variables: todo save/fetch all to/from core data
    @State private var includedArrDelays = false
    @State private var includedTaxi = false
    @State private var includedFlightLevel = false
    @State private var includedTrackShortening = false
    @State private var includedEnrWx = false
    @State private var includedReciprocalRwy = false
    @State private var includedZFWchange = false
    @State private var includedOthers = false
    
    @State private var selectedArrDelays: Int = 0
    
    @State private var selectedTaxi: Int = 0
    
    @State private var selectedTrackShortening: Int = 0
    
    @State private var selectedFlightLevel000: Int = 0
    @State private var selectedFlightLevel00: Int = 0
    @State private var selectedFlightLevelPrint: String = "0ft"
    
    @State private var selectedEnrWx: Int = 0
    
    @State private var selectedReciprocalRwy: Int = 0
    
    @State private var selectedOtherPrint: String = "0KG"
    
    @State private var selectedOthers000: Int = 0
    @State private var selectedOthers00: Int = 0
    @State private var actualZFW: Int = 0
    @State private var pob: String = ""
    @State private var perActualZFW: String = ""

    var body: some View {
        @StateObject var viewModel = ViewModelSummary()
        
        // MARK: fetch flight plan data - todo move to core data
        let flightPlanData: [String : Any] = fetchFlightPlanData()
        
        // MARK: fetch fuel data - todo move to core data
        let allAPIresponse = convertAllresponseFromAPI(jsonString: globalResponse.response)
        let fetchedDelays = allAPIresponse["projDelays"] as! [String : Any]
        let fetchedLevels = allAPIresponse["flightLevel"] as! [String : [String : Any]]
        let fetchedMiles = allAPIresponse["trackMiles"] as! [String : [String : Any]]
        let fetchedTimes = allAPIresponse["taxi"] as! [String : [String : Any]]
        let fetchedEnrWX = allAPIresponse["enrWX"] as! [String : [String : Any]]
        // arrival delays
        let projDelay: Int = fetchedDelays["expectedDelay"] as! Int
        // taxi
        let threeFlightsTaxi = fetchedTimes["flights3"]
        let aveDiffTaxi: Int = threeFlightsTaxi!["aveDiff"] as! Int
        // track miles
        let threeFlightsMiles = fetchedMiles["flights3"]!
        let sumMINS: Int = threeFlightsMiles["sumMINS"] as! Int
        // enroute weather
        let threeFlightsEnrWX = fetchedEnrWX["flights3"]!
        let aveDiffEnrWX: Int = threeFlightsEnrWX["aveMINS"] as! Int
        // flight level
        let threeFlightsLevels = fetchedLevels["flights3"]!
        let aveDiffLevels: Int = threeFlightsLevels["aveDiff"] as! Int
        // reciprocal rwy
        let reciprocalRwy: Int = 5  // todo adil add reciprocal rwy fuel data
        
        // set up flight info table data
//        let flightInfoData: InfoData = flightPlanData["infoData"] as! InfoData
//        @State var infoTable =
//            flightInfo(flightNo: flightInfoData.fltNo, aircraft: flightInfoData.tailNo, depDest: flightInfoData.dep+" / "+flightInfoData.dest, date: flightInfoData.flightDate, stdUTC: flightInfoData.STDUTC, staUTC: flightInfoData.STAUTC, stdLocal: flightInfoData.STDLocal, staLocal: flightInfoData.STALocal, blkTime: flightInfoData.BLKTime, fltTime: flightInfoData.FLTTime)
        
        // set up route data
//        let flightRouteData: RouteData = flightPlanData["routeData"] as! RouteData
        
        // MARK: set up perf tables data
        let perfData: PerfData = flightPlanData["perfData"] as! PerfData
        
//        @State var perfWeightsTable = [
//            perfWeights(weight: "ZFW", plan: perfData.planZFW, actual: "perActualZFW", max: perfData.maxZFW, limitation: perfData.limZFW),
//            perfWeights(weight: "TOW", plan: perfData.planTOW, actual: "perActualTOW", max: perfData.maxTOW, limitation: perfData.limTOW),
//            perfWeights(weight: "LDW", plan: perfData.planLDW, actual: "perActualLDW", max: perfData.maxLDW, limitation: perfData.limLDW),
//        ]
        
        // MARK: set up fuel info table data
        let fuelData: FuelData = flightPlanData["fuelData"] as! FuelData
        @State var fuelTable = [
            fuel(firstColumn: "(A) Burnoff", time: fuelData.burnoff["time"]!, fuel: fuelData.burnoff["fuel"]!, policy_reason: ""),
            fuel(firstColumn: "(B) Contingency Fuel", time: fuelData.cont["time"]!, fuel: fuelData.cont["fuel"]!, policy_reason: fuelData.cont["policy"]!),
            fuel(firstColumn: "(C) Altn Fuel", time: fuelData.altn["time"]!, fuel: fuelData.altn["fuel"]!, policy_reason: ""),
            fuel(firstColumn: "(D) Altn Hold", time: fuelData.hold["time"]!, fuel: fuelData.hold["fuel"]!, policy_reason: ""),
            fuel(firstColumn: "(E) 60min Topup Fuel", time: fuelData.topup60["time"]!, fuel: fuelData.topup60["fuel"]!, policy_reason: ""),
            fuel(firstColumn: "(F) Taxi Fuel", time: fuelData.taxi["time"]!, fuel: fuelData.taxi["fuel"]!, policy_reason: fuelData.taxi["policy"]!),
            fuel(firstColumn: "(G) Flight Plan Requirement (A + B + C + D + E + F)", time: fuelData.planReq["time"]!, fuel: fuelData.planReq["fuel"]!, policy_reason: ""),
            fuel(firstColumn: "(H) Dispatch Additional Fuel", time: fuelData.dispAdd["time"]!, fuel: fuelData.dispAdd["fuel"]!, policy_reason: fuelData.dispAdd["policy"]!)
        ]
        // MARK: fuel calculations
        let calculatedDelayFuelValue: Int = selectedArrDelays * Int(fuelData.hold["unit"]!)!
        var calculatedDelayFuel: String {
            let result = calculatedDelayFuelValue
            if result <= 0 {
                return "\(result)"
            } else {
                return "+\(result)"
            }
        }
        var includedDelayFuel: [String: Any] {
            if includedArrDelays && calculatedDelayFuelValue > 0 {
                let remarks = coreDataModel.dataFlightPlan.unwrappedFuelArrivalDelayRemark
                if remarks == "" {
                    return ["fuel": calculatedDelayFuelValue, "time": selectedArrDelays, "remarks": "Arrival Delays (\(calculatedDelayFuel)KG);"]
                } else {
                    return ["fuel": calculatedDelayFuelValue, "time": selectedArrDelays, "remarks": "Arrival Delays (\(calculatedDelayFuel)KG, \(remarks));"]
                }
            } else {
                return ["fuel": 0, "time": 0, "remarks": ""]
            }
        }
        
        let calculatedTaxiFuelValue = selectedTaxi * Int(fuelData.taxi["unit"]!)!
        var calculatedTaxiFuel: String {
            let result = calculatedTaxiFuelValue
            if result <= 0 {
                return "\(result)"
            } else {
                return "+\(result)"
            }
        }
        var includedTaxiFuel: [String: Any] {
            if includedTaxi && calculatedTaxiFuelValue > 0 {
                let remarks = coreDataModel.dataFlightPlan.unwrappedFuelAdditionalTaxiRemark
                if remarks == "" {
                    return ["fuel": calculatedTaxiFuelValue, "time": selectedTaxi, "remarks": "Additional Taxi Time (\(calculatedTaxiFuel)KG);"]
                } else {
                    return ["fuel": calculatedTaxiFuelValue, "time": selectedTaxi, "remarks": "Additional Taxi Time (\(calculatedTaxiFuel)KG, \(remarks));"]
                }
            } else {
                return ["fuel": 0, "time": 0, "remarks": ""]
            }
        }
        
        var calculatedFlightLevelFuelValue: Int {
            let selectedFlightLevel: Int = selectedFlightLevel000 * 1000 + selectedFlightLevel00 * 100
            let unit = Double(perfData.lvlChange)! / 2000
            let result = Int(Double(selectedFlightLevel) * unit)

            return result
        }
        var calculatedFlightLevelFuel: String {
            let result = calculatedFlightLevelFuelValue
            if result <= 0 {
                return "\(result)"
            } else {
                return "+\(result)"
            }
        }
        var includedFlightLevelFuel: [String: Any] {
            if includedFlightLevel && calculatedFlightLevelFuelValue != 0 {
                let remarks = coreDataModel.dataFlightPlan.unwrappedFuelFlightLevelRemark
                if remarks == "" {
                    return ["fuel": calculatedFlightLevelFuelValue, "remarks": "Flight Level Deviation (\(calculatedFlightLevelFuel)KG);"]
                } else {
                    return ["fuel": calculatedFlightLevelFuelValue, "remarks": "Flight Level Deviation (\(calculatedFlightLevelFuel)KG, \(remarks));"]
                }
            } else {
                return ["fuel": 0, "remarks": ""]
            }
        }
        
        let calculatedTrackShorteningFuelValue = selectedTrackShortening * Int(fuelData.burnoff["unit"]!)!
        var calculatedTrackShorteningFuel: String {
            let result = calculatedTrackShorteningFuelValue
            if result <= 0 {
                return "\(result)"
            } else {
                return "+\(result)"
            }
        }
        var includedTrackShorteningFuel: [String: Any] {
            if includedTrackShortening {
                let remarks = coreDataModel.dataFlightPlan.unwrappedFuelTrackShorteningRemark
                if calculatedTrackShorteningFuelValue < 0 {
                    if remarks == "" {
                        return ["fuel": calculatedTrackShorteningFuelValue, "time": selectedTrackShortening, "remarks": "Track Shortening Savings (\(calculatedTrackShorteningFuel)KG);"]
                    } else {
                        return ["fuel": calculatedTrackShorteningFuelValue, "time": selectedTrackShortening, "remarks": "Track Shortening Savings (\(calculatedTrackShorteningFuel)KG, \(remarks));"]
                    }
                }
                else {
                    return ["fuel": 0, "time": 0, "remarks": ""]
                }
            } else {
                return ["fuel": 0, "time": 0, "remarks": ""]
            }
        }
        
        let calculatedEnrWxFuelValue = selectedEnrWx * Int(fuelData.burnoff["unit"]!)!
        var calculatedEnrWxFuel: String {
            let result = calculatedEnrWxFuelValue
            if result <= 0 {
                return "\(result)"
            } else {
                return "+\(result)"
            }
        }
        var includedEnrWxFuel: [String: Any] {
            if includedEnrWx && calculatedEnrWxFuelValue > 0{
                let remarks = coreDataModel.dataFlightPlan.unwrappedFuelEnrouteWeatherRemark
                if remarks == "" {
                    return ["fuel": calculatedEnrWxFuelValue, "time": selectedEnrWx, "remarks": "Enroute Weather Deviation (\(calculatedEnrWxFuel)KG);"]
                } else {
                    return ["fuel": calculatedEnrWxFuelValue, "time": selectedEnrWx, "remarks": "Enroute Weather Deviation (\(calculatedEnrWxFuel)KG, \(remarks));"]
                }
            } else {
                return ["fuel": 0, "time": 0, "remarks": ""]
            }
        }
        
        let calculatedReciprocalRwyFuelValue = selectedReciprocalRwy * Int(fuelData.altn["unit"]!)!
        var calculatedReciprocalRwyFuel: String {
            let result = calculatedReciprocalRwyFuelValue
            if result <= 0 {
                return "\(result)"
            } else {
                return "+\(result)"
            }
        }
        var includedReciprocalRwyFuel: [String: Any] {
            let remarks = coreDataModel.dataFlightPlan.unwrappedFuelReciprocalRemark
            if (includedReciprocalRwy && selectedReciprocalRwy > 0) {
                if remarks == "" {
                    return ["fuel": calculatedReciprocalRwyFuelValue, "time": selectedReciprocalRwy, "remarks": "Reciprocal Rwy (\(calculatedReciprocalRwyFuel)KG);"]
                } else {
                    return ["fuel": calculatedReciprocalRwyFuelValue, "time": selectedReciprocalRwy, "remarks": "Reciprocal Rwy (\(calculatedReciprocalRwyFuel)KG, \(remarks));"]
                }
            } else if (includedReciprocalRwy && selectedReciprocalRwy < 0) {
                if remarks == "" {
                    return ["fuel": calculatedReciprocalRwyFuelValue, "time": selectedReciprocalRwy, "remarks": "Reciprocal Rwy Savings (\(calculatedReciprocalRwyFuel)KG);"]
                } else {
                    return ["fuel": calculatedReciprocalRwyFuelValue, "time": selectedReciprocalRwy, "remarks": "Reciprocal Rwy Savings (\(calculatedReciprocalRwyFuel)KG, \(remarks);"]
                }
            } else {
                return ["fuel": 0, "time": 0, "remarks": ""]
            }
        }
         
        let calculatedZFWFuelValue = coreDataModel.calculatedZFWFuel(perfData)
        var calculatedZFWFuel: String {
            let result = calculatedZFWFuelValue
            if result <= 0 {
                return "\(result)"
            } else {
                return "+\(result)"
            }
        }
        var includedZFWFuel: [String: Any] {
            let remarks = coreDataModel.dataFlightPlan.unwrappedFuelZFWChangeRemark
            if (includedZFWchange && calculatedZFWFuelValue > 0) {
                if remarks == "" {
                    return ["fuel": calculatedZFWFuelValue, "remarks": "ZFW Increase (\(calculatedZFWFuel)KG);"]
                } else {
                    return ["fuel": calculatedZFWFuelValue, "remarks": "ZFW Increase (\(calculatedZFWFuel)KG, \(remarks));"]
                }
            } else if (includedZFWchange && calculatedZFWFuelValue < 0) {
                return ["fuel": calculatedZFWFuelValue, "remarks": ""]
            } else {
                return ["fuel": 0, "remarks": ""]
            }
        }
        
        let calculatedOthersFuelValue = selectedOthers000 * 1000 + selectedOthers00 * 100
        var calculatedOthersFuel: String {
            let selectedOthers = calculatedOthersFuelValue
            let result = selectedOthers
            if result <= 0 {
                return "\(result)"
            } else {
                return "+\(result)"
            }
        }
        var includedOthersFuel: [String: Any] {
            let remarks = coreDataModel.dataFlightPlan.unwrappedFuelOtherRemark
            if includedOthers && calculatedOthersFuelValue > 0 {
                if remarks == "" {
                    return ["fuel": calculatedOthersFuelValue, "remarks": "Others (\(calculatedOthersFuel)KG);"]
                } else {
                    return ["fuel": calculatedOthersFuelValue, "remarks": "Others (\(calculatedOthersFuel)KG, \(remarks));"]
                }
            } else {
                return ["fuel": 0, "remarks": ""]
            }
        }
        
        // MARK: set up altn table data
        let altnData: [AltnData] = flightPlanData["altnData"] as! [AltnData]
        @State var altnTable: [altn] = altnData.map { item in
            return altn(
                altnRwy: item.altnRwy,
                rte: item.rte,
                vis: item.vis,
                minima: item.minima,
                dist: item.dist,
                fl: item.fl,
                comp: item.comp,
                time: item.time,
                fuel: item.fuel
            )
        }

//        let atcFlightPlan: String = flightPlanData["atcFlightPlanData"] as! String
        
        // MARK: main body
        GeometryReader { proxy in
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    Text("Summary")
                        .font(.system(size: 20, weight: .semibold))
                    
                    Spacer().frame(maxWidth: .infinity)
                    
                    Button(action: {}) {  // todo add the action here, fix design
                        Text("Sign-off").foregroundColor(.white).font(.system(size: 17, weight: .regular))
                    }
                    .padding(.vertical, 11)
                    .padding(.horizontal)
                    .background(Color.theme.philippineGray3)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.white, lineWidth: 1)
                        )
                    
                }.padding(.bottom, 10)
                    .padding(.horizontal, 30)
                
                Text("Plan \(coreDataModel.dataSummaryInfo.unwrappedPlanNo) | Last updated 0820LT")
                    .font(.system(size: 15, weight: .semibold))
                    .padding(.leading, 30)
                    .padding(.bottom, 10)
                //scrollable outer list section
                List {
                    // MARK: Flight information section
                    Section(header:
                                HStack(alignment: .center) {
                        Text("FLIGHT INFORMATION")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(Color.black)
                        
                        Spacer()
                        
                        HStack {
                            Toggle(isOn: $showUTC) {
                                Text("Local").font(.system(size: 17, weight: .regular))
                                    .foregroundStyle(Color.black)
                            }
                            Text("UTC").font(.system(size: 17, weight: .regular))
                                .foregroundStyle(Color.black)
                        }.fixedSize(horizontal: true, vertical: false)
                    }) {
                        if showUTC {
                            VStack {
                                HStack {
                                    Group {
                                        Text("Flight No.").frame(width: calculateWidth(proxy.size.width - 65, 9), alignment: .leading)
                                        Text("Aircraft").frame(width: calculateWidth(proxy.size.width - 65, 9), alignment: .leading)
                                        Text("DEP / DEST").frame(width: calculateWidth(proxy.size.width - 65, 9), alignment: .leading)
                                        Text("Date").frame(width: calculateWidth(proxy.size.width - 65, 9), alignment: .leading)
                                        Text("STD").frame(width: calculateWidth(proxy.size.width - 65, 9), alignment: .leading)
                                        Text("STA").frame(width: calculateWidth(proxy.size.width - 65, 9), alignment: .leading)
                                        Text("BLK Time").frame(width: calculateWidth(proxy.size.width - 65, 9), alignment: .leading)
                                        Text("FLT Time").frame(width: calculateWidth(proxy.size.width - 65, 9), alignment: .leading)
                                        Text("POB").frame(width: calculateWidth(proxy.size.width - 65, 9), alignment: .leading)
                                    }
                                    .foregroundStyle(Color.blue)
                                    .font(.system(size: 15, weight: .medium))
                                }
                                HStack {
                                    Group {
                                        Text("\(coreDataModel.dataSummaryInfo.unwrappedFltNo)").frame(width: calculateWidth(proxy.size.width - 65, 9), alignment: .leading)
                                        Text("\(coreDataModel.dataSummaryInfo.unwrappedTailNo)").frame(width: calculateWidth(proxy.size.width - 65, 9), alignment: .leading)
                                        Text("\(coreDataModel.dataSummaryInfo.unwrappedDep+" / "+coreDataModel.dataSummaryInfo.unwrappedDest)").frame(width: calculateWidth(proxy.size.width - 65, 9), alignment: .leading)
                                        Text("\(coreDataModel.dataSummaryInfo.unwrappedFlightDate)").frame(width: calculateWidth(proxy.size.width - 65, 9), alignment: .leading)
                                        Text("\(coreDataModel.dataSummaryInfo.unwrappedStdUTC)").frame(width: calculateWidth(proxy.size.width - 65, 9), alignment: .leading)
                                        Text("\(coreDataModel.dataSummaryInfo.unwrappedStaUTC)").frame(width: calculateWidth(proxy.size.width - 65, 9), alignment: .leading)
                                        Text("\(coreDataModel.dataSummaryInfo.unwrappedBlkTime)").frame(width: calculateWidth(proxy.size.width - 65, 9), alignment: .leading)
                                        Text("\(coreDataModel.dataSummaryInfo.unwrappedFltTime)").frame(width: calculateWidth(proxy.size.width - 65, 9), alignment: .leading)
                                    }.font(.system(size: 17, weight: .regular))
                                    Group {
                                        // entry here
                                        TextField(
                                            "POB",
                                            text: $pob
                                        )
                                        .onSubmit {
                                            if coreDataModel.existDataSummaryInfo {
                                                coreDataModel.dataSummaryInfo.pob = pob
                                            } else {
                                                let item = SummaryInfoList(context: persistenceController.container.viewContext)
                                                item.pob = pob
                                            }
                                            coreDataModel.save()
                                        }
                                        .border(.secondary)
                                    }.font(.system(size: 17, weight: .regular))
                                    .frame(width: calculateWidth(proxy.size.width - 65, 9), alignment: .leading)
                                }
                            }
                        }
                        else {
                            VStack {
                                HStack {
                                    Group {
                                        Text("Flight No.").frame(width: calculateWidth(proxy.size.width - 65, 9), alignment: .leading)
                                        Text("Aircraft").frame(width: calculateWidth(proxy.size.width - 65, 9), alignment: .leading)
                                        Text("DEP / DEST").frame(width: calculateWidth(proxy.size.width - 65, 9), alignment: .leading)
                                        Text("Date").frame(width: calculateWidth(proxy.size.width - 65, 9), alignment: .leading)
                                        Text("STD").frame(width: calculateWidth(proxy.size.width - 65, 9), alignment: .leading)
                                        Text("STA").frame(width: calculateWidth(proxy.size.width - 65, 9), alignment: .leading)
                                        Text("BLK Time").frame(width: calculateWidth(proxy.size.width - 65, 9), alignment: .leading)
                                        Text("FLT Time").frame(width: calculateWidth(proxy.size.width - 65, 9), alignment: .leading)
                                        Text("POB").frame(width: calculateWidth(proxy.size.width - 65, 9), alignment: .leading)
                                    }
                                    .foregroundStyle(Color.blue)
                                    .font(.system(size: 15, weight: .medium))
                                }
                                HStack {
                                    Group {
                                        Text("\(coreDataModel.dataSummaryInfo.unwrappedFltNo)").frame(width: calculateWidth(proxy.size.width - 65, 9), alignment: .leading)
                                        Text("\(coreDataModel.dataSummaryInfo.unwrappedTailNo)").frame(width: calculateWidth(proxy.size.width - 65, 9), alignment: .leading)
                                        Text("\(coreDataModel.dataSummaryInfo.unwrappedDep+" / "+coreDataModel.dataSummaryInfo.unwrappedDest)").frame(width: calculateWidth(proxy.size.width - 65, 9), alignment: .leading)
                                        Text("\(coreDataModel.dataSummaryInfo.unwrappedFlightDate)").frame(width: calculateWidth(proxy.size.width - 65, 9), alignment: .leading)
                                        Text("\(coreDataModel.dataSummaryInfo.unwrappedStdLocal)").frame(width: calculateWidth(proxy.size.width - 65, 9), alignment: .leading)
                                        Text("\(coreDataModel.dataSummaryInfo.unwrappedStaLocal)").frame(width: calculateWidth(proxy.size.width - 65, 9), alignment: .leading)
                                        Text("\(coreDataModel.dataSummaryInfo.unwrappedBlkTime)").frame(width: calculateWidth(proxy.size.width - 65, 9), alignment: .leading)
                                        Text("\(coreDataModel.dataSummaryInfo.unwrappedFltTime)").frame(width: calculateWidth(proxy.size.width - 65, 9), alignment: .leading)
                                        // entry here
                                        TextField(
                                            "POB",
                                            text: $pob
                                        )
                                        .onSubmit {
                                            if coreDataModel.existDataSummaryInfo {
                                                coreDataModel.dataSummaryInfo.pob = pob
                                            } else {
                                                let item = SummaryInfoList(context: persistenceController.container.viewContext)
                                                item.pob = pob
                                            }

                                            coreDataModel.save()
                                        }
                                        .border(.secondary)
                                        
                                    }.font(.system(size: 17, weight: .regular))
                                        .frame(width: calculateWidth(proxy.size.width - 65, 9), alignment: .leading)
                                }
                            }
                        }
                        
                    }
                    
                    // MARK: Route section
                    Section(header: Text("ROUTE").foregroundStyle(Color.black).font(.system(size: 15, weight: .semibold))) {
                        // grouped row using hstack
                        VStack(alignment: .leading) {
                            HStack(alignment: .center) {
                                Text("Route No.")
                                    .foregroundStyle(Color.blue)
                                    .frame(maxWidth: 144, alignment: .leading)
                                    .font(.system(size: 15, weight: .medium))
                                Text(coreDataModel.dataSummaryRoute.unwrappedRouteNo)
                                    .frame(maxWidth: 860, alignment: .leading)
                                    .font(.system(size: 17, weight: .regular))
                            }
                            .padding(.top, 5)
                            .padding(.bottom, 5)
                            .padding(.leading, 25)
                            
                            Divider().padding(.leading, 25)
                            
                            HStack(alignment: .center) {
                                Text("Route")
                                    .foregroundStyle(Color.blue)
                                    .frame(maxWidth: 144, alignment: .leading)
                                    .font(.system(size: 15, weight: .medium))
                                Text(coreDataModel.dataSummaryRoute.unwrappedRoute)
                                    .frame(maxWidth: 860, alignment: .leading)
                                    .font(.system(size: 17, weight: .regular))
                            }
                            .padding(.top, 5)
                            .padding(.bottom, 5)
                            .padding(.leading, 25)
                            
                            Divider().padding(.leading, 25)
                            
                            HStack(alignment: .center) {
                                Text("Planned Dep Rwy")
                                    .foregroundStyle(Color.blue)
                                    .frame(maxWidth: 144, alignment: .leading)
                                    .font(.system(size: 15, weight: .medium))
                                Text(coreDataModel.dataSummaryRoute.unwrappedDepRwy)
                                    .frame(maxWidth: 860, alignment: .leading)
                                    .font(.system(size: 17, weight: .regular))
                            }
                            .padding(.top, 5)
                            .padding(.bottom, 5)
                            .padding(.leading, 25)
                            
                            Divider().padding(.leading, 25)
                            
                            HStack(alignment: .center) {
                                Text("Planned Arr Rwy")
                                    .foregroundStyle(Color.blue)
                                    .frame(maxWidth: 144, alignment: .leading)
                                    .font(.system(size: 15, weight: .medium))
                                Text(coreDataModel.dataSummaryRoute.unwrappedArrRwy)
                                    .frame(maxWidth: 860, alignment: .leading)
                                    .font(.system(size: 17, weight: .regular))
                            }
                            .padding(.top, 5)
                            .padding(.bottom, 5)
                            .padding(.leading, 25)
                            
                            Divider().padding(.leading, 25)
                            
                            HStack(alignment: .center) {
                                Text("Planned levels")
                                    .foregroundStyle(Color.blue)
                                    .frame(maxWidth: 144, alignment: .leading)
                                    .font(.system(size: 15, weight: .medium))
                                Text(coreDataModel.dataSummaryRoute.unwrappedLevels)
                                    .frame(maxWidth: 860, alignment: .leading)
                                    .font(.system(size: 17, weight: .regular))
                            }
                            .padding(.top, 5)
                            .padding(.bottom, 5)
                            .padding(.leading, 25)
                        }
                    }
                    
                    // MARK: Performance section
                    Section(header: Text("PERFORMANCE").foregroundStyle(Color.black).font(.system(size: 15, weight: .semibold))) {
                        // table body - first row
                        Table(coreDataModel.dataPerfInfo) {
                            TableColumn("FLT Rules", value: \.unwrappedFltRules)
                            TableColumn("GND Miles", value: \.unwrappedGndMiles)
                            TableColumn("AIR Miles", value: \.unwrappedAirMiles)
                            TableColumn("CRZ Comp", value: \.unwrappedCrzComp)
                            TableColumn("APD", value: \.unwrappedApd)
                            TableColumn("CI", value: \.unwrappedCi)
                        }
                        .frame(minHeight: 65)
                        .scrollDisabled(true)
                        // table body - changes
                        Table(coreDataModel.perfChangesTable) {
                            TableColumn("ZFW Change", value: \.zfwChange)
                            TableColumn("FL Change", value: \.lvlChange)
                        }
                        .frame(minHeight: 65)
                        .scrollDisabled(true)
                        // table body - weights
                        Table(coreDataModel.dataPerfWeight) {
                            TableColumn("Weight", value: \.unwrappedWeight)
                            TableColumn("Plan", value: \.unwrappedPlan)
                            TableColumn("Actual") {
                                CustomField(item: $0)
                            }
                            TableColumn("Max", value: \.unwrappedMax)
                            TableColumn("Limitation", value: \.unwrappedLimitation)
                        }
                        .frame(minHeight: 185)
                        .scrollDisabled(true)
                    }
                    
                    // MARK: Fuel section
                    Section(header: Text("FUEL").foregroundStyle(Color.black)) {
                        // grouped row using hstack
                        VStack(alignment: .leading, spacing: 0) {
                             //fuel info table body
                            Table(coreDataModel.dataFuelList) {
                                TableColumn("", value: \.unwrappedFirstColumn).width(420)
                                TableColumn("Time", value: \.unwrappedTime)
                                TableColumn("Fuel", value: \.unwrappedFuel)
                                TableColumn("Policy / Reason", value: \.unwrappedPolicyReason)
                            }
                            .frame(minHeight: 380)
                            .scrollDisabled(true)
                        }.listRowSeparator(.hidden)
                        
                        VStack(alignment: .leading, spacing: 0) {
                            // extra fuel section
                            // row I
                            VStack(alignment: .leading, spacing: 0) {
                                HStack(alignment: .center) {
                                    HStack(alignment: .center) {
                                        Text("(I) Pilot Extra Fuel")
                                            .frame(maxWidth: 310, alignment: .leading)
//                                        Text(includedExtraFuelTime(includedDelayFuel, includedTrackShorteningFuel, includedEnrWxFuel, includedReciprocalRwyFuel))
                                        Text("Confirm requirements")
                                            .frame(maxWidth: .infinity, alignment: .leading)
//                                        Text(includedExtraFuelAmt(includedDelayFuel, includedTaxiFuel, includedFlightLevelFuel, includedZFWFuel, includedEnrWxFuel, includedReciprocalRwyFuel, includedTrackShorteningFuel, includedOthersFuel))
                                        Text("Confirm requirements")
                                            .frame(maxWidth: .infinity, alignment: .leading)
//                                        Text(includedExtraFuelRemarks(includedDelayFuel, includedTaxiFuel, includedFlightLevelFuel, includedZFWFuel, includedEnrWxFuel, includedReciprocalRwyFuel, includedTrackShorteningFuel, includedOthersFuel))
                                        Text("Confirm requirements")
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }.padding(.vertical)
                                        .padding(.horizontal, 45)
                                    .frame(width: proxy.size.width - 25)
                                }.background(Color.theme.azure.opacity(0.12))
                                .frame(width: proxy.size.width)
                                Divider()
                            }.onTapGesture {
                                withAnimation {
                                    self.collapsed.toggle()
                                }
                            }.animation(nil)
                                .frame(alignment: .top)
                            
                            if collapsed {
                                VStack(spacing: 0) {
                                    Group {
                                        // header row
                                        HStack(alignment: .center) {
                                            HStack(alignment: .center) {
                                                Text("Included")
                                                    .frame(width: 70, alignment: .leading)
                                                    .padding(.horizontal, 24)
                                                Text("Reason")
                                                    .frame(width: 210, alignment: .leading)
                                                    .padding(.horizontal)
                                                HStack {
                                                    Text("Statistical")
                                                    
//                                                    NavigationLink(destination: FuelView()) {
//                                                        Text("Details").foregroundStyle(Color.blue)
//                                                    }.navigationBarBackButtonHidden()
//                                                    .navigationBarHidden(true)
//                                                    .buttonStyle(.plain)
                                                    Text("Details").foregroundStyle(Color.blue)
                                                   
                                                        
                                                }.frame(width: calculateWidth(proxy.size.width - 598, 3), alignment: .leading)
                                                    .padding(.horizontal)
                                                Text("Pilot Requirement")
                                                    .frame(width: calculateWidth(proxy.size.width - 702, 3), alignment: .leading)
                                                    .padding(.horizontal, 32)
                                                Text("Calculated Extra Fuel")
                                                    .frame(width: 190, alignment: .leading)
                                                    .padding(.horizontal)
                                                Text("Remarks")
                                                    .frame(width: calculateWidth(proxy.size.width - 604, 3), alignment: .leading)
                                            }.frame(width: proxy.size.width - 50)
                                                .padding()
                                        }.padding()
                                            .background(Color.theme.azure.opacity(0.12))
                                            .frame(width: proxy.size.width)
                                        
                                        Divider()
                                    }
                                    
                                    Group {
                                        // delays row
                                        HStack(alignment: .center) {
                                            HStack {
                                                Toggle(isOn: Binding<Bool>(
                                                    get: {coreDataModel.dataFuelExtra.includedArrDelays},
                                                    set: {
                                                        self.includedArrDelays = $0
                                                        coreDataModel.dataFuelExtra.includedArrDelays = $0
                                                        coreDataModel.save()
                                                    }
                                                )){}
                                                Spacer().frame(maxWidth: .infinity)
                                            }.frame(width: 70)
                                                .padding(.horizontal, 24)
                                            
                                            Text("Arrival Delays").foregroundColor(includedArrDelays ? Color.black : Color.theme.sonicSilver)
                                                .frame(width: 210, alignment: .leading)
                                                .padding(.horizontal)
                                            
                                            Text("+\(String(projDelay))mins").foregroundColor(includedArrDelays ? Color.black : Color.theme.sonicSilver)
                                                .frame(width: calculateWidth(proxy.size.width - 598, 3), alignment: .leading)
                                                .padding(.horizontal)
                                            
                                            HStack {
                                                withAnimation(.linear) {
                                                    ButtonStepper(onToggle: onToggleArrDelays, value: $selectedArrDelays, suffix: "mins")
                                                }
                                            }.frame(width: calculateWidth(proxy.size.width - 702, 3), alignment: .leading)
                                                .padding(.horizontal, 32)
                                            
                                            Text("\(calculatedDelayFuel)KG").foregroundColor(coreDataModel.dataFuelExtra.includedArrDelays ? Color.black : Color.theme.sonicSilver)
                                                .frame(width: 190, alignment: .leading)
                                                .padding(.horizontal)
                                            
                                            FieldString(name: "remarkArrDelays", field: coreDataModel.dataFuelExtra.unwrappedRemarkArrDelays).frame(width: calculateWidth(proxy.size.width - 604, 3), alignment: .leading).disabled(!includedArrDelays)
                                            
                                        }.padding()
                                            .frame(width: proxy.size.width - 50)
                                        
                                        Divider()
                                        // taxi row
                                        HStack(alignment: .center) {
                                            HStack {
                                                Toggle(isOn: Binding<Bool>(
                                                    get: {coreDataModel.dataFuelExtra.includedTaxi},
                                                    set: {
                                                        self.includedTaxi = $0
                                                        coreDataModel.dataFuelExtra.includedTaxi = $0
                                                        coreDataModel.save()
                                                    }
                                                )){}
                                                
                                                Spacer().frame(maxWidth: .infinity)
                                            }.frame(width: 70, alignment: .leading)
                                                .padding(.horizontal, 24)
                                            
                                            Text("Additional taxi").foregroundColor(includedTaxi ? Color.black : Color.theme.sonicSilver)
                                                .frame(width: 210, alignment: .leading)
                                                .padding(.horizontal)
                                            
                                            Text("+\(String(aveDiffTaxi))mins").foregroundColor(includedTaxi ? Color.black : Color.theme.sonicSilver)
                                                .frame(width: calculateWidth(proxy.size.width - 598, 3), alignment: .leading)
                                                .padding(.horizontal)
                                            
                                            HStack {
                                                ButtonStepper(onToggle: onToggleIncludedTaxi, value: $selectedTaxi, suffix: "mins")

                                            }.frame(width: calculateWidth(proxy.size.width - 702, 3), alignment: .leading)
                                                .padding(.horizontal, 32)
                                            
                                            Text("\(calculatedTaxiFuel)KG")
                                                .foregroundColor(includedTaxi ? Color.black : Color.theme.sonicSilver)
                                                .frame(width: 190, alignment: .leading)
                                                .padding(.horizontal)
                                            
                                            FieldString(name: "remarkTaxi", field: coreDataModel.dataFuelExtra.unwrappedRemarkTaxi).frame(width: calculateWidth(proxy.size.width - 604, 3), alignment: .leading).disabled(!includedTaxi)
                                        }.padding()
                                            .frame(width: proxy.size.width - 50)
                                        Divider()
                                        
                                        // flight level row
                                        HStack(alignment: .center) {
                                            HStack {
                                                Toggle(isOn: Binding<Bool>(
                                                    get: {coreDataModel.dataFuelExtra.includedFlightLevel},
                                                    set: {
                                                        self.includedFlightLevel = $0
                                                        coreDataModel.dataFuelExtra.includedFlightLevel = $0
                                                        coreDataModel.save()
                                                    }
                                                )){}
                                                
                                                Spacer().frame(maxWidth: .infinity)
                                            }.frame(width: 70)
                                                .padding(.horizontal, 24)
                                            
                                            Text("Flight level deviation").foregroundColor(includedFlightLevel ? Color.black : Color.theme.sonicSilver)
                                                .frame(width: 210, alignment: .leading)
                                                .padding(.horizontal)
                                            
                                            if aveDiffLevels < 0 {
                                                Text("\(String(aveDiffLevels))ft")
                                                    .foregroundColor(includedFlightLevel ? Color.black : Color.theme.sonicSilver)
                                                    .frame(width: calculateWidth(proxy.size.width - 598, 3), alignment: .leading)
                                                    .padding(.horizontal)
                                            } else {
                                                Text("+\(String(aveDiffLevels))ft")
                                                    .foregroundColor(includedFlightLevel ? Color.black : Color.theme.sonicSilver)
                                                    .frame(width: calculateWidth(proxy.size.width - 598, 3), alignment: .leading)
                                                    .padding(.horizontal)
                                            }
                                            
                                            HStack {
                                                ButtonStepperMultiple(onToggle: onToggleFlightLevel, value: $selectedFlightLevelPrint, suffix: "")
                                            }.frame(width: calculateWidth(proxy.size.width - 702, 3), alignment: .leading)
                                                .padding(.horizontal, 32)
                                            
                                            Text("\(calculatedFlightLevelFuel)KG")
                                                .foregroundColor(includedFlightLevel ? Color.black : Color.theme.sonicSilver)
                                                .frame(width: 190, alignment: .leading)
                                                .padding(.horizontal)
                                            FieldString(name: "remarkFlightLevel", field: coreDataModel.dataFuelExtra.unwrappedRemarkFlightLevel).frame(width: calculateWidth(proxy.size.width - 604, 3), alignment: .leading)
                                                .disabled(!includedFlightLevel)
                                        }.padding()
                                            .frame(width: proxy.size.width - 50)
                                        
                                        Divider()
                                        // track shortening row
                                        HStack(alignment: .center) {
                                            HStack {
                                                Toggle(isOn: Binding<Bool>(
                                                    get: {coreDataModel.dataFuelExtra.includedTrackShortening},
                                                    set: {
                                                        self.includedTrackShortening = $0
                                                        coreDataModel.dataFuelExtra.includedTrackShortening = $0
                                                        coreDataModel.save()
                                                    }
                                                )){}
                                                Spacer().frame(maxWidth: .infinity)
                                            }.frame(width: 70)
                                                .padding(.horizontal, 24)
                                            
                                            Text("Track shortening savings")
                                                .foregroundColor(includedTrackShortening ? Color.black : Color.theme.sonicSilver)
                                                .frame(width: 210, alignment: .leading)
                                                .padding(.horizontal)
                                            
                                            Text("\(String(sumMINS))mins")
                                                .foregroundColor(includedTrackShortening ? Color.black : Color.theme.sonicSilver)
                                                .frame(width: calculateWidth(proxy.size.width - 598, 3), alignment: .leading)
                                                .padding(.horizontal)
                                            
                                            HStack {
                                                ButtonStepper(onToggle: onToggleTrackShortening, value: $selectedTrackShortening, suffix: "mins")
                                            }.frame(width: calculateWidth(proxy.size.width - 702, 3), alignment: .leading)
                                                .padding(.horizontal, 32)
                                            
                                            Text("\(calculatedTrackShorteningFuel)KG")
                                                .foregroundColor(includedTrackShortening ? Color.black : Color.theme.sonicSilver)
                                                .frame(width: 190, alignment: .leading)
                                                .padding(.horizontal)
                                            
                                            FieldString(name: "remarkTrackShortening", field: coreDataModel.dataFuelExtra.unwrappedRemarkTrackShortening).frame(width: calculateWidth(proxy.size.width - 604, 3), alignment: .leading)
                                                .disabled(!includedTrackShortening)
                                        }.padding()
                                            .frame(width: proxy.size.width - 50)
                                        
                                        Divider()
                                        // enr wx row
                                        HStack(alignment: .center) {
                                            HStack {
                                                Toggle(isOn: Binding<Bool>(
                                                    get: {coreDataModel.dataFuelExtra.includedEnrWx},
                                                    set: {
                                                        self.includedEnrWx = $0
                                                        coreDataModel.dataFuelExtra.includedEnrWx = $0
                                                        coreDataModel.save()
                                                    }
                                                )){}
                                                Spacer().frame(maxWidth: .infinity)
                                            }.frame(width: 70)
                                                .padding(.horizontal, 24)
                                            
                                            Text("Enroute weather deviation")
                                                .foregroundColor(includedEnrWx ? Color.black : Color.theme.sonicSilver)
                                                .frame(width: 210, alignment: .leading)
                                                .padding(.horizontal)
                                            
                                            Text("+\(String(aveDiffEnrWX))mins")
                                                .foregroundColor(includedEnrWx ? Color.black : Color.theme.sonicSilver)
                                                .frame(width: calculateWidth(proxy.size.width - 598, 3), alignment: .leading)
                                                .padding(.horizontal)
                                            
                                            HStack {
                                                ButtonStepper(onToggle: onToggleEnrWx, value: $selectedEnrWx, suffix: "mins")
                                            }.frame(width: calculateWidth(proxy.size.width - 702, 3), alignment: .leading)
                                                .padding(.horizontal, 32)
                                            
                                            Text("\(calculatedEnrWxFuel)KG")
                                                .foregroundColor(includedEnrWx ? Color.black : Color.theme.sonicSilver)
                                                .frame(width: 190, alignment: .leading)
                                                .padding(.horizontal)
                                            
                                            FieldString(name: "remarkEnrWx", field: coreDataModel.dataFuelExtra.unwrappedRemarkEnrWx).frame(width: calculateWidth(proxy.size.width - 604, 3), alignment: .leading)
                                                .disabled(!includedEnrWx)
                                        }.padding()
                                            .frame(width: proxy.size.width - 50)
                                        
                                        Divider()
                                    }.font(.system(size: 17, weight: .medium))
                                    
                                    Group {
                                        // reciprocal rwy row
                                        HStack(alignment: .center) {
                                            HStack {
                                                Toggle(isOn: Binding<Bool>(
                                                    get: {coreDataModel.dataFuelExtra.includedReciprocalRwy},
                                                    set: {
                                                        self.includedReciprocalRwy = $0
                                                        coreDataModel.dataFuelExtra.includedReciprocalRwy = $0
                                                        coreDataModel.save()
                                                    }
                                                )){}
                                                Spacer().frame(maxWidth: .infinity)
                                            }.frame(width: 70)
                                                .padding(.horizontal, 24)
                                            
                                            Text("Reciprocal rwy")
                                                .foregroundColor(includedReciprocalRwy ? Color.black : Color.theme.sonicSilver)
                                                .frame(width: 210, alignment: .leading)
                                                .padding(.horizontal)
                                            
                                            Text("+/-\(String(reciprocalRwy))mins")
                                                .foregroundColor(includedReciprocalRwy ? Color.black : Color.theme.sonicSilver)
                                                .frame(width: calculateWidth(proxy.size.width - 598, 3), alignment: .leading)
                                                .padding(.horizontal)
                                            
                                            HStack {
                                                ButtonStepper(onToggle: onToggleReciprocalRwy, value: $selectedReciprocalRwy, suffix: "mins")
                                            }.frame(width: calculateWidth(proxy.size.width - 702, 3), alignment: .leading)
                                                .padding(.horizontal, 32)
                                            
                                            Text("\(calculatedReciprocalRwyFuel)KG")
                                                .foregroundColor(includedReciprocalRwy ? Color.black : Color.theme.sonicSilver)
                                                .frame(width: 190, alignment: .leading)
                                                .padding(.horizontal)
                                            
                                            FieldString(name: "remarkReciprocalRwy", field: coreDataModel.dataFuelExtra.unwrappedRemarkReciprocalRwy).frame(width: calculateWidth(proxy.size.width - 604, 3), alignment: .leading).disabled(!includedReciprocalRwy)
                                        }.padding()
                                        Divider()
                                        // zfw change row
                                        HStack(alignment: .center) {
                                            HStack {
                                                Toggle(isOn: Binding<Bool>(
                                                    get: {coreDataModel.dataFuelExtra.includedZFWchange},
                                                    set: {
                                                        self.includedZFWchange = $0
                                                        coreDataModel.dataFuelExtra.includedZFWchange = $0
                                                        coreDataModel.save()
                                                    }
                                                )){}
                                                Spacer().frame(maxWidth: .infinity)
                                            }.frame(width: 70)
                                                .padding(.horizontal, 24)
                                            
                                            Text("ZFW Change")
                                                .foregroundColor(includedZFWchange ? Color.black : Color.theme.sonicSilver)
                                                .frame(width: 210, alignment: .leading)
                                                .padding(.horizontal)
                                            
                                            Text("N.A.")
                                                .foregroundColor(includedZFWchange ? Color.black : Color.theme.sonicSilver)
                                                .frame(width: calculateWidth(proxy.size.width - 598, 3), alignment: .leading)
                                                .padding(.horizontal)
                                            
                                            HStack {
                                                Text("N.A.").foregroundColor(includedZFWchange ? Color.black : Color.theme.sonicSilver)
                                            }.frame(width: calculateWidth(proxy.size.width - 702, 3), alignment: .leading)
                                                .padding(.horizontal, 32)
                                            
                                            Text("\(calculatedZFWFuel)KG")
                                                .foregroundColor(includedZFWchange ? Color.black : Color.theme.sonicSilver)
                                                .frame(width: 190, alignment: .leading)
                                                .padding(.horizontal)
                                            
                                            FieldString(name: "remarkZFWChange", field: coreDataModel.dataFuelExtra.unwrappedRemarkZFWChange).frame(width: calculateWidth(proxy.size.width - 604, 3), alignment: .leading)
                                                .disabled(!includedZFWchange)
                                        }.padding()
                                        Divider()
                                        // others row
                                        HStack(alignment: .center) {
                                            HStack {
                                                Toggle(isOn: Binding<Bool>(
                                                    get: {coreDataModel.dataFuelExtra.includedOthers},
                                                    set: {
                                                        self.includedOthers = $0
                                                        coreDataModel.dataFuelExtra.includedOthers = $0
                                                        coreDataModel.save()
                                                    }
                                                )){}
                                                Spacer().frame(maxWidth: .infinity)
                                            }.frame(width: 70)
                                                .padding(.horizontal, 24)
                                            
                                            Text("Others")
                                                .foregroundColor(includedOthers ? Color.black : Color.theme.sonicSilver)
                                                .frame(width: 210, alignment: .leading)
                                                .padding(.horizontal)
                                            
                                            Text("N.A.")
                                                .foregroundColor(includedOthers ? Color.black : Color.theme.sonicSilver)
                                                .frame(width: calculateWidth(proxy.size.width - 598, 3), alignment: .leading)
                                                .padding(.horizontal)
                                            
                                            HStack {
                                                ButtonStepperMultiple(onToggle: onToggleOthers, value: $selectedOtherPrint, suffix: "")
                                                
                                            }.frame(width: calculateWidth(proxy.size.width - 702, 3), alignment: .leading)
                                                .padding(.horizontal, 32)
                                            
                                            Text("\(calculatedOthersFuel)KG")
                                                .foregroundColor(includedOthers ? Color.black : Color.theme.sonicSilver)
                                                .frame(width: 190, alignment: .leading)
                                                .padding(.horizontal)
                                            
                                            FieldString(name: "remarkOthers", field: coreDataModel.dataFuelExtra.unwrappedRemarkOthers).frame(width: calculateWidth(proxy.size.width - 604, 3), alignment: .leading)
                                                .disabled(!includedOthers)
                                        }.padding()
                                        Divider()
                                    }.frame(width: proxy.size.width - 50)
                                    
                                    HStack(alignment: .center) { // todo - fix alignment
                                        HStack(alignment: .center) {
                                            Rectangle().fill(Color.clear).frame(width: 70).padding(.horizontal, 12)
                                            
                                            Text("Total Extra Fuel")
                                                .frame(width: 210, alignment: .leading)
                                                .padding(.horizontal)
                                            
//                                            Text("\(includedExtraFuelTime(includedDelayFuel, includedTrackShorteningFuel, includedEnrWxFuel, includedReciprocalRwyFuel))mins")
                                            Text("Confirm requirements")
                                                .frame(width: calculateWidth(proxy.size.width - 598, 3), alignment: .leading)
                                                .padding(.horizontal)
                                            
                                            Rectangle().fill(Color.clear)
                                                .frame(width: calculateWidth(proxy.size.width - 702, 3), alignment: .leading)
                                                .padding(.horizontal)
                                            
//                                            Text("\(includedExtraFuelAmt(includedDelayFuel, includedTaxiFuel, includedFlightLevelFuel, includedZFWFuel, includedEnrWxFuel, includedReciprocalRwyFuel, includedTrackShorteningFuel, includedOthersFuel))KG")
                                            Text("Confirm requirements")
                                                .frame(width: 190, alignment: .leading)
                                                .padding(.leading, 50)
                                            
//                                            Text("\(includedExtraFuelRemarks(includedDelayFuel, includedTaxiFuel, includedFlightLevelFuel, includedZFWFuel, includedEnrWxFuel, includedReciprocalRwyFuel, includedTrackShorteningFuel, includedOthersFuel))")
                                            Text("Confirm requirements")
                                                .frame(width: calculateWidth(proxy.size.width - 604, 3), alignment: .leading)
                                                .padding(.leading, 50)
                                            
                                        }.padding()
                                            .frame(width: proxy.size.width - 50)
                                    }.background(Color.theme.azure.opacity(0.12))
                                        .frame(width: proxy.size.width)
                                } // end VStack
                            }// end collapsible
                            
                        }
                    }
                    
                    // ALTN section
                    Section(header: Text("ALTN").foregroundStyle(Color.black).font(.system(size: 15, weight: .semibold))) {
                        Table(altnTable) {
                            TableColumn("ALTN / RWY") {
                                Text($0.altnRwy).foregroundStyle(Color.black).font(.system(size: 17, weight: .regular))
                            }
                            TableColumn("RTE") {
                                Text($0.rte).foregroundStyle(Color.black).font(.system(size: 17, weight: .regular))
                            }
                            TableColumn("VIS") {
                                Text($0.vis).foregroundStyle(Color.black).font(.system(size: 17, weight: .regular))
                            }
                            TableColumn("MINIMA") {
                                Text($0.minima).foregroundStyle(Color.black).font(.system(size: 17, weight: .regular))
                            }
                            TableColumn("DIST") {
                                Text($0.dist).foregroundStyle(Color.black).font(.system(size: 17, weight: .regular))
                            }
                            TableColumn("FL") {
                                Text($0.fl).foregroundStyle(Color.black).font(.system(size: 17, weight: .regular))
                            }
                            TableColumn("COMP") {
                                Text($0.comp).foregroundStyle(Color.black).font(.system(size: 17, weight: .regular))
                            }
                            TableColumn("TIME") {
                                Text($0.time).foregroundStyle(Color.black).font(.system(size: 17, weight: .regular))
                            }
                            TableColumn("FUEL") {
                                Text($0.fuel).foregroundStyle(Color.black).font(.system(size: 17, weight: .regular))
                            }
                        }
                        .frame(minHeight: 250)
                        .scrollDisabled(true)
                    }
                    
                    // ATC flight plan section
                    //                Section(header: Text("ATC FLIGHT PLAN").foregroundStyle(Color.black)) {
                    //                    Text("\(atcFlightPlan)")
                    //                        .padding(.leading, 25)
                    //                }
                }.keyboardAvoidView()
            }
            .onAppear {
                self.pob = coreDataModel.dataSummaryInfo.unwrappedPob
                self.includedArrDelays = coreDataModel.dataFuelExtra.includedArrDelays
                self.includedTaxi = coreDataModel.dataFuelExtra.includedTaxi
                self.includedFlightLevel = coreDataModel.dataFuelExtra.includedFlightLevel
                self.includedTrackShortening = coreDataModel.dataFuelExtra.includedTrackShortening
                self.includedEnrWx = coreDataModel.dataFuelExtra.includedEnrWx
                self.includedReciprocalRwy = coreDataModel.dataFuelExtra.includedReciprocalRwy
                self.includedZFWchange = coreDataModel.dataFuelExtra.includedZFWchange
                self.includedOthers = coreDataModel.dataFuelExtra.includedOthers
                
                self.selectedArrDelays = coreDataModel.dataFuelExtra.selectedArrDelays
                self.selectedTaxi = coreDataModel.dataFuelExtra.selectedTaxi
                self.selectedTrackShortening = coreDataModel.dataFuelExtra.selectedTrackShortening
                self.selectedFlightLevel000 = coreDataModel.dataFuelExtra.selectedFlightLevel000
                self.selectedFlightLevel00 = coreDataModel.dataFuelExtra.selectedFlightLevel00
                self.selectedEnrWx = coreDataModel.dataFuelExtra.selectedEnrWx
                self.selectedReciprocalRwy = coreDataModel.dataFuelExtra.selectedReciprocalRwy
                self.selectedOthers000 = coreDataModel.dataFuelExtra.selectedOthers000
                self.selectedOthers00 = coreDataModel.dataFuelExtra.selectedOthers00
                
            }
            .onChange(of: selectionOutput) { newValue in
                switch self.target {
                    case "IncludedTaxi":
                        self.selectedTaxi = newValue
                        coreDataModel.dataFuelExtra.selectedTaxi = newValue
                    case "ArrDelays":
                        self.selectedArrDelays = newValue
                        coreDataModel.dataFuelExtra.selectedArrDelays = newValue
                    case "TrackShortening":
                        self.selectedTrackShortening = newValue
                        coreDataModel.dataFuelExtra.selectedTrackShortening = newValue
                    case "EnrouteWeather":
                        self.selectedEnrWx = newValue
                        coreDataModel.dataFuelExtra.selectedEnrWx = newValue
                    case "ReciprocalRWY":
                        self.selectedReciprocalRwy = newValue
                        coreDataModel.dataFuelExtra.selectedReciprocalRwy = newValue
                    default:
                        self.selectedArrDelays = newValue
                        coreDataModel.dataFuelExtra.selectedArrDelays = newValue
                }
                coreDataModel.save()
            }
            .sheet(isPresented: $isShowModal) {
                ModalPicker(selectionOutput: $selectionOutput, isShowing: $isShowModal, selection: selection, target: $target)
                    .presentationDetents([.medium])
                    .interactiveDismissDisabled(true)
            }
            .sheet(isPresented: $isShowModalMultiple) {
                ModalPickerMultiple(isShowing: $isShowModalMultiple, target: $target, onSelectOutput: onSelectOutput, selection1: selection1, selection2: selection2)
                    .presentationDetents([.medium])
                    .interactiveDismissDisabled(true)
            }
            .navigationTitle("Summary")
            .background(Color(.systemGroupedBackground))
        }
    }
    
    func includedExtraFuelTime(_ includedDelayFuel: [String: Any], _ includedTrackShorteningFuel: [String: Any], _ includedEnrWxFuel: [String: Any], _ includedReciprocalRwyFuel: [String: Any]) -> String {
        let delayTime: Int = includedDelayFuel["time"] as! Int
        let enrWxTime: Int = includedEnrWxFuel["time"] as! Int
        let reciprocalRwyTime: Int = includedReciprocalRwyFuel["time"] as! Int
        let trackShorteningTime: Int = includedTrackShorteningFuel["time"] as! Int
        let result = delayTime + enrWxTime + reciprocalRwyTime + trackShorteningTime
        if result < 0 {
            return formatTime(0)
        } else {
            return formatTime(result)
        }
    }
    
    func includedExtraFuelAmt(_ includedDelayFuel: [String: Any], _ includedTaxiFuel: [String: Any], _ includedFlightLevelFuel: [String: Any], _ includedZFWFuel: [String: Any], _ includedEnrWxFuel: [String: Any], _ includedReciprocalRwyFuel: [String: Any], _ includedTrackShorteningFuel: [String: Any], _ includedOthersFuel: [String: Any]) -> String {
        let delayFuel: Int = includedDelayFuel["fuel"] as! Int
        let taxiFuel: Int = includedTaxiFuel["fuel"] as! Int
        let flightLevelFuel: Int = includedFlightLevelFuel["fuel"] as! Int
        let enrWxFuel: Int = includedEnrWxFuel["fuel"] as! Int
        let reciprocalRwyFuel: Int = includedReciprocalRwyFuel["fuel"] as! Int
        let trackShorteningFuel: Int = includedTrackShorteningFuel["fuel"] as! Int
        let zfwFuel: Int = includedZFWFuel["fuel"] as! Int
        let othersFuel: Int = includedOthersFuel["fuel"] as! Int
        let result = delayFuel + taxiFuel + flightLevelFuel + enrWxFuel + reciprocalRwyFuel + trackShorteningFuel + zfwFuel + othersFuel
        if result < 0 {
            return formatFuelNumber(0)
        } else {
            return formatFuelNumber(result)
        }
    }
    
    func includedExtraFuelRemarks(_ includedDelayFuel: [String: Any], _ includedTaxiFuel: [String: Any], _ includedFlightLevelFuel: [String: Any], _ includedZFWFuel: [String: Any], _ includedEnrWxFuel: [String: Any], _ includedReciprocalRwyFuel: [String: Any], _ includedTrackShorteningFuel: [String: Any], _ includedOthersFuel: [String: Any]) -> String {
            let delayRemarks: String = includedDelayFuel["remarks"] as! String
            let taxiRemarks: String = includedTaxiFuel["remarks"] as! String
            let flightLevelRemarks: String = includedFlightLevelFuel["remarks"] as! String
            let trackShorteningRemarks: String = includedTrackShorteningFuel["remarks"] as! String
            let enrWxRemarks: String = includedEnrWxFuel["remarks"] as! String
            let reciprocalRwyRemarks: String = includedReciprocalRwyFuel["remarks"] as! String
            let zfwRemarks: String = includedZFWFuel["remarks"] as! String
            let othersRemarks: String = includedOthersFuel["remarks"] as! String
            return "\(delayRemarks) \(taxiRemarks) \(flightLevelRemarks) \(trackShorteningRemarks) \(enrWxRemarks) \(reciprocalRwyRemarks) \(zfwRemarks) \(othersRemarks)"
        }
    
    func formatFuelNumber(_ number: Int) -> String {
        let formattedString = String(format: "%06d", number)
        return formattedString
    }
    
    func formatTime(_ minutes: Int) -> String {
        let hours = minutes / 60
        let mins = minutes % 60
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        let date = Calendar.current.date(bySettingHour: hours, minute: mins, second: 0, of: Date()) ?? Date()
        
        return formatter.string(from: date)
    }
    
    func onToggleArrDelays() {
        if !includedArrDelays {
            return
        }
        self.target = "ArrDelays"
        self.isShowModal.toggle()
        self.selection = self.selectedArrDelays
    }
    
    func onToggleIncludedTaxi() {
        if !includedTaxi {
            return
        }
        self.target = "IncludedTaxi"
        self.isShowModal.toggle()
        self.selection = self.selectedTaxi
    }
    
    func onToggleTrackShortening() {
        if !includedTrackShortening {
            return
        }
        self.target = "TrackShortening"
        self.isShowModal.toggle()
        self.selection = self.selectedTrackShortening
    }
    
    func onToggleEnrWx() {
        if !includedEnrWx {
            return
        }
        self.target = "EnrouteWeather"
        self.isShowModal.toggle()
        self.selection = self.selectedEnrWx
    }
    
    func onToggleReciprocalRwy() {
        if !includedReciprocalRwy {
            return
        }
        self.target = "ReciprocalRWY"
        self.isShowModal.toggle()
        self.selection = self.selectedReciprocalRwy
    }
    
    func onSelectOutput(_ sel1: Int, _ sel2: Int) {
        if target == "Others" {
            self.onSelectOtherOutput(sel1, sel2)
        } else {
            self.onSelectFlightLevelOutput(sel1, sel2)
        }
    }
    
    func onToggleOthers() {
        if !includedOthers {
            return
        }
        self.target = "Others"
        self.isShowModalMultiple.toggle()
    }
    
    func onSelectOtherOutput(_ sel1: Int, _ sel2: Int) {
        self.selectedOthers000 = sel1
        self.selectedOthers00 = sel2
        self.selectedOtherPrint = "\((sel1 * 10) + sel2)00KG"
        self.selection1 = sel1
        self.selection2 = sel2
        coreDataModel.dataFuelExtra.selectedOthers000 = sel1
        coreDataModel.dataFuelExtra.selectedOthers00 = sel2
        coreDataModel.save()
    }
    
    func onToggleFlightLevel() {
        if !includedFlightLevel {
            return
        }
        self.target = "FlightLevel"
        self.isShowModalMultiple.toggle()
    }
    
    func onSelectFlightLevelOutput(_ sel1: Int, _ sel2: Int) {
        self.selectedFlightLevel000 = sel1
        self.selectedFlightLevel00 = sel2
        self.selectedFlightLevelPrint = "\((sel1 * 10) + sel2)00ft"
        self.selection1 = sel1
        self.selection2 = sel2
        coreDataModel.dataFuelExtra.selectedFlightLevel000 = sel1
        coreDataModel.dataFuelExtra.selectedFlightLevel00 = sel2
    }
}

