//
//  ContentView.swift
//  ATLAS
//
//  Created by phuong phan on 15/05/2023.
//

import SwiftUI
import SimilaritySearchKit
import SimilaritySearchKitDistilbert
import UIKit
import MobileCoreServices
import PDFKit
import QuickLookThumbnailing
import Foundation
import CoreML

struct MainView: View {
    @State private var documentText: String = ""
    @State private var fileName: String = ""
    @State private var fileIcon: UIImage? = nil
    @State private var totalCharacters: Int = 0
    @State private var totalTokens: Int = 0
    @State private var progress: Double = 0
    @State private var chunks: [String] = []
    @State private var embeddings: [[Float]] = []
    @State private var searchText: String = ""
    @State private var searchResults: [String] = []
    @State private var isLoading: Bool = false
    @State private var selectedCategoryId: MenuItem.ID?
    @State private var currentScreen = NavigationScreen.home
    private var viewModel = SideMenuModel()
    
    @State private var similarityIndex: SimilarityIndex?
    @State private var columnVisibility = NavigationSplitViewVisibility.doubleColumn
    @State var selectedItem: SubMenuItem? = nil
    
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
//
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
                
                List(viewModel.SideMenu, selection: $selectedItem) { item in
                    if !item.subMenuItems.isEmpty {
                        Section() {
                            ForEach(item.subMenuItems, id: \.self) { row in
                                RowSelection(item: row, selectedItem: self.$selectedItem)
                            }.onChange(of: selectedItem) { _ in
                                self.currentScreen = NavigationScreen.home
                            }
                        } header: {
                            Text(item.name)
                                .foregroundColor(Color.theme.eerieBlack).font(Font.custom("Inter-Medium", size: 17))
                        }
                    }
                    
                }.scrollContentBackground(.hidden)
            }.background(Color.theme.cultured)
        } detail: {
            if verticalSizeClass == .regular && horizontalSizeClass == .compact {
                ContentDetailSplit(selectedItem: self.$selectedItem, currentScreen: self.$currentScreen)
            } else {
                ContentDetail(selectedItem: self.$selectedItem, currentScreen: self.$currentScreen)
            }
        }.navigationSplitViewStyle(.balanced)
         .onAppear() {
             if self.selectedItem == nil {
                 self.selectedItem = viewModel.SideMenu.first?.subMenuItems.first;
             }
            columnVisibility = .all
        }.accentColor(Color.theme.tuftsBlue)
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
    
    struct ContentDetail: View {
        @Binding var selectedItem: SubMenuItem?
        @Binding var currentScreen: NavigationScreen
        
        var body: some View {
            NavigationStack {
                VStack(spacing: 0) {
                    NavView(selectedItem: self.$selectedItem, currentScreen: self.$currentScreen)
                }
            }
        }
    }
    
    struct ContentDetailSplit: View {
        @Binding var selectedItem: SubMenuItem?
        @Binding var currentScreen: NavigationScreen
        
        var body: some View {
            NavigationStack {
                VStack(spacing: 0) {
                    NavViewSplit(selectedItem: self.$selectedItem, currentScreen: self.$currentScreen)
                }
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
        if verticalSizeClass == .regular && horizontalSizeClass == .compact {
            MainView()
            BottomTabs()
        } else {
            MainView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Network())
    }
}
