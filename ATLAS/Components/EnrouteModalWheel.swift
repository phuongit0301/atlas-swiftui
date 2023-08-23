//
//  EnrouteModalWheel.swift
//  ATLAS
//
//  Created by phuong phan on 01/07/2023.
//

import SwiftUI

struct EnrouteModalWheelTime: View {
    @Binding var isShowing: Bool
    @Binding var selectionOutput: Date
    @State private var selection = Date()
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Button(action: {
                    self.isShowing.toggle()
                }) {
                    Text("Cancel").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                }
                Spacer()
                
                Text("Update").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.black)
                
                Spacer()
                Button(action: {
                    self.selectionOutput = selection
                    self.isShowing = false
                }) {
                    Text("Done").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                }
            }.padding()
                .background(.white)
                .roundedCorner(12, corners: [.topLeft, .topRight])
            
            HStack {
                DatePicker("", selection: $selection, displayedComponents: [.hourAndMinute]).labelsHidden().datePickerStyle(WheelDatePickerStyle())
                    .environment(\.locale, Locale(identifier: "en_GB"))
            }.Print("hour=======\(selection)")
            Spacer()
        }.onAppear {
            self.selection = selectionOutput
        }
    }
}

// todo enroutemodal wheel for afl, awind and afrm
// for afl: 2 wheel - 3|20 (where second wheel is increments of 10, you can refer to ModalPickerMultiple for reference)
// for awind and afrm - 6 digit wheel
struct EnrouteModalWheelAfl: View {
    @Binding var isShowing: Bool
    @Binding var selectionOutput: Int
    @State private var selection = Int
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Button(action: {
                    self.isShowing.toggle()
                }) {
                    Text("Cancel").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                }
                Spacer()
                
                Text("Update").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.black)
                
                Spacer()
                Button(action: {
                    self.selectionOutput = selection
                    self.isShowing = false
                }) {
                    Text("Done").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                }
            }.padding()
                .background(.white)
                .roundedCorner(12, corners: [.topLeft, .topRight])
            
            HStack {
                DatePicker("", selection: $selection, displayedComponents: [.hourAndMinute]).labelsHidden().datePickerStyle(WheelDatePickerStyle())
                    .environment(\.locale, Locale(identifier: "en_GB"))
            }.Print("hour=======\(selection)")
            Spacer()
        }.onAppear {
            self.selection = selectionOutput
        }
    }
}

//struct ModalPicker_Previews: PreviewProvider {
//    static var previews: some View {
//        ModalPicker(items: 0...100, selectionOutput: .constant(0), isShowing: .constant(true))
//    }
//}
