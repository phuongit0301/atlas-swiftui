//
//  HomeViewSplit.swift
//  ATLAS
//
//  Created by phuong phan on 20/05/2023.
//

import Foundation
import SwiftUI

struct HomeViewSplit: View {
//    @Binding var currentScreen: NavigationScreen
//    @Binding var selectedItem: SubMenuItem?
//
    var viewModel = ListFlightSplitModel()
    @EnvironmentObject var sideMenuState: SideMenuModelState
    
    var body: some View {
        VStack(spacing: 0) {
            Text(sideMenuState.selectedMenu?.name ?? "")
                .foregroundColor(Color.theme.eerieBlack)
                .font(.custom("Inter-SemiBold", size: 22))
                .padding(.bottom, 16)
            
            // flight informations
//            NavigationStack {
                List (selection: $sideMenuState.selectedMenu) {
                    ForEach(viewModel.ListItem, id: \.self) { item in
                        Section {
                            if !item.subMenuItems.isEmpty {
                                ForEach(item.subMenuItems, id: \.self) { row in
                                    NavigationLink(destination: getDestination(screen: item.screen ?? NavigationEnumeration.TableScreen, item: item, row: row)) {
                                        VStack(alignment: .leading, spacing: 0) {
                                            Text(row.name).foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-SemiBold", size: 16)).padding(.bottom, 5)
                                            
                                            if row.description != nil {
                                                Text(row.description ?? "").foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-Regular", size: 11))
                                            }
                                        }
                                    }
                                    
                                }
                            }
                        } header: {
                            Text(item.name)
                                .foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-SemiBold", size: 20))
                            
                        }
                    }
                }.listStyle(.insetGrouped)
                
//            }
            
        }
        
    }
}
