//
//  TabbarView.swift
//  ATLAS
//
//  Created by phuong phan on 20/05/2023.
//

import Foundation
import SwiftUI

struct TabbarScrollable: View {
    var tabbarItems: [String]
    @Namespace private var menuItemTransition
    @Binding var selectedIndex: Int
 
    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(tabbarItems.indices, id: \.self) { index in
                        TabbarItem(name: tabbarItems[index], isActive: selectedIndex == index, namespace: menuItemTransition)
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    selectedIndex = index
                                }
                            }
                    }
                }
            }
            .padding(.horizontal, 16)
            .onChange(of: selectedIndex) { index in
                withAnimation {
                    scrollView.scrollTo(index, anchor: .center)
                }
            }
        }
 
    }
}

struct TabbarItem: View {
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
                .background(Color.theme.aeroBlue)
                .matchedGeometryEffect(id: "highlightmenuitem", in: namespace)
                .cornerRadius(8)
        } else {
            Text(name)
                .font(.custom("Inter-Regular", size: 13))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .foregroundColor(Color.theme.eerieBlack)
        }
 
    }
}
