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
    @State private var selectedTab: Int = 0
    @Query var fuelPageData: [FuelPageData]
    
    var body: some View {
        GeometryReader { proxy in
            Group {
                if fuelPageData.first?.projDelays != nil {
                    VStack {
                        switch selectedTab {
                            case 0:
                                ArrivalDelayView().tag(selectedTab).ignoresSafeArea()
                            case 1:
                                TaxiTimeView().tag(selectedTab).ignoresSafeArea()
                            case 2:
                                TrackMilesView().tag(selectedTab).ignoresSafeArea()
                            case 3:
                                EnrouteWeatherView().tag(selectedTab).ignoresSafeArea()
                            case 4:
                                FlightLevelView().tag(selectedTab).ignoresSafeArea()
                            case 5:
                                ReciprocalRunwayView().tag(selectedTab).ignoresSafeArea()
                            default:
                                ReciprocalRunwayView().tag(selectedTab).ignoresSafeArea()
                            }
                        Spacer()
                        FuelSegmented(preselected: $selectedTab, options: IFuelTabs, geoWidth: proxy.size.width)
                    }
                    // todo wrap in bottom navigation
                    //ArrivalDelayView()
                    //TaxiTimeView()
                    //TrackMilesView()
                    //FlightLevelView()
                    //EnrouteWeatherView()
//                    ReciprocalRunwayView()
                    
                } else {
                    Text("Loading...")
                }
            }
            .task {
                await waitForResponse()
            }
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






