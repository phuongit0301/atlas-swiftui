//
//  HomeView.swift
//  ATLAS
//
//  Created by phuong phan on 20/05/2023.
//

import Foundation
import SwiftUI

struct HomeView: View {
//    @Binding var currentScreen: NavigationScreen
    @Binding var selectedItem: SubMenuItem?
    
    var viewModel = ListFlightModel()
    var viewInformationModel = ListFlightInformationModel()
    @State private var currentScreen = NavigationScreen.flight

    
    var body: some View {
        VStack(spacing: 0) {
            // header list icons
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(viewModel.ListItem, id: \.self) { item in
                        NavigationLink(destination: NavView(selectedItem: self.$selectedItem, currentScreen: self.$currentScreen)) {
                            VStack(spacing: 0) {
                                VStack(alignment: .center) {
                                    Image(item.image).frame(width: item.imageWidth, height: item.imageHeight)
                                }.frame(width: 60, height: 60, alignment: .center).padding().background(Color.theme.aeroBlue).cornerRadius(12)
                                Text(item.name).foregroundColor(Color.theme.eerieBlack).padding(.vertical, 5).font(.custom("Inter-Regular", size: 13))
                                if item.isExternal {
                                    Image("icon_external")
                                        .frame(width: 22, height: 17)
                                        .scaledToFit()
                                        .aspectRatio(contentMode: .fit)
                                        .padding(.trailing, 10)
                                }
                            }
                        }
                    }.padding()
                }
            }
            
            // flight informations
            List {
                HStack {
                    Text("Flight Information").foregroundColor(Color.theme.eerieBlack).fontWeight(.semibold).font(.system(size: 20))
                    Spacer()
                    Text("Last updated: 28 May 2023, 22:30 (UTC+8)").foregroundColor(Color.theme.eerieBlack).fontWeight(.regular).font(.system(size: 11))
                    Spacer()
                    Button(action: {
                        print("Three dot clicked!!")
                    }) {
                        Image("icon_ellipsis_circle")
                            .frame(width: 24, height: 24)
                            .scaledToFit()
                            .aspectRatio(contentMode: .fit)
                    }
                }
                ForEach(viewInformationModel.ListItem, id: \.self) { item in
                    Button(action: {
                        print("Clicked 11!")
                    }) {
                        HStack {
                            Text(item.name).foregroundColor(Color.theme.eerieBlack).fontWeight(.semibold).font(.system(size: 16))
                            Spacer()
                            Text(item.date).foregroundColor(Color.theme.eerieBlack).fontWeight(.regular).font(.system(size: 16))
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.theme.cultured)
            .listStyle(.insetGrouped)
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
}
