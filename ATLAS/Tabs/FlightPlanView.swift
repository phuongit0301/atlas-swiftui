//
//  FlightPlanView.swift
//  ATLAS
//
//  Created by phuong phan on 20/05/2023.
//

import Foundation
import SwiftUI

// fetch flight plan data - todo replace with API
func fetchFlightPlanData() -> [String: Any] {
//    let dateFormatterDate = DateFormatter()
//    let dateFormatterTime = DateFormatter()
//    dateFormatterDate.dateFormat = "ddMMyy"
//    dateFormatterTime.dateFormat = "HH:mm"
    let infoData = InfoData(planNo: "20", fltNo: "SQ123", tailNo: "9VSHM", dep: "SIN", dest: "BER", flightDate: "040723", STDUTC: "08:00", STAUTC: "17:00", STDLocal: "10:00", STALocal: "21:00")
    let routeData = RouteData(routeNo: "SINBER91", route: "WSSS/20L AKOMA DCT AKMET DCT AROSO Y513 KALIL Y504 BILIK G582 PUGER P574 UDULO P574 TOTOX L555 TOLDA M628 PEKEM M628 MIGMA M550 MEVDO  Y511 PMA V22 YEN L300 LXR P751 KATAB B12 DBA L613 TANSA UL617 KEA UG33 KOROS UN133 PEREN UL863 EVIVI DCT OKANA DCT TONDO DCT BEGLA DCT LOKVU DCT LEGAZ DCT BEFRE T204 TEXTI T204 NUKRO DCT EDDB/25L", depRwy: "WSSS/20L", arrRwy: "EDDB/25L", levels: "SIN/360/UDULO/380/PEKEM/390/MIGMA/400/KEA/410/KOROS/430/TEXTI/380")
    let perfData = PerfData(fltRules: "RVSM", gndMiles: "6385", airMiles: "7004", crzComp: "M42", apd: "1.4", ci: "100", zfwChange: "M1000KG BURN LESS 557KG", lvlChange: "P2000FT BURN LESS 200KG", planZFW: "143416", maxZFW: "161025", limZFW: "Structural", planTOW: "227883", maxTOW: "227930", limTOW: "Perf - Obstacle", planLDW: "151726", maxLDW: "172365", limLDW: "Structural")
    let object = ["infoData": infoData, "routeData": routeData, "perfData": perfData] as [String : Any]
    return object
}

struct InfoData: Codable {
    let planNo: String
    let fltNo: String
    let tailNo: String
    let dep: String
    let dest: String
    let flightDate: String
    let STDUTC: String
    let STAUTC: String
    let STDLocal: String
    let STALocal: String
}

struct RouteData: Codable {
    let routeNo: String
    let route: String
    let depRwy: String
    let arrRwy: String
    let levels: String
}

struct PerfData: Codable {
    let fltRules: String
    let gndMiles: String
    let airMiles: String
    let crzComp: String
    let apd: String
    let ci: String
    let zfwChange: String
    let lvlChange: String
    let planZFW: String
    let maxZFW: String
    let limZFW: String
    let planTOW: String
    let maxTOW: String
    let limTOW: String
    let planLDW: String
    let maxLDW: String
    let limLDW: String
}
//

