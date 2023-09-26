//
//  NoteItemList.swift
//  ATLAS
//
//  Created by phuong phan on 19/06/2023.
//

import Foundation
import SwiftUI

struct NoteItemList: View {
    @State var header: String = "" // "Aircraft Status"
    @State var isRelevant: Bool = false
    @Binding var showSheet: Bool
    @Binding var currentIndex: Int
    @Binding var itemList: [NoteList] // itemList
    @Binding var isShowList: Bool
    var geoWidth: Double
    var remove: () -> Void
    var add: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                HStack {
                    Text(header).foregroundColor(Color.theme.eerieBlack).font(.system(size: 20, weight: .semibold))
                    
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
                
                if !isRelevant {
                    Button(action: {
                        self.showSheet.toggle()
                    }) {
                        HStack {
                            Text("Add Note").foregroundColor(Color.theme.azure)
                                .font(.system(size: 17, weight: .regular))
                        }
                    }
                }
            }.padding(.vertical, 16)
            
            if isShowList {
                if itemList.isEmpty {
                    VStack(alignment: .leading) {
                        Text("No note saved. Tap on Add Note to save your first note.").foregroundColor(Color.theme.philippineGray2).font(.system(size: 17, weight: .regular)).padding()
                        Rectangle().fill(Color.theme.arsenic.opacity(0.36)).frame(height: 1)
                    }
                    Spacer()
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
                                            Text(itemList[index].name.trimmingCharacters(in: .whitespacesAndNewlines))
                                                .foregroundColor(Color.theme.eerieBlack)
                                                .font(.system(size: 16, weight: .regular))
                                            
                                            HStack {
                                                if isRelevant {
                                                    Text("@[Username]").foregroundColor(Color.theme.azure).font(.system(size: 11, weight: .regular))
                                                }
                                                
                                                Text("DD/MM/YY HHMM").foregroundColor(Color.theme.philippineGray).font(.system(size: 11, weight: .regular))
                                                
                                                ForEach(itemList[index].tags?.allObjects as! [TagList]) { tag in
                                                    HStack {
                                                        Text(tag.name)
                                                            .padding(.vertical, 4)
                                                            .padding(.horizontal, 8)
                                                            .font(.system(size: 12, weight: .regular))
                                                            .foregroundColor(Color.theme.eerieBlack)
                                                            .overlay(
                                                                RoundedRectangle(cornerRadius: 16)
                                                                    .stroke(Color.theme.eerieBlack, lineWidth: 1)
                                                            )
                                                    }.padding(.horizontal, 3)
                                                }
                                            }
                                        }.padding(.leading)
                                        
                                        Spacer()

                                        if isRelevant {
                                            Circle().fill(Color.theme.azure).frame(width: 12, height: 12)
                                        }
                                        
                                        Button(action: {
                                            if (itemList[index].isDefault) {
                                                remove()
                                            } else {
                                                add()
                                            }
                                        }) {
                                            itemList[index].isDefault ?
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
                                    if !isRelevant {
                                        Button(role: .destructive) {
                                            //Todo
                                        } label: {
                                            Text("Delete").font(.system(size: 15, weight: .medium)).foregroundColor(.white)
                                        }.tint(Color.theme.coralRed)
                                    }
                                    
                                    Button {
                                        self.currentIndex = index
                                        self.showSheet.toggle()
                                    } label: {
                                        Text("Edit").font(.system(size: 15, weight: .medium)).foregroundColor(.white)
                                    }
                                    .tint(Color.theme.orangePeel)
                                    
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
                            .padding(.bottom, 5)
                    }
                }
            }
            
            Spacer()
            
        }
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        print("Move");
        self.itemList.move(fromOffsets: source, toOffset: destination)
    }
}
