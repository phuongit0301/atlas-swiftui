//
//  CustomSegment.swift
//  ATLAS
//
//  Created by phuong phan on 19/06/2023.
//

import Foundation
import SwiftUI

struct CustomSegmentedControl: View {
    @Binding var preselectedIndex: Int
    var options: [Tab]
    let geoWidth: CGFloat
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(options.indices, id:\.self) { index in
                Text(options[index].title).font(.system(size: 17, weight:
                        .regular)).foregroundColor(preselectedIndex == index ? Color.theme.azure : Color.theme.spanishGray)
                    .onTapGesture {
                        withAnimation(.interactiveSpring()) {
                            preselectedIndex = index
                        }
                    }.frame(width: geoWidth / CGFloat(options.count))
            }
        }
        .frame(height: 65)
    }
}
