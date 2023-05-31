//
//  AtlasSearchView.swift
//  ATLAS
//
//  Created by phuong phan on 20/05/2023.
//

import Foundation
import SwiftUI

enum Status {
    case normal
    case like
    case dislike
}

struct AtlasSearchView: View {
    @EnvironmentObject var network: Network
    
    @State private var like = Status.normal
    @State private var flag: Bool = false
    @State private var showLoading: Bool = false
    // For Search
    @State private var txtSearch: String = ""
    @State private var value = 0

    let message = "Expected approach time is determined for an arriving aircraft that will be subjected to a delay of 10 minutes or more or such other period as has been determined by the appropriate authority. The expected approach time shall be transmitted to the aircraft as soon as practicable and preferably not later than at the commencement of its initial descent from cruising level. (6.5.7.1) Source: docs/ICAO-Doc4444-Pans-Atm-16thEdition-2016-OPSGROUP.pdf, page: 132"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                // flight informations
                
                Text("Atlas Search")
                    .font(.custom("Inter-SemiBold", size: 20))
                    .foregroundColor(.black)
                VStack(spacing: 0) {
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
                            
                            Image(systemName: "arrow.forward")
                                .foregroundColor(Color.theme.chineseSilver)
                                .frame(width: 20, height: 16)
                                .scaledToFit()
                                .aspectRatio(contentMode: .fit)
                            
                        }.padding(.horizontal, 12)
                            .padding(.vertical, 6)
                    }
                    .background(.white)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(16)
                    .overlay( /// apply a rounded border
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.white, lineWidth: 1)
                    )
                    
                    Rectangle().fill(Color.theme.lavender).frame(height: 8)
                    
                    // search form
                    HStack {
                        TypeWriterText(string: message, count: value)
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
                                .foregroundColor(self.like == Status.normal ? Color.theme.eerieBlack : Color.theme.tealDeer)
                                .frame(width: 24, height: 24)
                                .scaledToFit()
                                .aspectRatio(contentMode: .fit)
                        }
                        
                        Button(action: {
                            // To do: Handle button click
                        }) {
                            Image(systemName: "hand.thumbsdown")
                                .foregroundColor(Color.theme.eerieBlack)
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
                            withAnimation(.linear(duration: 30)) {
                                value = message.count
                            }
                        }) {
                            Text("Regenerate Response")
                                .font(.custom("Inter-Regular", size: 13))
                                .foregroundColor(Color.theme.eerieBlack)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 4)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.init(
                                            Color.RGBColorSpace.sRGB, red: 0, green: 0, blue: 0, opacity: 0.1), lineWidth: 1)
                                )
                            ActivityIndicator(shouldAnimate: self.$showLoading)
                        }.disabled(self.showLoading)
                        
                        Button(action: {
                            // To do: Handle button click
                        }) {
                            Text("Save To...")
                                .font(.custom("Inter-Regular", size: 13))
                                .foregroundColor(Color.theme.eerieBlack)
                                .background(Color.theme.tealDeer)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 4)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.theme.tealDeer, lineWidth: 1)
                                )
                        }.background(Color.theme.tealDeer)
                            .cornerRadius(12)
                        
                    }
                }.padding(.horizontal, 16)
                    .padding(.vertical, 8)
                
                
            }.background(Color.theme.lavender)
                .cornerRadius(8)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            Spacer()
            
        }.padding(16)
        
        Spacer()
    }
    
    func onSearch() {
        //To do call API
    }
    
    private func forcegroundColorLike(for likeNum: Status) -> Color {
        return likeNum == Status.normal ? Color.theme.eerieBlack : Color.theme.tealDeer
    }
    
    private func forcegroundColorDislike(for likeNum: Int) -> Color {
        return likeNum == 2 ? Color.theme.tealDeer : Color.theme.eerieBlack
    }
    
    private func forcegroundColorFlag(for isFlag: Bool) -> Color {
        return isFlag ? Color.theme.tealDeer : Color.theme.eerieBlack
    }
}
