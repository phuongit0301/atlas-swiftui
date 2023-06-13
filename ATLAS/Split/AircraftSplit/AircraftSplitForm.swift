//
//  AircraftSplitForm.swift
//  ATLAS
//
//  Created by phuong phan on 29/05/2023.
//

import Foundation
import SwiftUI

struct AirCraftSplitForm: View {
    @State private var textNote: String = ""
    @State private var showSheet = false
    
    @Binding var tagList: [ITagStorage]
    @Binding var itemList: [IFlightInfoStorageModel]
    var resetData: () -> Void
    @Binding var currentIndex: Int
    
    @State var selectedLine: ITag?
    @Namespace var lineAnimation
    @State private var animate = false
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(spacing: 0) {
                TextField("Add Note", text: $textNote)
                
                HStack {
                    
//                    Button(action: {
//                        // check text empty or not
//                        if textNote != "" && !tagList.isEmpty {
//                            showSheet.toggle()
//                        }
//                    }, label: {
//                        Text("Add Tags")
//                            .padding(.vertical, 4)
//                            .padding(.horizontal, 16)
//                            .font(.custom("Inter-SemiBold", size: 16))
//                            .foregroundColor((textNote != "" && !tagList.isEmpty) ? Color.theme.eerieBlack : .white)
//                            .background((textNote != "" && !tagList.isEmpty) ? Color.theme.tealDeer : Color.theme.chineseSilver)
//                            .cornerRadius(12)
//                            .frame(alignment: .center)
//                    })
//
                    Spacer()
                    
                    Button(action: {
                        if textNote != "" {
                            if currentIndex > -1 {
                                self.update()
                            } else {
                                self.save()
                            }
                        }
                    }, label: {
                        Text("Save")
                            .padding(.vertical, 4)
                            .padding(.horizontal, 16)
                            .font(.custom("Inter-SemiBold", size: 16))
                            .foregroundColor(textNote != "" ? Color.theme.eerieBlack : .white)
                            .background(textNote != "" ? Color.theme.tealDeer : Color.theme.chineseSilver)
                            .cornerRadius(12)
                            .frame(alignment: .center)
                    })
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
            }.padding(16)
                .sheet(isPresented: $showSheet) {
                    // List categories
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Select Applicable Tags").font(.custom("Inter-SemiBold", size: 16)).foregroundColor(Color.theme.eerieBlack)
                        
                        Rectangle().fill(Color.white).frame(height: 16)
                        
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
                        }
                    }.padding(16)
                        .presentationDetents([.height(150)])
                }
        }.background(Color.white)
            .roundedCorner(16, corners: [.bottomLeft, .bottomRight])
            .onChange(of: currentIndex) { newIndex in
                if currentIndex > -1 {
                    self.textNote = itemList[currentIndex].name
                }
            }
    }
    
    func save() {
        let tags: [ITagStorage] = tagList.filter { $0.isChecked };
        let newItem = IFlightInfoStorageModel(name: textNote, tags: tags, isDefault: false)
        
        itemList.append(newItem)
        
        textNote = ""
        self.resetData()
    }
    
    func update() {
        itemList[currentIndex].name = textNote
        textNote = ""
        self.resetData()
    }
}
