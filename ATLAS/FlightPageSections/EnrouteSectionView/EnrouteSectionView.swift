//
//  EnrouteSectionView.swift
//  ATLAS
//
//  Created by phuong phan on 25/09/2023.
//

import SwiftUI

struct EnrouteSectionView: View {
    @State var selectedTab: FlightNoteEnumeration = IFlightNoteTabs.first?.screenName ?? FlightNoteEnumeration.MapScreen
    @State var planTab = IFlightNoteTabs
    
    var body: some View {
        GeometryReader {proxy in
            VStack(spacing: 0) {
                switch selectedTab {
                    case .MapScreen:
                        MapViewModal()
                    case .NoteScreen:
                        EnrouteSectionListView()
                }
                
                CustomSegmentedControl(preselected: $selectedTab, options: planTab, geoWidth: proxy.size.width)
            }.frame(maxHeight: .infinity)
        }
    }
}
