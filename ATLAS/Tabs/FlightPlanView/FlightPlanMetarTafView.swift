//
//  FlightPlanMetarTafView.swift
//  ATLAS
//
//  Created by Muhammad Adil on 25/6/23.
//

import Foundation
import SwiftUI

// creating altn table structure
struct altnTaf: Identifiable {
    let altnRwy: String
    let eta: String
    let taf: String
    let id = UUID()
}

struct FlightPlanMETARTAFView: View {
    // initialise state variables
    let redWords: [String] = ["TEMPO", "RA", "SHRA", "RESHRA", "-SHRA", "+SHRA", "TS", "TSRA", "-TSRA", "+TSRA", "RETS"]

    var body: some View {
        // fetch flight plan data
        let flightPlanData: [String : Any] = fetchFlightPlanData()
        let flightInfoData: InfoData = flightPlanData["infoData"] as! InfoData
        let flightRouteData: RouteData = flightPlanData["routeData"] as! RouteData
        let metarTafData: MetarTafData = flightPlanData["metarTafData"] as! MetarTafData
        let depMetar = metarTafData.depMetar
        let depTaf = metarTafData.depTaf
        let arrMetar = metarTafData.arrMetar
        let arrTaf = metarTafData.arrTaf
        
        // set up altn table data
        let altnTafData: [AltnTafData] = metarTafData.altnTaf
        @State var altnTafTable: [altnTaf] = altnTafData.map { item in
            return altnTaf(
                altnRwy: item.altnRwy,
                eta: item.eta,
                taf: item.taf
            )
        }

        VStack(alignment: .leading) {
            // fixed header section, todo clean up design
            HStack(alignment: .center) {
                Text("METAR / TAF")
                    .font(.title)
                    .padding(.leading, 30)
            }
            .padding(.bottom, 10)
            Text("Plan \(flightInfoData.planNo) | Last updated 0820LT")
            .padding(.leading, 30)
            .padding(.bottom, 10)
            
            //scrollable outer list section
            List {
                // Dep METAR section
                Section(header: Text("DEP METAR | PLAN DEP \(flightInfoData.depICAO)  \(flightRouteData.depRwy)").foregroundStyle(Color.black)) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(depMetar.components(separatedBy: " "), id: \.self) { word in
                                if redWords.contains(word) {
                                    Text(word)
                                        .foregroundColor(.red)
                                } else if let number = Int(word), number < 3000 {
                                    Text(word)
                                        .foregroundColor(.red)
                                } else if word.range(of: #"^\d{3}$"#, options: .regularExpression) != nil {
                                    Text(word)
                                        .foregroundColor(.green)
                                } else if word.range(of: #"\d+KT"#, options: .regularExpression) != nil || word.range(of: #"^\d{4}$"#, options: .regularExpression) != nil {
                                    Text(word)
                                        .foregroundColor(.green)
                                } else {
                                    Text(word)
                                }
                            }
                        }
                        .padding(.leading, 25)
                    } // todo make fit to content without scrollview
                }
                
                // Dep TAF section
                Section(header: Text("DEP TAF | PLAN DEP \(flightInfoData.depICAO)  \(flightRouteData.depRwy)").foregroundStyle(Color.black)) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(depTaf.components(separatedBy: " "), id: \.self) { word in
                                if redWords.contains(word) {
                                    Text(word)
                                        .foregroundColor(.red)
                                } else if let number = Int(word), number < 3000 {
                                    Text(word)
                                        .foregroundColor(.red)
                                } else if word.range(of: #"^\d{3}$"#, options: .regularExpression) != nil {
                                    Text(word)
                                        .foregroundColor(.green)
                                } else if word.range(of: #"\d+KT"#, options: .regularExpression) != nil || word.range(of: #"^\d{4}$"#, options: .regularExpression) != nil {
                                    Text(word)
                                        .foregroundColor(.green)
                                } else {
                                    Text(word)
                                }
                            }
                        }
                        .padding(.leading, 25)
                    } // todo make fit to content without scrollview
                }
                // Arr METAR section
                Section(header: Text("ARR METAR | PLAN ARR \(flightInfoData.destICAO)  \(flightRouteData.arrRwy)").foregroundStyle(Color.black)) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(arrMetar.components(separatedBy: " "), id: \.self) { word in
                                if redWords.contains(word) {
                                    Text(word)
                                        .foregroundColor(.red)
                                } else if let number = Int(word), number < 3000 {
                                    Text(word)
                                        .foregroundColor(.red)
                                } else if word.range(of: #"^\d{3}$"#, options: .regularExpression) != nil {
                                    Text(word)
                                        .foregroundColor(.green)
                                } else if word.range(of: #"\d+KT"#, options: .regularExpression) != nil || word.range(of: #"^\d{4}$"#, options: .regularExpression) != nil {
                                    Text(word)
                                        .foregroundColor(.green)
                                } else {
                                    Text(word)
                                }
                            }
                        }
                        .padding(.leading, 25)
                    } // todo make fit to content without scrollview
                }
                // Arr TAF section
                Section(header: Text("ARR TAF | PLAN ARR \(flightInfoData.destICAO)  \(flightRouteData.arrRwy)").foregroundStyle(Color.black)) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(arrTaf.components(separatedBy: " "), id: \.self) { word in
                                if redWords.contains(word) {
                                    Text(word)
                                        .foregroundColor(.red)
                                } else if let number = Int(word), number < 3000 {
                                    Text(word)
                                        .foregroundColor(.red)
                                } else if word.range(of: #"^\d{3}$"#, options: .regularExpression) != nil {
                                    Text(word)
                                        .foregroundColor(.green)
                                } else if word.range(of: #"\d+KT"#, options: .regularExpression) != nil || word.range(of: #"^\d{4}$"#, options: .regularExpression) != nil {
                                    Text(word)
                                        .foregroundColor(.green)
                                } else {
                                    Text(word)
                                }
                            }
                        }
                        .padding(.leading, 25)
                    } // todo make fit to content without scrollview
                }
                // ALTN TAF section
                Section(header: Text("ALTN TAF").foregroundStyle(Color.black)) {
                    // todo - correct spacing and wrap text
                    Table(altnTafTable) {
                        TableColumn("ALTN / RWY", value: \.altnRwy)
                        TableColumn("ETA", value: \.eta)
                        TableColumn("TAF", value: \.taf)
                    }
                    .frame(minHeight: 250)
                    .scrollDisabled(true)
                } // todo fix spacing, make color selection like above (no need to use table if not required)
            }
        }
        .navigationTitle("METAR / TAF")
        .background(Color(.systemGroupedBackground))
    }
}


