//
//  ClipboardCrewBriefingNoteView.swift
//  ATLAS
//
//  Created by phuong phan on 29/09/2023.
//

import SwiftUI

struct ClipboardCrewBriefingNoteView: View {
    @EnvironmentObject var viewModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController
    
    let width: CGFloat
    
    @State private var currentIndex: Int = -1
    @State private var showSheet: Bool = false
    @State private var isShowListNote: Bool = true
    
    @State private var textNote: String = ""
    @State private var itemList = [NoteList]()
    var header: String = "Your Notes"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ClipboardCrewBriefingNoteItemList(
                header: header,
                showSheet: $showSheet,
                currentIndex: $currentIndex,
                itemList: $viewModel.noteListIncludeCrew,
                isShowList: $isShowListNote,
                geoWidth: width,
                resetData: resetData
            ).frame(maxHeight: .infinity)
                .background(Color.white)
                .cornerRadius(8)
        }.sheet(isPresented: $showSheet) {
            NoteItemForm(
                textNote: $textNote,
                tagList: $viewModel.tagList,
                itemList: $viewModel.preflightRefArray,
                currentIndex: $currentIndex,
                showSheet: $showSheet,
                type: "preflight",
                resetData: resetData,
                isCreateFromClipboard: true
            ).interactiveDismissDisabled(true)
        }
    }
    
    private func resetData() {
        viewModel.noteListIncludeCrew = viewModel.readNoteListIncludeCrew()
        viewModel.preflightArray = viewModel.read("preflight")
        viewModel.departureArray = viewModel.read("departure")
        viewModel.enrouteArray = viewModel.read("enroute")
        viewModel.arrivalArray = viewModel.read("arrival")
        viewModel.preflightRefArray = viewModel.read("preflightref")
        viewModel.departureRefArray = viewModel.read("departureref")
        viewModel.enrouteRefArray = viewModel.read("enrouteref")
        viewModel.arrivalRefArray = viewModel.read("arrivalref")
        
        if self.currentIndex > -1 {
            self.currentIndex = -1
        }
    }
}

