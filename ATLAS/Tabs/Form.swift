//
//  Form.swift
//  ATLAS
//
//  Created by phuong phan on 21/05/2023.
//

import Foundation
import SwiftUI

struct Form: View {
    @State private var textNote: String = ""
    @State private var arrSelectedLine: [ITag] = []
    @State private var showSheet = false
    
    @Binding var tagList: [ITag]
    
    @State var selectedLine: ITag?
    @Namespace var lineAnimation
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(.white).padding(.bottom, 8)
            
            VStack(spacing: 0) {
                TextField("Add Note", text: $textNote)
                
                HStack {
                    Button(action: {
                        showSheet.toggle()
                    }, label: {
                        Text("Add Tags")
                            .padding(.vertical, 4)
                            .padding(.horizontal, 16)
                            .font(.custom("Inter-SemiBold", size: 16))
                            .foregroundColor(textNote != "" ? Color.theme.eerieBlack : .white)
                            .background(textNote != "" ? Color.theme.tealDeer : Color.theme.chineseSilver)
                            .cornerRadius(12)
                            .frame(alignment: .center)
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        // To do show modal
                    }, label: {
                        Text("Save To...")
                            .padding(.vertical, 4)
                            .padding(.horizontal, 16)
                            .font(.custom("Inter-SemiBold", size: 16))
                            .foregroundColor(textNote != "" ? Color.theme.eerieBlack : .white)
                            .background(textNote != "" ? Color.theme.tealDeer : Color.theme.chineseSilver)
                            .cornerRadius(12)
                            .frame(alignment: .center)
                    })
                    
                    Button(action: {
                        
                    }, label: {
                        Text("Save")
                            .padding(.vertical, 4)
                            .padding(.horizontal, 16)
                            .font(.custom("Inter-SemiBold", size: 16))
                            .foregroundColor(textNote != "" ? Color.theme.eerieBlack : .white)
                            .background(textNote != "" ? Color.theme.tealDeer : Color.theme.chineseSilver)
                            .cornerRadius(12)
                            .frame(alignment: .center)
                    })
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
            }.padding(16)
                .sheet(isPresented: $showSheet) {
                    Text("1232131231")
                    // List Categories Selected
//                    VStack {
//                        List {
//                            ForEach(arrSelectedLine, id: \.self) { item in
//                                if let selectedLine = selectedLine {
//                                    ZStack {
//                                        Color.red.overlay(
//                                            HStack(alignment: .top) {
//                                                Text(selectedLine.name)
//                                                //                                            .matchedGeometryEffect(id: "\(selectedLine.id).text", in: lineAnimation)
//                                                    .foregroundColor(Color.theme.eerieBlack)
//                                                    .font(.custom("Inter-Regular", size: 16))
//
//                                                Spacer()
//
//                                                Image("icon_plus")
//                                                //                                            .matchedGeometryEffect(id: "\(selectedLine.id).icon", in: lineAnimation)
//                                                    .frame(width: 16, height: 17)
//                                                    .scaledToFit()
//                                                    .aspectRatio(contentMode: .fit)
//                                                    .foregroundColor(.black)
//                                            }.padding(16)
//                                                .frame(maxWidth: .infinity, alignment: .leading)
//                                                .listRowSeparator(.hidden)
//                                                .listRowInsets(EdgeInsets())
//                                                .listRowBackground(Color.white)
//                                        ).matchedGeometryEffect(id: "\(selectedLine.id)", in: lineAnimation)
//                                            .zIndex(3)
//
//                                        Button {
//
//                                        } label: {
//                                            Text("Close Button").foregroundColor(.black)
//                                        }
//
//                                    }
//                                } else {
//                                    ZStack {
//                                        Color.red.overlay(
//                                            HStack(alignment: .top) {
//                                                Text(item.name)
//                                                    .foregroundColor(Color.theme.eerieBlack)
//                                                    .font(.custom("Inter-Regular", size: 16))
//
//                                                Spacer()
//
//                                                Image("icon_plus")
//                                                    .frame(width: 16, height: 17)
//                                                    .scaledToFit()
//                                                    .aspectRatio(contentMode: .fit)
//                                                    .foregroundColor(.black)
//                                            }.padding(16)
//                                                .frame(maxWidth: .infinity, alignment: .leading)
//                                                .listRowSeparator(.hidden)
//                                                .listRowInsets(EdgeInsets())
//                                                .listRowBackground(Color.white)
//                                        ).matchedGeometryEffect(id: "\(item.id)", in: lineAnimation)
//                                            .zIndex(3)
//
//                                        Button {
//
//                                        } label: {
//                                            Text("Close Button").foregroundColor(.black)
//                                        }
//
//                                    }
//                                }
//                            }
//                        }
//
//                        // List categories
//                        VStack(spacing: 0) {
//                            List {
//                                ForEach(tagList, id: \.self) { item in
//                                    if arrSelectedLine.isEmpty || (!arrSelectedLine.isEmpty && arrSelectedLine.contains(where: { $0.id != item.id })) {
//
//                                        Button(action: {
//                                            withAnimation {
//                                                selectedLine = item
//                                                arrSelectedLine.append(item)
//                                            }
//                                        }, label: {
//                                            HStack(alignment: .top) {
//                                                Text(item.name)
//                                                //                                                    .matchedGeometryEffect(id: "\(item.id).text", in: lineAnimation)
//                                                    .foregroundColor(Color.theme.eerieBlack)
//                                                    .font(.custom("Inter-Regular", size: 16))
//
//                                                Spacer()
//
//                                                Image("icon_plus")
//                                                //                                                    .matchedGeometryEffect(id: "\(item.id).icon", in: lineAnimation)
//                                                    .frame(width: 16, height: 17)
//                                                    .scaledToFit()
//                                                    .aspectRatio(contentMode: .fit)
//                                                    .foregroundColor(.black)
//                                            }.padding(16)
//                                                .frame(maxWidth: .infinity, alignment: .leading)
//                                                .listRowSeparator(.hidden)
//                                                .listRowInsets(EdgeInsets())
//                                                .listRowBackground(Color.white)
//                                            //} // end else
//                                        }).matchedGeometryEffect(id: "\(item.id)", in: lineAnimation)
//                                    }
//                                }
//                            }
//                        } // End VStack List Categories
//                    }.presentationDetents([.medium])
                }
        }
    }
}
