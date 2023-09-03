//
//  ArrivalSplit.swift
//  ATLAS
//
//  Created by phuong phan on 29/05/2023.
//

import Foundation
import SwiftUI
    
struct ArrivalSplit: View {
    @State var item: ListFlightInformationItem?
    @EnvironmentObject var viewModel: CoreDataModelState
    
    @State private var currentIndex: Int = -1
    @State private var showSheet: Bool = false
    @State private var textNote: String = ""
    var header: String = "Arrival"
    var target: String = "arrivalref"
    
    var geoWidth: Double = 0
    
    var body: some View {
        VStack (spacing: 0) {
            HeaderViewSplit(isMenu: true, isNext: true, item: item)
            
            VStack(spacing: 0) {
                ItemListSplit(
                    header: header,
                    showSheet: $showSheet,
                    currentIndex: $currentIndex,
                    itemList: $viewModel.arrivalRefArray,
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
                            itemList: $viewModel.arrivalRefArray,
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
        if let found = viewModel.arrivalArray.first(where: {$0.id == viewModel.arrivalRefArray[index].parentId}) {
            found.isDefault = false
        }
        
        viewModel.delete(viewModel.arrivalRefArray[index])
        viewModel.save()
        resetData()
    }
    
    private func updateStatus(_ index: Int) {
        viewModel.arrivalRefArray[index].isDefault.toggle()
        viewModel.save()
        resetData()
    }
    
    private func delete(_ index: Int) {
        if let found = viewModel.arrivalArray.first(where: {$0.id == viewModel.arrivalRefArray[index].parentId}) {
            found.isDefault = false
        }
        
        viewModel.delete(viewModel.arrivalRefArray[index])
        viewModel.save()
        resetData()
    }
    
    private func resetData() {
        viewModel.arrivalArray = viewModel.read("arrival")
        viewModel.arrivalRefArray = viewModel.read("arrivalref")
        
        if self.currentIndex > -1 {
            self.currentIndex = -1
        }
    }
}
