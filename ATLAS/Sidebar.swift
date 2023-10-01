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
            HStack(alignment: .center, spacing: 0) {
                VStack(spacing: 0) {
                    Text("Captain Muhammad Adil").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.black)
                    Text("Accumulus Airlines").font(.system(size: 15, weight: .regular)).foregroundColor(Color.black)
                }.padding(.vertical, 8)
                    .padding(.horizontal, 14)
                    .background(Color.theme.tealDeer.opacity(0.25))
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.theme.electricBlue, lineWidth: 2))
            }.padding(.top)
                .frame(maxWidth: .infinity)
            
            
            List(selection: $sideMenuState.selectedMenu) {
                ForEach(sideMenuState.mainMenu, id: \.self) { item in
                    Group {
                        if !item.subMenuItems.isEmpty {
                            Section(header:
                                Text(item.name)
                                    .foregroundColor(Color.theme.eerieBlack).font(.system(size: 17, weight: .semibold))
                            ) {
                                ForEach(item.subMenuItems, id: \.self) { row in
                                    SidebarItem(item: row, selectedItem: $sideMenuState.selectedMenu)
                                }
                            }
                        } else {
                            Section(header:
                                Text(item.name)
                                    .foregroundColor(Color.theme.sonicSilver).font(.system(size: 17, weight: .semibold))
                            ) {
                                EmptyView()
                            }.listStyle(.insetGrouped)
                        }
                    }
                }
            }.scrollContentBackground(.hidden)
        }.background(Color.theme.cultured)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // todo
                    }) {
                        Image(systemName: "gear").foregroundColor(Color.theme.azure)
                            .font(.system(
                                size: 22))
                    }
                }
                ToolbarItem(placement: .principal) {
                    Image("logo")
                        .frame(width: 100, height: 32)
                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                        .padding(20)
                }
            }
    }
}
