//
//  EnrouteNoteItemForm.swift
//  ATLAS
//
//  Created by phuong phan on 19/06/2023.
//

import Foundation
import SwiftUI

struct EnrouteNoteItemForm: View {
    @AppStorage("uid") var userID: String = ""
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController
    @Binding var textNote: String
    @Binding var tagList: [TagList]
    @Binding var itemList: [NoteList]
    @Binding var currentIndex: Int
    @Binding var showSheet: Bool
    @State var type: String // Preflight, Depature, Arrival, Enroute
    @State var tagListSelected: [TagList] = []
    @State var pasteboard = UIPasteboard.general
    @State var isIncludeBriefing = false
    @State var isShareAabba = false
    
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
                        
                        if currentIndex > -1 {
                            Text("Edit Note").foregroundColor(.black).font(.system(size: 17, weight: .semibold))
                        } else {
                            Text("Add Note").foregroundColor(.black).font(.system(size: 17, weight: .semibold))
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            if currentIndex > -1 {
                                update()
                            } else {
                                save()
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
                            
                            HStack {
                                Text("Include in Crew Briefing").foregroundColor(Color.black).font(.system(size: 15, weight: .semibold))
                                Toggle(isOn: $isIncludeBriefing) {
                                    Text("").font(.system(size: 17, weight: .regular))
                                        .foregroundStyle(Color.black)
                                }
                            }.frame(height: 44)
                            
                            HStack {
                                Text("Share to AABBA").foregroundColor(Color.black).font(.system(size: 15, weight: .semibold))
                                Toggle(isOn: $isShareAabba) {
                                    Text("").font(.system(size: 17, weight: .regular))
                                        .foregroundStyle(Color.black)
                                }
                            }.frame(height: 44)
                            
                            Spacer()
                        }.padding(.horizontal)
                        
                    }.background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous).fill(.white)
                    )
                    .padding()

                }.background(Color.theme.platinum)
                    .keyboardAdaptive()
//                    .frame(height: geo.size.height)
            }.cornerRadius(8)
                .background(.white)
                .frame(maxHeight: .infinity)
                .onAppear {
                    if currentIndex > -1 {
                        self.textNote = itemList[currentIndex].unwrappedName
                        isIncludeBriefing = itemList[currentIndex].includeCrew
                        
                        let tags = itemList[currentIndex].tags?.allObjects ?? []
                        
                        if tags.count > 0 {
                            for index in 0..<tagList.count {
                                if tags.contains(where: {($0 as AnyObject).name == tagList[index].name}) {
                                    tagListSelected.append(tagList[index])
                                }
                            }
                        }
                    }
                }
        }
    }
    
    func save() {
        if let eventList = coreDataModel.selectedEvent {
            let name = textNote.trimmingCharacters(in: .whitespacesAndNewlines)
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            if !name.isEmpty {
                let item = NoteList(context: persistenceController.container.viewContext)
                item.id = UUID()
                item.name = name
                item.isDefault = true
                item.createdAt = dateFormatter.string(from: Date())
                item.canDelete = true
                item.fromParent = false
                item.type = type
                item.includeCrew = isIncludeBriefing
                item.addToTags(NSSet(array: tagListSelected))

                eventList.noteList = NSSet(array: (eventList.noteList ?? []) + [item])
                coreDataModel.save()
                
                if isShareAabba {
                    saveNoteAabba()
                }
                
                currentIndex = -1
                textNote = ""
                tagListSelected = []
                self.resetData()
                self.showSheet.toggle()
            }
        }
    }
    
    func saveNoteAabba() {
        if let eventList = coreDataModel.selectedEvent {
            if let noteAabbaPostList = eventList.noteAabbaPostList?.allObjects as? [NoteAabbaPostList], noteAabbaPostList.count > 0 {
                if let firstItem = noteAabbaPostList.first(where: {$0.unwrappedType == "enroute"}) {
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    
                    let name = textNote.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    var posts = [NotePostList]()
                    let comments = [NoteCommentList]()
                    
                    let newPost = NotePostList(context: persistenceController.container.viewContext)
                    let tags = tagListSelected.map { $0.name }

                    newPost.id = UUID()
                    newPost.postId = UUID().uuidString
                    newPost.userId = userID
                    newPost.userName = coreDataModel.dataUser?.username ?? ""
                    newPost.postDate = dateFormatter.string(from: Date())
                    newPost.postTitle = name
                    newPost.postText = name
                    newPost.upvoteCount = "0"
                    newPost.commentCount = "0"
                    
                    newPost.category = tags.joined(separator: ", ")
                    newPost.postUpdated = Date()
                    newPost.favourite = false
                    newPost.blue = false
                    newPost.voted = false
                    newPost.type = "enroute"
                    newPost.comments = NSSet(array: comments)
                    posts.append(newPost)
                    
                    firstItem.addToPosts(NSSet(array: posts))
                }
            }

            coreDataModel.save()
        }
    }
    
    func update() {
        let name = textNote.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !name.isEmpty {
            itemList[currentIndex].name = name
            itemList[currentIndex].tags = NSSet(array: tagListSelected)
            itemList[currentIndex].includeCrew = isIncludeBriefing
            
            coreDataModel.save()
            
            currentIndex = -1
            textNote = ""
            tagListSelected = []
            self.resetData()
            self.showSheet.toggle()
        }
    }
}
