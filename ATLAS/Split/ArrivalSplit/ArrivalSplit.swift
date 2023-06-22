//
//  ArrivalSplit.swift
//  ATLAS
//
//  Created by phuong phan on 29/05/2023.
//

import Foundation
import SwiftUI
    
struct ArrivalSplit: View {
    @EnvironmentObject var viewModel: FlightNoteModelState
    @State var arrivalTags: [ITagStorage] = []
    
    @State private var currentIndex: Int = -1
    @State private var showSheet: Bool = false
    @State private var textNote: String = ""
    var header: String = "Arrival Status"
    
    var geoWidth: Double = 0
    
    var body: some View {
        VStack (spacing: 0) {
            HeaderViewSplit(isMenu: true, isNext: true)
            
            VStack(spacing: 0) {
                ItemListSplit(
                    header: header,
                    showSheet: $showSheet,
                    currentIndex: $currentIndex,
                    itemList: $viewModel.arrivalQRArray,
                    geoWidth: geoWidth,
                    update: update
                ).frame(maxHeight: .infinity)
                    .background(Color.white)
                    .cornerRadius(8)
                    .sheet(isPresented: $showSheet) {
                        NoteFormSplit(
                            textNote: $textNote,
                            tagList: $arrivalTags,
                            itemList: $viewModel.arrivalQRArray,
                            currentIndex: $currentIndex,
                            showSheet: $showSheet,
                            resetData: self.resetData
                        ).interactiveDismissDisabled(true)
                    }
            }.padding()
        }.background(Color.theme.antiFlashWhite)
            .navigationBarBackButtonHidden()
            .ignoresSafeArea()
    }
    
    private func update(_ index: Int) {
        viewModel.updateArrival(item: viewModel.arrivalQRArray[index])
        viewModel.removeArrivalQR(item: viewModel.arrivalQRArray[index])
    }
    
    private func resetData() {
        self.arrivalTags = []
        
        if self.currentIndex > -1 {
            self.currentIndex = -1
        }
    }
}
