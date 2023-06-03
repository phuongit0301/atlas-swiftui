//
//  AircraftStatusContainer.swift
//  ATLAS
//
//  Created by phuong phan on 23/05/2023.
//

import Foundation
import SwiftUI

struct AircraftStatusContainer: View {
    @ObservedObject var viewModel: FlightNoteModelState
    @State var aircraftTags: [ITag] = []
    var calculateHeight: () -> Void
    var geoWidth: Double = 0
    
    var body: some View {
        VStack(spacing: 0) {
            if !itemList.isEmpty {
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
                            }
                        }
                        .padding(12)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: geoWidth, alignment: .leading)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.white)
                        .swipeActions(allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                print("Deleting conversation")
                            } label: {
                                Image(systemName: "trash.fill")
                                    .frame(width: 16, height: 16)
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fit)
                            }.tint(Color.theme.alizarinCrimson)
                            Button {
                                print("Muting conversation")
                            } label: {
                                Image(systemName: "square.and.pencil")
                                    .frame(width: 16, height: 16)
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fit)
                            }
                            .tint(Color.theme.eerieBlack)
                            
//                            Button {
//                                print("Muting conversation")
//                            } label: {
//                                Image(systemName: "tag.fill")
//                                    .frame(width: 16, height: 16)
//                                    .scaledToFit()
//                                    .aspectRatio(contentMode: .fit)
//                            }
//                            .tint(Color.theme.eerieBlack)
                        }
                    }.onMove(perform: move)
                }
                .listStyle(.plain)
                    .listRowBackground(Color.white)
                    .frame(maxWidth: .infinity, maxHeight: 98)

                Rectangle().fill(Color.theme.lightGray).frame(height: 1)
            }
            
            DepartureForm(tagList: self.$aircraftTags, itemList: self.$itemList, resetData: self.resetData).frame(height: 98)
        }
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        print("Move");
        itemList.move(fromOffsets: source, toOffset: destination)
    }
    
    private func resetData() {
        self.aircraftTags = []
        self.calculateHeight()
    }
    
    private func backgroundColor(for isDefault: Bool) -> Color {
        return isDefault ? Color.theme.champagne : Color.white
    }
}
