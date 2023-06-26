//
//  AircraftStatusContainer.swift
//  ATLAS
//
//  Created by phuong phan on 23/05/2023.
//

import Foundation
import SwiftUI

struct AircraftStatusContainer: View {
    @ObservedObject var viewModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController
    
    @State private var currentIndex: Int = -1
    @State private var showSheet: Bool = false
    @State private var textNote: String = ""
    var header: String = "Aircraft Status"
    var target: String = "aircraft"
    
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
                    tagList: $viewModel.tagList,
                    itemList: $viewModel.aircraftArray,
                    currentIndex: $currentIndex,
                    showSheet: $showSheet,
                    target: target,
                    resetData: self.resetData
                ).keyboardAdaptive()
                    .interactiveDismissDisabled(true)
            }
    }
    
    private func remove(_ item: NoteList) {
        viewModel.delete(item)
        viewModel.save()
        resetData()
    }
    
    private func addQR(_ index: Int) {
        let data = viewModel.aircraftArray[index]
        let item = NoteList(context: persistenceController.container.viewContext)
        item.id = UUID()
        item.name = data.name
        item.isDefault = false
        item.canDelete = true
        item.fromParent = true
        item.target = "aircraftref"
        item.parentId = data.id

        if let tags = data.tags {
            item.addToTags(tags)
        }
        
        data.isDefault = true
        viewModel.save()
        resetData()
    }
    
    private func removeQR(_ index: Int) {
        viewModel.aircraftArray[index].isDefault = false
        
        if let found = viewModel.aircraftRefArray.first(where: {$0.parentId == viewModel.aircraftArray[index].id}) {
            viewModel.delete(found)
        }
        viewModel.save()
        resetData()
    }
    
    private func resetData() {
        viewModel.aircraftArray = viewModel.read("aircraft")
        viewModel.aircraftRefArray = viewModel.read("aircraftref")
        
        if self.currentIndex > -1 {
            self.currentIndex = -1
        }
    }
}

struct AircraftStatusContainer_Previews: PreviewProvider {
    static var previews: some View {
        AircraftStatusContainer(viewModel: CoreDataModelState())
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
