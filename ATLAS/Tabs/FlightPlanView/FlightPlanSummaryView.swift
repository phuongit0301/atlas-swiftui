//
//  FlightPlanSummaryView.swift
//  ATLAS
//
//  Created by Muhammad Adil on 22/6/23.
//

import Foundation
import SwiftUI
import Combine

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
    @State private var calculatedZFWFuelValue = 0
    
    @State var showSheet = false

//    @Environment(\.modelContext) private var context
//    @Query var fuelPageData: [FuelPageData]
    
    var body: some View {
        @StateObject var viewModel = ViewModelSummary()
        
        // MARK: fetch fuel data - todo move to core data
        let fetchedDelays = coreDataModel.dataProjDelays
        let fetchedLevels = coreDataModel.dataFlightLevel
        let fetchedMiles = coreDataModel.dataTrackMiles
        let fetchedTimes = coreDataModel.dataProjTaxi
        let fetchedEnrWX = coreDataModel.dataEnrWX
        let fetchedReciprocalRwy = coreDataModel.dataReciprocalRwy
        // arrival delays
        var projDelay: Int {
            if fetchedDelays!.expectedDelay != nil {
                return fetchedDelays!.expectedDelay
            }
            return 0
        }
        // taxi
        let threeFlightsTaxi = fetchedTimes.first(where: {$0.type == "flights3"})
        let aveDiffTaxi: Int = threeFlightsTaxi!.aveDiff
        // track miles
        let threeFlightsMiles = fetchedMiles.first(where: {$0.type == "flights3"})
        let sumMINS: Int = threeFlightsMiles!.sumMINS
        // enroute weather
        let threeFlightsEnrWX = fetchedEnrWX.first(where: {$0.type == "flights3"})
        let aveDiffEnrWX: Int = threeFlightsEnrWX!.aveMINS
        // flight level
        let threeFlightsLevels = fetchedLevels.first(where: {$0.type == "flights3"})
        let aveDiffLevels: Int = threeFlightsLevels!.aveDiff
        // reciprocal rwy
        let reciprocalRwy: Int = fetchedReciprocalRwy!.aveMINS
        
       
        // MARK: fuel calculations
        var calculatedDelayFuelValue: Int {
            if let unit = coreDataModel.dataFuelDataList.unwrappedHold["unit"] {
                let temp = unit != "" ? (unit as NSString).integerValue : 0
                return selectedArrDelays * temp
            }
            
            return 0
        }
        
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
                let remarks = coreDataModel.dataFuelExtra?.unwrappedRemarkArrDelays
                if remarks == "" || remarks == nil {
                    return ["fuel": calculatedDelayFuelValue, "time": selectedArrDelays, "remarks": "Arrival Delays (\(calculatedDelayFuel)KG);"]
                } else {
                    return ["fuel": calculatedDelayFuelValue, "time": selectedArrDelays, "remarks": "Arrival Delays (\(calculatedDelayFuel)KG, \(remarks!));"]
                }
            } else {
                return ["fuel": 0, "time": 0, "remarks": ""]
            }
        }
               
        var calculatedTaxiFuelValue: Int {
            if let unit = coreDataModel.dataFuelDataList.unwrappedTaxi["unit"] {
                let temp = unit != "" ? (unit as NSString).integerValue : 0
                return selectedTaxi * temp
            }

            return 0
        }
        
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
                let remarks = coreDataModel.dataFuelExtra.unwrappedRemarkTaxi
                if remarks == "" || remarks == nil {
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
            let unit = Double(coreDataModel.dataPerfData.unwrappedLvlChange)! / 2000
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
                let remarks = coreDataModel.dataFuelExtra.unwrappedRemarkFlightLevel
                if remarks == "" || remarks == nil {
                    return ["fuel": calculatedFlightLevelFuelValue, "remarks": "Flight Level Deviation (\(calculatedFlightLevelFuel)KG);"]
                } else {
                    return ["fuel": calculatedFlightLevelFuelValue, "remarks": "Flight Level Deviation (\(calculatedFlightLevelFuel)KG, \(remarks));"]
                }
            } else {
                return ["fuel": 0, "remarks": ""]
            }
        }
        
        var calculatedTrackShorteningFuelValue: Int {
            if let unit = coreDataModel.dataFuelDataList.unwrappedBurnoff["unit"] {
                let temp = unit != "" ? (unit as NSString).integerValue : 0
                return selectedTrackShortening * temp
            }
            
            return 0
        }
        
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
                let remarks = coreDataModel.dataFuelExtra.unwrappedRemarkTrackShortening
                if calculatedTrackShorteningFuelValue < 0 {
                    if remarks == "" || remarks == nil {
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
        
        var calculatedEnrWxFuelValue: Int {
            if let unit = coreDataModel.dataFuelDataList.unwrappedBurnoff["unit"] {
                let temp = unit != "" ? (unit as NSString).integerValue : 0
                return selectedEnrWx * temp
            }
            
            return 0
        }

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
                let remarks = coreDataModel.dataFuelExtra.unwrappedRemarkEnrWx
                if remarks == "" || remarks == nil {
                    return ["fuel": calculatedEnrWxFuelValue, "time": selectedEnrWx, "remarks": "Enroute Weather Deviation (\(calculatedEnrWxFuel)KG);"]
                } else {
                    return ["fuel": calculatedEnrWxFuelValue, "time": selectedEnrWx, "remarks": "Enroute Weather Deviation (\(calculatedEnrWxFuel)KG, \(remarks));"]
                }
            } else {
                return ["fuel": 0, "time": 0, "remarks": ""]
            }
        }
        
        
        var calculatedReciprocalRwyFuelValue: Int {
            if let unit = coreDataModel.dataFuelDataList.unwrappedAltn["unit"] {
                let temp = unit != "" ? (unit as NSString).integerValue : 0
                return selectedReciprocalRwy * temp
            }

            return 0
        }
        
        var calculatedReciprocalRwyFuel: String {
            let result = calculatedReciprocalRwyFuelValue
            if result <= 0 {
                return "\(result)"
            } else {
                return "+\(result)"
            }
        }
        var includedReciprocalRwyFuel: [String: Any] {
            let remarks = coreDataModel.dataFuelExtra.unwrappedRemarkReciprocalRwy
            if (includedReciprocalRwy && selectedReciprocalRwy > 0) {
                if remarks == "" || remarks == nil {
                    return ["fuel": calculatedReciprocalRwyFuelValue, "time": selectedReciprocalRwy, "remarks": "Reciprocal Rwy (\(calculatedReciprocalRwyFuel)KG);"]
                } else {
                    return ["fuel": calculatedReciprocalRwyFuelValue, "time": selectedReciprocalRwy, "remarks": "Reciprocal Rwy (\(calculatedReciprocalRwyFuel)KG, \(remarks));"]
                }
            } else if (includedReciprocalRwy && selectedReciprocalRwy < 0) {
                if remarks == "" || remarks == nil {
                    return ["fuel": calculatedReciprocalRwyFuelValue, "time": selectedReciprocalRwy, "remarks": "Reciprocal Rwy Savings (\(calculatedReciprocalRwyFuel)KG);"]
                } else {
                    return ["fuel": calculatedReciprocalRwyFuelValue, "time": selectedReciprocalRwy, "remarks": "Reciprocal Rwy Savings (\(calculatedReciprocalRwyFuel)KG, \(remarks);"]
                }
            } else {
                return ["fuel": 0, "time": 0, "remarks": ""]
            }
        }
         
        var calculatedZFWFuel: String {
            let result = calculatedZFWFuelValue
            if result <= 0 {
                return "\(result)"
            } else {
                return "+\(result)"
            }
        }
        var includedZFWFuel: [String: Any] {
            let remarks = coreDataModel.dataFuelExtra.unwrappedRemarkZFWChange
            if (includedZFWchange && calculatedZFWFuelValue > 0) {
                if remarks == "" || remarks == nil {
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
            let remarks = coreDataModel.dataFuelExtra.unwrappedRemarkOthers
            if includedOthers && calculatedOthersFuelValue > 0 {
                if remarks == "" || remarks == nil {
                    return ["fuel": calculatedOthersFuelValue, "remarks": "Others (\(calculatedOthersFuel)KG);"]
                } else {
                    return ["fuel": calculatedOthersFuelValue, "remarks": "Others (\(calculatedOthersFuel)KG, \(remarks));"]
                }
            } else {
                return ["fuel": 0, "remarks": ""]
            }
        }
        
        var fuelInTanksFuel: String {
            let extraFuelAmt = Int(includedExtraFuelAmt(includedDelayFuel, includedTaxiFuel, includedFlightLevelFuel, includedZFWFuel, includedEnrWxFuel, includedReciprocalRwyFuel, includedTrackShorteningFuel, includedOthersFuel))!
            var flightPlanReqmt: Int = 0
            var addDispatchFuel: Int = 0
            for fuelList in coreDataModel.dataFuelTableList {
                if fuelList.unwrappedFirstColumn == "(G) Flight Plan Requirement (A + B + C + D + E + F)" {
                    flightPlanReqmt = Int(fuelList.unwrappedFuel)!
                }
                if fuelList.unwrappedFirstColumn == "(H) Dispatch Additional Fuel" {
                    addDispatchFuel = Int(fuelList.unwrappedFuel)!
                }
            }
            let result = flightPlanReqmt + addDispatchFuel + extraFuelAmt
            return formatFuelNumber(result)
        }
        
        var fuelInTanksTime: String {
            let extraFuelTime = includedExtraFuelTime(includedDelayFuel, includedTrackShorteningFuel, includedEnrWxFuel, includedReciprocalRwyFuel)
            var flightPlanReqmtTime: String = ""
            var addDispatchFuelTime: String = ""
            for fuelList in coreDataModel.dataFuelTableList {
                if fuelList.unwrappedFirstColumn == "(G) Flight Plan Requirement (A + B + C + D + E + F)" {
                    flightPlanReqmtTime = fuelList.unwrappedTime
                }
                if fuelList.unwrappedFirstColumn == "(H) Dispatch Additional Fuel" {
                    addDispatchFuelTime = fuelList.unwrappedTime
                }
            }
            let result = timeStringToMins(extraFuelTime) + timeStringToMins(flightPlanReqmtTime) + timeStringToMins(addDispatchFuelTime)
            return formatTime(result)
        }
        
        // MARK: main body
        GeometryReader { proxy in
            ZStack {
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
                                        }.font(.system(size: 15, weight: .regular))
                                        Group {
                                            // entry here
                                            TextField(
                                                "POB",
                                                text: $pob
                                            )
                                            .keyboardType(.numberPad)
                                            .onReceive(Just(pob)) { output in
                                                let newOutput = output.filter { "0123456789".contains($0) }
                                                pob = String(newOutput.prefix(3))
                                            }
                                            .onSubmit {
                                                if coreDataModel.existDataSummaryInfo {
                                                    coreDataModel.dataSummaryInfo.pob = pob
                                                } else {
                                                    let item = SummaryInfoList(context: persistenceController.container.viewContext)
                                                    item.pob = pob
                                                }
                                                coreDataModel.save()
                                            }
                                        }.font(.system(size: 15, weight: .regular))
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
                                TableColumn("FLT Rules") {
                                    Text($0.unwrappedFltRules).foregroundColor(.black).font(.system(size: 17, weight: .regular))
                                }
                                TableColumn("GND Miles") {
                                    Text($0.unwrappedGndMiles).foregroundColor(.black).font(.system(size: 17, weight: .regular))
                                }
                                TableColumn("AIR Miles") {
                                    Text($0.unwrappedAirMiles).foregroundColor(.black).font(.system(size: 17, weight: .regular))
                                }
                                TableColumn("CRZ Comp") {
                                    Text($0.unwrappedCrzComp).foregroundColor(.black).font(.system(size: 17, weight: .regular))
                                }
                                TableColumn("APD") {
                                    Text($0.unwrappedApd).foregroundColor(.black).font(.system(size: 17, weight: .regular))
                                }
                                TableColumn("CI") {
                                    Text($0.unwrappedCi).foregroundColor(.black).font(.system(size: 17, weight: .regular))
                                }
                            }
                            .frame(minHeight: 65)
                            .scrollDisabled(true)
                            // table body - changes
                            Table(coreDataModel.perfChangesTable) {
                                TableColumn("ZFW Change") {
                                    Text($0.zfwChange).foregroundColor(.black).font(.system(size: 17, weight: .regular))
                                }
                                TableColumn("FL Change") {
                                    Text($0.lvlChange).foregroundColor(.black).font(.system(size: 17, weight: .regular))
                                }
                            }
                            .frame(minHeight: 65)
                            .scrollDisabled(true)
                            // table body - weights
                            Table(coreDataModel.dataPerfWeight) {
                                TableColumn("Weight") {
                                    Text($0.unwrappedWeight).foregroundColor(.black).font(.system(size: 17, weight: .regular))
                                }
                                TableColumn("Plan") {
                                    Text($0.unwrappedPlan).foregroundColor(.black).font(.system(size: 17, weight: .regular))
                                }
                                TableColumn("Actual") {
                                    CustomField(item: $0)
                                }
                                TableColumn("Max") {
                                    Text($0.unwrappedMax).foregroundColor(.black).font(.system(size: 17, weight: .regular))
                                }
                                TableColumn("Limitation") {
                                    Text($0.unwrappedLimitation).foregroundColor(.black).font(.system(size: 17, weight: .regular))
                                }
                            }
                            .frame(minHeight: 185)
                            .scrollDisabled(true)
                        }
                        
                        // MARK: Fuel section
                        Section(header: Text("FUEL").foregroundStyle(Color.black).font(.system(size: 15, weight: .semibold))) {
                            // grouped row using hstack
                            VStack(alignment: .leading, spacing: 0) {
                                //fuel info table body
                                Table(coreDataModel.dataFuelTableList) {
                                    TableColumn("") {
                                        Text($0.unwrappedFirstColumn).foregroundColor(.black).font(.system(size: 15, weight: .medium))
                                    }.width(420)
                                    TableColumn("Time") {
                                        Text($0.unwrappedTime).foregroundColor(.black).font(.system(size: 17, weight: .regular))
                                    }.width((proxy.size.width - 600) / 3)
                                    TableColumn("Fuel") {
                                        Text($0.unwrappedFuel).foregroundColor(.black).font(.system(size: 17, weight: .regular))
                                    }.width((proxy.size.width - 600) / 3)
                                    TableColumn("Policy / Reason") {
                                        Text($0.unwrappedPolicyReason).foregroundColor(.black).font(.system(size: 17, weight: .regular))
                                    }.width((proxy.size.width - 300) / 3)
                                }
                                .frame(minHeight: 390)
                                .scrollDisabled(true)
                            }.listRowSeparator(.hidden)
                            
                            VStack(alignment: .leading, spacing: 0) {
                                // extra fuel section
                                // row I
                                VStack(alignment: .leading, spacing: 0) {
                                    HStack(alignment: .center) {
                                        HStack(alignment: .center) {
                                            Text("(I) Pilot Extra Fuel")
                                                .frame(width: 420, alignment: .leading)
                                                .font(.system(size: 15, weight: .medium))
                                            Text(includedExtraFuelTime(includedDelayFuel, includedTrackShorteningFuel, includedEnrWxFuel, includedReciprocalRwyFuel))
                                                .frame(width: (proxy.size.width - 600) / 3, alignment: .leading)
                                                .font(.system(size: 17, weight: .regular))
                                        
                                            Text(includedExtraFuelAmt(includedDelayFuel, includedTaxiFuel, includedFlightLevelFuel, includedZFWFuel, includedEnrWxFuel, includedReciprocalRwyFuel, includedTrackShorteningFuel, includedOthersFuel))
                                                .frame(width: (proxy.size.width - 600) / 3, alignment: .leading)
                                                .font(.system(size: 17, weight: .regular))
                                        
                                            Text(includedExtraFuelRemarks(includedDelayFuel, includedTaxiFuel, includedFlightLevelFuel, includedZFWFuel, includedEnrWxFuel, includedReciprocalRwyFuel, includedTrackShorteningFuel, includedOthersFuel)).frame(width: (proxy.size.width - 300) / 3, alignment: .leading)
                                                .font(.system(size: 17, weight: .regular))
                                                .lineLimit(nil)
                                        }.padding(.vertical)
                                            .padding(.horizontal, 58)
                                    }.background(Color.theme.azure.opacity(0.12))
                                        .frame(width: proxy.size.width)
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
                                                        .font(.system(size: 15, weight: .medium))
                                                        .padding(.horizontal, 24)
                                                    
                                                    Text("Reason")
                                                        .frame(width: 160, alignment: .leading)
                                                        .font(.system(size: 15, weight: .medium))
                                                        .padding(.horizontal)
                                                    
                                                    HStack {
                                                        Text("Statistical").font(.system(size: 15, weight: .medium))
                                                        Text("Details").font(.system(size: 15, weight: .medium))
                                                        .onTapGesture {
                                                            showSheet = true
                                                        }
                                                        .foregroundColor(.blue)
                                                    }.frame(width: calculateWidth(proxy.size.width - 590, 3), alignment: .leading)
                                                        .padding(.horizontal)
                                                    
                                                    Text("Pilot Requirement")
                                                        .font(.system(size: 15, weight: .medium))
                                                        .frame(width: calculateWidth(proxy.size.width - 627, 3), alignment: .leading)
                                                        .padding(.horizontal)
                                                    
                                                    Text("Calculated Extra Fuel")
                                                        .font(.system(size: 15, weight: .medium))
                                                        .frame(width: 170, alignment: .leading)
                                                        .padding(.horizontal)
                                                    
                                                    Text("Remarks")
                                                        .font(.system(size: 15, weight: .medium))
                                                        .frame(width: calculateWidth(proxy.size.width - 430, 3), alignment: .leading)
                                                }.frame(width: proxy.size.width - 50)
                                                    .padding()
                                            }.padding()
                                                .background(Color.theme.azure.opacity(0.12))
                                                .frame(width: proxy.size.width)
                                            
                                            Divider()
                                        }.font(.system(size: 15, weight: .medium))
                                        
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
                                                    .font(.system(size: 17, weight: .regular))
                                                    .frame(width: 160, alignment: .leading)
                                                    .padding(.horizontal)
                                                
                                                Text("+\(String(projDelay))mins").foregroundColor(includedArrDelays ? Color.black : Color.theme.sonicSilver)
                                                    .font(.system(size: 17, weight: .regular))
                                                    .frame(width: calculateWidth(proxy.size.width - 590, 3), alignment: .leading)
                                                    .padding(.horizontal)
                                                
                                                HStack {
                                                    withAnimation(.linear) {
                                                        ButtonStepper(onToggle: onToggleArrDelays, value: $selectedArrDelays, suffix: "mins").disabled(!includedArrDelays)
                                                    }
                                                }.frame(width: calculateWidth(proxy.size.width - 627, 3), alignment: .leading)
                                                    .padding(.horizontal)
                                                
                                                Text("\(calculatedDelayFuel)KG").foregroundColor(coreDataModel.dataFuelExtra.includedArrDelays ? Color.black : Color.theme.sonicSilver)
                                                    .font(.system(size: 17, weight: .regular))
                                                    .frame(width: 170, alignment: .leading)
                                                    .padding(.horizontal)
                                                
                                                FieldString(name: "remarkArrDelays", field: coreDataModel.dataFuelExtra.unwrappedRemarkArrDelays).frame(width: calculateWidth(proxy.size.width - 430, 3), alignment: .leading).disabled(!includedArrDelays)
                                                
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
                                                    .font(.system(size: 17, weight: .regular))
                                                    .frame(width: 160, alignment: .leading)
                                                    .padding(.horizontal)
                                                
                                                Text("+\(String(aveDiffTaxi))mins").foregroundColor(includedTaxi ? Color.black : Color.theme.sonicSilver)
                                                    .font(.system(size: 17, weight: .regular))
                                                    .frame(width: calculateWidth(proxy.size.width - 590, 3), alignment: .leading)
                                                    .padding(.horizontal)
                                                
                                                HStack {
                                                    ButtonStepper(onToggle: onToggleIncludedTaxi, value: $selectedTaxi, suffix: "mins").disabled(!includedTaxi)
                                                    
                                                }.frame(width: calculateWidth(proxy.size.width - 627, 3), alignment: .leading)
                                                    .padding(.horizontal)
                                                
                                                Text("\(calculatedTaxiFuel)KG")
                                                    .foregroundColor(includedTaxi ? Color.black : Color.theme.sonicSilver)
                                                    .font(.system(size: 17, weight: .regular))
                                                    .frame(width: 170, alignment: .leading)
                                                    .padding(.horizontal)
                                                
                                                FieldString(name: "remarkTaxi", field: coreDataModel.dataFuelExtra.unwrappedRemarkTaxi).frame(width: calculateWidth(proxy.size.width - 430, 3), alignment: .leading).disabled(!includedTaxi)
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
                                                    .font(.system(size: 17, weight: .regular))
                                                    .frame(width: 160, alignment: .leading)
                                                    .padding(.horizontal)
                                                
                                                if aveDiffLevels < 0 {
                                                    Text("\(String(aveDiffLevels))ft")
                                                        .foregroundColor(includedFlightLevel ? Color.black : Color.theme.sonicSilver)
                                                        .font(.system(size: 17, weight: .regular))
                                                        .frame(width: calculateWidth(proxy.size.width - 590, 3), alignment: .leading)
                                                        .padding(.horizontal)
                                                } else {
                                                    Text("+\(String(aveDiffLevels))ft")
                                                        .foregroundColor(includedFlightLevel ? Color.black : Color.theme.sonicSilver)
                                                        .font(.system(size: 17, weight: .regular))
                                                        .frame(width: calculateWidth(proxy.size.width - 590, 3), alignment: .leading)
                                                        .padding(.horizontal)
                                                }
                                                
                                                HStack {
                                                    ButtonStepperMultiple(onToggle: onToggleFlightLevel, value: $selectedFlightLevelPrint, suffix: "").disabled(!includedFlightLevel)
                                                }.frame(width: calculateWidth(proxy.size.width - 627, 3), alignment: .leading)
                                                    .padding(.horizontal)
                                                
                                                Text("\(calculatedFlightLevelFuel)KG")
                                                    .foregroundColor(includedFlightLevel ? Color.black : Color.theme.sonicSilver)
                                                    .font(.system(size: 17, weight: .regular))
                                                    .frame(width: 170, alignment: .leading)
                                                    .padding(.horizontal)
                                                FieldString(name: "remarkFlightLevel", field: coreDataModel.dataFuelExtra.unwrappedRemarkFlightLevel).frame(width: calculateWidth(proxy.size.width - 430, 3), alignment: .leading)
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
                                                    .font(.system(size: 17, weight: .regular))
                                                    .frame(width: 160, alignment: .leading)
                                                    .padding(.horizontal)
                                                
                                                Text("\(String(sumMINS))mins")
                                                    .foregroundColor(includedTrackShortening ? Color.black : Color.theme.sonicSilver)
                                                    .font(.system(size: 17, weight: .regular))
                                                    .frame(width: calculateWidth(proxy.size.width - 590, 3), alignment: .leading)
                                                    .padding(.horizontal)
                                                
                                                HStack {
                                                    ButtonStepper(onToggle: onToggleTrackShortening, value: $selectedTrackShortening, suffix: "mins").disabled(!includedTrackShortening)
                                                }.frame(width: calculateWidth(proxy.size.width - 627, 3), alignment: .leading)
                                                    .padding(.horizontal)
                                                
                                                Text("\(calculatedTrackShorteningFuel)KG")
                                                    .foregroundColor(includedTrackShortening ? Color.black : Color.theme.sonicSilver)
                                                    .font(.system(size: 17, weight: .regular))
                                                    .frame(width: 170, alignment: .leading)
                                                    .padding(.horizontal)
                                                
                                                FieldString(name: "remarkTrackShortening", field: coreDataModel.dataFuelExtra.unwrappedRemarkTrackShortening).frame(width: calculateWidth(proxy.size.width - 430, 3), alignment: .leading)
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
                                                    .font(.system(size: 17, weight: .regular))
                                                    .frame(width: 160, alignment: .leading)
                                                    .padding(.horizontal)
                                                
                                                Text("+\(String(aveDiffEnrWX))mins")
                                                    .foregroundColor(includedEnrWx ? Color.black : Color.theme.sonicSilver)
                                                    .font(.system(size: 17, weight: .regular))
                                                    .frame(width: calculateWidth(proxy.size.width - 590, 3), alignment: .leading)
                                                    .padding(.horizontal)
                                                
                                                HStack {
                                                    ButtonStepper(onToggle: onToggleEnrWx, value: $selectedEnrWx, suffix: "mins").disabled(!includedEnrWx)
                                                }.frame(width: calculateWidth(proxy.size.width - 627, 3), alignment: .leading)
                                                    .padding(.horizontal)
                                                
                                                Text("\(calculatedEnrWxFuel)KG")
                                                    .foregroundColor(includedEnrWx ? Color.black : Color.theme.sonicSilver)
                                                    .font(.system(size: 17, weight: .regular))
                                                    .frame(width: 170, alignment: .leading)
                                                    .padding(.horizontal)
                                                
                                                FieldString(name: "remarkEnrWx", field: coreDataModel.dataFuelExtra.unwrappedRemarkEnrWx).frame(width: calculateWidth(proxy.size.width - 430, 3), alignment: .leading)
                                                    .disabled(!includedEnrWx)
                                            }.padding()
                                                .frame(width: proxy.size.width - 50)
                                            
                                            Divider()
                                        }.font(.system(size: 15, weight: .regular))
                                        
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
                                                    .font(.system(size: 17, weight: .regular))
                                                    .frame(width: 160, alignment: .leading)
                                                    .padding(.horizontal)
                                                
                                                Text("+/-\(String(reciprocalRwy))mins")
                                                    .foregroundColor(includedReciprocalRwy ? Color.black : Color.theme.sonicSilver)
                                                    .font(.system(size: 17, weight: .regular))
                                                    .frame(width: calculateWidth(proxy.size.width - 590, 3), alignment: .leading)
                                                    .padding(.horizontal)
                                                
                                                HStack {
                                                    ButtonStepper(onToggle: onToggleReciprocalRwy, value: $selectedReciprocalRwy, suffix: "mins").disabled(!includedReciprocalRwy)
                                                }.frame(width: calculateWidth(proxy.size.width - 627, 3), alignment: .leading)
                                                    .padding(.horizontal)
                                                
                                                Text("\(calculatedReciprocalRwyFuel)KG")
                                                    .foregroundColor(includedReciprocalRwy ? Color.black : Color.theme.sonicSilver)
                                                    .font(.system(size: 17, weight: .regular))
                                                    .frame(width: 170, alignment: .leading)
                                                    .padding(.horizontal)
                                                
                                                FieldString(name: "remarkReciprocalRwy", field: coreDataModel.dataFuelExtra.unwrappedRemarkReciprocalRwy).frame(width: calculateWidth(proxy.size.width - 430, 3), alignment: .leading).disabled(!includedReciprocalRwy)
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
                                                    .font(.system(size: 17, weight: .regular))
                                                    .frame(width: 160, alignment: .leading)
                                                    .padding(.horizontal)
                                                
                                                Text("N.A.")
                                                    .foregroundColor(includedZFWchange ? Color.black : Color.theme.sonicSilver)
                                                    .font(.system(size: 17, weight: .regular))
                                                    .frame(width: calculateWidth(proxy.size.width - 590, 3), alignment: .leading)
                                                    .padding(.horizontal)
                                                
                                                HStack {
                                                    Text("N.A.")
                                                        .foregroundColor(includedZFWchange ? Color.black : Color.theme.sonicSilver)
                                                        .font(.system(size: 17, weight: .regular))
                                                }.frame(width: calculateWidth(proxy.size.width - 627, 3), alignment: .leading)
                                                    .padding(.horizontal)
                                                
                                                Text("\(calculatedZFWFuel)KG")
                                                    .foregroundColor(includedZFWchange ? Color.black : Color.theme.sonicSilver)
                                                    .font(.system(size: 17, weight: .regular))
                                                    .frame(width: 170, alignment: .leading)
                                                    .padding(.horizontal)
                                                
                                                FieldString(name: "remarkZFWChange", field: coreDataModel.dataFuelExtra.unwrappedRemarkZFWChange).frame(width: calculateWidth(proxy.size.width - 430, 3), alignment: .leading)
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
                                                    .font(.system(size: 17, weight: .regular))
                                                    .frame(width: 160, alignment: .leading)
                                                    .padding(.horizontal)
                                                
                                                Text("N.A.")
                                                    .foregroundColor(includedOthers ? Color.black : Color.theme.sonicSilver)
                                                    .font(.system(size: 17, weight: .regular))
                                                    .frame(width: calculateWidth(proxy.size.width - 590, 3), alignment: .leading)
                                                    .padding(.horizontal)
                                                
                                                HStack {
                                                    ButtonStepperMultiple(onToggle: onToggleOthers, value: $selectedOtherPrint, suffix: "").disabled(!includedOthers)
                                                    
                                                }.frame(width: calculateWidth(proxy.size.width - 627, 3), alignment: .leading)
                                                    .padding(.horizontal)
                                                
                                                Text("\(calculatedOthersFuel)KG")
                                                    .foregroundColor(includedOthers ? Color.black : Color.theme.sonicSilver)
                                                    .font(.system(size: 17, weight: .regular))
                                                    .frame(width: 170, alignment: .leading)
                                                    .padding(.horizontal)
                                                
                                                FieldString(name: "remarkOthers", field: coreDataModel.dataFuelExtra.unwrappedRemarkOthers).frame(width: calculateWidth(proxy.size.width - 430, 3), alignment: .leading)
                                                    .disabled(!includedOthers)
                                            }.padding()
                                            Divider()
                                        }.frame(width: proxy.size.width - 50)
                                            .font(.system(size: 15, weight: .regular))
                                        
                                        HStack(alignment: .center) {
                                            HStack(alignment: .center) {
                                                Text("").frame(width: 70)
                                                    .padding(.horizontal, 24)
                                                
                                                Text("Total Extra Fuel")
                                                    .font(.system(size: 17, weight: .regular))
                                                    .frame(width: 160, alignment: .leading)
                                                
                                                Text("\(includedExtraFuelTime(includedDelayFuel, includedTrackShorteningFuel, includedEnrWxFuel, includedReciprocalRwyFuel))mins")
                                                    .font(.system(size: 17, weight: .regular))
                                                    .frame(width: calculateWidth(proxy.size.width - 590, 3), alignment: .leading)
                                                        .padding(.leading, 32)
                                                
                                                
                                                Text("").frame(width: calculateWidth(proxy.size.width - 627, 3), alignment: .leading)
                                                    .padding(.horizontal)
                                                
                                                Text("\(includedExtraFuelAmt(includedDelayFuel, includedTaxiFuel, includedFlightLevelFuel, includedZFWFuel, includedEnrWxFuel, includedReciprocalRwyFuel, includedTrackShorteningFuel, includedOthersFuel))KG")
                                                    .font(.system(size: 17, weight: .regular))
                                                    .frame(width: 170, alignment: .leading)
                                                    .padding(.leading, 32)
                                                
                                                Text("\(includedExtraFuelRemarks(includedDelayFuel, includedTaxiFuel, includedFlightLevelFuel, includedZFWFuel, includedEnrWxFuel, includedReciprocalRwyFuel, includedTrackShorteningFuel, includedOthersFuel))")
                                                    .font(.system(size: 17, weight: .regular))
                                                    .lineLimit(nil)
                                                    .frame(width: calculateWidth(proxy.size.width - 430, 3), alignment: .leading)
                                            }.padding()
                                        }.padding(.horizontal, 20)
                                        .background(Color.theme.azure.opacity(0.12))
                                            .frame(width: proxy.size.width)
                                    } // end VStack
                                }// end collapsible
                            }
                            
                            VStack(alignment: .leading, spacing: 0) {
                                HStack(alignment: .center) {
                                    HStack(alignment: .center) {
                                        Text("Fuel in Tanks (G + H + I)")
                                            .frame(width: 420, alignment: .leading)
                                            .font(.system(size: 15, weight: .medium))
                                        Text("\(fuelInTanksTime)")
                                            .frame(width: (proxy.size.width - 600) / 3, alignment: .leading)
                                            .font(.system(size: 17, weight: .regular))
                                        Text("\(fuelInTanksFuel)")
                                            .frame(width: (proxy.size.width - 600) / 3, alignment: .leading)
                                            .font(.system(size: 17, weight: .regular))
                                        Text("")
                                            .frame(width: (proxy.size.width - 300) / 3, alignment: .leading)
                                            .font(.system(size: 17, weight: .regular))
                                    }.padding(.vertical, 32)
                                        .padding(.horizontal, 58)
                                }.frame(width: proxy.size.width)
                            }.listRowBackground(Color.theme.sonicSilver.opacity(0.12))
                        }.listRowInsets(EdgeInsets(.init(top: 0, leading: 24, bottom: 0, trailing: 0)))
                        
                        // ALTN section
                        Section(header: Text("ALTN").foregroundStyle(Color.black).font(.system(size: 15, weight: .semibold))) {
                            Table(coreDataModel.dataAltnList) {
                                TableColumn("ALTN / RWY") {
                                    Text($0.unwrappedAltnRwy).foregroundStyle(Color.black).font(.system(size: 17, weight: .regular))
                                }
                                TableColumn("RTE") {
                                    Text($0.unwrappedRte).foregroundStyle(Color.black).font(.system(size: 17, weight: .regular))
                                        .lineLimit(nil)
                                }.width(200)
                                TableColumn("VIS") {
                                    Text($0.unwrappedVis).foregroundStyle(Color.black).font(.system(size: 17, weight: .regular))
                                }
                                TableColumn("MINIMA") {
                                    Text($0.unwrappedMinima).foregroundStyle(Color.black).font(.system(size: 17, weight: .regular))
                                }
                                TableColumn("DIST") {
                                    Text($0.unwrappedDist).foregroundStyle(Color.black).font(.system(size: 17, weight: .regular))
                                }
                                TableColumn("FL") {
                                    Text($0.unwrappedFl).foregroundStyle(Color.black).font(.system(size: 17, weight: .regular))
                                }
                                TableColumn("COMP") {
                                    Text($0.unwrappedComp).foregroundStyle(Color.black).font(.system(size: 17, weight: .regular))
                                }
                                TableColumn("TIME") {
                                    Text($0.unwrappedTime).foregroundStyle(Color.black).font(.system(size: 17, weight: .regular))
                                }
                                TableColumn("FUEL") {
                                    Text($0.unwrappedFuel).foregroundStyle(Color.black).font(.system(size: 17, weight: .regular))
                                }
                            }
                            .frame(minHeight: 350)
                            .scrollDisabled(true)
                        }
                        
                        // ATC flight plan section
                        //                Section(header: Text("ATC FLIGHT PLAN").foregroundStyle(Color.black)) {
                        //                    Text("\(atcFlightPlan)")
                        //                        .padding(.leading, 25)
                        //                }
                    }
                    .keyboardAvoidView()
                    .sheet(isPresented: $showSheet, content: {
                        FuelModal(isShowing: $showSheet).interactiveDismissDisabled(true)
                    })
                }
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
                self.selectedFlightLevelPrint = "\((self.selectedFlightLevel000 * 10) + self.selectedFlightLevel00)00ft"
                self.selectedEnrWx = coreDataModel.dataFuelExtra.selectedEnrWx
                self.selectedReciprocalRwy = coreDataModel.dataFuelExtra.selectedReciprocalRwy
                self.selectedOthers000 = coreDataModel.dataFuelExtra.selectedOthers000
                self.selectedOthers00 = coreDataModel.dataFuelExtra.selectedOthers00
                self.selectedOtherPrint = "\((self.selectedOthers000 * 10) + self.selectedOthers00)00KG"
                
                self.calculatedZFWFuelValue = coreDataModel.calculatedZFWFuel()
            }.onReceive(Just(coreDataModel.dataFuelExtra)) { newValue in
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
                self.selectedFlightLevelPrint = "\((self.selectedFlightLevel000 * 10) + self.selectedFlightLevel00)00ft"
                self.selectedEnrWx = coreDataModel.dataFuelExtra.selectedEnrWx
                self.selectedReciprocalRwy = coreDataModel.dataFuelExtra.selectedReciprocalRwy
                self.selectedOthers000 = coreDataModel.dataFuelExtra.selectedOthers000
                self.selectedOthers00 = coreDataModel.dataFuelExtra.selectedOthers00
                self.selectedOtherPrint = "\((self.selectedOthers000 * 10) + self.selectedOthers00)00KG"
                
                self.calculatedZFWFuelValue = coreDataModel.calculatedZFWFuel()
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
            .onReceive(Just(coreDataModel.dataPerfWeight)) { _ in
                self.calculatedZFWFuelValue = coreDataModel.calculatedZFWFuel()
            }
            .formSheet(isPresented: $isShowModal) {
                ModalPicker(selectionOutput: $selectionOutput, isShowing: $isShowModal, selection: $selection, target: $target)
                    .presentationDetents([.medium])
                    .interactiveDismissDisabled(true)
            }
            .formSheet(isPresented: $isShowModalMultiple) {
                ModalPickerMultiple(isShowing: $isShowModalMultiple, target: $target, onSelectOutput: onSelectOutput, selection1: $selection1, selection2: $selection2)
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
    
    func timeStringToMins(_ time: String) -> Int {
        let hoursString = time.prefix(2) as Substring
        let minsString = time.suffix(2) as Substring
        let hours = hoursString != "" ? Int(hoursString)! : 0
        let mins = hoursString != "" ? Int(minsString)! : 0
        
        let duration = (hours * 60) + mins
        
        return duration
    }

    
    func onToggleArrDelays() {
        if !includedArrDelays {
            return
        }
        self.target = "ArrDelays"
        self.selection = self.selectedArrDelays
        self.isShowModal.toggle()
    }
    
    func onToggleIncludedTaxi() {
        if !includedTaxi {
            return
        }
        self.target = "IncludedTaxi"
        self.selection = self.selectedTaxi
        self.isShowModal.toggle()
    }
    
    func onToggleTrackShortening() {
        if !includedTrackShortening {
            return
        }
        self.target = "TrackShortening"
        self.selection = self.selectedTrackShortening
        self.isShowModal.toggle()
    }
    
    func onToggleEnrWx() {
        if !includedEnrWx {
            return
        }
        self.target = "EnrouteWeather"
        self.selection = self.selectedEnrWx
        self.isShowModal.toggle()
    }
    
    func onToggleReciprocalRwy() {
        if !includedReciprocalRwy {
            return
        }
        self.target = "ReciprocalRWY"
        self.selection = self.selectedReciprocalRwy
        self.isShowModal.toggle()
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
        self.selection1 = self.selectedOthers000
        self.selection2 = self.selectedOthers00
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
        self.selection1 = self.selectedFlightLevel000
        self.selection2 = self.selectedFlightLevel00
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

// todo @phuong customise Modal view per figma
struct FuelModal: View {
    @EnvironmentObject var flightPlanDetailModel: FlightPlanDetailModel
    @Binding var isShowing: Bool
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Spacer()
                
                Text("Fuel Statistics").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.black)
                
                Spacer()
                Button(action: {
                    self.isShowing.toggle()
                }) {
                    Text("Done").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                }
            }.padding()
                .background(.white)
                .roundedCorner(12, corners: [.topLeft, .topRight])
            
            FuelView()
        }.onAppear {
            flightPlanDetailModel.isModal = true
        }.onDisappear {
            flightPlanDetailModel.isModal = false
        }
    }
    
    func dismiss() {
        // Call this function to dismiss the modal todo add dismiss function
    }
}
