//
//  EnrouteSplitContainer.swift
//  ATLAS
//
//  Created by phuong phan on 29/05/2023.
//

import Foundation
import SwiftUI

struct EnrouteSplitContainer: View {
    @Binding var itemList: [IFlightInfoModel]
    @State var enrouteTags: [ITag] = EnrouteTags().TagList
    var calculateHeight: () -> Void
    var geoWidth: Double = 0
    var contentHeight: Double = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Enroute")
                .foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-SemiBold", size: 20))
            
            Rectangle().fill(Color.theme.cultured).frame(height: 16)
            
            HStack(spacing: 0) {
                Text("Enroute")
                    .font(.custom("Inter-SemiBold", size: 16))
                    .foregroundColor(Color.theme.eerieBlack)
                
                Spacer()
            }.frame(maxWidth: .infinity)
            .padding()
            .background(Color.white)
            .roundedCorner(8, corners: [.topLeft, .topRight])
            
            Rectangle().fill(Color.theme.eerieBlack).frame(height: 1)
            
//            if !itemList.isEmpty {
//                List {
//                    ForEach(itemList, id: \.self) { item in
//                        VStack(alignment: .leading, spacing: 0) {
//                            HStack(alignment: .top) {
//                                Image("icon_dots_group")
//                                    .frame(width: 14, height: 16)
//                                    .scaledToFit()
//                                    .aspectRatio(contentMode: .fit)
//                                
//                                Text(item.name)
//                                    .foregroundColor(Color.theme.eerieBlack)
//                                    .font(.custom("Inter-Regular", size: 16))
//                                
//                                if !item.tags.isEmpty {
//                                    ForEach(item.tags, id: \.self) { tag in
//                                        Text(tag.name)
//                                            .padding(.vertical, 4)
//                                            .padding(.horizontal, 8)
//                                            .font(.custom("Inter-Medium", size: 12))
//                                            .foregroundColor(Color.theme.eerieBlack)
//                                            .overlay(
//                                                RoundedRectangle(cornerRadius: 16)
//                                                    .stroke(Color.theme.eerieBlack, lineWidth: 1)
//                                            )
//                                    }
//                                }
//                            }
//                        }.padding(12)
//                            .frame(maxWidth: geoWidth, alignment: .leading)
//                            .listRowSeparator(.hidden)
//                            .listRowInsets(EdgeInsets())
//                            .listRowBackground(self.backgroundColor(for: item.isDefault))
//                            .lineLimit(2)
//                            .fixedSize(horizontal: false, vertical: true)
//                            .swipeActions(allowsFullSwipe: false) {
//                                Button {
//                                    print("Muting conversation")
//                                } label: {
//                                    Image(systemName: "tag.fill")
//                                        .frame(width: 16, height: 16)
//                                        .scaledToFit()
//                                        .aspectRatio(contentMode: .fit)
//                                }
//                                .tint(Color.theme.pastelOrange)
//                                
//                                Button {
//                                    print("Muting conversation")
//                                } label: {
//                                    Image(systemName: "square.and.pencil")
//                                        .frame(width: 16, height: 16)
//                                        .scaledToFit()
//                                        .aspectRatio(contentMode: .fit)
//                                }
//                                .tint(Color.theme.eerieBlack)
//                                
//                                Button {
//                                    print("Muting conversation")
//                                } label: {
//                                    Image(systemName: "doc.on.doc.fill")
//                                        .frame(width: 16, height: 16)
//                                        .scaledToFit()
//                                        .aspectRatio(contentMode: .fit)
//                                }
//                                .tint(Color.theme.tuftsBlue)
//                                
//                                Button {
//                                    print("Muting conversation")
//                                } label: {
//                                    Image(systemName: "square.and.arrow.up")
//                                        .frame(width: 16, height: 16)
//                                        .scaledToFit()
//                                        .aspectRatio(contentMode: .fit)
//                                }
//                                .tint(Color.theme.chineseSilver)
//                                
//                                Button(role: .destructive) {
//                                    print("Deleting conversation")
//                                } label: {
//                                    Image(systemName: "trash.fill")
//                                        .frame(width: 16, height: 16)
//                                        .scaledToFit()
//                                        .aspectRatio(contentMode: .fit)
//                                }.tint(Color.theme.alizarinCrimson)
//                            }
//                    }.onMove(perform: move)
//                }.listStyle(.plain)
//                    .listRowBackground(Color.white)
//                    .frame(height: contentHeight)
//                
//                Rectangle().fill(Color.theme.lightGray).frame(height: 1)
//            }
            
            EnrouteSplitForm(tagList: self.$enrouteTags, itemList: self.$itemList, resetData: self.resetData).frame(height: 98)
            
            Spacer()
        }.padding()
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        print("Move");
        itemList.move(fromOffsets: source, toOffset: destination)
    }
    
    private func resetData() {
        self.enrouteTags = []
        self.calculateHeight()
    }
    
    private func backgroundColor(for isDefault: Bool) -> Color {
        return isDefault ? Color.theme.champagne : Color.white
    }
}
