//
//  ATLASApp.swift
//  ATLAS
//
//  Created by phuong phan on 15/05/2023.
//

import SwiftUI

@main
struct ATLASApp: App {
    @ObservedObject var apiManager = APIManager.shared
    var network = Network()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(network)
                .onAppear {
                    Task {
                        await apiManager.makePostRequest()
                    }
                }
        }
    }
}
