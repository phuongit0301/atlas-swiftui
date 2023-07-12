//
//  FuelView.swift
//  ATLAS
//
//  Created by phuong phan on 20/05/2023.
//

import Foundation
import SwiftUI
import SwiftData

struct FuelView: View {
    // fuel page swift data initialise
    @Environment(\.modelContext) private var context
    @Query var fuelPageData: [FuelPageData]
    
    var body: some View {
        Group {
            if fuelPageData.first?.projDelays != nil {
                // todo wrap in bottom navigation
                //ArrivalDelayView()
                //TaxiTimeView()
                //TrackMilesView()
                //FlightLevelView()
                //EnrouteWeatherView()
                ReciprocalRunwayView()
            } else {
                Text("Loading...")
            }
        }
        .task {
            await waitForResponse()
        }
    }
    
    func waitForResponse() async {
        while fuelPageData.first?.projDelays == nil {
            do {
                try await Task.sleep(nanoseconds: 500000000) // Sleep for 0.5 seconds
            }
            catch {
                print("Error: \(error)")
            }
        }
    }
}






