//
//  AircraftSplit.swift
//  ATLAS
//
//  Created by phuong phan on 29/05/2023.
//

import Foundation
import SwiftUI
    
struct AircraftSplit: View {
    @EnvironmentObject var viewModel: FlightNoteModelState
    @State var aircraftTags: [ITagStorage] = []
    
    @State private var currentIndex: Int = -1
    @State private var showSheet: Bool = false
    @State private var textNote: String = ""
    var header: String = "Aircraft Status"
    
    var geoWidth: Double = 0
    
    var body: some View {
        VStack (spacing: 0) {
            HeaderViewSplit(isMenu: true, isNext: true)
            
            VStack(spacing: 0) {
                ItemListSplit(
                    header: header,
                    showSheet: $showSheet,
                    currentIndex: $currentIndex,
                    itemList: $viewModel.aircraftQRArray,
                    geoWidth: geoWidth,
                    update: update
                ).frame(maxHeight: .infinity)
                    .background(Color.white)
                    .cornerRadius(8)
                    .sheet(isPresented: $showSheet) {
                        NoteFormSplit(
                            textNote: $textNote,
                            tagList: $aircraftTags,
                            itemList: $viewModel.aircraftQRArray,
                            currentIndex: $currentIndex,
                            showSheet: $showSheet,
                            resetData: self.resetData
                        ).interactiveDismissDisabled(true)
                    }
            }.padding(.vertical)
        }.padding()
            .background(Color.theme.antiFlashWhite)
            .navigationBarBackButtonHidden()
            .ignoresSafeArea()
    }
    
    private func update(_ index: Int) {
        viewModel.updateAircraft(item: viewModel.aircraftQRArray[index])
        viewModel.removeAircraftQR(item: viewModel.aircraftQRArray[index])
    }
    
    private func resetData() {
        self.aircraftTags = []
        
        if self.currentIndex > -1 {
            self.currentIndex = -1
        }
    }
}
