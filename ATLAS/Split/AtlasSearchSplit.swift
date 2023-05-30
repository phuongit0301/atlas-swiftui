//
//  AtlasSearchSplit.swift
//  ATLAS
//
//  Created by phuong phan on 20/05/2023.
//

import Foundation
import SwiftUI

struct AtlasSearchSplit: View {
    @State private var txtSearch: String = ""
    @State private var like = 0 // 0: normal, 1: Like, 2: Dislike
    @State private var flag: Bool = false
    
    @State private var value = 0

    let message = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin dictum eros urna, a eleifend orci aliquam nec. Vivamus non iaculis quam. Morbi ipsum dolor, venenatis. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin dictum eros urna, a eleifend orci aliquam nec. Vivamus non iaculis quam. Morbi ipsum dolor, venenatis. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin dictum eros urna, a eleifend orci aliquam nec. Vivamus non iaculis quam. Morbi ipsum dolor, venenatis."
    
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
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white, lineWidth: 1)
                )
                
                Rectangle().fill(Color.theme.lavender).frame(height: 8)
                
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
                        self.like = self.like == 1 ? 0 : 1
                    }) {
                        Image(systemName: "hand.thumbsup")
                            .foregroundColor(self.like == 1 ? Color.theme.tealDeer : Color.theme.eerieBlack)
                            .frame(width: 24, height: 24)
                            .scaledToFit()
                            .aspectRatio(contentMode: .fit)
                    }
                    
                    Button(action: {
                        self.like = self.like == 2 ? 0 : 2
                    }) {
                        Image(systemName: "hand.thumbsdown")
                            .foregroundColor(self.like == 2 ? Color.theme.tealDeer : Color.theme.eerieBlack)
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
//                        self.isShowText.toggle()
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
                    }
                    
                    Button(action: {
                        // To do: Handle button click
                    }) {
                        Text("Save To…")
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
                    
                }.background(Color.theme.lavender)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            }.padding(16)
            .background(Color.theme.lavender)
                .cornerRadius(8)
            
            Spacer()
        }.padding(16)
            .background(Color.theme.cultured)
    }
    
    func onSearch() {
        //To do call API
    }
}

struct TypeWriterText: View, Animatable {
    var string: String
    var count = 0

    var animatableData: Double {
        get { Double(count) }
        set { count = Int(max(0, newValue)) }
    }

    var body: some View {
        let stringToShow = String(string.prefix(count))
        ScrollView {
            Text(stringToShow).font(.custom("Inter-Regular", size: 16))
                .foregroundColor(Color.theme.eerieBlack)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
        }.frame(maxWidth: .infinity, maxHeight: 200)
    }
}
