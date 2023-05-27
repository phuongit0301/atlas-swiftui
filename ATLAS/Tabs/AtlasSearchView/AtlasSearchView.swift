//
//  AtlasSearchView.swift
//  ATLAS
//
//  Created by phuong phan on 20/05/2023.
//

import Foundation
import SwiftUI

struct AtlasSearchView: View {
    @State private var txtSearch: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                // flight informations
                Collapsible {
                    Text("Atlas Search")
                        .font(.custom("Inter-SemiBold", size: 20))
                        .foregroundColor(.black)
                } content: {
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
                            Text("Generate Search")
                                .font(.custom("Inter-Regular", size: 16))
                                .foregroundColor(Color.theme.eerieBlack)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .frame(maxWidth: .infinity, maxHeight: 100)
                        }.background(.white)
//                            .frame(maxWidth: .infinity, maxHeight: 100)
                            .overlay(
                                RoundedRectangle(cornerRadius: 0)
                                    .stroke(Color.theme.eerieBlack, lineWidth: 1)
                            )
                        
                        Rectangle().fill(Color.theme.lavender).frame(height: 8)
                        
                        // icons and button bottom
                        HStack(alignment: .center) {
                            Button(action: {
                                // To do: Handle button click
                            }) {
                                Image(systemName: "hand.thumbsup")
                                    .foregroundColor(Color.theme.eerieBlack)
                                    .frame(width: 24, height: 24)
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fit)
                            }
                            
                            Button(action: {
                                // To do: Handle button click
                            }) {
                                Image(systemName: "hand.thumbsdown")
                                    .foregroundColor(Color.theme.chineseSilver)
                                    .frame(width: 24, height: 24)
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fit)
                            }
                            
                            Button(action: {
                                // To do: Handle button click
                            }) {
                                Image(systemName: "flag")
                                    .foregroundColor(Color.theme.eerieBlack)
                                    .frame(width: 24, height: 24)
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fit)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                // To do: Handle button click
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
                            
                        }
                    }
                } headerContent: {
                    HStack {
                        Spacer()
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
}
