//
//  ItemList.swift
//  ATLAS
//
//  Created by phuong phan on 19/06/2023.
//

import Foundation
import SwiftUI

struct ItemList: View {
    @State var header: String = "" // "Aircraft Status"
    @Binding var showSheet: Bool
    @Binding var currentIndex: Int
    @Binding var itemList: [NoteList] // itemList
    var geoWidth: Double
    var remove: (_ item: NoteList) -> Void
    var addQR: (_ index: Int) -> Void
    var removeQR: (_ index: Int) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(header).foregroundColor(Color.theme.eerieBlack).font(.system(size: 20, weight: .semibold))
                Spacer()
                
                Button(action: {
                    self.showSheet.toggle()
                }) {
                    HStack {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 16, height: 16)
                            .foregroundColor(Color.theme.azure)
                        Text("Add Note").foregroundColor(Color.theme.azure)
                            .font(.system(size: 17, weight: .regular))
                    }
                }
            }.padding(.vertical, 16)
            
            Rectangle().fill(Color.theme.arsenic.opacity(0.36)).frame(height: 1)
            
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
                                HStack(alignment: .center) {
                                    Image(systemName: "line.3.horizontal")
                                        .foregroundColor(Color.theme.arsenic.opacity(0.3))
                                        .frame(width: 22, height: 22)
                                        .scaledToFit()
                                        .aspectRatio(contentMode: .fit)
                                    
                                    Text(itemList[index].name.trimmingCharacters(in: .whitespacesAndNewlines))
                                        .foregroundColor(Color.theme.eerieBlack)
                                        .font(.system(size: 16, weight: .regular))
                                    
                                    Spacer()
                                    
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

                                    
                                    Button(action: {
                                        if (itemList[index].isDefault) {
                                            removeQR(index)
                                        } else {
                                            addQR(index)
                                        }
                                    }) {
                                        itemList[index].isDefault ?
                                            Image(systemName: "star.fill")
                                                .foregroundColor(Color.theme.azure)
                                                .frame(width: 22, height: 22)
                                                .scaledToFit()
                                                .aspectRatio(contentMode: .fit)
                                        :
                                            Image(systemName: "star")
                                                .foregroundColor(Color.theme.azure)
                                                .frame(width: 22, height: 22)
                                                .scaledToFit()
                                                .aspectRatio(contentMode: .fit)
                                    }.padding(.horizontal, 5)
                                        .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(12)
                            .frame(maxWidth: geoWidth, alignment: .leading)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.white)
                            .swipeActions(allowsFullSwipe: false) {
                                if itemList[index].canDelete {
                                    Button(role: .destructive) {
                                        remove(itemList[index])
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
                                    addQR(index)
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
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        print("Move");
        self.itemList.move(fromOffsets: source, toOffset: destination)
    }
}
