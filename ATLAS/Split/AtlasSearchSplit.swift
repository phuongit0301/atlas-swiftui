//
//  AtlasSearchSplit.swift
//  ATLAS
//
//  Created by phuong phan on 20/05/2023.
//

import Foundation
import SwiftUI

struct AtlasSearchSplit: View {
    @EnvironmentObject var network: Network
    
    @State private var like = Status.normal
    @State private var flag: Bool = false
    @State private var showLoading: Bool = false
    @State private var firstLoading: Bool = true
    // For Search
    @State private var txtSearch: String = ""

    @State private var message = ""
    @State private var messageCount = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Atlas Search")
                    .foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-SemiBold", size: 20))
                
                Rectangle().fill(Color.theme.lavender).frame(height: 16)
                
                HStack {
                    HStack(alignment: .center) {
                        Image(systemName: "magnifyingglass.circle")
                            .foregroundColor(Color.theme.eerieBlack)
                            .frame(width: 24, height: 24)
                            .scaledToFit()
                            .aspectRatio(contentMode: .fit)
                        
                        TextField("Search", text: $txtSearch, onCommit: onSearch)
                            .font(.custom("Inter-Regular", size: 16))
                            .padding(13)
                            .frame(maxWidth: .infinity, maxHeight: 48)
                        
                        if !firstLoading {
                            Button(action: {
                                self.message = ""
                                self.messageCount = 0
                                
                                self.showLoading = true
                                onSearch()
                            }) {
                                Image(systemName: "arrow.forward")
                                    .foregroundColor(Color.theme.eerieBlack)
                                    .frame(width: 20, height: 16)
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fit)
                            }
                        }
                        
                    }.padding(.horizontal, 12)
                        .padding(.vertical, 6)
                }
                .background(.white)
                .frame(maxWidth: .infinity)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white, lineWidth: 1)
                )
                
                Rectangle().fill(Color.theme.lavender).frame(height: 8)
                
                if firstLoading {
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            if txtSearch != "" {
                                self.message = ""
                                self.messageCount = 0
                                
                                self.showLoading = true
                                onSearch()
                            }
                        }) {
                            HStack {
                                Text("Search")
                                    .font(.custom("Inter-Regular", size: 16))
                                    .foregroundColor(txtSearch != "" ? Color.white : Color.theme.eerieBlack)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.theme.eerieBlack, lineWidth: 0)
                                    )
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                
                                if showLoading {
                                    ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                                }
                            }.padding(.horizontal, 8)
                        }
                        .background(txtSearch != "" ? Color.theme.eerieBlack : Color.theme.chineseSilver)
                        .cornerRadius(12)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .disabled(self.showLoading)
                    }
                }
                
                if txtSearch != "" && !firstLoading {
                    VStack(spacing: 0) {
                        HStack {
                            TypeWriterText(string: message, count: messageCount)
                               .frame(maxWidth: .infinity, alignment: .leading)
                        }.background(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 0)
                                .stroke(Color.theme.eerieBlack, lineWidth: 1)
                        )
                        
                        Rectangle().fill(Color.theme.lavender).frame(height: 8)
                        
                        // icons and button bottom
                        HStack(alignment: .center) {
                            Button(action: {
                                if like == Status.like {
                                    self.like = Status.normal
                                } else {
                                    self.like = Status.like
                                }
                            }) {
                                Image(systemName: "hand.thumbsup")
                                    .foregroundColor(self.like == Status.like ? Color.theme.tealDeer : Color.theme.eerieBlack)
                                    .frame(width: 24, height: 24)
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fit)
                            }
                            
                            Button(action: {
                                if like == Status.dislike {
                                    self.like = Status.normal
                                } else {
                                    self.like = Status.dislike
                                }
                            }) {
                                Image(systemName: "hand.thumbsdown")
                                    .foregroundColor(self.like == Status.dislike ? Color.theme.tealDeer : Color.theme.eerieBlack)
                                    .frame(width: 24, height: 24)
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fit)
                            }
                            
                            Button {
                                self.flag.toggle()
                            } label: {
                                Image(systemName: "flag")
                                    .tint(flag ? Color.theme.tealDeer : Color.theme.eerieBlack)
                                    .frame(width: 24, height: 24)
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fit)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                if txtSearch != "" {
                                    self.message = ""
                                    self.messageCount = 0
                                    
                                    self.showLoading = true
                                    onSearch()
                                }
                            }) {
                                Text("Regenerate Response")
                                    .font(.custom("Inter-Regular", size: 13))
                                    .foregroundColor(Color.theme.eerieBlack)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.init(
                                                Color.RGBColorSpace.sRGB, red: 0, green: 0, blue: 0, opacity: 0.1), lineWidth: 0)
                                    )
                                
                                if showLoading {
                                    ActivityIndicator(shouldAnimate: self.$showLoading)
                                }
                                
                            }.disabled(self.showLoading)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .border(Color.init(
                                Color.RGBColorSpace.sRGB, red: 0, green: 0, blue: 0, opacity: 0.1), width: 1, cornerRadius: 12)
//                            Button(action: {
//                                // To do: Handle button click
//                            }) {
//                                Text("Save To…")
//                                    .font(.custom("Inter-Regular", size: 13))
//                                    .foregroundColor(Color.theme.eerieBlack)
//                                    .background(Color.theme.tealDeer)
//                                    .padding(.horizontal, 16)
//                                    .padding(.vertical, 4)
//                                    .overlay(
//                                        RoundedRectangle(cornerRadius: 12)
//                                            .stroke(Color.theme.tealDeer, lineWidth: 1)
//                                    )
//                            }.background(Color.theme.tealDeer)
//                                .cornerRadius(12)
                            
                        }.background(Color.theme.lavender)
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    }
                }
                
            }.padding(12)
            .background(Color.theme.lavender)
                .cornerRadius(8)
            
            Spacer()
        }.padding(12)
            .background(Color.theme.cultured)
    }
    
    func onSearch() {
        network.handleSearch(question: txtSearch, onSuccess: {
            self.showLoading = false
            self.firstLoading = false
            
            withAnimation(.linear(duration: 30)) {
                message = network.dataSearch.result
                messageCount = network.dataSearch.result.count
            }
        }, onFailure: { error in
            self.showLoading = false
            print("Error fetch data == \(error)")
        })
    }
}
