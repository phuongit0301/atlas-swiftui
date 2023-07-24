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
import SwiftData

struct MainView: View {
    @State private var columnVisibility = NavigationSplitViewVisibility.detailOnly
    @EnvironmentObject var sideMenuState: SideMenuModelState
    @EnvironmentObject var modelState: TabModelState
    
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
//            NavigationSplitView(columnVisibility: $columnVisibility) {
//                Sidebar()
//            } detail: {
//                NavigationStack {
//                    HomeViewSplit()
//                    BottomTabs()
//                }
//            }.navigationSplitViewStyle(.balanced)
//                .accentColor(Color.theme.tuftsBlue)
            NavigationStack {
                HomeViewSplit()
                BottomTabs()
            }
        } else {
            NavigationView {
                Sidebar()
                HomeView()
            }.accentColor(Color.theme.tuftsBlue)
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
    @EnvironmentObject var coreDataModel: CoreDataModelState
    
    // fuel page swift data initialise
    @Environment(\.modelContext) private var context
    @Query var fuelPageData: [FuelPageData]
    @State var loading = false
    
    var body: some View {
        VStack(spacing: 0) {
            if loading || coreDataModel.loading {
                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.black)).controlSize(.large)
            } else {
                MainView()
            }
        }.onAppear {
            Task {
                // check if fuel page swift data has data
                if fuelPageData.first?.projDelays == nil {
                    loading = true
                    // add fuel page data to swift data
                    // fetch api response
                    @ObservedObject var globalResponse = GlobalResponse.shared
                    @ObservedObject var apiManager = APIManager.shared
                    await apiManager.makePostRequest()
                    let allAPIresponse: processedFuelDataModel = convertAllresponseFromAPI(jsonString: globalResponse.response)
                    // map response to FuelPageData model class
                    let fetchedFuelPageData = FuelPageData(projDelays: allAPIresponse.projDelays!, historicalDelays: allAPIresponse.historicalDelays!, taxi: allAPIresponse.taxi!, trackMiles: allAPIresponse.trackMiles!, enrWX: allAPIresponse.enrWX!, flightLevel: allAPIresponse.flightLevel!, reciprocalRwy: allAPIresponse.reciprocalRwy!)
                    // insert into context and save
                    context.insert(fetchedFuelPageData)
                    try? context.save()
                    loading = false
                }
            }
        }
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
