//
//  CalendarSectionView.swift
//  ATLAS
//
//  Created by phuong phan on 06/09/2023.
//

import SwiftUI

struct CalendarSectionView: View {
    var body: some View {
        GeometryReader { proxy in
            HStack(spacing: 0) {
                CalendarView(calendar: Calendar(identifier: .gregorian)).frame(width: (proxy.size.width * 2 / 3))
                
                VStack {
                    Text("Event")
                }
            }
        }
    }
}
