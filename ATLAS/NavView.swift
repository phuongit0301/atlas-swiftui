//
//  NavView.swift
//  ATLAS
//
//  Created by phuong phan on 20/05/2023.
//

import Foundation
import SwiftUI

struct NavView: View {
    @EnvironmentObject var sideMenuState: SideMenuModelState
    
    // Custom Back button
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(sideMenuState.selectedMenu?.name ?? "").foregroundColor(Color.theme.eerieBlack).padding(.trailing, 10).font(.custom("Inter-SemiBold", size: 34))
                VStack {
                    Text(sideMenuState.selectedMenu?.flight ?? "").foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-SemiBold", size: 15))
                    Text(sideMenuState.selectedMenu?.date ?? "").foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-SemiBold", size: 15))
                }
                Spacer()
            }.padding(16)

            HomeView()
        }.background(Color.theme.cultured)
        .toolbar {
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
                Button(action: {
                    
                }) {
                    Image("icon_arrow_right")
                        .frame(width: 41, height: 72)
                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                }
            }
        }
    }
}
