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
            Image("logo")
                .frame(width: 163, height: 26)
                .scaledToFit()
                .aspectRatio(contentMode: .fit)
                .padding(20)
            
            List(selection: $sideMenuState.selectedMenu) {
                ForEach(sideMenuState.mainMenu, id: \.self) { item in
                    if !item.subMenuItems.isEmpty {
                        Section() {
                            ForEach(item.subMenuItems, id: \.self) { row in
                                SidebarItem(item: row, selectedItem: $sideMenuState.selectedMenu)
                            }
                        } header: {
                            Text(item.name)
                                .foregroundColor(Color.theme.eerieBlack).font(.system(size: 20, weight: .semibold))
                        }
                    }
                }
            }.scrollContentBackground(.hidden)
        }.background(Color.theme.cultured)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        
                    }) {
                        Image(systemName: "person.crop.circle").foregroundColor(Color.theme.azure)
                            .frame(width: 22, height: 22)
                            .scaledToFit()
                            .aspectRatio(contentMode: .fit)
                    }
                }
            }
    }
}
