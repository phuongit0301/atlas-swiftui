//
//  FlightPlanModel.swift
//  ATLAS
//
//  Created by phuong phan on 17/06/2023.
//

import Foundation
import SwiftUI

enum AISearchEnumeration {
    case AISearchView
    case PreviousSearchView
}

let IAISearchTabs = [
    AISearchTab(title: "Search", screenName: AISearchEnumeration.AISearchView),
    AISearchTab(title: "Previous Searches", screenName: AISearchEnumeration.PreviousSearchView),
]

struct AISearchTab {
    var icon: Image?
    var title: String
    var screenName: AISearchEnumeration
}
