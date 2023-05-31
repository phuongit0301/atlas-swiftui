//
//  ATLASApp.swift
//  ATLAS
//
//  Created by phuong phan on 15/05/2023.
//

import SwiftUI

//@main
struct ATLASApp1: App {
    @ObservedObject var apiManager = APIManager.shared

    var body: some Scene {
        WindowGroup {
            // charts view
            ChartsContentView()
            // simulate run charts api on app launch
                .onAppear {
                Task {
                    await apiManager.makePostRequest()
                }
            }
        }
    }
}