// creating flight info table structure
struct flightInfo: Identifiable {
    let flightNo: String
    let aircraft: String
    let depDest: String
    let date: String
    let stdUTC: String
    let staUTC: String
    let stdLocal: String
    let staLocal: String
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

// creating flight info table structure
struct perfWeights: Identifiable {
    let weight: String
    let plan: String
    //let actual: Int
    let max: String
    let limitation: String
    let id = UUID()
}


struct FlightPlanView: View {
    @State private var showUTC = true
    var body: some View {
        // fetch flight plan data
        let flightPlanData: [String : Any] = fetchFlightPlanData()
        // set up flight info table data
        let flightInfoData: InfoData = flightPlanData["infoData"] as! InfoData
        @State var infoTable = [
            flightInfo(flightNo: flightInfoData.fltNo, aircraft: flightInfoData.tailNo, depDest: flightInfoData.dep+" / "+flightInfoData.dest, date: flightInfoData.flightDate, stdUTC: flightInfoData.STDUTC, staUTC: flightInfoData.STAUTC, stdLocal: flightInfoData.STDLocal, staLocal: flightInfoData.STALocal)
        ]
        // set up route data
        let flightRouteData: RouteData = flightPlanData["routeData"] as! RouteData
        // set up perf tables data
        let perfData: PerfData = flightPlanData["perfData"] as! PerfData
        @State var perfInfoTable = [
            perfInfo(fltRules: perfData.fltRules, gndMiles: perfData.gndMiles, airMiles: perfData.airMiles, crzComp: perfData.crzComp, apd: perfData.apd, ci: perfData.ci)
        ]
        @State var perfChangesTable = [
            perfChanges(zfwChange: perfData.zfwChange, lvlChange: perfData.lvlChange)
        ]
        @State var perfWeightsTable = [
            perfWeights(weight: "ZFW", plan: perfData.planZFW, max: perfData.maxZFW, limitation: perfData.limZFW),
            perfWeights(weight: "TOW", plan: perfData.planTOW, max: perfData.maxTOW, limitation: perfData.limTOW),
            perfWeights(weight: "LDW", plan: perfData.planLDW, max: perfData.maxLDW, limitation: perfData.limLDW),
        ]
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
                    // table body
                    if showUTC {
                        Table(infoTable) {
                            TableColumn("Flight No.", value: \.flightNo)
                            TableColumn("Aircraft", value: \.aircraft)
                            TableColumn("DEP / DEST", value: \.depDest)
                            TableColumn("Date", value: \.date)
                            TableColumn("STD", value: \.stdUTC)
                            TableColumn("STA", value: \.staUTC)
                        }
                        .frame(minHeight: 65)
                    }
                    else {
                        Table(infoTable) {
                            TableColumn("Flight No.", value: \.flightNo)
                            TableColumn("Aircraft", value: \.aircraft)
                            TableColumn("DEP / DEST", value: \.depDest)
                            TableColumn("Date", value: \.date)
                            TableColumn("STD", value: \.stdLocal)
                            TableColumn("STA", value: \.staLocal)
                        }
                        .frame(minHeight: 65)
                    }
                    
                }
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
                        .padding(5)
                        Divider()
                        HStack(alignment: .center) {
                            Text("Route")
                            .foregroundStyle(Color.blue)
                            .frame(maxWidth: 144, alignment: .leading)
                            Text(flightRouteData.route)
                                .frame(maxWidth: 860, alignment: .leading)
                        }
                        .padding(5)
                        Divider()
                        HStack(alignment: .center) {
                            Text("Planned Dep Rwy")
                            .foregroundStyle(Color.blue)
                            .frame(maxWidth: 144, alignment: .leading)
                            Text(flightRouteData.depRwy)
                                .frame(maxWidth: 860, alignment: .leading)
                        }
                        .padding(5)
                        Divider()
                        HStack(alignment: .center) {
                            Text("Planned Arr Rwy")
                            .foregroundStyle(Color.blue)
                            .frame(maxWidth: 144, alignment: .leading)
                            Text(flightRouteData.arrRwy)
                                .frame(maxWidth: 860, alignment: .leading)
                        }
                        .padding(5)
                        Divider()
                        HStack(alignment: .center) {
                            Text("Planned levels")
                            .foregroundStyle(Color.blue)
                            .frame(maxWidth: 144, alignment: .leading)
                            Text(flightRouteData.levels)
                                .frame(maxWidth: 860, alignment: .leading)
                        }
                        .padding(5)
                    }
                }
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
            }
        }
        .navigationTitle("Summary")
        .background(Color(.systemGroupedBackground))
    }
    
}
