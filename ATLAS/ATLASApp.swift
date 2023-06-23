//
//  ATLASApp.swift
//  ATLAS
//
//  Created by phuong phan on 15/05/2023.
//

import SwiftUI

@main
struct ATLASApp: App {
    @UIApplicationDelegateAdaptor var appDelegate: AppDelegate
    @ObservedObject var apiManager = APIManager.shared
    @StateObject var tabModelState = TabModelState()
    @StateObject var mainNavModelState = MainNavModelState()
    @StateObject var flightNoteModelState = FlightNoteModelState()
    @StateObject var searchModelSplitState = SearchModelSplitState()
    @StateObject var fpModelSplitState = FPModelSplitState()
    @StateObject var nav = NavigationStateManager()
    
    var network = Network()
    var sideMenuModelState = SideMenuModelState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(network)
                .environmentObject(tabModelState)
                .environmentObject(sideMenuModelState)
                .environmentObject(mainNavModelState)
                .environmentObject(flightNoteModelState)
                .environmentObject(searchModelSplitState)
                .environmentObject(fpModelSplitState)
                .environmentObject(nav)
                .onAppear {
                    Task {
                        await apiManager.makePostRequest()
                    }
                }
        }.handlesExternalEvents(
            matching: ["sg.accumulus.ios.book-flight", "App-Prefs://root=NOTES"]
        )
        
//        WindowGroup {
//            ContentView()
//                .environmentObject(network)
//                .environmentObject(tabModelState)
//                .environmentObject(sideMenuModelState)
//                .environmentObject(mainNavModelState)
//                .environmentObject(flightNoteModelState)
//                .environmentObject(searchModelSplitState)
//                .onAppear {
//                    Task {
//                        await apiManager.makePostRequest()
//                    }
//                }
//        }
//        .handlesExternalEvents(
//            matching: ["sg.accumulus.ios.book-flight", "App-Prefs://root=NOTES"]
//        )
    }
}
