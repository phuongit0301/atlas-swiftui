//
//  NoteDetailSplit.swift
//  ATLAS
//
//  Created by phuong phan on 29/05/2023.
//

import Foundation
import SwiftUI

struct NoteDetailSplit: View {
    @State private var routingName: String = ""
    
    var body: some View {
        GeometryReader { geo in
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Flight Plan")
                        .foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-SemiBold", size: 20))
                    
                    Rectangle().fill(Color.theme.cultured).frame(height: 16)
                    
                    Text("OFP Updates")
                        .foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-SemiBold", size: 20))
                    
                    Rectangle().fill(Color.theme.cultured).frame(height: 16)
                    
                    VStack(alignment: .center, spacing: 0) {
                        Text("Actual Weights").foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-Regular", size: 12))
                            .padding(10)
                            .frame(maxWidth: .infinity)
                            .border(Color.theme.chineseSilver2, width: 1)
                        HStack(spacing: 0) {
                            Text("PZFW").foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-SemiBold", size: 12))
                                .padding(10)
                                .frame(maxWidth: .infinity)
                                .border(Color.theme.chineseSilver2, width: 1)
                            Text("PTOW").foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-SemiBold", size: 12))
                                .padding(10)
                                .frame(maxWidth: .infinity)
                                .border(Color.theme.chineseSilver2, width: 1)
                            Text("PLWT").foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-SemiBold", size: 12))
                                .padding(10)
                                .frame(maxWidth: .infinity)
                                .border(Color.theme.chineseSilver2, width: 1)
                        }
                        HStack(spacing: 0) {
                            Text("142560").foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-Regular", size: 12))
                                .padding(10)
                                .frame(maxWidth: .infinity)
                                .border(Color.theme.chineseSilver2, width: 1)
                            Text("227000").foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-Regular", size: 12))
                                .padding(10)
                                .frame(maxWidth: .infinity)
                                .border(Color.theme.chineseSilver2, width: 1)
                            Text("150500").foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-Regular", size: 12))
                                .padding(10)
                                .frame(maxWidth: .infinity)
                                .border(Color.theme.chineseSilver2, width: 1)
                        }
                    }.border(Color.theme.chineseSilver2, width: 1)
                        .cornerRadius(4)
                        .background(Color.white)
                        .frame(maxWidth: .infinity)
                    
                    Rectangle().fill(Color.theme.cultured).frame(height: 16)
                    
                    VStack(alignment: .center, spacing: 0) {
                        Text("Extra Fuel").foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-Regular", size: 12))
                            .padding(10)
                            .frame(maxWidth: .infinity)
                            .border(Color.theme.chineseSilver2, width: 1)
                        HStack(spacing: 0) {
                            Text("Time").foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-SemiBold", size: 12))
                                .padding(10)
                                .frame(maxWidth: .infinity)
                                .border(Color.theme.chineseSilver2, width: 1)
                            Text("Fuel (Kg)").foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-SemiBold", size: 12))
                                .padding(10)
                                .frame(maxWidth: .infinity)
                                .border(Color.theme.chineseSilver2, width: 1)
                            Text("Reason").foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-SemiBold", size: 12))
                                .padding(10)
                                .frame(maxWidth: .infinity)
                                .border(Color.theme.chineseSilver2, width: 1)
                        }
                        HStack(spacing: 0) {
                            Text("00:15").foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-Regular", size: 12))
                                .padding(10)
                                .frame(maxWidth: .infinity)
                                .border(Color.theme.chineseSilver2, width: 1)
                            Text("1000").foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-Regular", size: 12))
                                .padding(10)
                                .frame(maxWidth: .infinity)
                                .border(Color.theme.chineseSilver2, width: 1)
                            Text("ENR WX, ARR DELAYS").foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-Regular", size: 12))
                                .padding(10)
                                .frame(maxWidth: .infinity)
                                .border(Color.theme.chineseSilver2, width: 1)
                        }
                    }.border(Color.theme.chineseSilver2, width: 1)
                        .cornerRadius(4)
                        .background(Color.white)
                        .frame(maxWidth: .infinity)
                    
                    Rectangle().fill(Color.theme.cultured).frame(height: 16)
                    
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Routing")
                            .foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-SemiBold", size: 20))
                        
                        Rectangle().fill(Color.theme.cultured).frame(height: 16)
                        
                        TextField("Enter Routing", text: $routingName)
                            .frame(height: 150)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(4)
                        
                        Rectangle().fill(Color.theme.cultured).frame(height: 16)
                        
                        HStack {
                            Spacer()
                            
                            Button(action: {}, label: {
                                Text("Copy")
                                    .cornerRadius(12)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 4)
                                    .foregroundColor(Color.white)
                                    .background(Color.theme.tuftsBlue)
                                    .font(.custom("Inter-Regular", size: 13))
                                
                            }).cornerRadius(12)
    
                            Button(action: {}, label: {
                                Text("Paste")
                                    .cornerRadius(12)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 4)
                                    .foregroundColor(Color.white)
                                    .background(Color.theme.tuftsBlue)
                                    .font(.custom("Inter-Regular", size: 13))
                            }).cornerRadius(12)
                        }
                    }
                    
                    Spacer()
                }.padding()
                    .background(Color.theme.cultured)
            }.background(Color.theme.cultured)
        }
    }
}
