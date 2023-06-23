//
//  NavigationStateManager.swift
//  ATLAS
//
//  Created by phuong phan on 23/06/2023.
//

import Foundation
import SwiftUI

class NavigationStateManager: ObservableObject {
    
    @Published var selectionPath = NavigationPath()

    func popToRoot() {
        selectionPath = NavigationPath()
    }
}
