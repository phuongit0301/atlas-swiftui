//
//  AutoCompleteView.swift
//  ATLAS
//
//  Created by phuong phan on 22/10/2023.
//

import SwiftUI

struct AutoCompleteView: View {
    @EnvironmentObject var preflightModel: PreflightModel
    
    @Binding var isShowing: Bool
    @Binding var itemList: [IAlternate]
    @Binding var isRouteFormChange: Bool
    
    @State private var listRoutes = [String]()
    @State private var tfRoute = ""
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .center) {
                    Button(action: {
                        preflightModel.currentIndexAutoComplete = -1
                        preflightModel.routeAlternateType = ""
                        self.isShowing.toggle()
                    }) {
                        Text("Cancel").font(Font.custom("SF Pro", size: 15).weight(.regular)).foregroundColor(Color.theme.azure)
                    }
                    
                    Spacer()
                    
                    Text("Enter ICAO").font(Font.custom("SF Pro", size: 15).weight(.semibold)).foregroundColor(Color.black)
                    
                    Spacer()
                    
                    Button(action: {
                        preflightModel.currentIndexAutoComplete = -1
                        preflightModel.routeAlternateType = ""
                        self.isShowing.toggle()
                    }) {
                        Text("Done").font(Font.custom("SF Pro", size: 15).weight(.semibold)).foregroundColor(Color.theme.azure)
                    }
                }.padding()
                    .background(.white)
                    .overlay(Rectangle().inset(by: 0.17).stroke(.black.opacity(0.3), lineWidth: 0.33))
                    .roundedCorner(12, corners: [.topLeft, .topRight])
                
                VStack(alignment: .leading, spacing: 8) {
                    TextField("Enter Airport", text: $tfRoute)
                        .padding(8)
                        .background(Color.white)
                        .cornerRadius(8)
                        .frame(height: 44)
                        .onChange(of: tfRoute) {newValue in
                            if preflightModel.currentIndexAutoComplete != -1 && itemList[preflightModel.currentIndexAutoComplete].altn != newValue {
                                listRoutes = AIRLINE_DROP_DOWN.filter {$0.lowercased().hasPrefix(newValue.lowercased())}
                                isRouteFormChange = true
                            }
                        }
                    
                    if listRoutes.count > 0 {
                        ScrollView {
                            ForEach(listRoutes.indices, id: \.self) { index in
                                HStack(alignment: .center) {
                                    Text(listRoutes[index]).font(.system(size: 15, weight: .regular))
                                }.frame(width: proxy.size.width - 64, alignment: .leading)
                                    .onTapGesture {
                                        tfRoute = listRoutes[index]
                                        if itemList.count > 0 {
                                            isRouteFormChange = true
                                            itemList[preflightModel.currentIndexAutoComplete].altn = listRoutes[index]
                                            listRoutes = []
                                            preflightModel.currentIndexAutoComplete = -1
                                            preflightModel.routeAlternateType = ""
                                            self.isShowing.toggle()
                                        }
                                    }
                                
                                if index + 1 < listRoutes.count {
                                    Divider().padding(.horizontal, -32)
                                }
                            }
                        }.padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(lineWidth: 0)
                                    .foregroundColor(.white)
                            )
                    }
                    Spacer()
                }.padding(16)
                    .background(Color.theme.antiFlashWhite)
                    .onAppear {
                        if preflightModel.currentIndexAutoComplete > -1 && itemList[preflightModel.currentIndexAutoComplete].altn != "" && itemList[preflightModel.currentIndexAutoComplete].altn != "Select Airport" {
                            tfRoute = itemList[preflightModel.currentIndexAutoComplete].altn
                        }
                    }
                
            }
        }
    }
}
