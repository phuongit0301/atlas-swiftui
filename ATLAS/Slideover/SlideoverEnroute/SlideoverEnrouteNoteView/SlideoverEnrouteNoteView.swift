//
//  SlideoverEnrouteNoteView.swift
//  ATLAS
//
//  Created by phuong phan on 29/09/2023.
//

import SwiftUI

struct SlideoverEnrouteNoteView: View {
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
            SlideoverEnrouteNoteItemList(
                header: header,
                currentIndex: $currentIndex,
                itemList: $viewModel.enrouteRefArray,
                isShowList: $isShowListNote,
                geoWidth: width,
                resetData: resetData
            ).frame(maxHeight: .infinity)
                .padding(.horizontal)
                .background(Color.white)
                .cornerRadius(8)
            
            SlideoverEnrouteNoteRelevantList(
                header: "Relevant AABBA Posts",
                showModalComment: $showModalComment,
                currentIndex: $currentIndex,
                itemList: $viewModel.dataPostEnrouteRef,
                isShowList: $isShowListRelevent,
                postIndex: $postIndex,
                geoWidth: width,
                resetData: resetData
            ).frame(maxHeight: .infinity)
                .padding(.horizontal)
                .background(Color.white)
                .cornerRadius(8)
        }
    }
    
    private func resetData() {
        viewModel.dataPostEnroute = viewModel.readDataPostList("enroute", "")
        viewModel.dataPostEnrouteRef = viewModel.readDataPostList("enroute", "ref")
        viewModel.enrouteArray = viewModel.read("enroute")
        viewModel.enrouteRefArray = viewModel.read("enrouteref")
        
        if self.currentIndex > -1 {
            self.currentIndex = -1
        }
    }
}

