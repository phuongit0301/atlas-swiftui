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
    @State var collapseFlightNote: Bool = false
    @State var collapseQuickReference = false
    
    var viewModel = ListFlightNoteInformationModel()
    @EnvironmentObject var viewModelState: FlightNoteModelState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Flight Informations Card
            FlightInformationCard().id("flight-information-card")

            Rectangle().fill(Color.theme.cultured).frame(height: 8)
            
            // Flight Note Card
            FlightNoteCard(geoWidth: geoWidth, collapsed: self.$collapseFlightNote, viewModel: viewModelState).id("flight-note-card")
            Rectangle().fill(Color.theme.cultured).frame(height: 8)
            // Quick Reference
            QuickReferenceCard(geoWidth: geoWidth, viewModel: viewModelState)
            Rectangle().fill(Color.theme.cultured).frame(height: 30)
            Spacer()
        }.padding(.horizontal, 16)
    }
}
