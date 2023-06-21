//
//  DepartureCardContainer.swift
//  ATLAS
//
//  Created by phuong phan on 23/05/2023.
//

import Foundation
import SwiftUI

struct DepartureCardContainer: View {
    @ObservedObject var viewModel: FlightNoteModelState
    @State var depTags: [ITagStorage] = CommonTags().TagList
    
    @State private var currentIndex: Int = -1
    @State private var showSheet: Bool = false
    @State private var textNote: String = ""
    var header: String = "Departure Status"
    
    var geoWidth: Double = 0
    
    var body: some View {
        ItemList(
            header: header,
            showSheet: $showSheet,
            currentIndex: $currentIndex,
            itemList: $viewModel.departureArray,
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
                    tagList: $depTags,
                    itemList: $viewModel.departureArray,
                    currentIndex: $currentIndex,
                    showSheet: $showSheet,
                    resetData: self.resetData
                ).keyboardAdaptive()
                    .interactiveDismissDisabled(true)
            }
    }
    
    private func remove(_ index: Int) {
        viewModel.removeDeparture(item: viewModel.departureArray[index])
    }
    
    private func addQR(_ index: Int) {
        var item = viewModel.departureArray[index]
        item.fromParent = true
        item.canDelete = true
        viewModel.addDepartureQR(item: item)
    }
    
    private func removeQR(_ index: Int) {
        viewModel.removeDepartureQR(item: viewModel.departureArray[index])
    }
    
    private func resetData() {
        self.depTags = CommonTags().TagList
        
        if self.currentIndex > -1 {
            self.currentIndex = -1
        }
    }
}

struct DepartureCardContainer_Previews: PreviewProvider {
    static var previews: some View {
        DepartureCardContainer(viewModel: FlightNoteModelState())
    }
}
