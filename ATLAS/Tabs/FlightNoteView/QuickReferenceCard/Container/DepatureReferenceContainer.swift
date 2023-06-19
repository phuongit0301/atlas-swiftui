//
//  DepatureReferenceContainer.swift
//  ATLAS
//
//  Created by phuong phan on 23/05/2023.
//

import Foundation
import SwiftUI

struct DepatureReferenceContainer: View {
    @ObservedObject var viewModel: FlightNoteModelState
    @State var depTags: [ITagStorage] = []
    
    @State private var currentIndex: Int = -1
    
    var geoWidth: Double = 0
    
    var body: some View {
        VStack(spacing: 0) {
            if !viewModel.departureQRArray.isEmpty {
                VStack(spacing: 0) {
                    List {
                        ForEach(viewModel.departureQRArray.indices, id: \.self) { index in
                            VStack(alignment: .leading, spacing: 0) {
                                HStack(alignment: .top) {
                                    Image("icon_dots_group")
                                        .frame(width: 14, height: 16)
                                        .scaledToFit()
                                        .aspectRatio(contentMode: .fit)
                                    
                                    Text(viewModel.departureQRArray[index].name)
                                        .foregroundColor(Color.theme.eerieBlack)
                                        .font(.custom("Inter-Regular", size: 16))
                                    
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
                                }
                            }.padding(12)
                                .frame(maxWidth: geoWidth, alignment: .leading)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets())
                                .listRowBackground(Color.white)
                                .swipeActions(allowsFullSwipe: false) {
                                    Button(role: .destructive) {
                                        viewModel.updateDeparture(item: viewModel.departureQRArray[index])
                                        viewModel.removeItemDepartureQR(item: viewModel.departureQRArray[index])
                                    } label: {
                                        Image(systemName: "trash.fill")
                                            .frame(width: 16, height: 16)
                                            .scaledToFit()
                                            .aspectRatio(contentMode: .fit)
                                    }.tint(Color.theme.alizarinCrimson)
                                    
                                    Button {
                                        self.currentIndex = index
                                    } label: {
                                        Image(systemName: "square.and.pencil")
                                            .frame(width: 16, height: 16)
                                            .scaledToFit()
                                            .aspectRatio(contentMode: .fit)
                                    }
                                    .tint(Color.theme.eerieBlack)
                                    
//                                    Button {
//                                        print("Tag")
//                                    } label: {
//                                        Image(systemName: "pin.fill")
//                                            .frame(width: 16, height: 16)
//                                            .scaledToFit()
//                                            .aspectRatio(contentMode: .fit)
//                                    }
//                                    .tint(Color.theme.eerieBlack)
                                }
                        }.onMove(perform: move)
                    }.listStyle(.plain)
                        .listRowBackground(Color.white)
                }.background(Color.white)
                // end list
                Rectangle().fill(Color.theme.lightGray).frame(height: 1)
            }
            
            QuickReferenceForm(
                tagList: self.$depTags,
                itemList: $viewModel.departureQRArray,
                resetData: self.resetData,
                currentIndex: $currentIndex
            ).frame(height: 98)
        }
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        viewModel.departureQRArray.move(fromOffsets: source, toOffset: destination)
    }
    
    private func delete(at offsets: IndexSet) {
        viewModel.departureQRArray.remove(atOffsets: offsets)
    }
    
    private func resetData() {
        self.depTags = DepartureTags().TagList
        
        if self.currentIndex > -1 {
            self.currentIndex = -1
        }
    }
    
    private func backgroundColor(for isDefault: Bool) -> Color {
        return isDefault ? Color.theme.champagne : Color.white
    }
}
