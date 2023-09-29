//
//  ClipboardNoteView.swift
//  ATLAS
//
//  Created by phuong phan on 25/09/2023.
//

import SwiftUI

struct ClipboardNoteView: View {
    @EnvironmentObject var viewModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController
    
    let width: CGFloat
    
    @State var parentIndex = 0
    @State var postIndex = 0
    @State private var currentIndex: Int = -1
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
                currentIndex: $currentIndex,
                itemList: $viewModel.preflightRefArray,
                isShowList: $isShowListNote,
                geoWidth: width,
                resetData: resetData
            ).frame(maxHeight: .infinity)
                .padding(.horizontal)
                .background(Color.white)
                .cornerRadius(8)
            
            ClipboardNoteItemRelevantList(
                header: "Relevant AABBA Posts",
                showModalComment: $showModalComment,
                currentIndex: $currentIndex,
                itemList: $viewModel.dataPostPreflightRef,
                isShowList: $isShowListRelevent,
                postIndex: $postIndex,
                geoWidth: width,
                resetData: resetData
            ).frame(maxHeight: .infinity)
                .padding(.horizontal)
                .background(Color.white)
                .cornerRadius(8)
        }.sheet(isPresented: $showModalComment) {
            ModalNoteCommentView(isShowing: $showModalComment, parentIndex: $parentIndex, postIndex: $postIndex, posts: $viewModel.dataPostPreflightRef).interactiveDismissDisabled(true)
        }
    }
    
    private func resetData() {
        viewModel.dataPostPreflight = viewModel.readDataPostList("preflight", "")
        viewModel.dataPostPreflightRef = viewModel.readDataPostList("preflight", "ref")
        viewModel.preflightArray = viewModel.read("preflight")
        viewModel.preflightRefArray = viewModel.read("preflightref")
        
        if self.currentIndex > -1 {
            self.currentIndex = -1
        }
    }
}
