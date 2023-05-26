//
//  FlightNoteCardContainer.swift
//  ATLAS
//
//  Created by phuong phan on 23/05/2023.
//

import Foundation
import SwiftUI

struct AircraftStatusContainer: View {
    var viewModel = DepartureFlightInfoModel()
    
    var body: some View {
//        Form()
        VStack(spacing: 0) {
            Text("Aricraft")
        }.frame(maxWidth: .infinity)            
    }
}
