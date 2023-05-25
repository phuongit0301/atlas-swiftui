//
//  TabView.swift
//  ATLAS
//
//  Created by phuong phan on 20/05/2023.
//

import Foundation
import SwiftUI

struct Tab {
    var icon: Image?
    var title: String
}

struct Tabs: View {
    var fixed = true
    
    var tabs: [Tab]
    let geoWidth: CGFloat
    @Binding var selectedTab: Int
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { proxy in
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        ForEach(0 ..< tabs.count, id: \.self) { row in
                            Button(action: {
                                withAnimation {
                                    selectedTab = row
                                }
                            }, label: {
                                VStack(spacing: 0) {
                                    HStack {
                                        HStack {
                                            // Text
                                            selectedTab == row ?
                                                Text(tabs[row].title)
                                                .font(.custom("Inter-SemiBold", size: 15))
                                                    .foregroundColor(Color.theme.eerieBlack)
                                                    .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                                            :
                                                Text(tabs[row].title)
                                                .font(.custom("Inter-Regular", size: 15))
                                                    .foregroundColor(Color.theme.eerieBlack)
                                                    .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                                            // Image
                                            AnyView(tabs[row].icon)
                                                .foregroundColor(.white)
                                                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
                                        }
//                                            .padding(10)
//                                            .background(selectedTab == row ? Color.theme.aeroBlue : Color.theme.cultured)
                                    }
                                    .frame(width: fixed ? (geoWidth / CGFloat(tabs.count)) : .none, height: 50)
                                    Rectangle().frame(height: selectedTab == row ? 3 : 0)
                                    // Bar Indicator
                                    Rectangle().fill(Color.theme.eerieBlack).frame(height: 1)
                                }.fixedSize()
                            })
                            .accentColor(Color.theme.eerieBlack)
                                .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            }
        }
        .frame(height: 53)
//        .onAppear(perform: {
//////            UIScrollView.appearance().backgroundColor = Color.theme.cultured
////            UIScrollView.appearance().bounces = fixed ? false : true
//
//            UIScrollView.appearance().bounces = true
//        })
//        .onDisappear(perform: {
//            UIScrollView.appearance().bounces = true
//        })
    }
}
