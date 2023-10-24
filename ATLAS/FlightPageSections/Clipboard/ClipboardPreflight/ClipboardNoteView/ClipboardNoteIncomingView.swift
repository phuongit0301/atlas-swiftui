//
//  ClipboardNoteIncomingView.swift
//  ATLAS
//
//  Created by phuong phan on 25/09/2023.
//

import SwiftUI

struct ClipboardNoteIncomingView: View {
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
            ClipboardNoteItemList(
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
            
            ClipboardNoteItemRelevantList(
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
        }.sheet(isPresented: $showModalComment) {
            ModalNoteCommentView(isShowing: $showModalComment, parentIndex: $parentIndex, postIndex: $postIndex, posts: $coreDataModel.dataPostPreflightRef).interactiveDismissDisabled(true)
        }.sheet(isPresented: $showSheet) {
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
