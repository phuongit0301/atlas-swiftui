//
//  NoteItemForm.swift
//  ATLAS
//
//  Created by phuong phan on 19/06/2023.
//

import Foundation
import SwiftUI

struct NoteItemForm: View {
    @EnvironmentObject var viewModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController
    @Binding var textNote: String
    @Binding var tagList: [TagList]
    @Binding var itemList: [NoteList]
    @Binding var currentIndex: Int
    @Binding var showSheet: Bool
    @State var tagListSelected: [TagList] = []
    @State var pasteboard = UIPasteboard.general
    @State var isIncludeBriefing = true
    
    @State private var animate = false
    
    var body: some View {
        GeometryReader { geo in
            // List categories
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Button(action: {
                            textNote = ""
                            tagListSelected = []
                            self.showSheet.toggle()
                        }) {
                            Text("Cancel").foregroundColor(Color.theme.azure).font(.system(size: 17, weight: .regular))
                        }
                        
                        Spacer()
                        
                        if currentIndex > -1 {
                            Text("Edit Note").foregroundColor(.black).font(.system(size: 17, weight: .semibold))
                        } else {
                            Text("Add Note").foregroundColor(.black).font(.system(size: 17, weight: .semibold))
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            if currentIndex > -1 {
                                update()
                            } else {
                                save()
                            }
                        }) {
                            Text("Done").foregroundColor(Color.theme.azure).font(.system(size: 17, weight: .semibold))
                        }
                    }
                    .padding()
                    .background(.white)
                    
                    Rectangle().fill(.black.opacity(0.3)).frame(height: 1)
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                Text("NOTE").foregroundColor(Color.black).font(.system(size: 15, weight: .regular)).padding(.vertical, 16)
                                
                                Spacer()
                                
                                Button(action: {
                                    if let clipboardText = pasteboard.string {
                                        textNote = clipboardText
                                    }
                                }, label: {
                                    HStack {
                                        Text("Paste").font(.system(size: 17, weight: .regular))
                                            .foregroundColor(Color.white)
                                            .padding(.horizontal)
                                            .padding(.vertical, 4)
                                    }
                                }).background(Color.theme.azure)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(.white, lineWidth: 0)
                                    )
                                    .padding(.vertical, 4)
                            }.frame(height: 44)
                            
                            Divider().padding(.horizontal, -16)
                            
                            TextField("Type note here", text: $textNote, axis: .vertical)
                                .padding(.vertical, 10)
                                .frame(width: geo.size.width - 64 > 0 ? geo.size.width - 64 : geo.size.width, alignment: .leading)
                                .lineLimit(3, reservesSpace: true)
                            
                            
                            if tagList.count > 0 {
                                Divider().padding(.horizontal, -16)
                                
                                NewFlowLayout(alignment: .leading) {
                                    ForEach(tagList, id: \.self) { item in
                                        NoteTagItem(tagList: $tagList, item: item, tagListSelected: $tagListSelected)
                                    }
                                }.padding(.vertical)
                            }
                            
                            HStack {
                                Text("Include in Crew Briefing").foregroundColor(Color.black).font(.system(size: 15, weight: .semibold))
                                Toggle(isOn: $isIncludeBriefing) {
                                    Text("").font(.system(size: 17, weight: .regular))
                                        .foregroundStyle(Color.black)
                                }
                            }.frame(height: 44)
                            
                            Spacer()
                        }.padding(.horizontal)
                        
                    }.background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous).fill(.white)
                    )
                    .padding()

                }.background(Color.theme.platinum)
                    .keyboardAdaptive()
//                    .frame(height: geo.size.height)
            }.cornerRadius(8)
                .background(.white)
                .frame(maxHeight: .infinity)
        }
    }
    
    func save() {
        
    }
    
    func update() {
        
    }
}
