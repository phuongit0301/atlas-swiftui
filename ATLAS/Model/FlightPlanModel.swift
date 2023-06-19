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
