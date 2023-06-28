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
    //let actual: Int
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
    // initialise state variables
    @ObservedObject var globalResponse = GlobalResponse.shared
    @State private var showUTC = true
    @State private var includedArrDelays = true
    @State private var includedTaxi = true
    @State private var includedFlightLevel = true
    @State private var includedTrackShortening = true
    @State private var includedEnrWx = true
    @State private var includedReciprocalRwy = true
    @State private var includedZFWchange = true
    @State private var includedOthers = true
    
    // for these variables: todo save/fetch all to/from core data
    @State private var selectedArrDelays: Int = 0
    @State private var selectedTaxi: Int = 0
    @State private var selectedFlightLevel000: Int = 0
    @State private var selectedFlightLevel00: Int = 0
    @State private var selectedTrackShortening: Int = 0
    @State private var selectedEnrWx: Int = 0
    @State private var selectedReciprocalRwy: Int = 0
    @State private var selectedOthers000: Int = 0
    @State private var selectedOthers00: Int = 0
    @State private var actualZFW: Int = 0
    @State private var pob: String = ""


    var body: some View {
        // fetch flight plan data
        let flightPlanData: [String : Any] = fetchFlightPlanData()
        
        // fetch fuel data - todo move to core data
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
        let flightInfoData: InfoData = flightPlanData["infoData"] as! InfoData
        @State var infoTable =
            flightInfo(flightNo: flightInfoData.fltNo, aircraft: flightInfoData.tailNo, depDest: flightInfoData.dep+" / "+flightInfoData.dest, date: flightInfoData.flightDate, stdUTC: flightInfoData.STDUTC, staUTC: flightInfoData.STAUTC, stdLocal: flightInfoData.STDLocal, staLocal: flightInfoData.STALocal, blkTime: flightInfoData.BLKTime, fltTime: flightInfoData.FLTTime)
        
        // set up route data
        let flightRouteData: RouteData = flightPlanData["routeData"] as! RouteData
        
        // set up perf tables data
        let perfData: PerfData = flightPlanData["perfData"] as! PerfData
        @State var perfInfoTable = [
            perfInfo(fltRules: perfData.fltRules, gndMiles: perfData.gndMiles, airMiles: perfData.airMiles, crzComp: perfData.crzComp, apd: perfData.apd, ci: perfData.ci)
        ]
        @State var perfChangesTable = [
            perfChanges(zfwChange: "M1000KG BURN LESS \(perfData.zfwChange)KG", lvlChange: "P2000FT BURN LESS \(perfData.lvlChange)KG")
        ]
        @State var perfWeightsTable = [
            perfWeights(weight: "ZFW", plan: perfData.planZFW, max: perfData.maxZFW, limitation: perfData.limZFW),
            perfWeights(weight: "TOW", plan: perfData.planTOW, max: perfData.maxTOW, limitation: perfData.limTOW),
            perfWeights(weight: "LDW", plan: perfData.planLDW, max: perfData.maxLDW, limitation: perfData.limLDW),
        ]
        
        // set up fuel info table data
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
        // fuel calculations
        var calculatedDelayFuel: Int {
            return selectedArrDelays * Int(fuelData.hold["unit"]!)!
        }
        var includedDelayFuel: [String: Any] {
            if includedArrDelays {
                return ["fuel": selectedArrDelays * Int(fuelData.hold["unit"]!)!, "time": selectedArrDelays, "remarks": "Arrival Delays \("")"] // todo set to textfield value
            } else {
                return ["fuel": 0, "time": 0, "remarks": ""]
            }
        }
        var calculatedTaxiFuel: Int {
            return selectedTaxi * Int(fuelData.taxi["unit"]!)!
        }
        var includedTaxiFuel: [String: Any] {
            if includedTaxi {
                return ["fuel": selectedTaxi * Int(fuelData.taxi["unit"]!)!, "remarks": "Additional Taxi Time \("")"] // todo set to textfield value
            } else {
                return ["fuel": 0, "remarks": ""]
            }
        }
        
        var calculatedFlightLevelFuel: Int {
            let selectedFlightLevel: Int = selectedFlightLevel000 * 1000 + selectedFlightLevel00 * 100
            let unit: Int = Int(perfData.lvlChange)! / 2000
            return selectedFlightLevel * unit
        }
        var includedFlightLevelFuel: [String: Any] {
            let selectedFlightLevel = selectedFlightLevel000 * 1000 + selectedFlightLevel00 * 100
            if includedFlightLevel {
                return ["fuel": selectedFlightLevel * (Int(perfData.lvlChange)! / 2000), "remarks": "Flight Level Deviation \("")"] // todo set to textfield value
            } else {
                return ["fuel": 0, "remarks": ""]
            }
        }
        var calculatedTrackShorteningFuel: Int {
            return selectedTrackShortening * Int(fuelData.burnoff["unit"]!)!
        }
        var includedTrackShorteningFuel: Int {
            if includedTrackShortening {
                return selectedTrackShortening * Int(fuelData.burnoff["unit"]!)!
            } else {
                return 0
            }
        }
        var calculatedEnrWxFuel: Int {
            return selectedEnrWx * Int(fuelData.burnoff["unit"]!)!
        }
        var includedEnrWxFuel: [String: Any] {
            if includedEnrWx {
                return ["fuel": selectedEnrWx * Int(fuelData.burnoff["unit"]!)!, "time": selectedEnrWx, "remarks": "Enroute Weather Deviation \("")"] // todo set to textfield value
            } else {
                return ["fuel": 0, "time": 0, "remarks": ""]
            }
        }
        var calculatedReciprocalRwyFuel: Int {
            return selectedReciprocalRwy * Int(fuelData.altn["unit"]!)!
        }
        var includedReciprocalRwyFuel: [String: Any] {
            if (includedReciprocalRwy && selectedReciprocalRwy > 0) {
                return ["fuel": selectedReciprocalRwy * Int(fuelData.altn["unit"]!)!, "time": selectedReciprocalRwy, "remarks": "Reciprocal Rwy \("")"] // todo set to textfield value
            } else if (includedReciprocalRwy && selectedReciprocalRwy < 0) {
                return ["fuel": selectedReciprocalRwy * Int(fuelData.altn["unit"]!)!, "time": selectedReciprocalRwy, "remarks": ""]
            } else {
                return ["fuel": 0, "time": 0, "remarks": ""]
            }
        }
        var calculatedZFWFuel: Int {
            return (actualZFW - Int(perfData.planZFW)!)  * (Int(perfData.zfwChange)! / 1000)  // todo change to textfield value for actualZFW
        }
        var includedZFWFuel: [String: Any] {
            let fuelBurn = (actualZFW - Int(perfData.planZFW)!)  * (Int(perfData.zfwChange)! / 1000) // todo change to textfield value for actualZFW
            if (includedZFWchange && fuelBurn > 0) {
                return ["fuel": fuelBurn, "remarks": "ZFW Increase \("")"] // todo set to textfield value
            } else if (includedZFWchange && fuelBurn < 0) {
                return ["fuel": fuelBurn, "remarks": ""]
            } else {
                return ["fuel": 0, "remarks": ""]
            }
        }
        var calculatedOthersFuel: Int {
            let selectedOthers = selectedOthers000 * 1000 + selectedOthers00 * 100
            return selectedOthers
        }
        var includedOthersFuel: [String: Any] {
            let selectedOthers = selectedOthers000 * 1000 + selectedOthers00 * 100
            if includedOthers {
                return ["fuel": selectedOthers, "remarks": "\("")"]
            } else {
                return ["fuel": 0, "remarks": ""]
            }
        }

        var includedExtraFuelAmt: String {
            let delayFuel: Int = includedDelayFuel["fuel"] as! Int
            let taxiFuel: Int = includedTaxiFuel["fuel"] as! Int
            let flightLevelFuel: Int = includedFlightLevelFuel["fuel"] as! Int
            let zfwFuel: Int = includedZFWFuel["fuel"] as! Int
            let enrWxFuel: Int = includedEnrWxFuel["fuel"] as! Int
            let reciprocalRwyFuel: Int = includedReciprocalRwyFuel["fuel"] as! Int
            let trackShorteningFuel: Int = includedTrackShorteningFuel
            let othersFuel: Int = includedOthersFuel["fuel"] as! Int
            let result = delayFuel + taxiFuel + flightLevelFuel + zfwFuel + enrWxFuel + reciprocalRwyFuel + trackShorteningFuel + othersFuel
            return formatFuelNumber(result)
        }
        var includedExtraFuelTime: String {
            let delayTime: Int = includedDelayFuel["time"] as! Int
            let enrWxTime: Int = includedEnrWxFuel["time"] as! Int
            let reciprocalRwyTime: Int = includedReciprocalRwyFuel["time"] as! Int
            let result = delayTime + enrWxTime + reciprocalRwyTime
            return formatTime(result)
        }
        var includedExtraFuelRemarks: String {
            let delayRemarks: String = includedDelayFuel["remarks"] as! String
            let taxiRemarks: String = includedTaxiFuel["remarks"] as! String
            let flightLevelRemarks: String = includedFlightLevelFuel["remarks"] as! String
            let zfwRemarks: String = includedZFWFuel["remarks"] as! String
            let enrWxRemarks: String = includedEnrWxFuel["remarks"] as! String
            let reciprocalRwyRemarks: String = includedReciprocalRwyFuel["remarks"] as! String
            let othersRemarks: String = includedOthersFuel["remarks"] as! String
            return "\(delayRemarks); \(taxiRemarks); \(flightLevelRemarks); \(zfwRemarks); \(enrWxRemarks); \(reciprocalRwyRemarks); \(othersRemarks)"
        }

        // set up altn table data
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

        // set up ATC flight plan data
//        let atcFlightPlan: String = flightPlanData["atcFlightPlanData"] as! String

        VStack(alignment: .leading) {
            // fixed header section, todo clean up design
            HStack(alignment: .center) {
                Text("Summary")
                    .font(.title)
                    .padding(.leading, 30)
                Spacer()
                .frame(maxWidth: .infinity)
                Button(action: {}) {  // todo add the action here, fix design
                    Text("Sign-off")
                }
                .buttonStyle(.bordered)
                .padding(.trailing, 30)
            }
            .padding(.bottom, 10)
            Text("Plan \(flightInfoData.planNo) | Last updated 0820LT")
            .padding(.leading, 30)
            .padding(.bottom, 10)
            //scrollable outer list section
            List {
                // Flight information section
                Section(header:
                    HStack(alignment: .center) {
                        Text("FLIGHT INFORMATION")
                        .foregroundStyle(Color.black)
                        Spacer()
                        .frame(maxWidth: .infinity)  // todo fix spacing
                        Text("Local")
                        Toggle(isOn: $showUTC) {}
                        Text("UTC")
                    }) {
                    // table body - todo fix alignment and design
                    if showUTC {
                        VStack {
                            HStack {
                                Group {
                                    Text("Flight No.")
                                    Text("Aircraft")
                                    Text("DEP / DEST")
                                    Text("Date")
                                    Text("STD")
                                    Text("STA")
                                    Text("BLK Time")
                                    Text("FLT Time")
                                    Text("POB")
                                }
                                .foregroundStyle(Color.blue)
                            }
                            HStack {
                                Group {
                                    Text("\(infoTable.flightNo)")
                                    Text("\(infoTable.aircraft)")
                                    Text("\(infoTable.depDest)")
                                    Text("\(infoTable.date)")
                                    Text("\(infoTable.stdUTC)")
                                    Text("\(infoTable.staUTC)")
                                    Text("\(infoTable.blkTime)")
                                    Text("\(infoTable.fltTime)")
                                }
                                Group {
                                    // entry here
                                    TextField(
                                        "POB",
                                        text: $pob
                                    )
                                    .onSubmit {
                                        // todo save to core data
                                    }
                                    .textInputAutocapitalization(.never)
                                    .disableAutocorrection(true)
                                    .border(.secondary) // todo todo change design
                                }
                            }
                        }
//                        Table(infoTable) {
//                            TableColumn("Flight No.", value: \.flightNo)
//                            TableColumn("Aircraft", value: \.aircraft)
//                            TableColumn("DEP / DEST", value: \.depDest)
//                            TableColumn("Date", value: \.date)
//                            TableColumn("STD", value: \.stdUTC)
//                            TableColumn("STA", value: \.staUTC)
//                        }
//                        .frame(minHeight: 65)
                    }
                    else {
                        VStack {
                            HStack {
                                Group {
                                    Text("Flight No.")
                                    Text("Aircraft")
                                    Text("DEP / DEST")
                                    Text("Date")
                                    Text("STD")
                                    Text("STA")
                                    Text("BLK Time")
                                    Text("FLT Time")
                                    Text("POB")
                                }
                                .foregroundStyle(Color.blue)
                            }
                            HStack {
                                Group {
                                    Text("\(infoTable.flightNo)")
                                    Text("\(infoTable.aircraft)")
                                    Text("\(infoTable.depDest)")
                                    Text("\(infoTable.date)")
                                    Text("\(infoTable.stdLocal)")
                                    Text("\(infoTable.staLocal)")
                                    Text("\(infoTable.blkTime)")
                                    Text("\(infoTable.fltTime)")
                                    // entry here
                                    TextField(
                                        "POB",
                                        text: $pob
                                    )
                                    .onSubmit {
                                        // todo save to core data
                                    }
                                    .textInputAutocapitalization(.never)
                                    .disableAutocorrection(true)
                                    .border(.secondary) // todo change design
                                }
                            }
                        }
//                        Table(infoTable) {
//                            TableColumn("Flight No.", value: \.flightNo)
//                            TableColumn("Aircraft", value: \.aircraft)
//                            TableColumn("DEP / DEST", value: \.depDest)
//                            TableColumn("Date", value: \.date)
//                            TableColumn("STD", value: \.stdLocal)
//                            TableColumn("STA", value: \.staLocal)
//                        }
//                        .frame(minHeight: 65)
                    }
                    
                }
                
                // Route section
                Section(header: Text("ROUTE").foregroundStyle(Color.black)) {
                    // grouped row using hstack
                    VStack(alignment: .leading) {
                        HStack(alignment: .center) {
                            Text("Route No.")
                            .foregroundStyle(Color.blue)
                            .frame(maxWidth: 144, alignment: .leading)
                            Text(flightRouteData.routeNo)
                                .frame(maxWidth: 860, alignment: .leading)
                        }
                        .padding(.top, 5)
                        .padding(.bottom, 5)
                        .padding(.leading, 25)
                        Divider()
                            .padding(.leading, 25)
                        HStack(alignment: .center) {
                            Text("Route")
                            .foregroundStyle(Color.blue)
                            .frame(maxWidth: 144, alignment: .leading)
                            Text(flightRouteData.route)
                                .frame(maxWidth: 860, alignment: .leading)
                        }
                        .padding(.top, 5)
                        .padding(.bottom, 5)
                        .padding(.leading, 25)
                        Divider()
                            .padding(.leading, 25)
                        HStack(alignment: .center) {
                            Text("Planned Dep Rwy")
                            .foregroundStyle(Color.blue)
                            .frame(maxWidth: 144, alignment: .leading)
                            Text(flightRouteData.depRwy)
                                .frame(maxWidth: 860, alignment: .leading)
                        }
                        .padding(.top, 5)
                        .padding(.bottom, 5)
                        .padding(.leading, 25)
                        Divider()
                            .padding(.leading, 25)
                        HStack(alignment: .center) {
                            Text("Planned Arr Rwy")
                            .foregroundStyle(Color.blue)
                            .frame(maxWidth: 144, alignment: .leading)
                            Text(flightRouteData.arrRwy)
                                .frame(maxWidth: 860, alignment: .leading)
                        }
                        .padding(.top, 5)
                        .padding(.bottom, 5)
                        .padding(.leading, 25)
                        Divider()
                            .padding(.leading, 25)
                        HStack(alignment: .center) {
                            Text("Planned levels")
                            .foregroundStyle(Color.blue)
                            .frame(maxWidth: 144, alignment: .leading)
                            Text(flightRouteData.levels)
                                .frame(maxWidth: 860, alignment: .leading)
                        }
                        .padding(.top, 5)
                        .padding(.bottom, 5)
                        .padding(.leading, 25)
                    }
                }
                
                // Performance section
                Section(header: Text("PERFORMANCE").foregroundStyle(Color.black)) {
                    // table body - first row
                    Table(perfInfoTable) {
                        TableColumn("FLT Rules", value: \.fltRules)
                        TableColumn("GND Miles", value: \.gndMiles)
                        TableColumn("AIR Miles", value: \.airMiles)
                        TableColumn("CRZ Comp", value: \.crzComp)
                        TableColumn("APD", value: \.apd)
                        TableColumn("CI", value: \.ci)
                    }
                    .frame(minHeight: 65)
                    .scrollDisabled(true)
                    // table body - changes
                    Table(perfChangesTable) {
                        TableColumn("ZFW Change", value: \.zfwChange)
                        TableColumn("FL Change", value: \.lvlChange)
                    }
                    .frame(minHeight: 65)
                    .scrollDisabled(true)
                    // table body - weights
                    Table(perfWeightsTable) {
                        TableColumn("Weight", value: \.weight)
                        TableColumn("Plan", value: \.plan)
                        TableColumn("Actual") {_ in
//                            $weight in TextField("Enter actual weight", text: $weight)
                            Text("textfield")  // todo make textfield here
                        }
                        TableColumn("Max", value: \.max)
                        TableColumn("Limitation", value: \.limitation)
                    }
                    .frame(minHeight: 185)
                    .scrollDisabled(true)
                }
                
                // Fuel section
                Section(header: Text("FUEL").foregroundStyle(Color.black)) {
                    // grouped row using hstack
                    VStack(alignment: .leading) {
                        // fuel info table body
                        Table(fuelTable) {
                            TableColumn("", value: \.firstColumn)
                            TableColumn("Time", value: \.time)
                            TableColumn("Fuel", value: \.fuel)
                            TableColumn("Policy / Reason", value: \.policy_reason)
                        }
                        .frame(minHeight: 300)
                        .scrollDisabled(true)
                        
                        // extra fuel section
                        // row I
                        HStack(alignment: .center) {
                            Text("(I) Pilot Extra Fuel")
                                .frame(maxWidth: 310, alignment: .leading)
                            Text("Confirm requirements")  // todo change to dynamic - includedExtraFuelTime
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Confirm requirements") // todo change to dynamic - includedExtraFuelAmt
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Confirm requirements") // todo change to dynamic - includedExtraFuelRemarks
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.leading, 25)
                        .background(Color.cyan)  // todo correct design
                        Divider()
                            .padding(.leading, 25)
                        // collapsible fuel calculation section -  todo correct design and make collapsible on select row I
                        Group {
                            // header row
                            HStack(alignment: .center) {
                                Text("Included")
                                    .frame(maxWidth: 70, alignment: .leading) // todo correct spacing
                                Text("Reason")
                                    .frame(maxWidth: .infinity, alignment: .leading) // todo correct spacing
                                Text("Statistical")
                                Text(" Details")  // todo change to button link to fuel page
                                    .frame(maxWidth: .infinity, alignment: .leading) // todo correct spacing
                                    .foregroundStyle(Color.blue)
                                Text("Pilot Requirement")
                                    .frame(maxWidth: .infinity, alignment: .leading) // todo correct spacing
                                Text("Calculated Extra Fuel")
                                    .frame(maxWidth: .infinity, alignment: .leading) // todo correct spacing
                                Text("Remarks")
                                    .frame(maxWidth: .infinity, alignment: .leading) // todo correct spacing
                            }
                            .background(Color.cyan)  // todo correct design
                            Divider()
                        }
                        .padding(.leading, 25)
                        Group {
                            // delays row
                            HStack(alignment: .center) {
                                Toggle(isOn: $includedArrDelays) {}  // todo toggle logic flow
                                    .frame(maxWidth: 65, alignment: .leading)
                                Text("Arrival Delays")
                                    .frame(maxWidth: .infinity, alignment: .leading) // todo correct spacing
                                Text("+\(String(projDelay))mins")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Picker("Select", selection: $selectedArrDelays) {
                                    ForEach(0...120, id: \.self) { number in
                                        Text("+\(number)mins")
                                    }
                                }
                                .pickerStyle(.wheel) // todo make into modal as per figma design
                                Text("\(String(calculatedDelayFuel))KG")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Enter remarks (optional)")
                                    .frame(maxWidth: .infinity, alignment: .leading) // todo make into textfield
                            }
                            Divider()
                            // taxi row
                            HStack(alignment: .center) {
                                Toggle(isOn: $includedTaxi) {}  // todo toggle logic flow
                                    .frame(maxWidth: 65, alignment: .leading)
                                Text("Additional taxi")
                                    .frame(maxWidth: .infinity, alignment: .leading) // todo correct spacing
                                Text("+\(String(aveDiffTaxi))mins")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Picker("Select", selection: $selectedTaxi) {
                                    ForEach(0...60, id: \.self) { number in
                                        Text("+\(number)mins")
                                    }
                                }
                                .pickerStyle(.wheel) // todo make into modal as per figma design
                                Text("\(String(calculatedTaxiFuel))KG")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Enter remarks (optional)")
                                    .frame(maxWidth: .infinity, alignment: .leading) // todo make into textfield
                            }
                            Divider()
                            // flight level row
                            HStack(alignment: .center) {
                                Toggle(isOn: $includedFlightLevel) {}  // todo toggle logic flow
                                    .frame(maxWidth: 65, alignment: .leading)
                                Text("Flight level deviation")
                                    .frame(maxWidth: .infinity, alignment: .leading) // todo correct spacing
                                if aveDiffLevels < 0 {
                                    Text("\(String(aveDiffLevels))ft")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                } else {
                                    Text("+\(String(aveDiffLevels))ft")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                Picker("Select", selection: $selectedFlightLevel000) {
                                    ForEach(-10...10, id: \.self) { number in
                                        Text("\(number)000ft")
                                    }
                                }
                                .pickerStyle(.wheel) // todo make into modal as per figma design
                                Picker("Select", selection: $selectedFlightLevel00) {
                                    ForEach(-9...9, id: \.self) { number in
                                        Text("\(number)00ft")
                                    }
                                }
                                .pickerStyle(.wheel) // todo make into modal as per figma design
                                Text("\(String(calculatedFlightLevelFuel))KG")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Enter remarks (optional)")
                                    .frame(maxWidth: .infinity, alignment: .leading) // todo make into textfield
                            }
                            Divider()
                            // track shortening row
                            HStack(alignment: .center) {
                                Toggle(isOn: $includedTrackShortening) {}  // todo toggle logic flow
                                    .frame(maxWidth: 65, alignment: .leading)
                                Text("Track shortening savings")
                                    .frame(maxWidth: .infinity, alignment: .leading) // todo correct spacing
                                Text("\(String(sumMINS))mins")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Picker("Select", selection: $selectedTrackShortening) {
                                    ForEach(-30...0, id: \.self) { number in
                                        Text("\(number)mins")
                                    }
                                }
                                .pickerStyle(.wheel) // todo make into modal as per figma design
                                Text("\(String(calculatedTrackShorteningFuel))KG")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Enter remarks (optional)")
                                    .frame(maxWidth: .infinity, alignment: .leading) // todo make into textfield
                            }
                            .padding(.leading, 25)
                            .frame(maxWidth: .infinity)
                            Divider()
                                .padding(.leading, 25)
                            // enr wx row
                            HStack(alignment: .center) {
                                Toggle(isOn: $includedEnrWx) {}  // todo toggle logic flow
                                    .frame(maxWidth: 65, alignment: .leading)
                                Text("Enroute weather deviation")
                                    .frame(maxWidth: .infinity, alignment: .leading) // todo correct spacing
                                Text("+\(String(aveDiffEnrWX))mins")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Picker("Select", selection: $selectedEnrWx) {
                                    ForEach(0...30, id: \.self) { number in
                                        Text("\(number)mins")
                                    }
                                }
                                .pickerStyle(.wheel) // todo make into modal as per figma design
                                Text("\(String(calculatedEnrWxFuel))KG")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Enter remarks (optional)")
                                    .frame(maxWidth: .infinity, alignment: .leading) // todo make into textfield
                            }
                            Divider()
                        }
                        .padding(.leading, 25)
                        Group {
                            // reciprocal rwy row
                            HStack(alignment: .center) {
                                Toggle(isOn: $includedReciprocalRwy) {}  // todo toggle logic flow
                                    .frame(maxWidth: 65, alignment: .leading)
                                Text("Reciprocal rwy")
                                    .frame(maxWidth: .infinity, alignment: .leading) // todo correct spacing
                                Text("+/-\(String(reciprocalRwy))mins")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Picker("Select", selection: $selectedReciprocalRwy) {
                                    ForEach(-15...15, id: \.self) { number in
                                        Text("\(number)mins")
                                    }
                                }
                                .pickerStyle(.wheel) // todo make into modal as per figma design
                                Text("\(String(calculatedReciprocalRwyFuel))KG")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Enter remarks (optional)")
                                    .frame(maxWidth: .infinity, alignment: .leading) // todo make into textfield
                            }
                            Divider()
                            // zfw change row
                            HStack(alignment: .center) {
                                Toggle(isOn: $includedZFWchange) {}  // todo toggle logic flow
                                    .frame(maxWidth: 65, alignment: .leading)
                                Text("ZFW Change")
                                    .frame(maxWidth: .infinity, alignment: .leading) // todo correct spacing
                                Text("N.A.")
                                    .frame(maxWidth: .infinity, alignment: .leading) // todo correct spacing
                                Text("N.A.")
                                    .frame(maxWidth: .infinity, alignment: .leading) // todo correct spacing
                                Text("\(String(calculatedZFWFuel))KG")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Enter remarks (optional)")
                                    .frame(maxWidth: .infinity, alignment: .leading) // todo make into textfield
                            }
                            Divider()
                            // others row
                            HStack(alignment: .center) {
                                Toggle(isOn: $includedOthers) {}  // todo toggle logic flow
                                    .frame(maxWidth: 65, alignment: .leading)
                                Text("Others")
                                    .frame(maxWidth: .infinity, alignment: .leading) // todo correct spacing
                                Text("N.A.")
                                    .frame(maxWidth: .infinity, alignment: .leading) // todo correct spacing
                                Picker("Select", selection: $selectedOthers000) {
                                    ForEach(0...10, id: \.self) { number in
                                        Text("\(number)000KG")
                                    }
                                }
                                .pickerStyle(.wheel) // todo make into modal as per figma design
                                Picker("Select", selection: $selectedOthers00) {
                                    ForEach(0...9, id: \.self) { number in
                                        Text("\(number)00KG")
                                    }
                                }
                                .pickerStyle(.wheel) // todo make into modal as per figma design
                                Text("\(String(calculatedOthersFuel))KG")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Enter remarks (optional)")
                                    .frame(maxWidth: .infinity, alignment: .leading) // todo make into textfield
                            }
                            Divider()
                        }
                        .padding(.leading, 25)
                        HStack(alignment: .center) {
                            Text("Total Extra Fuel")
                                .frame(maxWidth: 310, alignment: .leading)
                            Text("\(includedExtraFuelAmt)KG")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("\(includedExtraFuelTime)mins")
                                .frame(maxWidth: .infinity, alignment: .leading)  // remove after testing
                            Text("\(includedExtraFuelRemarks)")
                                .frame(maxWidth: .infinity, alignment: .leading)  // remove after testing
                        }
                        .padding(.leading, 25)
                        .background(Color.cyan)  // todo correct design
                        Divider()
                            .padding(.leading, 25)
                        
                    }
                }
                
                // ALTN section
                Section(header: Text("ALTN").foregroundStyle(Color.black)) {
                    // todo - correct spacing and wrap text
                    Table(altnTable) {
                        TableColumn("ALTN / RWY", value: \.altnRwy)
                        TableColumn("RTE", value: \.rte)
                        TableColumn("VIS", value: \.vis)
                        TableColumn("MINIMA", value: \.minima)
                        TableColumn("DIST", value: \.dist)
                        TableColumn("FL", value: \.fl)
                        TableColumn("COMP", value: \.comp)
                        TableColumn("TIME", value: \.time)
                        TableColumn("FUEL", value: \.fuel)
                    }
                    .frame(minHeight: 250)
                    .scrollDisabled(true)
                }
                
                // ATC flight plan section
//                Section(header: Text("ATC FLIGHT PLAN").foregroundStyle(Color.black)) {
//                    Text("\(atcFlightPlan)")
//                        .padding(.leading, 25)
//                }
            }
        }
        .navigationTitle("Summary")
        .background(Color(.systemGroupedBackground))
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
}

