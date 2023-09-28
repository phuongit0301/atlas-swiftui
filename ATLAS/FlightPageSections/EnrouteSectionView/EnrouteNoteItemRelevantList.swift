//
//  EnrouteNoteItemRelevantList.swift
//  ATLAS
//
//  Created by phuong phan on 19/06/2023.
//

import Foundation
import SwiftUI

struct EnrouteNoteItemRelevantList: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var mapIconModel: MapIconModel
    
    @State var header: String = "" // "Aircraft Status"
    @Binding var showSheet: Bool
    @Binding var showModalComment: Bool
    @Binding var currentIndex: Int
    @Binding var itemList: [NoteAabbaPostList] // itemList
    @Binding var isShowList: Bool
    @Binding var postIndex: Int
    var geoWidth: Double
    var remove: () -> Void
    var add: () -> Void
    
    @State var postList: [NotePostList] = []
    @State var listHeight: CGFloat = 0
    let dateFormatter = DateFormatter()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center, spacing: 0) {
                HStack(alignment: .center, spacing: 8) {
                    Text(header).foregroundColor(Color.theme.eerieBlack).font(.system(size: 17, weight: .semibold))
                    
                    if isShowList {
                        Image(systemName: "chevron.down")
                            .foregroundColor(Color.blue)
                            .scaledToFit()
                            .aspectRatio(contentMode: .fit)
                    } else {
                        Image(systemName: "chevron.up")
                            .foregroundColor(Color.blue)
                            .scaledToFit()
                            .aspectRatio(contentMode: .fit)
                    }
                    
                    Spacer()
                }.contentShape(Rectangle())
                    .onTapGesture {
                        self.isShowList.toggle()
                    }
            }.frame(height: 54)
            
            if isShowList {
                if postList.isEmpty {
                    VStack(alignment: .leading) {
                        Text("No note saved. Tap on Add Note to save your first note.").foregroundColor(Color.theme.philippineGray2).font(.system(size: 17, weight: .regular)).padding()
                    }
                    Spacer()
                } else {
                    VStack(spacing: 0) {
                        List {
                            ForEach(postList.indices, id: \.self) { index in
                                VStack(alignment: .leading, spacing: 0) {
                                    HStack(alignment: .center, spacing: 0) {
                                        Image(systemName: "line.3.horizontal")
                                            .foregroundColor(Color.theme.arsenic.opacity(0.3))
                                            .frame(width: 22, height: 22)
                                            .scaledToFit()
                                            .aspectRatio(contentMode: .fit)
                                        
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text(postList[index].unwrappedPostText.trimmingCharacters(in: .whitespacesAndNewlines))
                                                .foregroundColor(Color.theme.eerieBlack)
                                                .font(.system(size: 16, weight: .regular))
                                            
                                            HStack(alignment: .center, spacing: 8) {
                                                HStack(alignment: .center, spacing: 8) {
                                                    NoteTagItemColor(name: postList[index].unwrappedCategory)
                                                }
                                                
                                                Text(postList[index].unwrappedUserName).foregroundColor(Color.theme.azure).font(.system(size: 11, weight: .regular))
                                                
                                                Text(renderDate(postList[index].unwrappedPostDate)).foregroundColor(Color.theme.philippineGray).font(.system(size: 11, weight: .regular))
                                                
                                                Button(action: {
                                                    postList[index].upvoteCount = "\(((postList[index].upvoteCount as? NSString)?.intValue ?? 0) + 1)"
                                                    coreDataModel.save()
                                                    
                                                    mapIconModel.num += 1
                                                }, label: {
                                                    HStack(alignment: .center, spacing: 4) {
                                                        Image(systemName: "arrowshape.left")
                                                            .foregroundColor(Color.black)
                                                            .font(.system(size: 20))
                                                            .rotationEffect(.degrees(90))
                                                        
                                                        Text(postList[index].unwrappedUpvoteCount).foregroundColor(Color.black).font(.system(size: 13, weight: .regular))
                                                    }
                                                }).buttonStyle(PlainButtonStyle())
                                                
                                                Button(action: {
                                                    postIndex = index
                                                    showModalComment.toggle()
                                                }, label: {
                                                    HStack(alignment: .center, spacing: 4) {
                                                        Image(systemName: "bubble.left.and.bubble.right")
                                                            .foregroundColor(Color.black)
                                                            .font(.system(size: 20))
                                                        
                                                        Text(postList[index].unwrappedCommentCount).foregroundColor(Color.black).font(.system(size: 13, weight: .regular))
                                                    }
                                                }).buttonStyle(PlainButtonStyle())
                                                
                                            }
                                        }.padding(.leading)
                                        
                                        Spacer()

                                        if postList[index].blue {
                                            Circle().fill(Color.theme.azure).frame(width: 12, height: 12)
                                        } else {
                                            Circle().stroke(Color.theme.azure, lineWidth: 1).frame(width: 12, height: 12)
                                        }
                                        
                                        
                                        Button(action: {
                                            postList[index].favourite = !postList[index].favourite
                                            coreDataModel.save()
                                            
                                            mapIconModel.num += 1
                                        }) {
                                            postList[index].favourite ?
                                                Image(systemName: "star.fill")
                                                    .foregroundColor(Color.theme.azure)
                                                    .font(.system(size: 22))
                                            :
                                                Image(systemName: "star")
                                                    .foregroundColor(Color.theme.azure)
                                                    .font(.system(size: 22))
                                        }.padding(.horizontal, 5)
                                            .buttonStyle(PlainButtonStyle())
                                            
                                    }
                                }.id(UUID())
                                .padding(.vertical, 8)
                                .frame(maxWidth: geoWidth, alignment: .leading)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets())
                                .listRowBackground(Color.white)
                                .swipeActions(allowsFullSwipe: false) {
                                    Button {
                                        add()
                                    } label: {
                                        Text("Info").font(.system(size: 15, weight: .medium)).foregroundColor(.white)
                                    }
                                    .tint(Color.theme.graniteGray)
                                }
                            }.onMove(perform: move)
                        }.listStyle(.plain)
                            .listRowBackground(Color.white)
                            .frame(height: 73 * CGFloat(postList.count))
                    }
                }
            }
            
            Spacer()
            
        }.onAppear {
            if itemList.count > 0 {
                if let firstItem = itemList.first {
                    postList = firstItem.posts?.allObjects as! [NotePostList]
                }
            }
        }
    }
    
    func renderDate(_ date: String) -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let dateFormat = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "dd/MM/yy HHmm"
            return dateFormatter.string(from: dateFormat)
        }

        return ""
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        print("Move");
        self.itemList.move(fromOffsets: source, toOffset: destination)
    }
}
