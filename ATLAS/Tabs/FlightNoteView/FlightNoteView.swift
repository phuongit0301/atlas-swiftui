//
//  FlightNoteView.swift
//  ATLAS
//
//  Created by phuong phan on 20/05/2023.
//

import Foundation
import SwiftUI

struct FlightNoteView: View {
    var geoWidth: Double = 0
    
    var viewModel = ListFlightNoteInformationModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Flight Informations Card
            FlightInformationCard().id("flight-information-card")

            Rectangle().fill(Color.theme.cultured).frame(height: 8)
            
            // Flight Note Card
            FlightNoteCard(geoWidth: geoWidth).id("flight-note-card")
            
            Rectangle().fill(Color.theme.cultured).frame(height: 8)
            
            // Quick Reference
            QuickReferenceCard()
            Spacer()
        }.padding(.horizontal, 16)
    }
}
