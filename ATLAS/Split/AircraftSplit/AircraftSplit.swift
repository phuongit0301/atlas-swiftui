//
//  AircraftSplit.swift
//  ATLAS
//
//  Created by phuong phan on 29/05/2023.
//

import Foundation
import SwiftUI
    
struct AircraftSplit: View {
    @EnvironmentObject var viewModel: FlightNoteModelState
    @State var animatedContentHeight: CGFloat = 45
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                AircraftSplitContainer(itemList: $viewModel.aircraftData, calculateHeight: self.calculateHeight, geoWidth: geo.size.width, contentHeight: animatedContentHeight)
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.theme.cultured)
        }
    }
    
    private func calculateHeight() {
        animatedContentHeight = CGFloat(45 * $viewModel.aircraftData.count)
    }
}
