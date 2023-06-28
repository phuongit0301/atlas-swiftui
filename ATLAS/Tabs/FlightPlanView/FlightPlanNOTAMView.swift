//
//  FlightPlanNOTAMView.swift
//  ATLAS
//
//  Created by Muhammad Adil on 25/6/23.
//

import Foundation
import SwiftUI

struct FlightPlanNOTAMView: View {
    // initialise state variables

    var body: some View {
        // fetch flight plan data
        let flightPlanData: [String : Any] = fetchFlightPlanData()
        let flightInfoData: InfoData = flightPlanData["infoData"] as! InfoData
        let notamsData: NotamsData = flightPlanData["notamsData"] as! NotamsData
        let depNotams = notamsData.depNotams
        let enrNotams = notamsData.enrNotams
        let arrNotams = notamsData.arrNotams

        VStack(alignment: .leading) {
            // fixed header section, todo clean up design
            HStack(alignment: .center) {
                Text("NOTAMS")
                    .font(.title)
                    .padding(.leading, 30)
            }
            .padding(.bottom, 10)
            Text("Plan \(flightInfoData.planNo) | Last updated 0820LT")
            .padding(.leading, 30)
            .padding(.bottom, 10)
            //scrollable outer list section
            List {
                // Dep NOTAM section
                Section(header: Text("DEP NOTAMS").foregroundStyle(Color.black)) {
                    ForEach(depNotams, id: \.self) { notam in
                        Text(notam)
                            .padding(.leading, 25)
                    }
                }
                // Enr NOTAM section
                Section(header: Text("ENROUTE NOTAMS").foregroundStyle(Color.black)) {
                    ForEach(enrNotams, id: \.self) { notam in
                        Text(notam)
                            .padding(.leading, 25)
                    }
                }
                // Arr NOTAM section
                Section(header: Text("ARR NOTAMS").foregroundStyle(Color.black)) {
                    ForEach(arrNotams, id: \.self) { notam in
                        Text(notam)
                            .padding(.leading, 25)
                    }
                }
            }
        }
        .navigationTitle("NOTAMS")
        .background(Color(.systemGroupedBackground))
    }
}

