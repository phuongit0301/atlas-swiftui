//
//  ClipboardDepartureNoteView.swift
//  ATLAS
//
//  Created by phuong phan on 29/09/2023.
//

import SwiftUI

struct ClipboardDepartureNoteView: View {
    @EnvironmentObject var viewModel: CoreDataModelState
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
            ClipboardDepartureNoteItemList(
                header: header,
                showSheet: $showSheet,
                currentIndex: $currentIndex,
                itemList: $viewModel.departureRefArray,
                isShowList: $isShowListNote,
                geoWidth: width,
                resetData: resetData
            ).frame(maxHeight: .infinity)
                .background(Color.white)
                .cornerRadius(8)
            
            ClipboardDepartureNoteRelevantList(
                header: "Relevant AABBA Posts",
                showModalComment: $showModalComment,
                currentIndex: $currentIndex,
                itemList: $viewModel.dataPostDepartureRef,
                isShowList: $isShowListRelevent,
                postIndex: $postIndex,
                geoWidth: width,
                resetData: resetData
            ).frame(maxHeight: .infinity)
                .background(Color.white)
                .cornerRadius(8)
        }.sheet(isPresented: $showModalComment) {
            ModalNoteCommentView(isShowing: $showModalComment, parentIndex: $parentIndex, postIndex: $postIndex, posts: $viewModel.dataPostDepartureRef).interactiveDismissDisabled(true)
        }.sheet(isPresented: $showSheet) {
            NoteItemForm(
                textNote: $textNote,
                tagList: $viewModel.tagList,
                itemList: $viewModel.departureRefArray,
                currentIndex: $currentIndex,
                showSheet: $showSheet,
                type: "departure",
                resetData: resetData,
                isCreateFromClipboard: true
            ).interactiveDismissDisabled(true)
        }
    }
    
    private func resetData() {
        viewModel.dataPostDeparture = viewModel.readDataPostList("departure", "")
        viewModel.dataPostDepartureRef = viewModel.readDataPostList("departure", "ref")
        viewModel.departureArray = viewModel.read("departure")
        viewModel.departureRefArray = viewModel.read("departureref")
        
        if self.currentIndex > -1 {
            self.currentIndex = -1
        }
    }
}

