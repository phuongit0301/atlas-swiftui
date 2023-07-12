//
//  FuelView.swift
//  ATLAS
//
//  Created by phuong phan on 20/05/2023.
//

import Foundation
import SwiftUI

struct FuelView: View {
    @ObservedObject var globalResponse = GlobalResponse.shared
    
    var body: some View {
        Group {
            if globalResponse.response != "" {
                ArrivalDelayView()
            } else {
                Text("Loading...")
            }
        }
        .task {
            await waitForResponse()
        }
    }
    
    func waitForResponse() async {
        while globalResponse.response == "" {
            do {
                try await Task.sleep(nanoseconds: 500000000) // Sleep for 0.5 seconds
            }
            catch {
                print("Error: \(error)")
            }
        }
    }
}






