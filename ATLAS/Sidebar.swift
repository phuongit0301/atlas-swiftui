//
//  Sidebar.swift
//  ATLAS
//
//  Created by phuong phan on 16/06/2023.
//

import Foundation
import SwiftUI

struct Sidebar: View {
    @EnvironmentObject var sideMenuState: SideMenuModelState
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            
            Image("logo")
                .frame(width: 163, height: 26)
                .scaledToFit()
                .aspectRatio(contentMode: .fit)
                .padding(20)
            
            HStack {
                Image("icon_profile")
                    .frame(width: 40, height: 40)
                    .scaledToFit()
                    .aspectRatio(contentMode: .fit)
                    .padding(20)
                
            }.frame(maxWidth: .infinity, alignment: .leading)
                .background(.white)
                .cornerRadius(8)
                .padding(15)
            
            List(selection: $sideMenuState.selectedMenu) {
                ForEach(sideMenuState.mainMenu, id: \.self) { item in
                    if !item.subMenuItems.isEmpty {
                        Section() {
                            ForEach(item.subMenuItems, id: \.self) { row in
                                SidebarItem(item: row, selectedItem: $sideMenuState.selectedMenu)
                            }
                        } header: {
                            Text(item.name)
                                .foregroundColor(Color.theme.eerieBlack).font(Font.custom("Inter-Medium", size: 17))
                        }
                    }
                }
            }.scrollContentBackground(.hidden)
        }.background(Color.theme.cultured)
    }
}
