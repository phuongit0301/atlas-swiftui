//
//  NoteForm.swift
//  ATLAS
//
//  Created by phuong phan on 19/06/2023.
//

import Foundation
import SwiftUI

struct NoteForm: View {
    @EnvironmentObject var persistenceController: PersistenceController
    @Binding var textNote: String
    @Binding var tagList: [TagList]
    @Binding var itemList: [NoteList]
    @Binding var currentIndex: Int
    @Binding var showSheet: Bool
    @State var target: String
    var resetData: () -> Void
    
    @State private var animate = false
    
    var body: some View {
        GeometryReader { geo in
            // List categories
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Button(action: {
                            self.showSheet.toggle()
                        }) {
                            Text("Cancel").foregroundColor(Color.theme.azure).font(.system(size: 17, weight: .regular))
                        }
                        
                        Spacer()
                        
                        if currentIndex > -1 {
                            Text("Edit Note").foregroundColor(.black).font(.system(size: 17, weight: .semibold))
                        } else {
                            Text("Add New Note").foregroundColor(.black).font(.system(size: 17, weight: .semibold))
                        }
                        
                        
                        Spacer()
                        
                        Button(action: {
                            if currentIndex > -1 {
                                update()
                            } else {
                                save()
                            }
                        }) {
                            Text("Done").foregroundColor(Color.theme.azure).font(.system(size: 17, weight: .regular))
                        }
                    }
                    .padding()
                    .background(.white)
                    
                    Rectangle().fill(.black.opacity(0.3)).frame(height: 1)
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("NOTE").foregroundColor(Color.theme.arsenic.opacity(0.6)).font(.system(size: 13, weight: .regular)).padding(.vertical, 16)
                            Rectangle().fill(Color.theme.arsenic.opacity(0.36)).frame(height: 1)
                            
                            TextField("Tap in this space to type or edit", text: $textNote, axis: .vertical)
                                .padding(.vertical, 10)
                                .frame(width: geo.size.width - 64 > 0 ? geo.size.width - 64 : geo.size.width, alignment: .leading)
                                .lineLimit(8, reservesSpace: true)
                            
                            
                            if tagList.count > 0 {
                                Rectangle().fill(.black.opacity(0.3)).frame(height: 1)
                                
                                NewFlowLayout(alignment: .leading) {
                                    ForEach(tagList) { item in
                                        Button(action: {
                                            if let matchingIndex = self.tagList.firstIndex(where: { $0.id == item.id }) {
                                                self.tagList[matchingIndex].isChecked.toggle()
                                                persistenceController.container.context.ref
                                            }
                                            withAnimation(.easeInOut(duration: 0.5)) {
                                                self.animate = true
                                            }
                                        }, label: {
                                            Text(item.name)
                                                .font(.system(size: 12, weight: .regular))
                                        }).padding(.vertical, 4)
                                            .padding(.horizontal, 8)
                                            .background(item.isChecked ? Color.theme.tealDeer : Color.theme.brightGray)
                                            .foregroundColor(item.isChecked ? Color.theme.eerieBlack : Color.theme.philippineGray)
                                            .cornerRadius(16)
                                            .Print("tag========>\(item)")
                                    }
                                }.padding(.vertical)
                            }
                            
                            Spacer()
                        }.padding(.horizontal)
                        
                    }.background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous).fill(.white)
                    )
                    .padding()

                }.background(Color.theme.platinum)
                    .frame(height: geo.size.height)
            }.cornerRadius(8)
                .background(.white)
                .frame(maxHeight: .infinity)
                .onAppear {
                    if currentIndex > -1 {
                        self.textNote = itemList[currentIndex].name
                        
                        let tags = itemList[currentIndex].tags?.allObjects ?? []
                        
                        if tags.count > 0 {
                            for index in 0..<tagList.count {
                                if tags.contains(where: {($0 as AnyObject).name == tagList[index].name}) {
                                    tagList[index].isChecked = true
                                }
                            }
                        }
                    }
                }
        }
    }
    
    func save() {
        let name = textNote.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !name.isEmpty {
            let tags: [TagList] = tagList.filter { $0.isChecked };
            
            let item = NoteList(context: persistenceController.container.viewContext)
            item.name = name
            item.tags = NSSet(array: tags)
            item.isDefault = false
            item.canDelete = true
            item.fromParent = false
            item.target = target
            
            persistenceController.save()
            
            textNote = ""
            self.resetData()
            self.showSheet.toggle()
        }
    }
    
    func update() {
        let name = textNote.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !name.isEmpty {
            itemList[currentIndex].name = name
            itemList[currentIndex].tags = NSSet(array: tagList.filter { $0.isChecked })
            
            persistenceController.save()
            
            textNote = ""
            self.resetData()
            self.showSheet.toggle()
        }
    }
}
