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
        ScrollViewReader { scrollView in
            ScrollView(.horizontal, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        ForEach(tabbarItems.indices, id: \.self) { index in
                            VStack(alignment: .leading, spacing: 0) {
                                TabbarItemCustom(name: tabbarItems[index], isActive: selectedIndex == index, namespace: menuItemTransition)
                                    .frame(width: geoWidth / CGFloat(tabbarItems.count))
                                    .onTapGesture {
                                        withAnimation(.easeInOut) {
                                            selectedIndex = index
                                        }
                                    }
                                Rectangle().fill(Color.theme.eerieBlack).frame(height: selectedIndex == index ? 3 : 0)
                            }
                        }
                    }
                    
                    Rectangle().fill(Color.theme.eerieBlack).frame(width: geoWidth, height: 1)
                }
            }
            .frame(maxWidth: .infinity)
            .onChange(of: selectedIndex) { index in
                withAnimation {
                    scrollView.scrollTo(index, anchor: .center)
                }
            }
        }
 
    }
}

struct TabbarItemCustom: View {
    var name: String
    var isActive: Bool = false
    let namespace: Namespace.ID
 
    var body: some View {
        if isActive {
            Text(name)
                .font(.custom("Inter-SemiBold", size: 13))
                .fontWeight(.semibold)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .foregroundColor(Color.theme.eerieBlack)
                .matchedGeometryEffect(id: "highlightmenuitem", in: namespace)
        } else {
            Text(name)
                .font(.custom("Inter-Regular", size: 13))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .foregroundColor(Color.theme.eerieBlack)
        }
 
    }
}
