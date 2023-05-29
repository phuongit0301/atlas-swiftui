//
//  AircraftSplit.swift
//  ATLAS
//
//  Created by phuong phan on 29/05/2023.
//

import Foundation
import SwiftUI
    
struct AircraftSplit: View {
    @State var itemAircraft: [IFlightInfoModel] = []
    @State var animatedContentHeight: CGFloat = 45
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                AircraftSplitContainer(itemList: self.$itemAircraft, calculateHeight: self.calculateHeight, geoWidth: geo.size.width, contentHeight: animatedContentHeight)
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.theme.cultured)
        }
    }
    
    private func calculateHeight() {
        animatedContentHeight = CGFloat(45 * itemAircraft.count)
    }
}
