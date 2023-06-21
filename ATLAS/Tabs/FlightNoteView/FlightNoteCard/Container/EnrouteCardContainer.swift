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
    @State private var showSheet: Bool = false
    @State private var textNote: String = ""
    var header: String = "Enroute Status"
    
    var geoWidth: Double = 0
    
    var body: some View {
        ItemList(
            header: header,
            showSheet: $showSheet,
            currentIndex: $currentIndex,
            itemList: $viewModel.enrouteArray,
            geoWidth: geoWidth,
            remove: remove,
            addQR: addQR,
            removeQR: removeQR
        ).frame(maxHeight: .infinity)
            .padding()
            .background(Color.white)
            .cornerRadius(8)
            .sheet(isPresented: $showSheet) {
                NoteForm(
                    textNote: $textNote,
                    tagList: $enrouteTags,
                    itemList: $viewModel.enrouteArray,
                    currentIndex: $currentIndex,
                    showSheet: $showSheet,
                    resetData: self.resetData
                ).keyboardAdaptive()
                    .interactiveDismissDisabled(true)
            }
    }
    
    private func remove(_ index: Int) {
        viewModel.removeEnroute(item: viewModel.enrouteArray[index])
    }
    
    private func addQR(_ index: Int) {
        viewModel.addEnrouteQR(item: viewModel.enrouteArray[index])
    }
    
    private func removeQR(_ index: Int) {
        viewModel.removeEnrouteQR(item: viewModel.enrouteArray[index])
    }
    
    private func resetData() {
        self.enrouteTags = []
        
        if self.currentIndex > -1 {
            self.currentIndex = -1
        }
    }
}

struct EnrouteCardContainer_Previews: PreviewProvider {
    static var previews: some View {
        EnrouteCardContainer(viewModel: FlightNoteModelState())
    }
}
