//
//  ArrivalCardContainer.swift
//  ATLAS
//
//  Created by phuong phan on 23/05/2023.
//

import Foundation
import SwiftUI

struct ArrivalCardContainer: View {
    @ObservedObject var viewModel: FlightNoteModelState
    @State var arrivalTags: [ITagStorage] = CommonTags().TagList
    
    @State private var currentIndex: Int = -1
    
    var geoWidth: Double = 0
    
    var body: some View {
        VStack(spacing: 0) {
            if !viewModel.arrivalDataArray.isEmpty {
                VStack(spacing: 0) {
                    List {
                        ForEach(viewModel.arrivalDataArray.indices, id: \.self) { index in
                            VStack(alignment: .leading, spacing: 0) {
                                HStack(alignment: .top) {
                                    Image("icon_dots_group")
                                        .frame(width: 14, height: 16)
                                        .scaledToFit()
                                        .aspectRatio(contentMode: .fit)
                                    
                                    Text(viewModel.arrivalDataArray[index].name)
                                        .foregroundColor(Color.theme.eerieBlack)
                                        .font(.custom("Inter-Regular", size: 16))
                                    
                                    
                                    ForEach(viewModel.arrivalDataArray[index].tags) { tag in
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
                            }.padding(12)
                                .frame(maxWidth: geoWidth, alignment: .leading)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets())
                                .listRowBackground(self.backgroundColor(for: viewModel.arrivalDataArray[index].isDefault))
                                .swipeActions(allowsFullSwipe: false) {
                                    if !viewModel.arrivalDataArray[index].isDefault {
                                        Button(role: .destructive) {
                                            viewModel.removeItemArrival(item: viewModel.arrivalDataArray[index])
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
                                    }
                                    
                                    Button {
                                        viewModel.addArrivalQR(item: viewModel.arrivalDataArray[index])
                                        viewModel.arrivalDataArray[index].isDefault = true
                                    } label: {
                                        Image(systemName: "tag.fill")
                                            .frame(width: 16, height: 16)
                                            .scaledToFit()
                                            .aspectRatio(contentMode: .fit)
                                    }
                                    .tint(Color.theme.eerieBlack)
                                }
                        }.onMove(perform: move)
                    }.listStyle(.plain)
                        .listRowBackground(Color.theme.champagne)
                        .frame(height: CGFloat(viewModel.arrivalDataArray.count * 45))
                        .padding(.bottom, 5)
                }.layoutPriority(1)
                    .background(Color.white)
                // end list
                Rectangle().fill(Color.theme.lightGray).frame(height: 1)
            }

            DepartureForm(
                tagList: self.$arrivalTags,
                itemList: $viewModel.arrivalDataArray,
                resetData: self.resetData,
                currentIndex: $currentIndex
            ).frame(height: 98)
            
        }
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        print("Move");
        viewModel.arrivalDataArray.move(fromOffsets: source, toOffset: destination)
    }
    
    private func resetData() {
        self.arrivalTags = CommonTags().TagList
        
        if self.currentIndex > -1 {
            self.currentIndex = -1
        }
    }
    
    private func backgroundColor(for isDefault: Bool) -> Color {
        return isDefault ? Color.theme.champagne : Color.white
    }
}
