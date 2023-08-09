//
//  ArrivalCardContainer.swift
//  ATLAS
//
//  Created by phuong phan on 23/05/2023.
//

import Foundation
import SwiftUI

struct ArrivalCardContainer: View {
    @ObservedObject var viewModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController
    
    @State private var currentIndex: Int = -1
    @State private var showSheet: Bool = false
    @State private var textNote: String = ""
    var header: String = "Arrival Status"
    var target: String = "arrival"
    
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
                    tagList: $viewModel.tagList,
                    itemList: $viewModel.arrivalArray,
                    currentIndex: $currentIndex,
                    showSheet: $showSheet,
                    target: target,
                    resetData: self.resetData
                ).interactiveDismissDisabled(true)
            }
    }
    
    private func remove(_ item: NoteList) {
        viewModel.delete(item)
        viewModel.save()
        resetData()
    }
    
    private func addQR(_ index: Int) {
        let data = viewModel.arrivalArray[index]
        let item = NoteList(context: persistenceController.container.viewContext)
        item.id = UUID()
        item.name = data.name
        item.isDefault = false
        item.canDelete = true
        item.fromParent = true
        item.target = "arrivalref"
        item.parentId = data.id

        if let tags = data.tags {
            item.addToTags(tags)
        }
        
        data.isDefault = true
        viewModel.save()
        resetData()
    }
    
    private func removeQR(_ index: Int) {
        viewModel.arrivalArray[index].isDefault = false
        
        if let found = viewModel.arrivalRefArray.first(where: {$0.parentId == viewModel.arrivalArray[index].id}) {
            viewModel.delete(found)
        }
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

struct ArrivalCardContainer_Previews: PreviewProvider {
    static var previews: some View {
        ArrivalCardContainer(viewModel: CoreDataModelState())
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
