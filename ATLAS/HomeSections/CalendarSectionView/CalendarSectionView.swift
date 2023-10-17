//
//  CalendarSectionView.swift
//  ATLAS
//
//  Created by phuong phan on 06/09/2023.
//

import SwiftUI
import iCalendarParser

struct CalendarSectionView: View {
    @State var showModal = false
    @State var showLoading = false
    @State var isEdit = false
    
    @EnvironmentObject var coreDataModel: CoreDataModelState
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("Calendar").font(.system(size: 17, weight: .semibold))
                    
                    Spacer()
                    
                    Button(action: {
                        Task {
                            showLoading = true
                            await coreDataModel.syncDataEvent()
                            showLoading = false
                        }
                    }, label: {
                        HStack {
                            Text("Sync Calendar").font(.system(size: 17, weight: .regular)).foregroundColor(Color.white)
                            
                            if showLoading {
                                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.white)).padding(.leading)
                            }
                        }
                        
                    }).padding(.vertical, 11)
                        .padding(.horizontal)
                        .background(Color.theme.azure)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(.white, lineWidth: 1))
                        .cornerRadius(8)
                        .buttonStyle(PlainButtonStyle())
                        .disabled(showLoading)
                    
                    Button(action: {
                        self.showModal.toggle()
                    }, label: {
                        Text("Add Event").font(.system(size: 17, weight: .regular)).foregroundColor(Color.white)
                    }).padding(.vertical, 11)
                        .padding(.horizontal)
                        .background(Color.theme.azure)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(.white, lineWidth: 1))
                        .cornerRadius(8)
                        .buttonStyle(PlainButtonStyle())
                }.padding(.horizontal)
                
                HStack(spacing: 0) {
                    CalendarView(calendar: Calendar(identifier: .gregorian)).frame(width: (proxy.size.width * 2 / 3))
                    
                    CalendarInformationView(showModal: $showModal, isEdit: $isEdit)
                }
            }// end VStack
            .background(Color.theme.antiFlashWhite)
            .sheet(isPresented: $showModal) {
                EventModalView(showModal: $showModal, isEdit: $isEdit).interactiveDismissDisabled(true)
            }.frame(height: proxy.size.height + 200)
        }
    }
}
