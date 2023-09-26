//
//  NoteItemRelevantList.swift
//  ATLAS
//
//  Created by phuong phan on 19/06/2023.
//

import Foundation
import SwiftUI

struct NoteItemRelevantList: View {
    @State var header: String = "" // "Aircraft Status"
    @Binding var showSheet: Bool
    @Binding var currentIndex: Int
    @Binding var itemList: [NoteList] // itemList
    @Binding var isShowList: Bool
    var geoWidth: Double
    var remove: () -> Void
    var add: () -> Void
    
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
                    VStack(alignment: .leading) {
                        Text("No note saved. Tap on Add Note to save your first note.").foregroundColor(Color.theme.philippineGray2).font(.system(size: 17, weight: .regular)).padding()
                        Divider().padding(.horizontal, -16)
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
                                            Text(itemList[index].unwrappedName.trimmingCharacters(in: .whitespacesAndNewlines))
                                                .foregroundColor(Color.theme.eerieBlack)
                                                .font(.system(size: 16, weight: .regular))
                                            
                                            HStack(alignment: .center, spacing: 8) {
                                                ForEach(itemList[index].tags?.allObjects as! [TagList]) { tag in
                                                    HStack(alignment: .center, spacing: 8) {
                                                        Text(tag.name)
                                                            .padding(.vertical, 4)
                                                            .padding(.horizontal, 12)
                                                            .font(.system(size: 11, weight: .regular))
                                                            .foregroundColor(Color.theme.eerieBlack)
                                                            .overlay(
                                                                RoundedRectangle(cornerRadius: 12)
                                                                    .stroke(Color.theme.eerieBlack, lineWidth: 1)
                                                            )
                                                    }
                                                }
                                                
                                                Text("@[Username]").foregroundColor(Color.theme.azure).font(.system(size: 11, weight: .regular))
                                                
                                                Text(renderDate(itemList[index].unwrappedCreatedAt)).foregroundColor(Color.theme.philippineGray).font(.system(size: 11, weight: .regular))
                                                
                                                HStack(alignment: .center, spacing: 4) {
                                                    Image(systemName: "arrowshape.left")
                                                        .foregroundColor(Color.black)
                                                        .font(.system(size: 20))
                                                        .rotationEffect(.degrees(90))
                                                    
                                                    Text("20").foregroundColor(Color.black).font(.system(size: 13, weight: .regular))
                                                }
                                                
                                                HStack(alignment: .center, spacing: 4) {
                                                    Image(systemName: "bubble.left.and.bubble.right")
                                                        .foregroundColor(Color.black)
                                                        .font(.system(size: 20))
                                                    
                                                    Text("1").foregroundColor(Color.black).font(.system(size: 13, weight: .regular))
                                                }
                                            }
                                        }.padding(.leading)
                                        
                                        Spacer()

                                        Circle().fill(Color.theme.azure).frame(width: 12, height: 12)
                                        
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
                            .frame(height: 73 * CGFloat(itemList.count))
                    }
                }
            }
            
            Spacer()
            
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
