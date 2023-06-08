//
//  ArrivalReferenceContainer.swift
//  ATLAS
//
//  Created by phuong phan on 23/05/2023.
//

import Foundation
import SwiftUI

struct ArrivalReferenceContainer: View {
    @ObservedObject var viewModel: FlightNoteModelState
    @State var arrivalTags: [ITagStorage] = []
    
    @State private var currentIndex: Int = -1
    
    var geoWidth: Double = 0
    
    var body: some View {
        VStack(spacing: 0) {
            if !viewModel.arrivalQRDataArray.isEmpty {
                VStack(spacing: 0) {
                    List {
                        ForEach(viewModel.arrivalQRDataArray.indices, id: \.self) { index in
                            VStack(alignment: .leading, spacing: 0) {
                                HStack(alignment: .top) {
                                    Image("icon_dots_group")
                                        .frame(width: 14, height: 16)
                                        .scaledToFit()
                                        .aspectRatio(contentMode: .fit)
                                    
                                    Text(viewModel.arrivalQRDataArray[index].name)
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
                                        viewModel.updateArrival(item: viewModel.arrivalQRDataArray[index])
                                        viewModel.removeItemArrivalQR(item: viewModel.arrivalQRDataArray[index])
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
//                                        print("Tags")
//                                    } label: {
//                                        Image(systemName: "tag.fill")
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
                tagList: self.$arrivalTags,
                itemList: $viewModel.arrivalQRDataArray,
                resetData: self.resetData,
                currentIndex: $currentIndex
            ).frame(height: 98)
        }
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        print("Move");
        viewModel.arrivalQRDataArray.move(fromOffsets: source, toOffset: destination)
    }
    
    private func resetData() {
        self.arrivalTags = ArrivalTags().TagList
        
        if self.currentIndex > -1 {
            self.currentIndex = -1
        }
    }
    
    private func backgroundColor(for isDefault: Bool) -> Color {
        return isDefault ? Color.theme.champagne : Color.white
    }
}
