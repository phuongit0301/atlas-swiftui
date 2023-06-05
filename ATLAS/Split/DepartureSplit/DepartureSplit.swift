//
//  DepartureSplit.swift
//  ATLAS
//
//  Created by phuong phan on 29/05/2023.
//

import Foundation
import SwiftUI
    
struct DepartureSplit: View {
    @EnvironmentObject var viewModel: FlightNoteModelState

    var body: some View {
        GeometryReader { geo in
            VStack {
                DepartureSplitContainer(viewModel: viewModel, geoWidth: geo.size.width)
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.theme.cultured)
        }
    }
}
