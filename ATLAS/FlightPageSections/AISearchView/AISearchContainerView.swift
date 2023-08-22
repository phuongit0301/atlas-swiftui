//
//  AISearchContainer.swift
//  ATLAS
//
//  Created by phuong phan on 13/07/2023.
//

import Foundation
import SwiftUI

struct AISearchContainerView: View {
    @State private var selectedIndex: Int = 0
    
    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                TabView(selection: $selectedIndex, content: {
                    AISearchView().tag(0)
                    PreviousSearchView().tag(1)
                }).background(.white)
                    .roundedCorner(12, corners: [.topLeft, .topRight])
                    .padding(.horizontal)
                    .padding(.top)
                TabViewCustom(tabbarItems: ["Search", "Previous Searches"], geoWidth: proxy.size.width, selectedIndex: $selectedIndex)
            }
        }
    }
}

struct AISearchContainerView_Previews: PreviewProvider {
    static var previews: some View {
        AISearchContainerView()
    }
}
