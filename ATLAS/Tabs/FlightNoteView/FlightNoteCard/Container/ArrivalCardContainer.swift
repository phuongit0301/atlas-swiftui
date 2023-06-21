//
//  ArrivalCardContainer.swift
//  ATLAS
//
//  Created by phuong phan on 23/05/2023.
//

import Foundation
import SwiftUI

struct ArrivalCardContainer: View {
    @ObservedObject var viewModel: FlightNoteModelState
    @State var arrivalTags: [ITagStorage] = CommonTags().TagList
    
    @State private var currentIndex: Int = -1
    @State private var showSheet: Bool = false
    @State private var textNote: String = ""
    var header: String = "Arrival Status"
    
    var geoWidth: Double = 0
    
    var body: some View {
        ItemList(
            header: header,
            showSheet: $showSheet,
            currentIndex: $currentIndex,
            itemList: $viewModel.arrivalArray,
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
                    tagList: $arrivalTags,
                    itemList: $viewModel.arrivalArray,
                    currentIndex: $currentIndex,
                    showSheet: $showSheet,
                    resetData: self.resetData
                ).keyboardAdaptive()
                    .interactiveDismissDisabled(true)
            }
    }
    
    private func remove(_ index: Int) {
        viewModel.removeArrival(item: viewModel.arrivalArray[index])
    }
    
    private func addQR(_ index: Int) {
        var item = viewModel.arrivalArray[index]
        item.fromParent = true
        item.canDelete = true
        viewModel.addArrivalQR(item: item)
    }
    
    private func removeQR(_ index: Int) {
        viewModel.removeArrivalQR(item: viewModel.arrivalArray[index])
    }
    
    private func resetData() {
        self.arrivalTags = CommonTags().TagList
        
        if self.currentIndex > -1 {
            self.currentIndex = -1
        }
    }
}

struct ArrivalCardContainer_Previews: PreviewProvider {
    static var previews: some View {
        ArrivalCardContainer(viewModel: FlightNoteModelState())
    }
}
