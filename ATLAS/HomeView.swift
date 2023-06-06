//
//  HomeView.swift
//  ATLAS
//
//  Created by phuong phan on 20/05/2023.
//

import Foundation
import SwiftUI

struct HomeView: View {
    var viewInformationModel = ListFlightInformationModel()
    @State private var currentScreen = MainScreen.FlightScreen
    @EnvironmentObject var modelState: TabModelState
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
            
            
            VStack(spacing: 0) {
                // header list icons
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 0) {
                        ForEach($modelState.tabs) { $item in
                            NavigationLink(destination: FlightView(currentTab: $item)) {
                                if item.isShowTabbar {
                                    VStack(spacing: 0) {
                                        VStack(alignment: .center) {
                                            Image(systemName: item.iconName)
                                                .foregroundColor(Color.theme.eerieBlack)
                                                .frame(width: 32, height: 34)
                                                .scaledToFit()
                                                .aspectRatio(contentMode: .fit)
                                        }.frame(width: 60, height: 60, alignment: .center).padding().background(Color.theme.aeroBlue).cornerRadius(12)
                                        
                                        Text(item.name).foregroundColor(Color.theme.eerieBlack).padding(.vertical, 5).font(.custom("Inter-Regular", size: 13))
                                        
                                        if item.isExternal {
                                            Image(systemName: "pip.exit")
                                                .frame(width: 22, height: 17)
                                                .scaledToFit()
                                                .aspectRatio(contentMode: .fit)
                                                .padding(.trailing, 10)
                                        }
                                    }
                                }
                            }.navigationBarBackButtonHidden(true)
                        }.padding()
                    }
                }
                
                // flight informations
                List {
                    HStack {
                        Text("Flight Information").foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-SemiBold", size: 20))
                        Rectangle().fill(.white).frame(width: 32)
                        Text("Last updated: 28 May 2023, 22:30 (UTC+8)").foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-Regular", size: 11))
                        Spacer()
                        Button(action: {
                            print("Three dot clicked!!")
                        }) {
                            Image("icon_ellipsis_circle")
                                .frame(width: 24, height: 24)
                                .scaledToFit()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                    ForEach(viewInformationModel.ListItem, id: \.self) { item in
                        Button(action: {
                            print("Clicked 11!")
                        }) {
                            HStack {
                                Text(item.name).foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-SemiBold", size: 16))
                                Spacer()
                                Text(item.date).foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-Regular", size: 16))
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color.theme.cultured)
                .listStyle(.insetGrouped)
                .navigationBarTitleDisplayMode(.inline)
            }
            
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
