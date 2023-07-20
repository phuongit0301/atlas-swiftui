//
//  CustomSegment.swift
//  ATLAS
//
//  Created by phuong phan on 19/06/2023.
//

import Foundation
import SwiftUI

struct FuelSegmented: View {
    @EnvironmentObject var flightPlanDetailModel: FlightPlanDetailModel
    @Binding var preselected: Int
    var options: [FuelTab]
    let geoWidth: CGFloat
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(options.indices, id:\.self) { index in
                if flightPlanDetailModel.isModal {
                    Text(options[index].title.components(separatedBy: " ").joined(separator: "\n")).font(.system(size: 17, weight:
                            .regular)).foregroundColor(preselected == index ? Color.theme.azure : Color.theme.spanishGray)
                        .multilineTextAlignment(.center)
                        .onTapGesture {
                            withAnimation(.interactiveSpring()) {
                                preselected = index
                            }
                        }.frame(width: geoWidth / CGFloat(options.count))
                } else {
                    Text(options[index].title).font(.system(size: 17, weight:
                            .regular)).foregroundColor(preselected == index ? Color.theme.azure : Color.theme.spanishGray)
                        .onTapGesture {
                            withAnimation(.interactiveSpring()) {
                                preselected = index
                            }
                        }.frame(width: geoWidth / CGFloat(options.count))
                }
            }
        }
        .frame(height: 65)
        .background(.white)
    }
}
