//
//  AISearchContainer.swift
//  ATLAS
//
//  Created by phuong phan on 13/07/2023.
//

import Foundation
import SwiftUI

struct AISearchContainerView: View {
    @State private var selectedTab: Int = 0
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                switch selectedTab {
                    case 0:
                        AISearchView().tag(selectedTab).ignoresSafeArea()
                    case 1:
                        PreviousSearchView().tag(selectedTab).ignoresSafeArea()
                    default:
                        AISearchView().tag(selectedTab).ignoresSafeArea()
                    }
                Spacer()
                AISearchSegmented(preselected: $selectedTab, options: IAISearchTabs, geoWidth: proxy.size.width)
            }
        }
    }
}
