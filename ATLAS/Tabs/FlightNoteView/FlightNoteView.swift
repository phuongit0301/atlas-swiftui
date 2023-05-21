//
//  FlightNoteView.swift
//  ATLAS
//
//  Created by phuong phan on 20/05/2023.
//

import Foundation
import SwiftUI

struct FlightNoteView: View {
    var viewModel = ListFlightNoteInformationModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Flight Informations Card
                FlightInformationCard()

                Rectangle().fill(Color.theme.cultured).frame(height: 8)
                
                // Flight Note Card
                FlightNoteCard()
                
                Rectangle().fill(Color.theme.cultured).frame(height: 8)
                
                // Quick Reference
                VStack(alignment: .leading, spacing: 0) {
                    Collapsible {
                        Text("Quick Reference")
                            .font(.custom("Inter-SemiBold", size: 20))
                            .foregroundColor(.black)
                    } content: {
                        VStack(spacing: 0) {
                            Text("Quick Reference")
                        }
                    } headerContent: {
                        HStack {
                            Spacer()
                        }
                    }.padding(.horizontal, 16)
                        .padding(.vertical, 8)
                }.background(Color.theme.champagne)
                    .cornerRadius(8)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            }.padding(.horizontal, 16)
        }
    }
}
