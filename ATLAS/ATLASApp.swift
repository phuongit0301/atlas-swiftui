//
//  ATLASApp.swift
//  ATLAS
//
//  Created by phuong phan on 15/05/2023.
//

import SwiftUI
import FirebaseCore

class FBAppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct ATLASApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(FBAppDelegate.self) var delegate
    @AppStorage("uid") var userID: String = ""
    
    let persistenceController = PersistenceController.shared
    let remoteServiceController = RemoteService.shared
    
    @ObservedObject var apiManager = APIManager.shared
    @StateObject var tabModelState = TabModelState()
    @StateObject var mainTabModelState = MainTabModelState()
    @StateObject var flightNoteModelState = FlightNoteModelState()
    @StateObject var searchModelSplitState = SearchModelSplitState()
    @StateObject var fpModelSplitState = FPModelSplitState()
    @StateObject var coreDataModel = CoreDataModelState()
    @StateObject var viewModelSummary = ViewModelSummary()
    @StateObject var flightPlanDetailModel = FlightPlanDetailModel()
    @StateObject var refModel = ScreenReferenceModel()
    @StateObject var aiSearchModel = AISearchModelState()
    @StateObject var locationViewModel = LocationViewModel()
    @StateObject var calendarModel = CalendarModel()
    @StateObject var mapIconModel = MapIconModel()

    var network = Network()
    var sideMenuModelState = SideMenuModelState()
    
    var body: some Scene {
        WindowGroup {
            VStack {
                if coreDataModel.loading || coreDataModel.loadingInit {
                    ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.black)).controlSize(.large)
                } else {
                    if userID != "" {
                        ContentView()
                    } else {
//                        LoginView()
                        OnboardingView()
                    }
                }
            }.onAppear {
                if locationViewModel.authorizationStatus == .notDetermined {
                    locationViewModel.requestPermission()
                }
            }
            .onAppWentToBackground {
                if !coreDataModel.loading && !coreDataModel.loadingInit {
                    coreDataModel.updateFlightPlan()
                }
            }
            .environmentObject(network)
                .environmentObject(tabModelState)
                .environmentObject(sideMenuModelState)
                .environmentObject(mainTabModelState)
                .environmentObject(flightNoteModelState)
                .environmentObject(searchModelSplitState)
                .environmentObject(flightPlanDetailModel)
                .environmentObject(viewModelSummary)
                .environmentObject(fpModelSplitState)
                .environmentObject(coreDataModel)
                .environmentObject(persistenceController)
                .environmentObject(remoteServiceController)
                .environmentObject(refModel)
                .environmentObject(aiSearchModel)
                .environmentObject(calendarModel)
                .environmentObject(mapIconModel)
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
                    coreDataModel.loading = true
                    await coreDataModel.initFetchData()
                    coreDataModel.loading = false
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
