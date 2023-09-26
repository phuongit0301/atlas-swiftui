//
//  DepartureReferenceContainer.swift
//  ATLAS
//
//  Created by phuong phan on 23/05/2023.
//

import Foundation
import SwiftUI

struct DepartureReferenceContainer: View {
    @EnvironmentObject var viewModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController
    // Custom Back button
    @Environment(\.dismiss) private var dismiss
    
    @State private var currentIndex: Int = -1
    @State private var showSheet: Bool = false
    @State private var textNote: String = ""
    var header: String = "Departure"
    var target: String = "departureref"
    
    var body: some View {
        VStack(spacing: 0) {
            Text("123")
//            GeometryReader { proxy in
//                ItemListReference(
//                    header: header,
//                    showSheet: $showSheet,
//                    currentIndex: $currentIndex,
//                    itemList: $viewModel.departureRefArray,
//                    geoWidth: proxy.size.width,
//                    update: update,
//                    updateStatus: updateStatus,
//                    delete: delete
//                ).frame(maxHeight: .infinity)
//                    .sheet(isPresented: $showSheet) {
//                        NoteReferenceForm(
//                            textNote: $textNote,
//                            tagList: $viewModel.tagList,
//                            itemList: $viewModel.departureRefArray,
//                            currentIndex: $currentIndex,
//                            showSheet: $showSheet,
//                            target: target,
//                            resetData: self.resetData
//                        ).interactiveDismissDisabled(true)
//                    }
//            }
        }
    }
    
//    private func update(_ index: Int) {
//        if let found = viewModel.departureArray.first(where: {$0.id == viewModel.departureRefArray[index].parentId}) {
//            found.isDefault = false
//        }
//        
//        viewModel.delete(viewModel.departureRefArray[index])
//        viewModel.save()
//        resetData()
//    }
//    
//    private func updateStatus(_ index: Int) {
//        viewModel.departureRefArray[index].isDefault.toggle()
//        viewModel.save()
//        resetData()
//    }
//    
//    private func delete(_ index: Int) {
//        if let found = viewModel.departureArray.first(where: {$0.id == viewModel.departureRefArray[index].parentId}) {
//            found.isDefault = false
//        }
//        
//        viewModel.delete(viewModel.departureRefArray[index])
//        viewModel.save()
//        resetData()
//    }
//    
//    private func resetData() {
//        viewModel.departureArray = viewModel.read("departure")
//        viewModel.departureRefArray = viewModel.read("departureref")
//        
//        if self.currentIndex > -1 {
//            self.currentIndex = -1
//        }
//    }
}

struct DepartureReferenceContainer_Previews: PreviewProvider {
    static var previews: some View {
        DepartureReferenceContainer().environmentObject(FlightNoteModelState())
            .environmentObject(SideMenuModelState())
    }
}
