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

func toggleSidebar() {
    #if os(iOS)
    #else
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    #endif
}

struct ContentView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    @State private var columnVisibility = NavigationSplitViewVisibility.detailOnly
    @EnvironmentObject var coreDataModel: CoreDataModelState
    
    @State var loading = false
    
    var body: some View {
        VStack(spacing: 0) {
            if loading || coreDataModel.loading {
                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.black)).controlSize(.large)
            } else {
                if verticalSizeClass == .regular && horizontalSizeClass == .compact {
                    NavigationStack {
                        HomeViewSplit()
                        BottomTabs()
                    }
                } else {
                    NavigationSplitView(columnVisibility: $columnVisibility) {
                        Sidebar()
                    } detail: {
                        if coreDataModel.isEventActive {
                            HomeFlightSectionView()
                        } else {
                            MainView()
                        }
                    }.accentColor(Color.theme.tuftsBlue)
                        
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
