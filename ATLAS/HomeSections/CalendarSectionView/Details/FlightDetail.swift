//
//  FlightDetail.swift
//  ATLAS
//
//  Created by phuong phan on 11/09/2023.
//

import SwiftUI

struct FlightDetail: View {
    @Binding var event: EventList?
    @Binding var showModal: Bool
    @Binding var isEdit: Bool
    @Binding var isBtnDisabled: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Flight").font(.system(size: 15, weight: .semibold)).foregroundStyle(Color.black)
                
                Spacer()
                
                if isBtnDisabled {
                    Button(action: {
                    }, label: {
                        Text("Edit").font(.system(size: 15, weight: .regular)).foregroundStyle(Color.theme.philippineGray3)
                    }).buttonStyle(PlainButtonStyle())
                } else {
                    Button(action: {
                        self.isEdit.toggle()
                        self.showModal.toggle()
                    }, label: {
                        Text("Edit").font(.system(size: 15, weight: .regular)).foregroundStyle(Color.theme.azure)
                    }).buttonStyle(PlainButtonStyle())
                }
            }.frame(height: 44).padding(.vertical, 8).padding(.horizontal)
            
            Divider()
            
            Text(event?.name ?? "").font(.system(size: 17, weight: .semibold)).foregroundStyle(Color.black).frame(height: 44).padding(.vertical, 8).padding(.horizontal)
            
            Grid(alignment: .topLeading) {
                GridRow {
                    Text("DEP").font(.system(size: 15, weight: .semibold)).foregroundStyle(Color.black)
                    Text("ARR").font(.system(size: 15, weight: .semibold)).foregroundStyle(Color.black)
                }.frame(height: 44, alignment: .leading).padding(.horizontal)
                
                Divider()
                
                GridRow {
                    Text(event?.unwrappedDep ?? "").font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black)
                    Text(event?.unwrappedDest ?? "").font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black)
                }.frame(height: 44, alignment: .leading).padding(.horizontal)
            }
            
            Grid(alignment: .topLeading) {
                GridRow {
                    Text("STD").font(.system(size: 15, weight: .semibold)).foregroundStyle(Color.black)
                    Text("STA").font(.system(size: 15, weight: .semibold)).foregroundStyle(Color.black)
                }.frame(height: 44, alignment: .leading).padding(.horizontal)
                
                Divider()
                
                GridRow {
                    Text(event?.unwrappedStartDate ?? "").font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black)
                    Text(event?.unwrappedEndDate ?? "").font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black)
                }.frame(height: 44, alignment: .leading).padding(.horizontal)
            }
            
//            VStack(alignment: .leading, spacing: 0) {
//                HStack {
//                    Text("People").font(.system(size: 15, weight: .semibold)).foregroundStyle(Color.black)
//                    
//                    Spacer()
//                    
//                    Button(action: {
//                        // Todo
//                    }, label: {
//                        Text("Invite").font(.system(size: 15, weight: .regular)).foregroundStyle(Color.theme.azure)
//                    }).buttonStyle(PlainButtonStyle())
//                }.frame(height: 44).padding(.vertical, 8).padding(.horizontal)
//                
//                Divider()
//                
//                Text("Add other Atlas users to this flight").font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black).frame(height: 44).padding(.vertical, 8).padding(.horizontal)
//            }
//            
//            VStack(alignment: .leading, spacing: 0) {
//                HStack {
//                    Text("Reminders").font(.system(size: 15, weight: .semibold)).foregroundStyle(Color.black)
//                }.frame(height: 44).padding(.vertical, 8).padding(.horizontal)
//                
//                Divider()
//                
//                Text("24h hours before").font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black).frame(height: 44).padding(.vertical, 8).padding(.horizontal)
//            }
//            
        }// End VStack
        .background(Color.white)
            .cornerRadius(8)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.theme.gainsboro, lineWidth: 0.5))
    }
}

