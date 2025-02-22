//
//  NoteItemRelevantList.swift
//  ATLAS
//
//  Created by phuong phan on 19/06/2023.
//

import Foundation
import SwiftUI

struct NoteItemRelevantList: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController
    @EnvironmentObject var mapIconModel: MapIconModel
    
    @State var header: String = "" // "Aircraft Status"
    @Binding var showSheet: Bool
    @Binding var showModalComment: Bool
    @Binding var currentIndex: Int
    @Binding var itemList: [NotePostList] // itemList
    @Binding var isShowList: Bool
    @Binding var postIndex: Int
    var geoWidth: Double
    var resetData: () -> Void?
    
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
                .padding(.horizontal)
            
            if isShowList {
                if itemList.isEmpty {
                    HStack {
                        Text("No note saved").foregroundColor(Color.theme.philippineGray2).font(.system(size: 17, weight: .regular))
                        Spacer()
                    }.padding(.horizontal)
                        .frame(height: 44)
                } else {
                    VStack(spacing: 0) {
                        List {
                            ForEach(itemList.indices, id: \.self) { index in
                                VStack(alignment: .leading, spacing: 0) {
                                    HStack(alignment: .center, spacing: 0) {
                                        Image(systemName: "line.3.horizontal")
                                            .foregroundColor(Color.theme.arsenic.opacity(0.3))
                                            .frame(width: 22, height: 22)
                                            .scaledToFit()
                                            .aspectRatio(contentMode: .fit)
                                        
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text(itemList[index].unwrappedPostText.trimmingCharacters(in: .whitespacesAndNewlines))
                                                .foregroundColor(Color.theme.eerieBlack)
                                                .font(.system(size: 16, weight: .regular))
                                            
                                            HStack(alignment: .center, spacing: 8) {
                                                if let tags = renderTag(itemList[index].unwrappedCategory) {
                                                    if tags.count > 0 {
                                                        HStack(alignment: .center, spacing: 8) {
                                                            ForEach(tags, id: \.self) {item in
                                                                NoteTagItemColor(name: item)
                                                            }
                                                        }
                                                    }
                                                }
                                                
                                                Text(itemList[index].unwrappedUserName).foregroundColor(Color.theme.azure).font(.system(size: 11, weight: .regular))
                                                
                                                Text(renderDate(itemList[index].unwrappedPostDate)).foregroundColor(Color.theme.philippineGray).font(.system(size: 11, weight: .regular))
                                                
                                                Button(action: {
                                                    if itemList[index].voted {
                                                        itemList[index].upvoteCount = "\(((itemList[index].upvoteCount as? NSString)?.intValue ?? 0) - 1)"
                                                    } else {
                                                        itemList[index].upvoteCount = "\(((itemList[index].upvoteCount as? NSString)?.intValue ?? 0) + 1)"
                                                    }
                                                    
                                                    itemList[index].voted.toggle()
                                                    coreDataModel.save()
                                                    mapIconModel.num += 1
                                                }, label: {
                                                    HStack(alignment: .center, spacing: 4) {
                                                        if itemList[index].voted {
                                                            Image(systemName: "arrowshape.left")
                                                                .foregroundColor(Color.theme.azure)
                                                                .font(.system(size: 20))
                                                                .rotationEffect(.degrees(90))
                                                        } else {
                                                            Image(systemName: "arrowshape.left")
                                                                .foregroundColor(Color.black)
                                                                .font(.system(size: 20))
                                                                .rotationEffect(.degrees(90))
                                                        }
                                                            
                                                        Text(itemList[index].unwrappedUpvoteCount).foregroundColor(Color.black).font(.system(size: 13, weight: .regular))
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
                                                        
                                                        Text(itemList[index].unwrappedCommentCount).foregroundColor(Color.black).font(.system(size: 13, weight: .regular))
                                                    }
                                                }).buttonStyle(PlainButtonStyle())
                                                
                                            }
                                        }.padding(.leading)
                                        
                                        Spacer()

                                        if itemList[index].blue {
                                            Circle().fill(Color.theme.azure).frame(width: 12, height: 12)
                                        } else {
                                            Circle().stroke(Color.theme.azure, lineWidth: 1).frame(width: 12, height: 12)
                                        }
                                        
                                        
                                        Button(action: {
                                            if (itemList[index].favourite) {
                                                removeQR(index)
                                            } else {
                                                addQR(index)
                                            }
                                        }) {
                                            itemList[index].favourite ?
                                                Image(systemName: "star.fill")
                                                    .foregroundColor(Color.theme.azure)
                                                    .font(.system(size: 22))
                                            :
                                                Image(systemName: "star")
                                                    .foregroundColor(Color.theme.azure)
                                                    .font(.system(size: 22))
                                        }.padding(.horizontal, 5)
                                            .buttonStyle(PlainButtonStyle())
                                            
                                    }.padding(.vertical, 8)
                                    
                                    if index + 1 < itemList.count {
                                        Divider().padding(.horizontal, -16)
                                    }
                                }.id(UUID())
                                .frame(maxWidth: geoWidth, alignment: .leading)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets.init(top: 0, leading: 16, bottom: 0, trailing: 16))
                                .listRowBackground(Color.white)
                                .swipeActions(allowsFullSwipe: false) {
                                    if itemList[index].canDelete {
                                        Button(role: .destructive) {
                                            coreDataModel.delete(itemList[index])
                                            coreDataModel.save()
                                            resetData()
                                        } label: {
                                            Text("Delete").font(.system(size: 15, weight: .medium)).foregroundColor(.white)
                                        }.tint(Color.theme.coralRed)
                                        
                                        Button {
                                            self.currentIndex = index
                                            self.showSheet.toggle()
                                        } label: {
                                            Text("Edit").font(.system(size: 15, weight: .medium)).foregroundColor(.white)
                                        }
                                        .tint(Color.theme.orangePeel)
                                        
                                    } else {
                                        Button {
                                            // TODO
                                        } label: {
                                            Text("Info").font(.system(size: 15, weight: .medium)).foregroundColor(.white)
                                        }
                                        .tint(Color.theme.graniteGray)
                                    }
                                }
                            }.onMove(perform: move)
                        }.listStyle(.plain)
                            .listRowBackground(Color.white)
                            .frame(height: 73 * CGFloat(itemList.count))
                    }
                }
            }
        }
    }
    
    private func addQR(_ index: Int) {
        let data = itemList[index]
        data.favourite = true
        data.fromParent = true
        coreDataModel.save()
        resetData()
    }
    
    private func removeQR(_ index: Int) {
        itemList[index].favourite = false
        itemList[index].fromParent = false
//        if let found = coreDataModel.dataPostPreflightRef.first(where: {$0.parentId == itemList[index].id}) {
//            coreDataModel.delete(found)
//        }
        coreDataModel.save()
        resetData()
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
