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

// todo enroutemodal wheel for afl, oat, awind and afrm
// for afl: 2 wheel - A|B - A from 0 to 5, B from 0 to 90, increments of 10 (you can refer to ModalPickerMultiple for reference)
// for oat: 2 digit wheel A|B, - A from -9 to 9, B from 0 to 9.
// for awind: 6 digit wheel A|B|C|D|E|F|G - A from 0 to 3, B from 0 to 6, C from 0 to 9, D,E,F,G each from 0 to 9
// for afrm: 6 digit wheel A|B|C|D|E|F|G - A,B,C,D,E,F,G from 0 to 9
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
