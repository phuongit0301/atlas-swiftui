//
//  NavView.swift
//  ATLAS
//
//  Created by phuong phan on 20/05/2023.
//

import Foundation
import SwiftUI

struct NavView: View {
    @Binding var selectedItem: SubMenuItem?
    @Binding var currentScreen: NavigationScreen
    // Custom Back button
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(selectedItem?.name ?? "").foregroundColor(Color.theme.eerieBlack).padding(.trailing, 10).font(.custom("Inter-SemiBold", size: 34))
                VStack {
                    Text(selectedItem?.flight ?? "").foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-SemiBold", size: 15))
                    Text(selectedItem?.date ?? "").foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-SemiBold", size: 15))
                }
                Spacer()
            }.padding(16)
            if currentScreen == .flight {
                FlightView()
            } else {
                HomeView(selectedItem: self.$selectedItem)
            }
        }.background(Color.theme.cultured)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: toggleSidebar) {
                    Image("sidebar_left")
                        .frame(width: 26, height: 20)
                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                        .padding(.trailing, 10)
                }
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image("icon_arrow_left")
                        .frame(width: 41, height: 72)
                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                }
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {}) {
                    Image("icon_arrow_right")
                        .frame(width: 41, height: 72)
                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                }
            }
        }
    }
}
