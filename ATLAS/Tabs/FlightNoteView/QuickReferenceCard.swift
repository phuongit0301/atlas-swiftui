//
//  QuickReferenceCard.swift
//  ATLAS
//
//  Created by phuong phan on 22/05/2023.
//

import Foundation
import SwiftUI

struct QuickReferenceCard: View {
    var body: some View {
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
    }
}
