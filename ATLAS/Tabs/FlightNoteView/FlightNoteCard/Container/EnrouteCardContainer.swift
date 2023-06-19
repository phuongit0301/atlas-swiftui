//
//  EnrouteCardContainer.swift
//  ATLAS
//
//  Created by phuong phan on 23/05/2023.
//

import Foundation
import SwiftUI

struct EnrouteCardContainer: View {
    @ObservedObject var viewModel: FlightNoteModelState
    @State var enrouteTags: [ITagStorage] = CommonTags().TagList
    
    @State private var currentIndex: Int = -1
    
    var geoWidth: Double = 0
    
    var body: some View {
        VStack(spacing: 0) {
            if !viewModel.enrouteArray.isEmpty {
                VStack(spacing: 0) {
                    List {
                        ForEach(viewModel.enrouteArray.indices, id: \.self) { index in
                            VStack(alignment: .leading, spacing: 0) {
                                HStack(alignment: .top) {
                                    Image("icon_dots_group")
                                        .frame(width: 14, height: 16)
                                        .scaledToFit()
                                        .aspectRatio(contentMode: .fit)
                                    
                                    Text(viewModel.enrouteArray[index].name)
                                        .foregroundColor(Color.theme.eerieBlack)
                                        .font(.custom("Inter-Regular", size: 16))
                                    
                                    ForEach(viewModel.enrouteArray[index].tags) { tag in
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
                                .listRowBackground(self.backgroundColor(isDefault: viewModel.enrouteArray[index].isDefault, canDelete: viewModel.enrouteArray[index].canDelete))
                                .swipeActions(allowsFullSwipe: false) {
                                    if viewModel.enrouteArray[index].canDelete {
                                        Button(role: .destructive) {
                                            viewModel.removeItemEnroute(item: viewModel.enrouteArray[index])
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
                                        var obj = viewModel.enrouteArray[index]
                                        obj.canDelete = false
                                        
                                        viewModel.addEnrouteQR(item: obj)
                                        viewModel.enrouteArray[index].isDefault = true
                                    } label: {
                                        Image(systemName: "pin.fill")
                                            .frame(width: 16, height: 16)
                                            .scaledToFit()
                                            .aspectRatio(contentMode: .fit)
                                    }
                                    .tint(Color.theme.eerieBlack)
                                }
                        }.onMove(perform: move)
                    }.listStyle(.plain)
                        .listRowBackground(Color.theme.champagne)
                        .padding(.bottom, 5)
                }.background(Color.white)
                // end list
                Rectangle().fill(Color.theme.lightGray).frame(height: 1)
            }
            
            DepartureForm(
                tagList: self.$enrouteTags,
                itemList: $viewModel.enrouteArray,
                resetData: self.resetData,
                currentIndex: $currentIndex
            ).frame(height: 98)
        }
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        print("Move");
        viewModel.enrouteArray.move(fromOffsets: source, toOffset: destination)
    }
    
    private func resetData() {
        self.enrouteTags = CommonTags().TagList
        
        if self.currentIndex > -1 {
            self.currentIndex = -1
        }
    }
    
    private func backgroundColor(isDefault: Bool, canDelete: Bool) -> Color {
        return isDefault ? Color.theme.champagne : Color.white
    }
}
