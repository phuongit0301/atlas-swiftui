//
//  CustomSegment.swift
//  ATLAS
//
//  Created by phuong phan on 19/06/2023.
//

import Foundation
import SwiftUI

struct FlightPlanSegmented: View {
    @Binding var preselected: FlightPlanEnumeration
    var options: [Tab]
    let geoWidth: CGFloat
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(options.indices, id:\.self) { index in
                Text(options[index].title).font(.system(size: 17, weight:
                        .regular)).foregroundColor(preselected == options[index].screenName ? Color.theme.azure : Color.theme.spanishGray)
                    .onTapGesture {
                        withAnimation(.interactiveSpring()) {
                            preselected = options[index].screenName
                        }
                    }.frame(width: geoWidth / CGFloat(options.count))
            }
        }
        .frame(height: 65)
        .background(.white)
    }
}
