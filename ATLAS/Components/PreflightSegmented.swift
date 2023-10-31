//
//  PreflightSegmented.swift
//  ATLAS
//
//  Created by phuong phan on 26/09/2023.
//

import Foundation
import SwiftUI

struct PreflightSegmented: View {
    @Binding var preselected: PreflightTabEnumeration
    var options: [PreflightTab]
    let geoWidth: CGFloat
    
    var body: some View {
        VStack(spacing: 0) {
            Divider().frame(height: 0.5).overlay(Color.theme.spanishGray)
            
            HStack(spacing: 0) {
                ForEach(options.indices, id:\.self) { index in
                    if options[index].disabled {
                        Text(options[index].title).font(.system(size: 17, weight:
                                .regular)).foregroundColor(preselected == options[index].screenName ? Color.theme.azure : Color.theme.spanishGray)
                            .frame(width: geoWidth / CGFloat(options.count))
                    } else {
                        Text(options[index].title).font(.system(size: 17, weight:
                                .regular)).foregroundColor(preselected == options[index].screenName ? Color.theme.azure : Color.theme.spanishGray)
                            .onTapGesture {
                                withAnimation(.interactiveSpring()) {
                                    preselected = options[index].screenName
                                }
                            }.frame(width: geoWidth / CGFloat(options.count))
                    }
                }
            }.frame(height: 65)
        }.frame(height: 65)
            .background(.white)
    }
}
