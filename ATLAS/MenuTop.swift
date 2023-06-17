//
//  MenuTop.swift
//  ATLAS
//
//  Created by phuong phan on 16/06/2023.
//

import Foundation
import SwiftUI

struct MenuTop: View {
    @EnvironmentObject var modelState: TabModelState
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 0) {
                ForEach($modelState.tabs) { $item in
                    VStack(alignment: .center, spacing: 0) {
                        if item.isExternal {
                            VStack(alignment: .center, spacing: 0) {
                                VStack(alignment: .center) {
                                    Image(systemName: item.iconName)
                                        .resizable()
                                        .foregroundColor(Color.theme.eerieBlack)
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30, height: 40)
                                }.frame(width: 60, height: 60, alignment: .center).padding().background(Color.theme.aeroBlue).cornerRadius(12)
                                
                                Text(item.name).foregroundColor(Color.theme.eerieBlack).padding(.vertical, 5).font(.custom("Inter-Regular", size: 13))
                                
                                Image(systemName: "pip.exit")
                                    .foregroundColor(Color.black)
                                    .frame(width: 22, height: 17)
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fit)
                            }.onTapGesture {
                                withAnimation(.easeInOut) {
                                    if let url = URL(string: item.scheme) {
                                        if UIApplication.shared.canOpenURL(url) {
                                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                        }
                                    }
                                }
                            }
                        } else {
                            NavigationLink(destination: FlightView(selectedTab: item)) {
                                VStack(alignment: .center, spacing: 0) {
                                    VStack(alignment: .center) {
                                        Image(systemName: item.iconName)
                                            .resizable()
                                            .foregroundColor(Color.theme.eerieBlack)
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 30, height: 40)
                                    }.frame(width: 60, height: 60, alignment: .center).padding().background(Color.theme.aeroBlue).cornerRadius(12)
                                    
                                    Text(item.name).foregroundColor(Color.theme.eerieBlack).padding(.vertical, 5).font(.custom("Inter-Regular", size: 13))
                                }
                            }.navigationBarBackButtonHidden(true)
                        }
                    }.padding()
                }
            }
        }
    }
}
