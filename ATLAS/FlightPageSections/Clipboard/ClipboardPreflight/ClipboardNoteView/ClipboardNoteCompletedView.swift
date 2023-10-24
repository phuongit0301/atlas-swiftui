//
//  ClipboardNoteCompletedView.swift
//  ATLAS
//
//  Created by phuong phan on 25/09/2023.
//

import SwiftUI

struct ClipboardNoteCompletedView: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController
    
    let width: CGFloat
    
    @State var parentIndex = 0
    @State var postIndex = 0
    @State private var currentIndex: Int = -1
    @State private var showSheet: Bool = false
    @State private var isShowListNote: Bool = true
    @State private var isShowListRelevent: Bool = true
    @State private var showModalComment: Bool = false
    
    @State private var textNote: String = ""
    @State private var itemList = [NoteList]()
    var header: String = "Your Notes"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ClipboardNoteCompletedItemList(
                header: header,
                showSheet: $showSheet,
                currentIndex: $currentIndex,
                itemList: $coreDataModel.preflightRefArray,
                isShowList: $isShowListNote,
                geoWidth: width,
                resetData: resetData
            ).frame(maxHeight: .infinity)
                .background(Color.white)
                .cornerRadius(8)
            
            ClipboardNoteCompletedItemRelevantList(
                header: "Relevant AABBA Posts",
                showModalComment: $showModalComment,
                currentIndex: $currentIndex,
                itemList: $coreDataModel.dataPostPreflightRef,
                isShowList: $isShowListRelevent,
                postIndex: $postIndex,
                geoWidth: width,
                resetData: resetData
            ).frame(maxHeight: .infinity)
                .background(Color.white)
                .cornerRadius(8)
        }.onAppear {
            resetData()
        }
    }
    
    private func resetData() {
        coreDataModel.dataPostPreflight = coreDataModel.readDataPostList("preflight", "")
        coreDataModel.dataPostPreflightRef = coreDataModel.readDataPostList("preflight", "ref")
        coreDataModel.preflightArray = coreDataModel.read("preflight")
        coreDataModel.preflightRefArray = coreDataModel.readClipBoard("preflight")
        
        if self.currentIndex > -1 {
            self.currentIndex = -1
        }
    }
}
