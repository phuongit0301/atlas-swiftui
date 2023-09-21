//
//  RecencyModel.swift
//  ATLAS
//
//  Created by phuong phan on 19/05/2023.
//

import Foundation
import SwiftUI

class RecencySection: ObservableObject {
    @Published var dataItemDropDown: [String] = ["Item 1", "Item 2", "Item 3"]
    
    @Published var dataExpiringDropDown: [String] = ["Expiring 9 month", "Expiring 6 month", "Expiring 3 month"]
    
    @Published var dataRecencyDropDown: [String] = ["Type 1", "Type 2", "Type 3"]
    
    @Published var dataExpirySoonDropDown: [String] = ["Soon 1", "Soon 2", "Soon 3"]
}
