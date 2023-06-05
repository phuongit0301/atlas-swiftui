//
//  ArrivalSplit.swift
//  ATLAS
//
//  Created by phuong phan on 29/05/2023.
//

import Foundation
import SwiftUI
    
struct ArrivalSplit: View {
    @ObservedObject var viewModel: FlightNoteModelState = FlightNoteModelState()

    var body: some View {
        GeometryReader { geo in
            VStack {
                ArrivalSplitContainer(viewModel: viewModel, geoWidth: geo.size.width)
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.theme.cultured)
        }
    }
}
