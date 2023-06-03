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
    var geoWidth: Double = 0
    
    @State var aircraftTags: [ITag] = []
    
    var body: some View {
        VStack(spacing: 0) {
            if !viewModel.aircraftData.isEmpty {
                VStack(spacing: 0) {
                    List {
                        ForEach(viewModel.aircraftData, id: \.self) { item in
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
                            .frame(maxWidth: geoWidth, alignment: .leading)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.white)
                            .swipeActions(allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    viewModel.removeItemAircraft(item: item)
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
                                    viewModel.addAircraftQR(item: item)
                                } label: {
                                    Image(systemName: "tag.fill")
                                        .frame(width: 16, height: 16)
                                        .scaledToFit()
                                        .aspectRatio(contentMode: .fit)
                                }
                                .tint(Color.theme.eerieBlack)
                            }
                        }.onMove(perform: move)
                    }
                    .listStyle(.plain)
                    .listRowBackground(Color.white)
                    .frame(height: CGFloat($viewModel.aircraftData.count * 45))
                }.layoutPriority(1)

                Rectangle().fill(Color.theme.lightGray).frame(height: 1)
            }
            
            DepartureForm(tagList: self.$aircraftTags, itemList: self.$viewModel.aircraftData, resetData: self.resetData).frame(height: 98)
        }
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        print("Move");
        viewModel.aircraftData.move(fromOffsets: source, toOffset: destination)
    }
    
    private func resetData() {
        self.aircraftTags = []
    }
    
    private func backgroundColor(for isDefault: Bool) -> Color {
        return isDefault ? Color.theme.champagne : Color.white
    }
}
