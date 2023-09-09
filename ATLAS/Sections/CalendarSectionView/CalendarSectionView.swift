//
//  CalendarSectionView.swift
//  ATLAS
//
//  Created by phuong phan on 06/09/2023.
//

import SwiftUI

struct CalendarSectionView: View {
    @State var showModal = false
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("Calendar").font(.system(size: 17, weight: .semibold))
                    
                    Spacer()
                    
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
                    
                    CalendarInformationView()
                }
            }// end VStack
            .background(Color.theme.antiFlashWhite)
            .sheet(isPresented: $showModal) {
                EventModalView(showModal: $showModal)
            }
        }
    }
}
