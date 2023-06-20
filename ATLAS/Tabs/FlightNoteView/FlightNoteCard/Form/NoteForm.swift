//
//  NoteForm.swift
//  ATLAS
//
//  Created by phuong phan on 19/06/2023.
//

import Foundation
import SwiftUI

struct NoteForm: View {
    @Binding var textNote: String
    @Binding var tagList: [ITagStorage]
    @Binding var itemList: [IFlightInfoStorageModel]
    @Binding var currentIndex: Int
    @Binding var showSheet: Bool
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
                                .padding(.vertical, 16)
                                .frame(width: geo.size.width - 64 > 0 ? geo.size.width - 64 : geo.size.width, alignment: .leading)
                                .lineLimit(15, reservesSpace: true)
                            
                            
                            if tagList.count > 0 {
                                Rectangle().fill(.black.opacity(0.3)).frame(height: 1)
                                
                                HStack {
                                    ForEach(tagList) { item in
                                        Button(action: {
                                            if let matchingIndex = self.tagList.firstIndex(where: { $0.id == item.id }) {
                                                self.tagList[matchingIndex].isChecked.toggle()
                                            }
                                            withAnimation(.easeInOut(duration: 0.5)) {
                                                self.animate = true
                                            }
                                        }, label: {
                                            Text(item.name)
                                                .font(.custom("Inter-Medium", size: 12))
                                        }).padding(.vertical, 4)
                                            .padding(.horizontal, 8)
                                            .background(item.isChecked ? Color.theme.tealDeer : Color.theme.brightGray)
                                            .foregroundColor(item.isChecked ? Color.theme.eerieBlack : Color.theme.philippineGray)
                                            .cornerRadius(16)
                                    }
                                }.fixedSize(horizontal: false, vertical: false)
                            }
                            
                            Spacer()
                        }.padding(.horizontal, 16)
                        
                    }.background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous).fill(.white)
                    )
                    .padding()
                    .frame(height: geo.size.height - 60 > 0 ? geo.size.height - 60 : geo.size.height)

                }.background(Color.theme.platinum)
                    .frame(height: geo.size.height)
            }.cornerRadius(8)
                .background(.white)
                .frame(maxHeight: .infinity)
                .onAppear {
                    if currentIndex > -1 {
                        self.textNote = itemList[currentIndex].name
                    }
                }
            
        }
    }
    
    func save() {
        let name = textNote.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !name.isEmpty {
            let tags: [ITagStorage] = tagList.filter { $0.isChecked };
            let newItem = IFlightInfoStorageModel(name: name, tags: tags, isDefault: false, canDelete: true)
            
            itemList.append(newItem)
            
            textNote = ""
            self.resetData()
            self.showSheet.toggle()
        }
    }
    
    func update() {
        let name = textNote.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !name.isEmpty {
            itemList[currentIndex].name = name
            itemList[currentIndex].tags = tagList.filter { $0.isChecked }
            
            textNote = ""
            self.resetData()
            self.showSheet.toggle()
        }
    }
}
