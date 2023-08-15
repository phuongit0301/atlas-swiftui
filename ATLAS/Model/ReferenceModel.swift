//
//  TabModel.swift
//  ATLAS
//
//  Created by phuong phan on 01/06/2023.
//

import Foundation
import SwiftUI

class AISearchModelState: ObservableObject {
    @Published var currentIndex = -1
}

enum SummaryDataDropDown: String, CaseIterable, Identifiable {
    case pic = "PIC"
    case p1 = "P1"
    case picus = "PIC(u/s)"
    case p1us = "P1(u/s)"
    case p2 = "P2"
    var id: Self { self }
}
