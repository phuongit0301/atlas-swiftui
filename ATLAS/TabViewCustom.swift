//
//  TabViewCustom.swift
//  ATLAS
//
//  Created by phuong phan on 20/05/2023.
//

import Foundation
import SwiftUI

//struct Tab {
//    var icon: Image?
//    var title: String
//}

struct TabViewCustom: View {
    var tabbarItems: [String]
    @Namespace private var menuItemTransition
    let geoWidth: CGFloat
    @Binding var selectedIndex: Int
 
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
//            Rectangle().fill(Color.theme.spanishGray).frame(width: geoWidth, height: 1)
            
            HStack {
                ForEach(tabbarItems.indices, id: \.self) { index in
                    VStack {
                        TabbarItemCustom(name: tabbarItems[index], isActive: selectedIndex == index, namespace: menuItemTransition)
                            .frame(width: geoWidth / CGFloat(tabbarItems.count))
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    selectedIndex = index
                                }
                            }
                    }
                }
            }
        }.frame(maxWidth: .infinity).background(.white)
    }
}

struct TabbarItemCustom: View {
    var name: String
    var isActive: Bool = false
    let namespace: Namespace.ID
 
    var body: some View {
        if isActive {
            Text(name)
                .font(.system(size: 17, weight: .medium))
                .padding()
                .foregroundColor(Color.theme.azure)
        } else {
            Text(name)
                .font(.system(size: 17, weight: .medium))
                .padding()
                .foregroundColor(Color.theme.spanishGray)
        }
 
    }
}
