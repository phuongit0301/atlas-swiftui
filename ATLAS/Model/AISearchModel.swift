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

struct AISearchTab {
    var icon: Image?
    var title: String
    var screenName: AISearchEnumeration
}
