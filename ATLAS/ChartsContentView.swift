//
//  ContentView.swift
//  ATLAS
//
//  Created by Muhammad Adil on 25/5/23.
//

import Foundation
import SwiftUI
import os


struct ChartsContentView: View {
    var body: some View {
        SummaryView()
    }
}

struct ChartsContentView_Previews: PreviewProvider {
    struct Preview: View {
        var body: some View {
            ChartsContentView()
        }
    }
    static var previews: some View {
        Preview()
    }
}
