//
//  ContentView.swift
//  ATLAS
//
//  Created by phuong phan on 15/05/2023.
//

import SwiftUI
import UIKit
import MobileCoreServices
import PDFKit
import QuickLookThumbnailing
import Foundation
import CoreML
import os

struct MainView: View {
    @State private var columnVisibility = NavigationSplitViewVisibility.doubleColumn
    @EnvironmentObject var sideMenuState: SideMenuModelState
    
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
//    init() {
//        for family: String in UIFont.familyNames
//            {
//                print(family)
//                for names: String in UIFont.fontNames(forFamilyName: family)
//                {
//                    print("== \(names)")
//                }
//            }
//    }
    
    //app view wrapper
    var body: some View {
        if verticalSizeClass == .regular && horizontalSizeClass == .compact {
            NavigationSplitView(columnVisibility: $columnVisibility) {
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
                                        RowSelection(item: row, selectedItem: $sideMenuState.selectedMenu)
                                    }
                                } header: {
                                    Text(item.name)
                                        .foregroundColor(Color.theme.eerieBlack).font(Font.custom("Inter-Medium", size: 17))
                                }
                            }
                        }
                    }.scrollContentBackground(.hidden)
                }.background(Color.theme.cultured)
            } detail: {
                NavigationStack {
                    VStack(spacing: 0) {
                        HomeViewSplit()
                        BottomTabs()
                    }
                }
            }.navigationSplitViewStyle(.balanced)
                .onAppear() {
                    columnVisibility = .all
                }.accentColor(Color.theme.tuftsBlue)
        } else {
            
            NavigationSplitView(columnVisibility: $columnVisibility) {
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
                                        RowSelection(item: row, selectedItem: $sideMenuState.selectedMenu)
                                    }
                                } header: {
                                    Text(item.name)
                                        .foregroundColor(Color.theme.eerieBlack).font(Font.custom("Inter-Medium", size: 17))
                                }
                            }
                        }
                    }.scrollContentBackground(.hidden)
                }.background(Color.theme.cultured)
            } detail: {
                NavigationStack {
                    VStack(spacing: 0) {
                        HomeView()
                    }
                }
            }.navigationSplitViewStyle(.balanced)
                .onAppear() {
                    columnVisibility = .all
                }.accentColor(Color.theme.tuftsBlue)
        }
    }
    
    struct RowSelection: View {

        let item: SubMenuItem
        @Binding var selectedItem: SubMenuItem?

        var body: some View {
            NavigationLink(value: selectedItem) {
                HStack {
                    if item == selectedItem {
                        Text(item.name).foregroundColor(.white).font(.custom("Inter-SemiBold", size: 16))
                        Spacer()
                        Text(item.date ?? "").foregroundColor(.white).font(.custom("Inter-SemiBold", size: 16))
                    } else {
                        Text(item.name).background(Color.clear).font(.custom("Inter-Regular", size: 16))
                        Spacer()
                        Text(item.date ?? "").background(Color.clear).font(.custom("Inter-Regular", size: 16))
                    }
                }.padding(.horizontal, 15)
            }
        }
    }
}

func toggleSidebar() {
    #if os(iOS)
    #else
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    #endif
}

struct ContentView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    var body: some View {
        MainView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Network())
            .environmentObject(SideMenuModelState())
            .environmentObject(TabModelState())
    }
}
