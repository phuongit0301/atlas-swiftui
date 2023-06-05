//
//  DepartureSplitContainer.swift
//  ATLAS
//
//  Created by phuong phan on 29/05/2023.
//

import Foundation
import SwiftUI

struct DepartureSplitContainer: View {
    @ObservedObject var viewModel: FlightNoteModelState
    @State var depTags: [ITagStorage] = DepartureTags().TagList
    
    var geoWidth: Double = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Departure")
                .foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-SemiBold", size: 20))
            
            Rectangle().fill(Color.theme.cultured).frame(height: 16)
            
            HStack(spacing: 0) {
                Text("Departure")
                    .font(.custom("Inter-SemiBold", size: 16))
                    .foregroundColor(Color.theme.eerieBlack)
                
                Spacer()
            }.frame(maxWidth: .infinity)
            .padding()
            .background(Color.white)
            .roundedCorner(8, corners: [.topLeft, .topRight])
            
            Rectangle().fill(Color.theme.eerieBlack).frame(height: 1)
            
            if !viewModel.departureQRDataArray.isEmpty {
                VStack(spacing: 0) {
                    List {
                        ForEach(viewModel.departureQRDataArray) { item in
                            VStack(alignment: .leading, spacing: 0) {
                                HStack(alignment: .top) {
                                    Image("icon_dots_group")
                                        .frame(width: 14, height: 16)
                                        .scaledToFit()
                                        .aspectRatio(contentMode: .fit)
                                    
                                    Text(item.name)
                                        .foregroundColor(Color.theme.eerieBlack)
                                        .font(.custom("Inter-Regular", size: 16))
                                    
//                                    ForEach(item.tags) { tag in
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
                                .listRowBackground(self.backgroundColor(for: item.isDefault))
                                .swipeActions(allowsFullSwipe: false) {
                                    Button(role: .destructive) {
                                        viewModel.removeItemDepartureQR(item: item)
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
                                        print("Tag")
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
                        .listRowBackground(Color.white)
                        .frame(height: CGFloat(viewModel.departureQRDataArray.count * 45))
                }.layoutPriority(1)
                    .Print("viewModel.departureQRDataArray=====\(viewModel.departureQRDataArray)")
                // end list
                
                Rectangle().fill(Color.theme.lightGray).frame(height: 1)
            }
            
            DepartureSplitForm(tagList: self.$depTags, itemList: $viewModel.departureQRDataArray, resetData: self.resetData).frame(height: 98)
            
            Spacer()
        }.padding()
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        print("Move");
        viewModel.departureQRDataArray.move(fromOffsets: source, toOffset: destination)
    }
    
    private func resetData() {
        self.depTags = DepartureTags().TagList
    }
    
    private func backgroundColor(for isDefault: Bool) -> Color {
        return Color.white
    }
}
