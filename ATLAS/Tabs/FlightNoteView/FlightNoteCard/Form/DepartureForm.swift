//
//  Form.swift
//  ATLAS
//
//  Created by phuong phan on 21/05/2023.
//

import Foundation
import SwiftUI

struct DepartureForm: View {
    @State private var textNote: String = ""
    @State private var arrSelectedLine: [ITag] = []
    @State private var showSheet = false
    
    @Binding var tagList: [ITag]
    @State private var temp = DepartureTags().TagList
    
    @State var selectedLine: ITag?
    @Namespace var lineAnimation
    @State private var animate = false
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(.white).padding(.bottom, 8)
            
            VStack(spacing: 0) {
                TextField("Add Note", text: $textNote)
                
                Button(action: {
                    showSheet.toggle()
                }, label: {
                    Text("Add Tags")
                        .padding(.vertical, 4)
                        .padding(.horizontal, 16)
                        .font(.custom("Inter-SemiBold", size: 16))
                        .foregroundColor(textNote != "" ? Color.theme.eerieBlack : .white)
                        .background(textNote != "" ? Color.theme.tealDeer : Color.theme.chineseSilver)
                        .cornerRadius(12)
                        .frame(alignment: .center)
                })
                
                HStack {
                    
                    Button(action: {
                        // To do show modal
                    }, label: {
                        Text("Save To...")
                            .padding(.vertical, 4)
                            .padding(.horizontal, 16)
                            .font(.custom("Inter-SemiBold", size: 16))
                            .foregroundColor(textNote != "" ? Color.theme.eerieBlack : .white)
                            .background(textNote != "" ? Color.theme.tealDeer : Color.theme.chineseSilver)
                            .cornerRadius(12)
                            .frame(alignment: .center)
                    })
                    
                    Button(action: {
                        
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
                        Text("Select applicable flight phase").font(.custom("Inter-SemiBold", size: 16)).foregroundColor(Color.theme.eerieBlack)
                        
                        Rectangle().fill(Color.white).frame(height: 16)
                        
                        HStack {
                            ForEach(tagList, id: \.self) { item in
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
                        .presentationDetents([.height(100)])
                        
                    
                    Spacer()
                }
        }
    }
    
    func removeRows(at offsets: IndexSet) {
        temp.remove(atOffsets: offsets)
    }
}
