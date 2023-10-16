//
//  DepartureNoteItemList.swift
//  ATLAS
//
//  Created by phuong phan on 19/06/2023.
//

import Foundation
import SwiftUI

struct DepartureNoteItemList: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController
    
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
                                            if (itemList[index].isDefault) {
                                                removeQR(index)
                                            } else {
                                                addQR(index)
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
                                    
                                    if index + 1 < itemList.count {
                                        Divider().padding(.horizontal, -16).padding(.vertical, 8)
                                    }
                                    
                                }.id(UUID())
                                .frame(maxWidth: geoWidth, alignment: .leading)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets.init(top: 0, leading: 16, bottom: 0, trailing: 16))
                                .listRowBackground(Color.white)
                                .swipeActions(allowsFullSwipe: false) {
                                    Button(role: .destructive) {
                                        if let found = coreDataModel.departureRefArray.first(where: {$0.parentId == itemList[index].id}) {
                                            coreDataModel.delete(found)
                                        }
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
    
    private func addQR(_ index: Int) {
        if let eventList = coreDataModel.selectedEvent {
            let data = itemList[index]
            let item = NoteList(context: persistenceController.container.viewContext)
            item.id = UUID()
            item.name = data.name
            item.isDefault = false
            item.createdAt = dateFormatter.string(from: Date())
            item.canDelete = true
            item.fromParent = true
            item.type = "departureref"
            item.includeCrew = data.includeCrew
            item.parentId = data.id
            
            if let tags = data.tags {
                item.addToTags(tags)
            }
            
            eventList.noteList = NSSet(array: (eventList.noteList ?? []) + [item])
            data.isDefault = true
            coreDataModel.save()
            resetData()
        }
    }
    
    private func removeQR(_ index: Int) {
        itemList[index].isDefault = false

        if let found = coreDataModel.departureRefArray.first(where: {$0.parentId == coreDataModel.departureRefArray[index].id}) {
            coreDataModel.delete(found)
        }
        coreDataModel.save()
        resetData()
    }
}
