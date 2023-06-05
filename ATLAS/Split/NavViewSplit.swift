//
//  NavView.swift
//  ATLAS
//
//  Created by phuong phan on 20/05/2023.
//

import Foundation
import SwiftUI

struct NavViewSplit: View {
    @Binding var selectedItem: SubMenuItem?
    @Binding var currentScreen: MainScreen
    // Custom Back button
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(selectedItem?.name ?? "").foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-SemiBold", size: 22))
                Text(" / ").foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-SemiBold", size: 22))
                Text(selectedItem?.date ?? "").foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-SemiBold", size: 22))
                Spacer()
            }.padding(16)

            if currentScreen == .FlightScreen {
                FlightView()
            } else {
                HomeViewSplit()
            }
            
        }.background(Color.theme.cultured)
    }
}
