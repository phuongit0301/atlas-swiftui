//
//  EnrouteSplit.swift
//  ATLAS
//
//  Created by phuong phan on 29/05/2023.
//

import Foundation
import SwiftUI
    
struct EnrouteSplit: View {
    @EnvironmentObject var viewModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController
    @State var enrouteTags: [ITagStorage] = []
    
    @State private var currentIndex: Int = -1
    @State private var showSheet: Bool = false
    @State private var textNote: String = ""
    var header: String = "Enroute Status"
    var target: String = "enrouteref"
    
    var geoWidth: Double = 0
    
    var body: some View {
        VStack (spacing: 0) {
            HeaderViewSplit(isMenu: true, isNext: true)
            
            VStack(spacing: 0) {
                ItemListSplit(
                    header: header,
                    showSheet: $showSheet,
                    currentIndex: $currentIndex,
                    itemList: $viewModel.enrouteRefArray,
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
                            itemList: $viewModel.enrouteRefArray,
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
        if let found = viewModel.enrouteArray.first(where: {$0.id == viewModel.enrouteRefArray[index].parentId}) {
            found.isDefault = false
        }
        
        viewModel.delete(viewModel.enrouteRefArray[index])
        viewModel.save()
        resetData()
    }
    
    private func updateStatus(_ index: Int) {
        viewModel.enrouteRefArray[index].isDefault.toggle()
        viewModel.save()
        resetData()
    }
    
    private func delete(_ index: Int) {
        if let found = viewModel.enrouteArray.first(where: {$0.id == viewModel.enrouteRefArray[index].parentId}) {
            found.isDefault = false
        }
        
        viewModel.delete(viewModel.enrouteRefArray[index])
        viewModel.save()
        resetData()
    }
    
    private func resetData() {
        viewModel.enrouteArray = viewModel.read("enroute")
        viewModel.enrouteRefArray = viewModel.read("enrouteref")
        
        if self.currentIndex > -1 {
            self.currentIndex = -1
        }
    }
}
