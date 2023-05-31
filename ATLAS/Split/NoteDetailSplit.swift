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
    @State var copiedText: String = ""
    @State var pasteText: String = ""
    private let pasteboard = UIPasteboard.general
    
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
                        
                        Text("WSSS/20L AKOMA DCT AKMET DCT AROSO Y513 KALIL Y504 BILIK G582 PUGER P574 UDULO P574 TOTOX L555 TOLDA M628 PEKEM M628 MIGMA M550 MEVDO Y511 PMA V22 YEN L300 LXR P751 KATAB B12 DBA L613 TANSA UL617 KEA UG33 KOROS UN133 PEREN UL863 EVIVI DCT OKANA DCT TONDO DCT BEGLA DCT LOKVU DCT LEGAZ DCT BEFRE T204 TEXTI T204 NUKRO DCT EDDB/25L")
                            .frame(height: 150)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(4)
                        
                        Rectangle().fill(Color.theme.cultured).frame(height: 16)
                        
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                pasteboard.string = "WSSS/20L AKOMA DCT AKMET DCT AROSO Y513 KALIL Y504 BILIK G582 PUGER P574 UDULO P574 TOTOX L555 TOLDA M628 PEKEM M628 MIGMA M550 MEVDO Y511 PMA V22 YEN L300 LXR P751 KATAB B12 DBA L613 TANSA UL617 KEA UG33 KOROS UN133 PEREN UL863 EVIVI DCT OKANA DCT TONDO DCT BEGLA DCT LOKVU DCT LEGAZ DCT BEFRE T204 TEXTI T204 NUKRO DCT EDDB/25L"
                            }, label: {
                                Text("Copy")
                                    .cornerRadius(12)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 4)
                                    .foregroundColor(Color.white)
                                    .background(Color.theme.tuftsBlue)
                                    .font(.custom("Inter-Regular", size: 13))
                                
                            }).cornerRadius(12)
    
                            Button(action: {
                                if let clipboardText = pasteboard.string {
                                    pasteText = clipboardText
                                }
                            }, label: {
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
