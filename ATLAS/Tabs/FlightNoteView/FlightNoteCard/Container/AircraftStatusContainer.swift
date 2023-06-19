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
    @State var aircraftTags: [ITagStorage] = []
    
    @State private var currentIndex: Int = -1
    
    var geoWidth: Double = 0
    
    var body: some View {
        VStack(spacing: 0) {
            if !viewModel.aircraftDataArray.isEmpty {
                VStack(spacing: 0) {
                    List {
                        ForEach(viewModel.aircraftDataArray.indices, id: \.self) { index in
                            VStack(alignment: .leading, spacing: 0) {
                                HStack(alignment: .top) {
                                    Image(systemName: "line.3.horizontal")
                                        .foregroundColor(Color.theme.arsenic.opacity(0.3))
                                        .frame(width: 22, height: 22)
                                        .scaledToFit()
                                        .aspectRatio(contentMode: .fit)
                                    
                                    Text(viewModel.aircraftDataArray[index].name)
                                        .foregroundColor(Color.theme.eerieBlack)
                                        .font(.custom("Inter-Regular", size: 16))
                                }
                            }
                            .padding(12)
                            .frame(maxWidth: geoWidth, alignment: .leading)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(self.backgroundColor(isDefault: viewModel.aircraftDataArray[index].isDefault, canDelete: viewModel.aircraftDataArray[index].canDelete))
                            .swipeActions(allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    viewModel.removeItemAircraft(item: viewModel.aircraftDataArray[index])
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
                                Button {
                                    viewModel.addAircraftQR(item: viewModel.aircraftDataArray[index])
                                    viewModel.aircraftDataArray[index].isDefault = true
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
                    .listRowBackground(Color.white)
                    .padding(.bottom, 5)
                }.background(Color.white)
                // end list
                Rectangle().fill(Color.theme.lightGray).frame(height: 1)
            }
            
            DepartureForm(
                tagList: self.$aircraftTags,
                itemList: $viewModel.aircraftDataArray,
                resetData: self.resetData,
                currentIndex: $currentIndex,
                isShowTagBtn: false
            ).frame(height: 98)
        }
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        print("Move");
        viewModel.aircraftDataArray.move(fromOffsets: source, toOffset: destination)
    }
    
    private func resetData() {
        self.aircraftTags = []
        
        if self.currentIndex > -1 {
            self.currentIndex = -1
        }
    }
    
    private func backgroundColor(isDefault: Bool, canDelete: Bool) -> Color {
        return isDefault ? Color.theme.champagne : Color.white
    }
}
