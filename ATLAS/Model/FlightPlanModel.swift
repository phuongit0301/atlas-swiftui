//
//  FlightPlanModel.swift
//  ATLAS
//
//  Created by phuong phan on 17/06/2023.
//

import Foundation
import SwiftUI

struct Tab {
    var icon: Image?
    var title: String
}

struct IFlightPlanTabs {
    let ListItem = {
        let MainItem = [
            Tab(title: "Flight Information"),
            Tab(title: "Quick Reference")
        ]
        
        return MainItem
    }()
}

struct IFPSplitModel: Identifiable, Encodable, Decodable {
    var id = UUID()
    var name: String
    var date: String
    var isFavourite: Bool = false
}

// For Flight Plan Split
class FPModelSplitState: ObservableObject {
    
    // Flight Plan Split
    @AppStorage("fpSplitArray") private var fpSplitDataStorage: Data = Data()
    
    @Published var fpSplitArray: [IFPSplitModel] = [] {
        didSet {
            saveFPSplit()
        }
    }
    
    init() {
        loadFPSplit()
    }
    
    private func loadFPSplit() {
        guard let decodedArray = try? JSONDecoder().decode([IFPSplitModel].self, from: fpSplitDataStorage)
        else {
            fpSplitArray = [
                IFPSplitModel(name: "Scheduled Departure", date: "XX:XX", isFavourite: false),
                IFPSplitModel(name: "POB", date: "XX:XX", isFavourite: false),
            ]
            return
        }
        
        fpSplitArray = decodedArray
    }
    
    private func saveFPSplit() {
        guard let encodedArray = try? JSONEncoder().encode(fpSplitArray) else {
            return
        }
        fpSplitDataStorage = encodedArray
    }
}
