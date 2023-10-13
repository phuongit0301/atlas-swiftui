//
//  ArrivalSectionListView.swift
//  ATLAS
//
//  Created by phuong phan on 25/09/2023.
//

import SwiftUI

struct ArrivalSectionListView: View {
    @EnvironmentObject var viewModel: CoreDataModelState
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
                    
                    ArrivalNoteItemList(
                        header: header,
                        showSheet: $showSheet,
                        currentIndex: $currentIndex,
                        itemList: $viewModel.arrivalArray,
                        isShowList: $isShowListNote,
                        geoWidth: proxy.size.width,
                        resetData: resetData
                    ).frame(maxHeight: .infinity)
                        .background(Color.white)
                        .cornerRadius(8)
                    
                    ArrivalNoteItemRelevantList(
                        header: "Relevant AABBA Posts",
                        showSheet: $showSheet,
                        showModalComment: $showModalComment,
                        currentIndex: $currentIndex,
                        itemList: $viewModel.dataPostArrival,
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
                viewModel.dataNoteAabbaArrival = viewModel.readDataNoteAabbaPostList("arrival")
            }.sheet(isPresented: $showModalComment) {
                ArrivalModalNoteCommentView(isShowing: $showModalComment, parentIndex: $parentIndex, postIndex: $postIndex).interactiveDismissDisabled(true)
            }.sheet(isPresented: $showSheet) {
                ArrivalNoteItemForm(
                    textNote: $textNote,
                    tagList: $viewModel.tagList,
                    itemList: $viewModel.arrivalArray,
                    currentIndex: $currentIndex,
                    showSheet: $showSheet,
                    type: "arrival",
                    resetData: resetData
                ).interactiveDismissDisabled(true)
            }
        }
        
    }
    
    private func resetData() {
        viewModel.arrivalArray = viewModel.read("arrival")
        viewModel.arrivalRefArray = viewModel.read("arrivalref")
        
        viewModel.dataPostArrival = viewModel.readDataPostList("arrival", "")
        viewModel.dataPostArrivalRef = viewModel.readDataPostList("arrival", "ref")
        
        viewModel.dataNoteAabbaArrival = viewModel.readDataNoteAabbaPostList("arrival")

        if self.currentIndex > -1 {
            self.currentIndex = -1
        }
    }
}
