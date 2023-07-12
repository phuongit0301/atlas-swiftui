//
//  ATLASApp.swift
//  ATLAS
//
//  Created by phuong phan on 15/05/2023.
//

import SwiftUI
import SwiftData

@main
struct ATLASApp: App {
    let persistenceController = PersistenceController.shared
    
    @UIApplicationDelegateAdaptor var appDelegate: AppDelegate
    @ObservedObject var apiManager = APIManager.shared
    @StateObject var tabModelState = TabModelState()
    @StateObject var mainNavModelState = MainNavModelState()
    @StateObject var flightNoteModelState = FlightNoteModelState()
    @StateObject var searchModelSplitState = SearchModelSplitState()
    @StateObject var fpModelSplitState = FPModelSplitState()
    @StateObject var coreDataModel = CoreDataModelState()

    var network = Network()
    var sideMenuModelState = SideMenuModelState()
    
    var body: some Scene {
        WindowGroup {
            VStack {
                if coreDataModel.loading {
                    ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.black)).controlSize(.large)
                } else {
                    ContentView()
                }
            }
            .environmentObject(network)
                .environmentObject(tabModelState)
                .environmentObject(sideMenuModelState)
                .environmentObject(mainNavModelState)
                .environmentObject(flightNoteModelState)
                .environmentObject(searchModelSplitState)
                .environmentObject(fpModelSplitState)
                .environmentObject(coreDataModel)
                .environmentObject(persistenceController)
                .onAppear {
                    Task {
                        coreDataModel.loading = true
                        //await apiManager.makePostRequest()
                        await coreDataModel.checkAndSyncData()
                        await coreDataModel.initFetchData()
                        coreDataModel.loading = false
                    }
                }
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                
        }
        .modelContainer(for: FuelPageData.self)
        .handlesExternalEvents(
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
