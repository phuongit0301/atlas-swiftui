//
//  FlightNoteView.swift
//  ATLAS
//
//  Created by phuong phan on 20/05/2023.
//

import Foundation
import SwiftUI

struct FlightNoteView: View {
    @State private var selectedTab: Int = 0
    @State private var noteTab = IFlightNoteTabs().ListItem
    @EnvironmentObject var viewModel: FlightNoteModelState
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                switch selectedTab {
                    case 0:
                        AircraftStatusContainer(viewModel: viewModel, geoWidth: proxy.size.width).tag(selectedTab).ignoresSafeArea()
                    case 1:
                        DepatureCardContainer(viewModel: viewModel, geoWidth: proxy.size.width).tag(selectedTab).ignoresSafeArea()
                    case 2:
                        EnrouteCardContainer(viewModel: viewModel, geoWidth: proxy.size.width).tag(selectedTab).ignoresSafeArea()
                    case 3:
                        ArrivalCardContainer(viewModel: viewModel, geoWidth: proxy.size.width).tag(selectedTab).ignoresSafeArea()
                    default:
                        AircraftStatusContainer(viewModel: viewModel,  geoWidth: proxy.size.width).tag(selectedTab).ignoresSafeArea()
                }
                
                Spacer()
                CustomSegmentedControl(preselectedIndex: $selectedTab, options: noteTab, geoWidth: proxy.size.width)
            }
        }
    }
}
