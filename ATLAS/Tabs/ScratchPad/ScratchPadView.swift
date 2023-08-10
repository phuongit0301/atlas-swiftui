//
//  ScratchPad.swift
//  ATLAS
//
//  Created by phuong phan on 27/06/2023.
//

import SwiftUI

struct ScratchPadView: View {
    @EnvironmentObject var viewModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController
    // Custom Back button
    @Environment(\.dismiss) private var dismiss
    
    @State private var currentIndex: Int = -1
    @State private var showSheet: Bool = false
    @State private var showSheetEdit: Bool = false
    @State var pasteboard = UIPasteboard.general
    var header: String = "Scratchpad"
    
    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { proxy in
                ItemListScratchPad(
                    header: header,
                    showSheet: $showSheet,
                    showSheetEdit: $showSheetEdit,
                    currentIndex: $currentIndex,
                    itemList: $viewModel.scratchPadArray,
                    geoWidth: proxy.size.width,
                    delete: delete,
                    pasteboard: $pasteboard
                ).sheet(isPresented: $showSheet) {
                        ScratchPadForm(
                            itemList: $viewModel.scratchPadArray,
                            currentIndex: $currentIndex,
                            showSheet: $showSheet,
                            resetData: self.resetData
                        ).interactiveDismissDisabled(true)
                    }
                    .sheet(isPresented: $showSheetEdit) {
                        ScratchPadEditForm(
                            itemList: $viewModel.scratchPadArray,
                            currentIndex: $currentIndex,
                            showSheetEdit: $showSheetEdit,
                            resetData: self.resetData,
                            pasteboard: $pasteboard
                        ).interactiveDismissDisabled(true)
                    }
            }
        }
    }
    
    func update(_ index: Int) {
        
    }
    
    func delete(_ index: Int) {
        viewModel.delete(viewModel.scratchPadArray[index])
        viewModel.save()
        resetData()
    }
    
    private func resetData() {
        if self.currentIndex > -1 {
            self.currentIndex = -1
        }
        viewModel.scratchPadArray = viewModel.readScratchPad()
    }
}

struct ScratchPadView_Previews: PreviewProvider {
    static var previews: some View {
        ScratchPadView()
    }
}
