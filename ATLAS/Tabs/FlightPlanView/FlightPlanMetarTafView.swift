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
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController
    @State var showLoading = false
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
                Spacer()
                Button(action: {
                    onSyncData()
                }, label: {
                    HStack {
                        if showLoading {
                            ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.white)).padding(.leading)
                        }
                        Text("Refresh").font(.system(size: 17))
                            .foregroundColor(Color.white)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                    }
                }).background(Color.theme.azure)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.white, lineWidth: 0)
                    )
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    
            }
            .padding(.bottom, 10)
            .padding(.trailing)
            
            Text("Plan \(flightInfoData.planNo) | Last updated 0820LT")
            .padding(.leading, 30)
            .padding(.bottom, 10)
            
            //scrollable outer list section
            List {
                // Dep METAR section
                Section(header: Text("DEP METAR | PLAN DEP \(coreDataModel.dataSummaryInfo.unwrappedDepICAO)  \(coreDataModel.dataSummaryRoute.unwrappedDepRwy)").foregroundStyle(Color.black)) {
                    HStack(spacing: 10) {
                        NewFlowLayout(alignment: .leading) {
                            ForEach(coreDataModel.dataMetarTaf.unwrappedDepMetar.components(separatedBy: " "), id: \.self) { word in
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
                    }.padding(.leading, 25)
                }
                
                // Dep TAF section
                Section(header: Text("DEP TAF | PLAN DEP \(coreDataModel.dataSummaryInfo.unwrappedDepICAO)  \(coreDataModel.dataSummaryRoute.unwrappedDepRwy)").foregroundStyle(Color.black)) {
                    HStack(spacing: 10) {
                        NewFlowLayout(alignment: .leading) {
                            ForEach(coreDataModel.dataMetarTaf.unwrappedDepTaf.components(separatedBy: " "), id: \.self) { word in
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
                    }
                }
                // Arr METAR section
                Section(header: Text("ARR METAR | PLAN ARR \(coreDataModel.dataSummaryInfo.unwrappedDepICAO)  \(coreDataModel.dataSummaryRoute.unwrappedArrRwy)").foregroundStyle(Color.black)) {
                    HStack(spacing: 10) {
                        NewFlowLayout(alignment: .leading) {
                            ForEach(coreDataModel.dataMetarTaf.unwrappedArrMetar.components(separatedBy: " "), id: \.self) { word in
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
                    }.padding(.leading, 25)
                }
                // Arr TAF section
                Section(header: Text("ARR TAF | PLAN ARR \(coreDataModel.dataSummaryInfo.unwrappedDepICAO)  \(coreDataModel.dataSummaryRoute.unwrappedArrRwy)").foregroundStyle(Color.black)) {
                        HStack(spacing: 10) {
                            NewFlowLayout(alignment: .leading) {
                                ForEach(coreDataModel.dataMetarTaf.unwrappedArrTaf.components(separatedBy: " "), id: \.self) { word in
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
                        }.padding(.leading, 25)
                }
                // ALTN TAF section
                Section(header: Text("ALTN TAF").foregroundStyle(Color.black)) {
                    Table(coreDataModel.dataAltnTaf) {
                        TableColumn("ALTN / RWY", value: \.unwrappedAltnRwy)
                        TableColumn("ETA") {
                            Text($0.unwrappedEta).font(.system(size: 17, weight: .regular))
                        }
                        TableColumn("TAF") {
                            Text($0.unwrappedTaf).font(.system(size: 17, weight: .regular)).lineLimit(nil)
                        }.width(800)
                    }
                    .frame(minHeight: 350)
                    .scrollDisabled(true)
                }
            }
        }
        .navigationTitle("METAR / TAF")
        .background(Color(.systemGroupedBackground))
    }
    
    func onSyncData() {
        Task {
            showLoading = true
            await coreDataModel.syncDataMetarTaf()
            showLoading = false
        }
    }
}


