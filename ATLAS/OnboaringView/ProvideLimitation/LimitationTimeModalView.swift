//
//  LimitationTimeModalView.swift
//  ATLAS
//
//  Created by phuong phan on 01/10/2023.
//

import SwiftUI

struct LimitationTimeModalView: View {
    @Binding var isShowing: Bool
    @Binding var pickerType: String //date, time, datetime
    @Binding var currentDate: String
    var header = "Time"
    @State private var currentDateTemp = Date()
    
    let dateFormatterTime = DateFormatter()
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Button(action: {
                    self.isShowing.toggle()
                }) {
                    Text("Cancel").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                }
                
                Spacer()
                
                Text("Time").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.black)
                
                Spacer()
                
                Button(action: {
                    // assign value from modal to entries form
                    if pickerType == "date" {
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                    } else if pickerType == "time" {
                        dateFormatter.dateFormat = "HH:mm"
                    } else if pickerType == "datetime" {
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                    }
                    
                    self.currentDate = dateFormatter.string(from: currentDateTemp)
                    
                    self.isShowing.toggle()
                }) {
                    Text("Done").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                }
            }.padding()
                .background(.white)
                .roundedCorner(12, corners: [.topLeft, .topRight])
            
            Divider()
            
            VStack {
                if pickerType == "date" {
                    DatePicker("", selection: $currentDateTemp, displayedComponents: [.date]).labelsHidden().datePickerStyle(WheelDatePickerStyle())
                        .environment(\.locale, Locale(identifier: "en_GB"))
                } else if pickerType == "time" {
                    DatePicker("", selection: $currentDateTemp, displayedComponents: [.hourAndMinute]).labelsHidden().datePickerStyle(WheelDatePickerStyle())
                        .environment(\.locale, Locale(identifier: "en_GB"))
                } else if pickerType == "datetime" {
                    DatePicker("", selection: $currentDateTemp, displayedComponents: [.date, .hourAndMinute]).labelsHidden().datePickerStyle(WheelDatePickerStyle())
                        .environment(\.locale, Locale(identifier: "en_GB"))
                }
                
            }
            Spacer()
            
        }.onAppear {
            if currentDate != "" {
                if pickerType == "date" {
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    currentDateTemp = dateFormatter.date(from: currentDate)!
                } else if pickerType == "time" {
                    dateFormatter.dateFormat = "HH:mm"
                    currentDateTemp = dateFormatter.date(from: currentDate)!
                } else if pickerType == "datetime" {
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                    currentDateTemp = dateFormatter.date(from: currentDate)!
                }
            }
        }
    }
}
