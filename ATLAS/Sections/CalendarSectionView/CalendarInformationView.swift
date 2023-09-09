//
//  CalendarInformationView.swift
//  ATLAS
//
//  Created by phuong phan on 08/09/2023.
//

import SwiftUI

struct CalendarInformationView: View {
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("Flight").font(.system(size: 15, weight: .semibold)).foregroundStyle(Color.black)
                        
                        Spacer()
                        
                        Button(action: {
                            // Todo
                        }, label: {
                            Text("Edit").font(.system(size: 15, weight: .regular)).foregroundStyle(Color.theme.azure)
                        }).buttonStyle(PlainButtonStyle())
                    }.frame(height: 44).padding(.vertical, 8).padding(.horizontal)
                    
                    Divider()
                    
                    Text("EK231 SIN-DXB").font(.system(size: 17, weight: .semibold)).foregroundStyle(Color.black).frame(height: 44).padding(.vertical, 8).padding(.horizontal)
                    
                    Grid(alignment: .topLeading) {
                        GridRow {
                            Text("DEP").font(.system(size: 15, weight: .semibold)).foregroundStyle(Color.black)
                            Text("ARR").font(.system(size: 15, weight: .semibold)).foregroundStyle(Color.black)
                        }.frame(height: 44, alignment: .leading).padding(.horizontal)
                        
                        Divider()
                        
                        GridRow {
                            Text("DEP").font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black)
                            Text("ARR").font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black)
                        }.frame(height: 44, alignment: .leading).padding(.horizontal)
                    }
                    
                    Grid(alignment: .topLeading) {
                        GridRow {
                            Text("STD").font(.system(size: 15, weight: .semibold)).foregroundStyle(Color.black)
                            Text("STA").font(.system(size: 15, weight: .semibold)).foregroundStyle(Color.black)
                        }.frame(height: 44, alignment: .leading).padding(.horizontal)
                        
                        Divider()
                        
                        GridRow {
                            Text("DD/MM/YY HHMM").font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black)
                            Text("DD/MM/YY HHMM").font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black)
                        }.frame(height: 44, alignment: .leading).padding(.horizontal)
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("People").font(.system(size: 15, weight: .semibold)).foregroundStyle(Color.black)
                            
                            Spacer()
                            
                            Button(action: {
                                // Todo
                            }, label: {
                                Text("Invite").font(.system(size: 15, weight: .regular)).foregroundStyle(Color.theme.azure)
                            }).buttonStyle(PlainButtonStyle())
                        }.frame(height: 44).padding(.vertical, 8).padding(.horizontal)
                        
                        Divider()
                        
                        Text("Add other Atlas users to this flight").font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black).frame(height: 44).padding(.vertical, 8).padding(.horizontal)
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("Reminders").font(.system(size: 15, weight: .semibold)).foregroundStyle(Color.black)
                        }.frame(height: 44).padding(.vertical, 8).padding(.horizontal)
                        
                        Divider()
                        
                        Text("24h hours before").font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black).frame(height: 44).padding(.vertical, 8).padding(.horizontal)
                    }
                    
                }// End VStack
                .background(Color.white)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.theme.gainsboro, lineWidth: 0.5))
            }.padding(.top, 8)
                .padding(.trailing)
        }
    }
}

struct CalendarInformationView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarInformationView()
    }
}
