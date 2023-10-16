//
//  SlideoverDepartureNoteRelevantList.swift
//  ATLAS
//
//  Created by phuong phan on 19/06/2023.
//

import Foundation
import SwiftUI

struct SlideoverDepartureNoteRelevantList: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var mapIconModel: MapIconModel
    
    @State var header: String = "" // "Aircraft Status"
    @Binding var showModalComment: Bool
    @Binding var currentIndex: Int
    @Binding var itemList: [NotePostList] // itemList
    @Binding var isShowList: Bool
    @Binding var postIndex: Int
    var geoWidth: Double
    var resetData: () -> Void?
    
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
                if itemList.isEmpty {
                    HStack(spacing: 0) {
                        Text("No note saved").foregroundColor(Color.theme.philippineGray2).font(.system(size: 17, weight: .regular))
                        Spacer()
                    }.frame(height: 44)
                } else {
                    VStack(spacing: 0) {
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
                                            HStack(alignment: .center, spacing: 8) {
                                                NoteTagItemColor(name: itemList[index].unwrappedCategory)
                                            }
                                            
                                            Text(itemList[index].unwrappedUserName).foregroundColor(Color.theme.azure).font(.system(size: 11, weight: .regular))
                                        }
                                        Text(renderDate(itemList[index].unwrappedPostDate)).foregroundColor(Color.theme.philippineGray).font(.system(size: 11, weight: .regular))
                                    }.padding(.leading)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        itemList[index].favourite = !itemList[index].favourite
                                        itemList[index].fromParent = !itemList[index].fromParent
                                        coreDataModel.save()
                                        resetData()
                                    }) {
                                        itemList[index].favourite || itemList[index].fromParent ?
                                        Image(systemName: "star.fill")
                                            .foregroundColor(Color.theme.azure)
                                            .font(.system(size: 20))
                                        :
                                        Image(systemName: "star")
                                            .foregroundColor(Color.theme.azure)
                                            .font(.system(size: 20))
                                    }.padding(.horizontal, 5)
                                        .buttonStyle(PlainButtonStyle())
                                    
                                }.padding(.bottom, 8)
                                
                                if index + 1 < itemList.count {
                                    Divider().padding(.horizontal, -16)
                                }
                            }.id(UUID())
                                .padding(.bottom, 8)
                                .frame(maxWidth: geoWidth, alignment: .leading)
                        }
                    }
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
