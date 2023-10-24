//
//  ClipboardNoteCompletedItemList.swift
//  ATLAS
//
//  Created by phuong phan on 19/06/2023.
//

import Foundation
import SwiftUI

struct ClipboardNoteCompletedItemList: View {
    @EnvironmentObject var viewModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController
    
    @State var header: String = ""
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
                }) {
                    HStack {
                        Text("Add Note").foregroundColor(Color.theme.azure)
                            .font(.system(size: 17, weight: .regular))
                    }
                }
            }.frame(height: 54)
                .padding(.horizontal)
            
            if isShowList {
                if itemList.isEmpty {
                    HStack {
                        Text("No note saved").foregroundColor(Color.theme.philippineGray2).font(.system(size: 15, weight: .regular))
                        Spacer()
                    }.frame(height: 44)
                        .padding(.horizontal)
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
                                        }) {
                                            itemList[index].isDefault || itemList[index].fromParent ?
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
                                    
                                    if index + 1 < itemList.count {
                                        Divider().padding(.horizontal, -16).padding(.vertical, 8)
                                    }
                                    
                                }.id(UUID())
                                    .listRowSeparator(.hidden)
                                    .listRowInsets(EdgeInsets.init(top: 0, leading: 16, bottom: 0, trailing: 16))
                                    .listRowBackground(Color.white)
                            }
                        }.listStyle(.plain)
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
}
