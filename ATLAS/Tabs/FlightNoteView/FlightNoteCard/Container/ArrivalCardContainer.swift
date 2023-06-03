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
    @State var arrivalTags: [ITag] = ArrivalTags().TagList

    var geoWidth: Double = 0
    
    var body: some View {
        VStack(spacing: 0) {
            if !viewModel.arrivalData.isEmpty {
                VStack(spacing: 0) {
                    List {
                        ForEach(viewModel.arrivalData, id: \.self) { item in
                            VStack(alignment: .leading, spacing: 0) {
                                HStack(alignment: .top) {
                                    Image("icon_dots_group")
                                        .frame(width: 14, height: 16)
                                        .scaledToFit()
                                        .aspectRatio(contentMode: .fit)
                                    
                                    Text(item.name)
                                        .foregroundColor(Color.theme.eerieBlack)
                                        .font(.custom("Inter-Regular", size: 16))
                                        .lineLimit(1)
                                        .fixedSize(horizontal: false, vertical: true)
                                    
                                    
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
                            }.padding(12)
                                .frame(maxWidth: geoWidth, alignment: .leading)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets())
                                .listRowBackground(self.backgroundColor(for: item.isDefault))
                                .swipeActions(allowsFullSwipe: false) {
                                    Button(role: .destructive) {
                                        viewModel.removeItemArrival(item: item)
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
                                    
                                    Button {
                                        viewModel.addArrivalQR(item: item)
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
                        .frame(height: CGFloat(viewModel.arrivalData.count * 45))
                }.layoutPriority(1)
                // end list
                Rectangle().fill(Color.theme.lightGray).frame(height: 1)
            }

            DepartureForm(tagList: self.$arrivalTags, itemList: $viewModel.arrivalData, resetData: self.resetData).frame(height: 98)
            
        }
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        print("Move");
        viewModel.arrivalData.move(fromOffsets: source, toOffset: destination)
    }
    
    private func resetData() {
        self.arrivalTags = ArrivalTags().TagList
    }
    
    private func backgroundColor(for isDefault: Bool) -> Color {
        return isDefault ? Color.theme.champagne : Color.white
    }
}
