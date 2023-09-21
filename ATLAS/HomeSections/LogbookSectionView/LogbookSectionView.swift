//
//  LogbookSectionView.swift
//  ATLAS
//
//  Created by phuong phan on 06/09/2023.
//

import SwiftUI

struct LogbookSectionView: View {
    @State var selectedTab: LogbookEnumeration = ILogbookTabs.first?.screenName ?? LogbookEnumeration.OverviewScreen
        
    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { proxy in
                VStack(spacing: 0) {
                    switch selectedTab {
                        case .OverviewScreen:
                            OverviewSubSectionView()
                        case .EntriesScreen:
                            EntriesSubSectionView()
                        case .LimitationsScreen:
                            LimitationsSubSectionView()
                    }
                    
                    Spacer()
                    
                    LogbookSegmented(preselected: $selectedTab, options: ILogbookTabs, geoWidth: proxy.size.width)
                }.frame(maxHeight: .infinity)
                    
            }
        }
    }
}

struct LogbookSectionView_Previews: PreviewProvider {
    static var previews: some View {
        LogbookSectionView()
    }
}
