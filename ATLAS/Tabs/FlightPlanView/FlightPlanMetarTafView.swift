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
                    Text(depMetar)
                        .padding(.leading, 25)
                }
                // Dep TAF section
                Section(header: Text("DEP TAF | PLAN DEP \(flightInfoData.depICAO)  \(flightRouteData.depRwy)").foregroundStyle(Color.black)) {
                    Text(depTaf)
                        .padding(.leading, 25)
                }
                // Arr METAR section
                Section(header: Text("ARR METAR | PLAN ARR \(flightInfoData.destICAO)  \(flightRouteData.arrRwy)").foregroundStyle(Color.black)) {
                    Text(arrMetar)
                        .padding(.leading, 25)
                }
                // Arr TAF section
                Section(header: Text("ARR TAF | PLAN ARR \(flightInfoData.destICAO)  \(flightRouteData.arrRwy)").foregroundStyle(Color.black)) {
                    Text(arrTaf)
                        .padding(.leading, 25)
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
                } // todo fix spacing
            }
        }
        .navigationTitle("NOTAMS")
        .background(Color(.systemGroupedBackground))
    }
}


