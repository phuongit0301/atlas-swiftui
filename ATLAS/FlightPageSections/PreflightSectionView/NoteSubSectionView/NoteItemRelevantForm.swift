//
//  NoteItemRelevantForm.swift
//  ATLAS
//
//  Created by phuong phan on 19/06/2023.
//

import Foundation
import SwiftUI

struct NoteItemRelevantForm: View {
    @AppStorage("uid") var userID: String = ""
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController
    @Binding var textNote: String
    @Binding var tagList: [TagList]
    @Binding var itemList: [NotePostList]
    @Binding var currentIndex: Int
    @Binding var showSheet: Bool
    @State var type: String // Preflight, Depature, Arrival, Enroute
    @State var tagListSelected: [TagList] = []
    @State var pasteboard = UIPasteboard.general
    
    @State private var animate = false
    
    var resetData: () -> Void
    var isCreateFromClipboard: Bool?
    let dateFormatter = DateFormatter()
    
    var body: some View {
        GeometryReader { geo in
            // List categories
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Button(action: {
                            textNote = ""
                            tagListSelected = []
                            currentIndex = -1
                            self.showSheet.toggle()
                        }) {
                            Text("Cancel").foregroundColor(Color.theme.azure).font(.system(size: 17, weight: .regular))
                        }
                        
                        Spacer()
                        
                        Text("Edit Note").foregroundColor(.black).font(.system(size: 17, weight: .semibold))
                        
                        Spacer()
                        
                        Button(action: {
                            if currentIndex > -1 {
                                update()
                            }
                        }) {
                            Text("Done").foregroundColor(Color.theme.azure).font(.system(size: 17, weight: .semibold))
                        }
                    }
                    .padding()
                    .background(.white)
                    
                    Rectangle().fill(.black.opacity(0.3)).frame(height: 1)
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                Text("NOTE").foregroundColor(Color.black).font(.system(size: 15, weight: .regular)).padding(.vertical, 16)
                                
                                Spacer()
                                
                                Button(action: {
                                    if let clipboardText = pasteboard.string {
                                        textNote = clipboardText
                                    }
                                }, label: {
                                    HStack {
                                        Text("Paste").font(.system(size: 17, weight: .regular))
                                            .foregroundColor(Color.white)
                                            .padding(.horizontal)
                                            .padding(.vertical, 4)
                                    }
                                }).background(Color.theme.azure)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(.white, lineWidth: 0)
                                    )
                                    .padding(.vertical, 4)
                            }.frame(height: 44)
                            
                            Divider().padding(.horizontal, -16)
                            
                            TextField("Type note here", text: $textNote, axis: .vertical)
                                .padding(.vertical, 10)
                                .frame(width: geo.size.width - 64 > 0 ? geo.size.width - 64 : geo.size.width, alignment: .leading)
                                .lineLimit(3, reservesSpace: true)
                            
                            
                            if tagList.count > 0 {
                                Divider().padding(.horizontal, -16)
                                
                                NewFlowLayout(alignment: .leading) {
                                    ForEach(tagList, id: \.self) { item in
                                        NoteTagItem(tagList: $tagList, item: item, tagListSelected: $tagListSelected)
                                    }
                                }.padding(.vertical)
                            }
                            
                            Spacer()
                        }.padding(.horizontal)
                        
                    }.background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous).fill(.white)
                    )
                    .padding()

                }.background(Color.theme.platinum)
                    .keyboardAdaptive()
            }.cornerRadius(8)
                .background(.white)
                .frame(maxHeight: .infinity)
                .onAppear {
                    if currentIndex > -1 {
                        self.textNote = itemList[currentIndex].unwrappedPostTitle
                        
                        var tags = [String]()
                        
                        if let category = itemList[currentIndex].category, category != "" {
                            if category.contains(", ") {
                                tags = category.components(separatedBy: ", ")
                            } else {
                                tags = [category]
                            }
                        }
                        
                        if tags.count > 0 {
                            for index in 0..<tagList.count {
                                if tags.contains(where: {$0 == tagList[index].name}) {
                                    tagListSelected.append(tagList[index])
                                }
                            }
                        }
                    }
                }
        }
    }
    
    func update() {
        let name = textNote.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !name.isEmpty {
            let tags = tagListSelected.map { $0.name }
            
            itemList[currentIndex].postTitle = name
            itemList[currentIndex].postText = name
            itemList[currentIndex].category = tags.joined(separator: ", ")
            itemList[currentIndex].postUpdated = Date()
            
            coreDataModel.save()
            
            currentIndex = -1
            textNote = ""
            tagListSelected = []
            self.resetData()
            self.showSheet.toggle()
        }
    }
}
