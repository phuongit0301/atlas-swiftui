//
//  OnboardingTimeModalView.swift
//  ATLAS
//
//  Created by phuong phan on 01/10/2023.
//

import SwiftUI

struct OnboardingTimeModalView: View {
    @Binding var isShowing: Bool
    
    @Binding var currentDate: String
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
                    dateFormatter.dateFormat = "HH:mm"
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
                DatePicker("", selection: $currentDateTemp, displayedComponents: [ .hourAndMinute]).labelsHidden().datePickerStyle(WheelDatePickerStyle())
                    .environment(\.locale, Locale(identifier: "en_GB"))
            }
            Spacer()
            
        }.onAppear {
            dateFormatter.dateFormat = "HH:mm"
            currentDateTemp = dateFormatter.date(from: currentDate)!
        }
    }
}
