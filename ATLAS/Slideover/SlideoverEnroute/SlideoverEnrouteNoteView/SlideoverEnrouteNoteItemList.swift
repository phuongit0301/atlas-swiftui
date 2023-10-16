//
//  SlideoverEnrouteNoteItemList.swift
//  ATLAS
//
//  Created by phuong phan on 19/06/2023.
//

import Foundation
import SwiftUI

struct SlideoverEnrouteNoteItemList: View {
    @EnvironmentObject var viewModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController
    
    @State var header: String = "" // "Aircraft Status"
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
                                        if (itemList[index].canDelete && itemList[index].fromParent) {
                                            update(index)
                                        } else {
                                            updateStatus(index)
                                        }
                                        
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
                                }.padding(.bottom, 8)
                                
                                if index + 1 < itemList.count {
                                    Divider().padding(.horizontal, -16)
                                }
                            }.id(UUID())
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
    
    private func update(_ index: Int) {
        if let found = viewModel.enrouteArray.first(where: {$0.id == viewModel.enrouteRefArray[index].parentId}) {
            found.isDefault = false
        }

        viewModel.delete(viewModel.enrouteRefArray[index])
        viewModel.save()
        resetData()
    }

    private func updateStatus(_ index: Int) {
        viewModel.enrouteRefArray[index].isDefault.toggle()
        viewModel.save()
        resetData()
    }
}
