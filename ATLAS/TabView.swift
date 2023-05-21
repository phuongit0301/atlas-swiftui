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
    
    @Binding var tabs: [Tab]
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
                                            Text(tabs[row].title)
                                                .font(Font.system(size: 18, weight: .semibold))
                                                .foregroundColor(Color.theme.eerieBlack)
                                                .padding(EdgeInsets(top: 10, leading: 3, bottom: 10, trailing: 15))
                                            // Image
                                            AnyView(tabs[row].icon)
                                                .foregroundColor(.white)
                                                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
                                        }.padding(10)
                                            .background(selectedTab == row ? Color.theme.aeroBlue : Color.theme.cultured)
                                            .cornerRadius(8)
                                    }
                                    .frame(width: fixed ? (geoWidth / CGFloat(tabs.count)) : .none, height: 52)
                                    Rectangle().frame(height: 5)
                                    // Bar Indicator
                                    Rectangle().fill(Color.theme.eerieBlack).frame(height: 1)
                                }.fixedSize()
                            })
                            .accentColor(Color.theme.eerieBlack)
                                .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .onChange(of: selectedTab) { target in
                        withAnimation {
                            proxy.scrollTo(target)
                        }
                    }
                }
            }
        }
        .frame(height: 60)
        .onAppear(perform: {
//            UIScrollView.appearance().backgroundColor = Color.theme.cultured
            UIScrollView.appearance().bounces = fixed ? false : true
        })
        .onDisappear(perform: {
            UIScrollView.appearance().bounces = true
        })
        .background(Color.theme.cultured)
    }
}
