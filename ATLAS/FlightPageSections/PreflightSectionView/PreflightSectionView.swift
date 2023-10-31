//
//  PreflightSectionView.swift
//  ATLAS
//
//  Created by phuong phan on 26/09/2023.
//

import SwiftUI

struct PreflightSectionView: View {
    @EnvironmentObject var preflightModel: PreflightModel
//    @State var selectedTab: PreflightTabEnumeration = IPreflightTabs.first?.screenName ?? PreflightTabEnumeration.SummaryScreen
    @State var planTab = IPreflightTabs
    
    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                switch preflightModel.selectedTab {
                    case .SummaryScreen:
                        SummarySubSectionView()
                    case .NotamScreen:
                        NotamSubSectionView()
                    case .MetarTafScreen:
                        MetarTafSubSectionView()
                    case .StatisticsScreen:
//                        FuelView()
                        StatisticsView()  // note added here new statistics view
                    case .Mapcreen:
                        MapViewModal()
                    case .NotesScreen:
                        NoteSubSectionView()
                }
                
                PreflightSegmented(preselected: $preflightModel.selectedTab, options: planTab, geoWidth: proxy.size.width)
            }.frame(maxHeight: .infinity)
        }
    }
}
