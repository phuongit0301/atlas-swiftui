//
//  AircraftReferenceContainer.swift
//  ATLAS
//
//  Created by phuong phan on 23/05/2023.
//

import Foundation
import SwiftUI

struct AircraftReferenceContainer: View {
    @EnvironmentObject var viewModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController
    // Custom Back button
    @Environment(\.dismiss) private var dismiss
    
    @State private var currentIndex: Int = -1
    @State private var showSheet: Bool = false
    @State private var textNote: String = ""
    var header: String = "Aircraft Status"
    var target: String = "aircraftref"
    
    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { proxy in
                ItemListReference(
                    header: header,
                    showSheet: $showSheet,
                    currentIndex: $currentIndex,
                    itemList: $viewModel.aircraftRefArray,
                    geoWidth: proxy.size.width,
                    update: update,
                    updateStatus: updateStatus,
                    delete: delete
                ).frame(maxHeight: .infinity)
                    .sheet(isPresented: $showSheet) {
                        NoteReferenceForm(
                            textNote: $textNote,
                            tagList: $viewModel.tagList,
                            itemList: $viewModel.aircraftRefArray,
                            currentIndex: $currentIndex,
                            showSheet: $showSheet,
                            target: target,
                            resetData: self.resetData
                        ).keyboardAdaptive()
                            .interactiveDismissDisabled(true)
                    }
                    
            }
        }
    }
    
    private func update(_ index: Int) {
        if let found = viewModel.aircraftArray.first(where: {$0.id == viewModel.aircraftRefArray[index].parentId}) {
            found.isDefault = false
            viewModel.delete(viewModel.aircraftRefArray[index])
        } else {
            viewModel.aircraftRefArray[index].isDefault = false
        }
        
        viewModel.save()
        resetData()
    }
    
    private func updateStatus(_ index: Int) {
        viewModel.aircraftRefArray[index].isDefault.toggle()
        viewModel.save()
        resetData()
    }
    
    private func delete(_ index: Int) {
        viewModel.delete(viewModel.aircraftRefArray[index])
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

struct AircraftReferenceContainer_Previews: PreviewProvider {
    static var previews: some View {
        AircraftReferenceContainer().environmentObject(FlightNoteModelState())
            .environmentObject(SideMenuModelState())
    }
}
