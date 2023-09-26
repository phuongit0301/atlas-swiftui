//
//  NoteSectionView.swift
//  ATLAS
//
//  Created by phuong phan on 25/09/2023.
//

import SwiftUI

struct NoteSectionView: View {
    @EnvironmentObject var viewModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController
    
    @State private var currentIndex: Int = -1
    @State private var showSheet: Bool = false
    @State private var isShowListNote: Bool = true
    @State private var isShowListRelevent: Bool = true
    @State private var textNote: String = ""
    @State private var itemList = [NoteList]()
    var header: String = "Your Notes"
    
    var body: some View {
        GeometryReader {proxy in
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
                }.frame(height: 44)
                
                NoteItemList(
                    header: header,
                    isRelevant: false,
                    showSheet: $showSheet,
                    currentIndex: $currentIndex,
                    itemList: $viewModel.departureArray,
                    isShowList: $isShowListNote,
                    geoWidth: proxy.size.width,
                    remove: remove,
                    add: add
                ).frame(maxHeight: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                
                NoteItemList(
                    header: "Relevant AABBA Posts",
                    isRelevant: true,
                    showSheet: $showSheet,
                    currentIndex: $currentIndex,
                    itemList: $viewModel.departureArray,
                    isShowList: $isShowListRelevent,
                    geoWidth: proxy.size.width,
                    remove: remove,
                    add: add
                ).frame(maxHeight: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
            }.padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(Color.theme.antiFlashWhite)
                .sheet(isPresented: $showSheet) {
                    NoteItemForm(
                        textNote: $textNote,
                        tagList: $viewModel.tagList,
                        itemList: $itemList,
                        currentIndex: $currentIndex,
                        showSheet: $showSheet
                    ).interactiveDismissDisabled(true)
                }
        }
        
    }
    
    private func remove() {
        
    }
    
    private func add() {
       
    }
}

struct NoteSectionView_Previews: PreviewProvider {
    static var previews: some View {
        NoteSectionView()
    }
}
