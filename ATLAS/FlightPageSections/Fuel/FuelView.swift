//
//  FuelView.swift
//  ATLAS
//
//  Created by phuong phan on 20/05/2023.
//

import Foundation
import SwiftUI

struct FuelView: View {
    // fuel page swift data initialise
    @State private var selectedTab: Int = 0
    @EnvironmentObject var coreDataModel: CoreDataModelState
    
    var body: some View {
        GeometryReader { proxy in
            Group {
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
                            ArrivalDelayView().tag(selectedTab).ignoresSafeArea()
                        }
                    Spacer()
                    FuelSegmented(preselected: $selectedTab, options: IFuelTabs, geoWidth: proxy.size.width)
                }.overlay(
                    Group {
                        if coreDataModel.loadingInitFuel {
                            HStack(alignment: .center) {
                                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.black)).controlSize(.large)
                            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                .background(Color.black.opacity(0.3))
                        }
                    }
                )
                    // todo wrap in bottom navigation
                    //ArrivalDelayView()
                    //TaxiTimeView()
                    //TrackMilesView()
                    //FlightLevelView()
                    //EnrouteWeatherView()
//                    ReciprocalRunwayView()
                    
            }
            .task {
                await waitForResponse()
            }
        }
    }
    
    func waitForResponse() async {
        while coreDataModel.dataProjDelays == nil {
            do {
                try await Task.sleep(nanoseconds: 500000000) // Sleep for 0.5 seconds
            }
            catch {
                print("Error: \(error)")
            }
        }
    }
}






