//
//  TabbarView.swift
//  ATLAS
//
//  Created by phuong phan on 20/05/2023.
//

import Foundation
import SwiftUI

struct TabbarScrollable: View {
    var tabbarItems: [ITabs]
    @Namespace private var menuItemTransition
    @Binding var selectedTab: ITabs
 
    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(tabbarItems, id: \.self) { item in
                        if item.isShowTabbar {
                            TabbarItem(item: item, isActive: item.id == selectedTab.id, namespace: menuItemTransition)
                                .onTapGesture {
                                    withAnimation(.easeInOut) {
                                        if (item.isExternal) {
                                            if let url = URL(string: item.scheme) {
                                                if UIApplication.shared.canOpenURL(url) {
                                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                                }
                                            }
                                        } else {
                                            selectedTab = item
                                        }
                                    }
                                }
                        }
                    }
                }
            }
            .padding()
            .background(Color.theme.antiFlashWhite)
            .onChange(of: selectedTab) { newItem in
                withAnimation {
                    scrollView.scrollTo(newItem, anchor: .center)
                }
            }
        }
 
    }
}

struct TabbarItem: View {
    var item: ITabs
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
                
                if item.isExternal {
                    Image(systemName: "pip.exit")
                        .foregroundColor(Color.theme.azure)
                        .frame(width: 14, height: 16)
                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                }
            }.padding(.horizontal, 22)
                .padding(.vertical, 14)
                .background(Color.theme.azure)
                .cornerRadius(5)
        } else {
            HStack {
                Text(item.name)
                    .font(.custom("Inter-Regular", size: 17))
                    .foregroundColor(Color.theme.azure)
                
                if item.isExternal {
                    Image(systemName: "pip.exit")
                        .foregroundColor(Color.theme.azure)
                        .frame(width: 14, height: 16)
                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                }
            }.padding(.horizontal, 22)
                .padding(.vertical, 14)
                .cornerRadius(5)
        }
 
    }
}
