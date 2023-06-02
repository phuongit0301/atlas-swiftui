//
//  File.swift
//  ATLAS
//
//  Created by phuong phan on 28/05/2023.
//

import Foundation
import SwiftUI

struct BottomTabs: View {
    private var viewModel = BottomMenuModel()
    @State private var currentScreen = MainScreen.HomeScreen
    @State var selectedItem: BottomMenuItem? = nil
    
    var body: some View {
        // header list icons
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 0) {
                ForEach(viewModel.BottomMenu, id: \.self) { item in
//                    NavigationLink(destination: NavViewSplit(selectedItem: self.$selectedItem, currentScreen: self.$currentScreen)) {
                        VStack(spacing: 0) {
                            VStack(alignment: .center) {
                                Image(systemName: item.name)
                                    .frame(width: 16, height: 16)
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fit)
                            }.frame(width: 32, height: 32, alignment: .center).padding().background(Color.theme.aeroBlue).cornerRadius(12)
                        }
//                    }.navigationBarBackButtonHidden(true)
                }.padding(12)
            }
        }
    }
}
