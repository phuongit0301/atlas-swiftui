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
    @Binding var selectedItem: SubMenuItem?
    
    var viewModel = ListFlightSplitModel()
    @State private var currentScreen = NavigationScreen.flight
    
    var body: some View {
        VStack(spacing: 0) {
            // flight informations
            List (selection: $selectedItem) {
                ForEach(viewModel.ListItem, id: \.self) { item in
                    Section {
                        if !item.subMenuItems.isEmpty {
                            ForEach(item.subMenuItems, id: \.self) { row in
                                NavigationLink(destination: getDestination(screen: item.screen ?? NavigationEnumeration.tableDetail, item: item, row: row)) {
                                    VStack(alignment: .leading, spacing: 0) {
                                        Text(row.name).foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-SemiBold", size: 16)).padding(.bottom, 5)
                                        
                                        if row.description != nil {
                                            Text(row.description ?? "").foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-Regular", size: 11))
                                        }
                                    }
                                }
                                    
                            }.onChange(of: selectedItem) { _ in
                                self.currentScreen = NavigationScreen.home
                            }
                        }
                    } header: {
                        Text(item.name)
                            .foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-SemiBold", size: 20))
                        
                    }
                }
            }.listStyle(.insetGrouped)
            
        }
        
    }
    
    func getDestination(screen: NavigationEnumeration, item: ListFlightSplitItem, row: ListFlightSplitItem) -> AnyView {
        if screen == NavigationEnumeration.tableDetail {
            return AnyView(TableDetailSplit(row: row))
        } else {
            if row.screen == NavigationEnumeration.noteDetail {
                return AnyView(NoteDetailSplit())
            }
            
            if row.screen == NavigationEnumeration.airCraftDetail {
                return AnyView(AircraftSplit())
            }
            
            if row.screen == NavigationEnumeration.departureDetail {
                return AnyView(DepartureSplit())
            }
            
            if row.screen == NavigationEnumeration.enrouteDetail {
                return AnyView(EnrouteSplit())
            }
            
            if row.screen == NavigationEnumeration.arrivalDetail {
                return AnyView(ArrivalSplit())
            }
            
            if row.screen == NavigationEnumeration.atlasSearchDetail {
                return AnyView(AtlasSearchSplit())
            }
            
            return AnyView(NoteDetailSplit())
        }
    }
}
