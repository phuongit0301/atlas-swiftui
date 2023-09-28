//
//  DepartureNoteItemList.swift
//  ATLAS
//
//  Created by phuong phan on 19/06/2023.
//

import Foundation
import SwiftUI

struct DepartureNoteItemList: View {
    @EnvironmentObject var viewModel: CoreDataModelState
    
    @State var header: String = "" // "Aircraft Status"
    @Binding var showSheet: Bool
    @Binding var currentIndex: Int
    @Binding var itemList: [NoteList] // itemList
    @Binding var isShowList: Bool
    var geoWidth: Double
    var resetData: () -> Void?
    
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
                
                Button(action: {
                    self.showSheet.toggle()
                }) {
                    HStack {
                        Text("Add Note").foregroundColor(Color.theme.azure)
                            .font(.system(size: 17, weight: .regular))
                    }
                }
            }.frame(height: 54)
            
            if isShowList {
                if itemList.isEmpty {
                    VStack(alignment: .leading) {
                        Text("No note saved. Tap on Add Note to save your first note.").foregroundColor(Color.theme.philippineGray2).font(.system(size: 17, weight: .regular)).padding()
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
                                                            .background(Color.theme.azure)
                                                            .foregroundColor(Color.white)
                                                            .cornerRadius(12)
                                                            .overlay(
                                                                RoundedRectangle(cornerRadius: 12)
                                                                    .stroke(Color.theme.azure, lineWidth: 0)
                                                            )
                                                    }
                                                }
                                                
                                                Text(renderDate(itemList[index].unwrappedCreatedAt)).foregroundColor(Color.theme.philippineGray).font(.system(size: 11, weight: .regular))
                                            }
                                        }.padding(.leading)
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            itemList[index].isDefault.toggle()
                                            viewModel.save()
                                            resetData()
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
                                    Button(role: .destructive) {
                                        viewModel.delete(itemList[index])
                                        viewModel.save()
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
