//
//  FlightNoteCardForm.swift
//  ATLAS
//
//  Created by phuong phan on 23/05/2023.
//

import Foundation
import SwiftUI

struct DepatureCardForm: View {
    @Binding var itemList: [IFlightInfoModel]
    @State var depTags: [ITag] = DepartureTags().TagList
    
    var body: some View {
        VStack(spacing: 0) {
            List {
                ForEach(itemList, id: \.self) { item in
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(alignment: .top) {
                            Image("icon_dots_group")
                                .frame(width: 14, height: 16)
                                .scaledToFit()
                                .aspectRatio(contentMode: .fit)
                            
                            Text(item.name)
                                .foregroundColor(Color.theme.eerieBlack)
                                .font(.custom("Inter-Regular", size: 16))
                            
                            if !item.tags.isEmpty {
                                ForEach(item.tags, id: \.self) { tag in
                                    Text(tag.name)
                                        .padding(.vertical, 4)
                                        .padding(.horizontal, 8)
                                        .font(.custom("Inter-Medium", size: 12))
                                        .foregroundColor(Color.theme.eerieBlack)
                                        .overlay(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .stroke(Color.theme.eerieBlack, lineWidth: 1)
                                            )
                                }
                            }
                        }
                    }.padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.theme.champagne)
                        .swipeActions(allowsFullSwipe: false) {
                            Button {
                                print("Muting conversation")
                            } label: {
                                Image(systemName: "tag.fill")
                                    .frame(width: 16, height: 16)
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fit)
                            }
                            .tint(Color.theme.pastelOrange)
                            
                            Button {
                                print("Muting conversation")
                            } label: {
                                Image(systemName: "square.and.pencil")
                                    .frame(width: 16, height: 16)
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fit)
                            }
                            .tint(Color.theme.eerieBlack)

                            Button {
                                print("Muting conversation")
                            } label: {
                                Image(systemName: "doc.on.doc.fill")
                                    .frame(width: 16, height: 16)
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fit)
                            }
                            .tint(Color.theme.tuftsBlue)

                            Button {
                                print("Muting conversation")
                            } label: {
                                Image(systemName: "square.and.arrow.up")
                                    .frame(width: 16, height: 16)
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fit)
                            }
                            .tint(Color.theme.chineseSilver)

                            Button(role: .destructive) {
                                print("Deleting conversation")
                            } label: {
                                Image(systemName: "trash.fill")
                                    .frame(width: 16, height: 16)
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fit)
                            }.tint(Color.theme.alizarinCrimson)
                        }
                }.onMove(perform: move)
            }.listStyle(.plain)
                .listRowBackground(Color.theme.champagne)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            Form(tagList: self.$depTags).frame(height: 98)
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        print("Move");
        itemList.move(fromOffsets: source, toOffset: destination)
    }
}
