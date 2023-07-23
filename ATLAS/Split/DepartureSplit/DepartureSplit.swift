//
//  DepartureSplit.swift
//  ATLAS
//
//  Created by phuong phan on 29/05/2023.
//

import Foundation
import SwiftUI
    
struct DepartureSplit: View {
    @State var item: ListFlightInformationItem?
    @EnvironmentObject var viewModel: CoreDataModelState
    
    @State private var currentIndex: Int = -1
    @State private var showSheet: Bool = false
    @State private var textNote: String = ""
    var header: String = "Departure Status"
    var target: String = "departureref"
    
    var geoWidth: Double = 0
    
    var body: some View {
        VStack (spacing: 0) {
            HeaderViewSplit(isMenu: true, isNext: true, item: item)
            
            VStack(spacing: 0) {
                ItemListSplit(
                    header: header,
                    showSheet: $showSheet,
                    currentIndex: $currentIndex,
                    itemList: $viewModel.departureRefArray,
                    geoWidth: geoWidth,
                    update: update,
                    updateStatus: updateStatus,
                    delete: delete
                ).frame(maxHeight: .infinity)
                    .background(Color.white)
                    .cornerRadius(8)
                    .sheet(isPresented: $showSheet) {
                        NoteFormSplit(
                            textNote: $textNote,
                            tagList: $viewModel.tagList,
                            itemList: $viewModel.departureRefArray,
                            currentIndex: $currentIndex,
                            showSheet: $showSheet,
                            target: target,
                            resetData: self.resetData
                        ).interactiveDismissDisabled(true)
                    }
            }.padding()
        }.background(Color.theme.antiFlashWhite)
            .navigationBarBackButtonHidden()
            .ignoresSafeArea()
    }
    
    private func update(_ index: Int) {
        if let found = viewModel.departureArray.first(where: {$0.id == viewModel.departureRefArray[index].parentId}) {
            found.isDefault = false
        }
        
        viewModel.delete(viewModel.departureRefArray[index])
        viewModel.save()
        resetData()
    }
    
    private func updateStatus(_ index: Int) {
        viewModel.departureRefArray[index].isDefault.toggle()
        viewModel.save()
        resetData()
    }
    
    private func delete(_ index: Int) {
        if let found = viewModel.departureArray.first(where: {$0.id == viewModel.departureRefArray[index].parentId}) {
            found.isDefault = false
        }
        
        viewModel.delete(viewModel.departureRefArray[index])
        viewModel.save()
        resetData()
    }
    
    private func resetData() {
        viewModel.departureArray = viewModel.read("departure")
        viewModel.departureRefArray = viewModel.read("departureref")
        
        if self.currentIndex > -1 {
            self.currentIndex = -1
        }
    }
}
