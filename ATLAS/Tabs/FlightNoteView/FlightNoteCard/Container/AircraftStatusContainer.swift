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
    var header: String = "Aircraft Status"
    
    var geoWidth: Double = 0
    
    var body: some View {
        ItemList(
            header: header,
            showSheet: $showSheet,
            currentIndex: $currentIndex,
            itemList: $viewModel.aircraftArray,
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
                    tagList: $aircraftTags,
                    itemList: $viewModel.aircraftArray,
                    currentIndex: $currentIndex,
                    showSheet: $showSheet,
                    resetData: self.resetData
                ).keyboardAdaptive()
                    .interactiveDismissDisabled(true)
            }
    }
    
    private func remove(_ index: Int) {
        viewModel.removeAircraft(item: viewModel.aircraftArray[index])
    }
    
    private func addQR(_ index: Int) {
        var item = viewModel.aircraftArray[index]
        item.fromParent = true
        item.canDelete = true
        viewModel.addAircraftQR(item: item)
    }
    
    private func removeQR(_ index: Int) {
        viewModel.removeAircraftQR(item: viewModel.aircraftArray[index])
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
