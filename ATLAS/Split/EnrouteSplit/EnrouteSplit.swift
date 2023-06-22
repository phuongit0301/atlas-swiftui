//
//  EnrouteSplit.swift
//  ATLAS
//
//  Created by phuong phan on 29/05/2023.
//

import Foundation
import SwiftUI
    
struct EnrouteSplit: View {
    @EnvironmentObject var viewModel: FlightNoteModelState
    @State var enrouteTags: [ITagStorage] = []
    
    @State private var currentIndex: Int = -1
    @State private var showSheet: Bool = false
    @State private var textNote: String = ""
    var header: String = "Enroute Status"
    
    var geoWidth: Double = 0
    
    var body: some View {
        VStack (spacing: 0) {
            HeaderViewSplit(isMenu: true, isNext: true)
            
            VStack(spacing: 0) {
                ItemListSplit(
                    header: header,
                    showSheet: $showSheet,
                    currentIndex: $currentIndex,
                    itemList: $viewModel.enrouteQRArray,
                    geoWidth: geoWidth,
                    update: update
                ).frame(maxHeight: .infinity)
                    .background(Color.white)
                    .cornerRadius(8)
                    .sheet(isPresented: $showSheet) {
                        NoteFormSplit(
                            textNote: $textNote,
                            tagList: $enrouteTags,
                            itemList: $viewModel.enrouteQRArray,
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
        viewModel.updateEnroute(item: viewModel.enrouteQRArray[index])
        viewModel.removeEnrouteQR(item: viewModel.enrouteQRArray[index])
    }
    
    private func resetData() {
        self.enrouteTags = []
        
        if self.currentIndex > -1 {
            self.currentIndex = -1
        }
    }
}
