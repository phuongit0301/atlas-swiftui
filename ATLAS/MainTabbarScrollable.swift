//
//  MainTabbarScrollable.swift
//  ATLAS
//
//  Created by phuong phan on 20/05/2023.
//

import Foundation
import SwiftUI

struct MainTabbarScrollable: View {
    var tabbarItems: [IMainTabs]
    @Namespace private var menuItemTransition
    @Binding var selectedTab: IMainTabs
 
    var body: some View {
        VStack (spacing: 0) {
            ScrollViewReader { scrollView in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(tabbarItems, id: \.self) { item in
                            if item.isShowTabbar {
                                MainTabbarItem(item: item, isActive: item.id == selectedTab.id, namespace: menuItemTransition)
                                    .onTapGesture {
                                        if !item.isDisabled {
                                            selectedTab = item
                                        }
                                    }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(4)
                .background(Color.theme.sonicSilver.opacity(0.12))
                    .onChange(of: selectedTab) { newItem in
                        scrollView.scrollTo(newItem, anchor: .center)
                    }
            }.cornerRadius(5)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }.zIndex(10)
            .background(Color.theme.antiFlashWhite)
 
    }
}

struct MainTabbarItem: View {
    var item: IMainTabs
    var isActive: Bool = false
    let namespace: Namespace.ID
 
    var body: some View {
        if isActive {
            HStack {
                Text(item.name)
                    .font(.custom("Inter-SemiBold", size: 17))
                    .fontWeight(.semibold)
                    .foregroundColor(Color.white)
                    .matchedGeometryEffect(id: "highlightmenuitem", in: namespace)
                    .cornerRadius(5)
                
            }.padding(.horizontal, 22)
                .padding(.vertical, 14)
                .background(Color.theme.azure)
                .cornerRadius(5)
        } else {
            HStack {
                Text(item.name)
                    .font(.custom("Inter-Regular", size: 17))
                    .foregroundColor(item.isDisabled ? Color.theme.sonicSilver : Color.theme.azure)
                
            }.padding(.horizontal, 22)
                .padding(.vertical, 14)
                .cornerRadius(5)
        }
 
    }
}
