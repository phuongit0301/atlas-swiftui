//
//  FuelViewSplit.swift
//  ATLAS
//
//  Created by Muhammad Adil on 13/6/23.
//

import Foundation
import SwiftUI

struct FuelViewSplit: View {
    @ObservedObject var globalResponse = GlobalResponse.shared
    
    var body: some View {
        Group {
            if globalResponse.response != "" {
                SummaryCardViewSlideOver()
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







