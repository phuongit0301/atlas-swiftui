//
//  ClipboardCrewBriefingNoteView.swift
//  ATLAS
//
//  Created by phuong phan on 29/09/2023.
//

import SwiftUI

struct ClipboardCrewBriefingNoteView: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
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
                itemList: $coreDataModel.noteListIncludeCrew,
                isShowList: $isShowListNote,
                geoWidth: width,
                resetData: resetData
            ).frame(maxHeight: .infinity)
                .background(Color.white)
                .cornerRadius(8)
        }
        .sheet(isPresented: $showSheet) {
            NoteItemForm(
                textNote: $textNote,
                tagList: $coreDataModel.tagList,
                itemList: $coreDataModel.preflightRefArray,
                currentIndex: $currentIndex,
                showSheet: $showSheet,
                type: "preflight",
                resetData: resetData,
                isCreateFromClipboard: true
            ).interactiveDismissDisabled(true)
        }
    }
    
    private func resetData() {
        coreDataModel.noteListIncludeCrew = coreDataModel.readNoteListIncludeCrew()
        coreDataModel.tagListCabinDefects = coreDataModel.readTagByName("Aircraft Status")
        coreDataModel.preflightArray = coreDataModel.read("preflight")
        coreDataModel.departureArray = coreDataModel.read("departure")
        coreDataModel.enrouteArray = coreDataModel.read("enroute")
        coreDataModel.arrivalArray = coreDataModel.read("arrival")
        coreDataModel.preflightRefArray = coreDataModel.readClipBoard("preflight")
        coreDataModel.departureRefArray = coreDataModel.readClipBoard("departure")
        coreDataModel.enrouteRefArray = coreDataModel.readClipBoard("enroute")
        coreDataModel.arrivalRefArray = coreDataModel.readClipBoard("arrival")
        
        if self.currentIndex > -1 {
            self.currentIndex = -1
        }
    }
}

