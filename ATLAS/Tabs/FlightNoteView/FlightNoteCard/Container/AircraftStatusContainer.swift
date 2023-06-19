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
    @State private var showSheet: Bool = false
    @State private var textNote: String = ""
    
    var geoWidth: Double = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Aircraft Status").foregroundColor(Color.theme.eerieBlack).font(.system(size: 20, weight: .semibold))
                Spacer()
                
                Button(action: {
                    self.showSheet.toggle()
                }) {
                    HStack {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 16, height: 16)
                            .foregroundColor(Color.theme.azure)
                        Text("Add Note").foregroundColor(Color.theme.azure)
                            .font(.system(size: 17, weight: .regular))
                    }
                }
            }.padding(.vertical, 16)
            
            Rectangle().fill(Color.theme.arsenic.opacity(0.36)).frame(height: 1)
            
            if viewModel.aircraftArray.isEmpty {
                VStack(alignment: .leading) {
                    Text("No note saved. Tap on Add Note to save your first note.").foregroundColor(Color.theme.philippineGray2).font(.system(size: 17, weight: .regular)).padding()
                    Rectangle().fill(Color.theme.arsenic.opacity(0.36)).frame(height: 1)
                }
                Spacer()
            } else {
                VStack(spacing: 0) {
                    List {
                        ForEach(viewModel.aircraftArray.indices, id: \.self) { index in
                            VStack(alignment: .leading, spacing: 0) {
                                HStack(alignment: .center) {
                                    Image(systemName: "line.3.horizontal")
                                        .foregroundColor(Color.theme.arsenic.opacity(0.3))
                                        .frame(width: 22, height: 22)
                                        .scaledToFit()
                                        .aspectRatio(contentMode: .fit)
                                    
                                    Text(viewModel.aircraftArray[index].name)
                                        .foregroundColor(Color.theme.eerieBlack)
                                        .font(.system(size: 16, weight: .regular))
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        if (viewModel.aircraftArray[index].isDefault) {
                                            viewModel.removeItemAircraftQR(item: viewModel.aircraftArray[index])
                                            viewModel.aircraftArray[index].isDefault = false
                                        } else {
                                            viewModel.addAircraftQR(item: viewModel.aircraftArray[index])
                                            viewModel.aircraftArray[index].isDefault = true
                                        }
                                    }) {
                                        viewModel.aircraftArray[index].isDefault ?
                                            Image(systemName: "star.fill")
                                                .foregroundColor(Color.theme.azure)
                                                .frame(width: 22, height: 22)
                                                .scaledToFit()
                                                .aspectRatio(contentMode: .fit)
                                        :
                                            Image(systemName: "star")
                                                .foregroundColor(Color.theme.azure)
                                                .frame(width: 22, height: 22)
                                                .scaledToFit()
                                                .aspectRatio(contentMode: .fit)
                                    }
                                }
                            }
                            .padding(12)
                            .frame(maxWidth: geoWidth, alignment: .leading)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.white)
                            .swipeActions(allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    viewModel.removeItemAircraft(item: viewModel.aircraftArray[index])
                                } label: {
                                    Text("Delete").font(.system(size: 15, weight: .medium)).foregroundColor(.white)
                                }.tint(Color.theme.graniteGray)
                                
                                Button {
                                    self.currentIndex = index
                                    self.showSheet.toggle()
                                } label: {
                                    Text("Edit").font(.system(size: 15, weight: .medium)).foregroundColor(.white)
                                }
                                .tint(Color.theme.orangePeel)
                                
                                Button {
                                    viewModel.addAircraftQR(item: viewModel.aircraftArray[index])
                                    viewModel.aircraftArray[index].isDefault = true
                                } label: {
                                    Text("Info").font(.system(size: 15, weight: .medium)).foregroundColor(.white)
                                }
                                .tint(Color.theme.coralRed)
                            }
                        }.onMove(perform: move)
                    }.listStyle(.plain)
                        .listRowBackground(Color.white)
                        .padding(.bottom, 5)
                }
            }
            
        }.frame(maxHeight: .infinity)
            .padding()
            .background(Color.white)
            .cornerRadius(8)
            .sheet(isPresented: $showSheet) {
                NoteForm(
                    textNote: $textNote,
                    tagList: $aircraftTags,
                    itemList: $viewModel.aircraftArray,
                    currentIndex: $currentIndex,
                    showSheet: $showSheet,
                    resetData: self.resetData)
            }
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        print("Move");
        viewModel.aircraftArray.move(fromOffsets: source, toOffset: destination)
    }
    
    private func resetData() {
        self.aircraftTags = []
        
        if self.currentIndex > -1 {
            self.currentIndex = -1
        }
    }
}

struct AircraftStatusContainer_Previews: PreviewProvider {
    static var previews: some View {
        AircraftStatusContainer(viewModel: FlightNoteModelState())
    }
}
