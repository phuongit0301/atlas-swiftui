//
//  FlightNoteCard.swift
//  ATLAS
//
//  Created by phuong phan on 21/05/2023.
//

import Foundation
import SwiftUI

struct FlightNoteCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // flight informations
            Collapsible {
                Text("Flight Notes")
                    .font(.custom("Inter-SemiBold", size: 20))
                    .foregroundColor(.black)
            } content: {
                VStack(spacing: 0) {
                    Text("Flight Notes")
                }
            } headerContent: {
                HStack {
                    Spacer()
                }.padding(.vertical, 8)
            }.padding(.horizontal, 16)
                .padding(.vertical, 8)
        }.background(Color.theme.honeydew)
            .cornerRadius(8)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}
