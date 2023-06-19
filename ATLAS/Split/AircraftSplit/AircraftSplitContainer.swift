//
//  AircraftSplitContainer.swift
//  ATLAS
//
//  Created by phuong phan on 29/05/2023.
//

import Foundation
import SwiftUI

struct AircraftSplitContainer: View {
    @ObservedObject var viewModel: FlightNoteModelState
    @State var aircraftTags: [ITagStorage] = []
    
    @State private var currentIndex: Int = -1
    
    var geoWidth: Double = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Aircraft Status")
                .foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-SemiBold", size: 20))
            
            Rectangle().fill(Color.theme.cultured).frame(height: 16)
            
            HStack(spacing: 0) {
                Text("Aircraft Status")
                    .font(.custom("Inter-SemiBold", size: 16))
                    .foregroundColor(Color.theme.eerieBlack)
                
                Spacer()
            }.frame(maxWidth: .infinity)
            .padding()
            .background(Color.white)
            .roundedCorner(8, corners: [.topLeft, .topRight])
            
            Rectangle().fill(Color.theme.eerieBlack).frame(height: 1)
            
            if !viewModel.aircraftQRArray.isEmpty {
                VStack(alignment: .leading, spacing: 0) {
                    List {
                        ForEach(viewModel.aircraftQRArray.indices, id: \.self) { index in
                            VStack(alignment: .leading, spacing: 0) {
                                HStack(alignment: .top) {
                                    Image("icon_dots_group")
                                        .frame(width: 14, height: 16)
                                        .scaledToFit()
                                        .aspectRatio(contentMode: .fit)
                                    
                                    Text(viewModel.aircraftQRArray[index].name)
                                        .foregroundColor(Color.theme.eerieBlack)
                                        .font(.custom("Inter-Regular", size: 16))
                                        .lineLimit(1)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }.padding(12)
                                .frame(maxWidth: geoWidth, alignment: .leading)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets())
                                .listRowBackground(Color.white)
                                .swipeActions(allowsFullSwipe: false) {
                                    Button(role: .destructive) {
                                        viewModel.removeItemAircraftQR(item: viewModel.aircraftQRArray[index])
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
            
            AirCraftSplitForm(
                tagList: self.$aircraftTags,
                itemList: $viewModel.aircraftQRArray,
                resetData: self.resetData,
                currentIndex: $currentIndex
            ).frame(height: 98)
            
            Spacer()
        }.padding()
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        print("Move");
        viewModel.aircraftQRArray.move(fromOffsets: source, toOffset: destination)
    }
    
    private func resetData() {
        self.aircraftTags = []
        
        if self.currentIndex > -1 {
            self.currentIndex = -1
        }
    }
    
    private func backgroundColor(for isDefault: Bool) -> Color {
        return isDefault ? Color.theme.champagne : Color.white
    }
}

