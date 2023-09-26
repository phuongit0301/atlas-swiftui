//
//  ArrivalReferenceContainer.swift
//  ATLAS
//
//  Created by phuong phan on 23/05/2023.
//

import Foundation
import SwiftUI

struct ArrivalReferenceContainer: View {    
    @EnvironmentObject var viewModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController
    // Custom Back button
    @Environment(\.dismiss) private var dismiss
    
    @State private var currentIndex: Int = -1
    @State private var showSheet: Bool = false
    @State private var textNote: String = ""
    var header: String = "Arrival"
    var target: String = "arrivalref"
    
    var body: some View {
        VStack(spacing: 0) {
            Text("123")
//            GeometryReader { proxy in
//                ItemListReference(
//                    header: header,
//                    showSheet: $showSheet,
//                    currentIndex: $currentIndex,
//                    itemList: $viewModel.arrivalRefArray,
//                    geoWidth: proxy.size.width,
//                    update: update,
//                    updateStatus: updateStatus,
//                    delete: delete
//                ).frame(maxHeight: .infinity)
//                    .sheet(isPresented: $showSheet) {
//                        NoteReferenceForm(
//                            textNote: $textNote,
//                            tagList: $viewModel.tagList,
//                            itemList: $viewModel.arrivalRefArray,
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
//        if let found = viewModel.arrivalArray.first(where: {$0.id == viewModel.arrivalRefArray[index].parentId}) {
//            found.isDefault = false
//        }
//
//        viewModel.delete(viewModel.arrivalRefArray[index])
//        viewModel.save()
//        resetData()
//    }
//
//    private func updateStatus(_ index: Int) {
//        viewModel.arrivalRefArray[index].isDefault.toggle()
//        viewModel.save()
//        resetData()
//    }
//
//    private func delete(_ index: Int) {
//        if let found = viewModel.arrivalArray.first(where: {$0.id == viewModel.arrivalRefArray[index].parentId}) {
//            found.isDefault = false
//        }
//
//        viewModel.delete(viewModel.arrivalRefArray[index])
//        viewModel.save()
//        resetData()
//    }
//
//    private func resetData() {
//        viewModel.arrivalArray = viewModel.read("arrival")
//        viewModel.arrivalRefArray = viewModel.read("arrivalref")
//
//        if self.currentIndex > -1 {
//            self.currentIndex = -1
//        }
//    }
}

struct ArrivalReferenceContainer_Previews: PreviewProvider {
    static var previews: some View {
        ArrivalReferenceContainer().environmentObject(FlightNoteModelState())
            .environmentObject(SideMenuModelState())
    }
}
