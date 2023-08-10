//
//  ATLASApp.swift
//  ATLAS
//
//  Created by phuong phan on 15/05/2023.
//

import SwiftUI

@main
struct ATLASApp: App {
    let persistenceController = PersistenceController.shared
    
    @UIApplicationDelegateAdaptor var appDelegate: AppDelegate
//    @ObservedObject var apiManager = APIManager.shared
    @StateObject var tabModelState = TabModelState()
    @StateObject var mainNavModelState = MainNavModelState()
    @StateObject var flightNoteModelState = FlightNoteModelState()
    @StateObject var searchModelSplitState = SearchModelSplitState()
    @StateObject var fpModelSplitState = FPModelSplitState()
    @StateObject var coreDataModel = CoreDataModelState()
    @StateObject var viewModelSummary = ViewModelSummary()
    @StateObject var flightPlanDetailModel = FlightPlanDetailModel()
    @StateObject var refModel = ScreenReferenceModel()
    @StateObject var aiSearchModel = AISearchModelState()

    var network = Network()
    var sideMenuModelState = SideMenuModelState()
    
    var body: some Scene {
        WindowGroup {
            VStack {
                if coreDataModel.loading || coreDataModel.loadingInit {
                    ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.black)).controlSize(.large)
                } else {
                    ContentView()
                }
            }
            .onAppWentToBackground {
                coreDataModel.updateFlightPlan()
            }
            .environmentObject(network)
                .environmentObject(tabModelState)
                .environmentObject(sideMenuModelState)
                .environmentObject(mainNavModelState)
                .environmentObject(flightNoteModelState)
                .environmentObject(searchModelSplitState)
                .environmentObject(flightPlanDetailModel)
                .environmentObject(viewModelSummary)
                .environmentObject(fpModelSplitState)
                .environmentObject(coreDataModel)
                .environmentObject(persistenceController)
                .environmentObject(refModel)
                .environmentObject(aiSearchModel)
                .task {
                    coreDataModel.loading = true
//                    await coreDataModel.checkAndSyncDataNote()
//                    await coreDataModel.checkAndSyncData()
//                    await coreDataModel.checkAndSyncDataFuel()
//                    await coreDataModel.initFetchData()
//                    coreDataModel.loading = false
                    await coreDataModel.checkAndSyncDataNote()
                    await coreDataModel.checkAndSyncData()
                    coreDataModel.loading = false
                }.task {
                    await coreDataModel.initFetchData()
                }
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                
        }
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
