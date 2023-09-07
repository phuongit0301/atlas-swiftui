//
//  HomeSectionView.swift
//  ATLAS
//
//  Created by phuong phan on 06/09/2023.
//

import SwiftUI

struct HomeSectionView: View {
    var body: some View {
        GeometryReader { proxy in
            HStack(spacing: 0) {
                CalendarView(calendar: Calendar(identifier: .gregorian)).frame(width: (proxy.size.width / 3) + 32)
                
                HomeInformationView()
            }.padding(.horizontal)
                .padding(.bottom)
        }
    }
}

struct HomeSectionView_Previews: PreviewProvider {
    static var previews: some View {
        HomeSectionView()
    }
}
