//
//  ArrivalSplit.swift
//  ATLAS
//
//  Created by phuong phan on 29/05/2023.
//

import Foundation
import SwiftUI
    
struct ArrivalSplit: View {
    @EnvironmentObject var viewModel: FlightNoteModelState
    @State var animatedContentHeight: CGFloat = 90

    var body: some View {
        GeometryReader { geo in
            VStack {
                ArrivalSplitContainer(itemList: $viewModel.arrivalData, calculateHeight: self.calculateHeight, geoWidth: geo.size.width, contentHeight: animatedContentHeight)
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.theme.cultured)
        }
    }
    
    private func calculateHeight() {
        animatedContentHeight = CGFloat(48 * viewModel.arrivalData.count)
    }
}
