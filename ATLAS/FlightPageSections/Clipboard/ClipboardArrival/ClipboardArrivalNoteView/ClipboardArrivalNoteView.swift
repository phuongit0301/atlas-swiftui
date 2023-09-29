//
//  ClipboardArrivalNoteView.swift
//  ATLAS
//
//  Created by phuong phan on 29/09/2023.
//

import SwiftUI

struct ClipboardArrivalNoteView: View {
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
            ClipboardArrivalNoteItemList(
                header: header,
                currentIndex: $currentIndex,
                itemList: $viewModel.arrivalRefArray,
                isShowList: $isShowListNote,
                geoWidth: width,
                resetData: resetData
            ).frame(maxHeight: .infinity)
                .padding(.horizontal)
                .background(Color.white)
                .cornerRadius(8)
            
            ClipboardArrivalNoteRelevantList(
                header: "Relevant AABBA Posts",
                showModalComment: $showModalComment,
                currentIndex: $currentIndex,
                itemList: $viewModel.dataPostArrivalRef,
                isShowList: $isShowListRelevent,
                postIndex: $postIndex,
                geoWidth: width,
                resetData: resetData
            ).frame(maxHeight: .infinity)
                .padding(.horizontal)
                .background(Color.white)
                .cornerRadius(8)
        }.sheet(isPresented: $showModalComment) {
            ModalNoteCommentView(isShowing: $showModalComment, parentIndex: $parentIndex, postIndex: $postIndex, posts: $viewModel.dataPostArrivalRef).interactiveDismissDisabled(true)
        }
    }
    
    private func resetData() {
        viewModel.dataPostArrival = viewModel.readDataPostList("arrival", "")
        viewModel.dataPostArrivalRef = viewModel.readDataPostList("arrival", "ref")
        viewModel.arrivalArray = viewModel.read("arrival")
        viewModel.arrivalRefArray = viewModel.read("arrivalref")
        
        if self.currentIndex > -1 {
            self.currentIndex = -1
        }
    }
}

