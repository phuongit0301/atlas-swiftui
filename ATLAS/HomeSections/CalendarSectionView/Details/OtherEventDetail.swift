//
//  OtherEventDetail.swift
//  ATLAS
//
//  Created by phuong phan on 11/09/2023.
//

import SwiftUI

struct OtherEventDetail: View {
    @Binding var event: EventList?
    @Binding var showModal: Bool
    @Binding var isEdit: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Event").font(.system(size: 15, weight: .semibold)).foregroundStyle(Color.black)
                
                Spacer()
                
                Button(action: {
                    self.isEdit.toggle()
                    self.showModal.toggle()
                }, label: {
                    Text("Edit").font(.system(size: 15, weight: .regular)).foregroundStyle(Color.theme.azure)
                }).buttonStyle(PlainButtonStyle())
            }.frame(height: 44).padding(.vertical, 8).padding(.horizontal)
            
            Divider()
            
            Text(event?.name ?? "").font(.system(size: 17, weight: .semibold)).foregroundStyle(Color.black).frame(height: 44).padding(.vertical, 8).padding(.horizontal)
            
            Grid(alignment: .topLeading) {
                GridRow {
                    Text("Start").font(.system(size: 15, weight: .semibold)).foregroundStyle(Color.black)
                    Text("End").font(.system(size: 15, weight: .semibold)).foregroundStyle(Color.black)
                }.frame(height: 44, alignment: .leading).padding(.horizontal)
                
                Divider()
                
                GridRow {
                    Text(event?.unwrappedStartDate ?? "").font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black)
                    Text(event?.unwrappedEndDate ?? "").font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black)
                }.frame(height: 44, alignment: .leading).padding(.horizontal)
            }
            
            if let location = event?.location {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("Location").font(.system(size: 15, weight: .semibold)).foregroundStyle(Color.black)
                    }.frame(height: 44).padding(.vertical, 8).padding(.horizontal)
                    
                    Divider()
                    
                    Text(location).font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black).frame(height: 44).padding(.vertical, 8).padding(.horizontal)
                }
            }
            
        }// End VStack
        .background(Color.white)
            .cornerRadius(8)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.theme.gainsboro, lineWidth: 0.5))
    }
}

