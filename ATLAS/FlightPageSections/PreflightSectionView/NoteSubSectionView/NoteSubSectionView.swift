//
//  NoteSubSectionView.swift
//  ATLAS
//
//  Created by phuong phan on 25/09/2023.
//

import SwiftUI

struct NoteSubSectionView: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController
    @EnvironmentObject var mapIconModel: MapIconModel
    
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
        GeometryReader {proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .center) {
                        Text("Notes")
                            .font(.system(size: 17, weight: .semibold))
                            .padding(.leading)
                        Spacer()
                        
                        Text("Last Update: DD/MM/YY HHMM").font(.system(size: 15, weight: .regular)).foregroundColor(Color.black)
                        
                        Button(action: {
                            // Todo
                        }, label: {
                            HStack {
                                Text("Refresh").font(.system(size: 17, weight: .regular))
                                    .foregroundColor(Color.white)
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                            }
                        }).background(Color.theme.azure)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(.white, lineWidth: 0)
                            )
                            .padding(.vertical, 8)
                    }.frame(height: 52)
                    
                    NoteItemList(
                        header: header,
                        showSheet: $showSheet,
                        currentIndex: $currentIndex,
                        itemList: $coreDataModel.preflightArray,
                        isShowList: $isShowListNote,
                        geoWidth: proxy.size.width,
                        resetData: resetData
                    ).frame(maxHeight: .infinity)
                        .background(Color.white)
                        .cornerRadius(8)
                    
                    NoteItemRelevantList(
                        header: "Relevant AABBA Posts",
                        showSheet: $showSheet,
                        showModalComment: $showModalComment,
                        currentIndex: $currentIndex,
                        itemList: $coreDataModel.dataPostPreflight,
                        isShowList: $isShowListRelevent,
                        postIndex: $postIndex,
                        geoWidth: proxy.size.width,
                        resetData: resetData
                    ).frame(maxHeight: .infinity)
                        .background(Color.white)
                        .cornerRadius(8)
                }.padding(.horizontal, 16)
                    .background(Color.theme.antiFlashWhite)
                    .padding(.bottom)
            }.onAppear {
                resetData()
            }
            .onChange(of: mapIconModel.num) { _ in
                coreDataModel.dataNoteAabbaPreflight = coreDataModel.readDataNoteAabbaPostList("preflight")
                coreDataModel.preflightArray = coreDataModel.read("preflight")
                coreDataModel.preflightRefArray = coreDataModel.read("preflightref")
            }.sheet(isPresented: $showModalComment) {
                ModalNoteCommentView(isShowing: $showModalComment, parentIndex: $parentIndex, postIndex: $postIndex, posts: $coreDataModel.dataPostPreflight).interactiveDismissDisabled(true)
            }.sheet(isPresented: $showSheet) {
                NoteItemForm(
                    textNote: $textNote,
                    tagList: $coreDataModel.tagList,
                    itemList: $coreDataModel.preflightArray,
                    currentIndex: $currentIndex,
                    showSheet: $showSheet,
                    type: "preflight",
                    resetData: resetData
                ).interactiveDismissDisabled(true)
            }
        }
        
    }
    
    private func resetData() {
        coreDataModel.preflightArray = coreDataModel.read("preflight")
        coreDataModel.preflightRefArray = coreDataModel.read("preflightref")
        coreDataModel.dataPostPreflight = coreDataModel.readDataPostList("preflight", "")
        coreDataModel.dataPostPreflightRef = coreDataModel.readDataPostList("preflight", "ref")
        coreDataModel.dataNoteAabbaPreflight = coreDataModel.readDataNoteAabbaPostList("preflight")

        if self.currentIndex > -1 {
            self.currentIndex = -1
        }
    }
}
