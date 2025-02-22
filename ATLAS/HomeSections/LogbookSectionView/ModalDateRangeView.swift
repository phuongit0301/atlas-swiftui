//
//  ModalDateRangeView.swift
//  ATLAS
//
//  Created by phuong phan on 21/09/2023.
//

import SwiftUI

struct ModalDateRangeView: View {
    @Binding var isShowing: Bool
    @Binding var selectedDate: String
    @Binding var selectedStartDate: String
    @Binding var selectedEndDate: String
    
    @State private var startDate = Date()
    @State private var endDate = Date()
    let dateFormatter = DateFormatter()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center) {
                Button(action: {
                    self.isShowing.toggle()
                }) {
                    Text("Cancel").font(Font.custom("SF Pro", size: 15).weight(.regular)).foregroundColor(Color.theme.azure)
                }
                
                Spacer()
                
                Text("Select Date Range").font(Font.custom("SF Pro", size: 15).weight(.semibold)).foregroundColor(Color.black)
                
                Spacer()
                
                Button(action: {
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    selectedDate = "From \(dateFormatter.string(from: startDate)) to \(dateFormatter.string(from: endDate))"
                    selectedStartDate = dateFormatter.string(from: startDate)
                    selectedEndDate = dateFormatter.string(from: endDate)
                    self.isShowing.toggle()
                }) {
                    Text("Done").font(Font.custom("SF Pro", size: 15).weight(.semibold)).foregroundColor(Color.theme.azure)
                }
            }.padding()
                .background(.white)
                .overlay(Rectangle().inset(by: 0.17).stroke(.black.opacity(0.3), lineWidth: 0.33))
                .roundedCorner(12, corners: [.topLeft, .topRight])
            
            HStack(spacing: 8) {
                VStack {
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                }.padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 0))
                
                VStack {
                    DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                }.padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 0))
                Spacer()
            }.padding(8)
            
            Spacer()
        }.background(Color.theme.antiFlashWhite)
            .onAppear {
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                if selectedStartDate != "", let selectedStartDate = dateFormatter.date(from: selectedStartDate) {
                    startDate = selectedStartDate
                }
                
                if selectedEndDate != "", let selectedEndDate = dateFormatter.date(from: selectedEndDate) {
                    endDate = selectedEndDate
                }
            }
    }
}

