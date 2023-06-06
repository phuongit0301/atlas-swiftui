//
//  DepatureCardContainer.swift
//  ATLAS
//
//  Created by phuong phan on 23/05/2023.
//

import Foundation
import SwiftUI

struct DepatureCardContainer: View {
    @ObservedObject var viewModel: FlightNoteModelState
    @State var depTags: [ITagStorage] = CommonTags().TagList
    
    @State private var currentIndex: Int = -1
    
    var geoWidth: Double = 0
    
    var body: some View {
        VStack(spacing: 0) {
            if !viewModel.departureDataArray.isEmpty {
                VStack(spacing: 0) {
                    List {
                        ForEach(viewModel.departureDataArray.indices, id: \.self) { index in
                            VStack(alignment: .leading, spacing: 0) {
                                HStack(alignment: .top) {
                                    Image("icon_dots_group")
                                        .frame(width: 14, height: 16)
                                        .scaledToFit()
                                        .aspectRatio(contentMode: .fit)
                                    
                                    Text(viewModel.departureDataArray[index].name)
                                        .foregroundColor(Color.theme.eerieBlack)
                                        .font(.custom("Inter-Regular", size: 16))
                                    
                                    ForEach(viewModel.departureDataArray[index].tags) { tag in
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
                            .padding(12)
                            .frame(maxWidth: geoWidth, alignment: .leading)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(self.backgroundColor(for: viewModel.departureDataArray[index].isDefault))
                            .swipeActions(allowsFullSwipe: false) {
                                if !viewModel.departureDataArray[index].isDefault {
                                    Button(role: .destructive) {
                                        viewModel.removeItemDeparture(item: viewModel.departureDataArray[index])
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
                                    viewModel.addDepartureQR(item: viewModel.departureDataArray[index])
                                    viewModel.departureDataArray[index].isDefault = true
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
                        .frame(height: CGFloat(viewModel.departureDataArray.count * 45))
                        .padding(.bottom, 5)
                }.layoutPriority(1)
                    .background(Color.white)
                // end list
                Rectangle().fill(Color.theme.lightGray).frame(height: 1)
            }
            
            DepartureForm(
                tagList: self.$depTags,
                itemList: $viewModel.departureDataArray,
                resetData: self.resetData,
                currentIndex: $currentIndex
            ).frame(height: 98)
        }
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        print("Move");
        viewModel.departureDataArray.move(fromOffsets: source, toOffset: destination)
    }
    
    private func resetData() {
        self.depTags = CommonTags().TagList
        
        if self.currentIndex > -1 {
            self.currentIndex = -1
        }
    }
    
    private func backgroundColor(for isDefault: Bool) -> Color {
        return isDefault ? Color.theme.champagne : Color.white
    }
}
