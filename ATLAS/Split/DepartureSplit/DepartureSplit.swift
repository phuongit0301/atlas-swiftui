//
//  DepartureSplit.swift
//  ATLAS
//
//  Created by phuong phan on 29/05/2023.
//

import Foundation
import SwiftUI
    
struct DepartureSplit: View {
    @State var itemDeparture: [IFlightInfoModel] = DepartureFlightInfoTempModel().ListItem
    @State var animatedContentHeight: CGFloat = 90

    var body: some View {
        GeometryReader { geo in
            VStack {
                DepartureSplitContainer(itemList: self.$itemDeparture, calculateHeight: self.calculateHeight, geoWidth: geo.size.width, contentHeight: animatedContentHeight)
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.theme.cultured)
        }
    }
    
    private func calculateHeight() {
        animatedContentHeight = CGFloat(48 * itemDeparture.count)
    }
}
