//
//  EnrouteSectionListView.swift
//  ATLAS
//
//  Created by phuong phan on 25/09/2023.
//

import SwiftUI

struct EnrouteSectionListView: View {
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
    
    let dateFormmater = DateFormatter()
    
    var body: some View {
        GeometryReader {proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .center) {
                        Text("Notes")
                            .font(.system(size: 17, weight: .semibold))
                            .padding(.leading)
                        Spacer()
                        
                        Text("Last Update: \(renderTitle())").foregroundColor(.black).font(.system(size: 15, weight: .regular))
                        
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
                    
                    EnrouteNoteItemList(
                        header: header,
                        showSheet: $showSheet,
                        currentIndex: $currentIndex,
                        itemList: $viewModel.enrouteArray,
                        isShowList: $isShowListNote,
                        geoWidth: proxy.size.width,
                        resetData: resetData
                    ).frame(maxHeight: .infinity)
                        .background(Color.white)
                        .cornerRadius(8)
                    
                    EnrouteNoteItemRelevantList(
                        header: "Relevant AABBA Posts",
                        showSheet: $showSheet,
                        showModalComment: $showModalComment,
                        currentIndex: $currentIndex,
                        itemList: $viewModel.dataPostEnroute,
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
                viewModel.dataNoteAabbaEnroute = viewModel.readDataNoteAabbaPostList("enroute")
            }.sheet(isPresented: $showModalComment) {
                EnrouteModalNoteCommentView(isShowing: $showModalComment, parentIndex: $parentIndex, postIndex: $postIndex).interactiveDismissDisabled(true)
            }.sheet(isPresented: $showSheet) {
                EnrouteNoteItemForm(
                    textNote: $textNote,
                    tagList: $viewModel.tagList,
                    itemList: $viewModel.enrouteArray,
                    currentIndex: $currentIndex,
                    showSheet: $showSheet,
                    type: "enroute",
                    resetData: resetData
                ).interactiveDismissDisabled(true)
            }
        }
        
    }
    
    private func resetData() {
        viewModel.enrouteArray = viewModel.read("enroute")
        viewModel.enrouteRefArray = viewModel.read("enrouteref")
        
        viewModel.dataPostEnroute = viewModel.readDataPostList("enroute", "")
        viewModel.dataPostEnrouteRef = viewModel.readDataPostList("enroute", "ref")
        
        viewModel.dataNoteAabbaEnroute = viewModel.readDataNoteAabbaPostList("enroute")

        if self.currentIndex > -1 {
            self.currentIndex = -1
        }
    }
    
    func renderTitle() -> String {
        dateFormmater.dateFormat = "yyyy-MM-dd HH:mm"
        
        let toDate = Date()
        
        if let updatedAt = mapIconModel.airportSelected?.unwrappedUpdatedAt, let fromDate = dateFormmater.date(from: updatedAt) {
            let delta = Calendar.current.dateComponents([.hour, .minute], from: fromDate, to: toDate)
            return  "\(String(format: "%02d", delta.hour ?? 0)) hrs \(String(format: "%02d", delta.minute ?? 0)) mins ago"
        }
        return ""
    }
}
