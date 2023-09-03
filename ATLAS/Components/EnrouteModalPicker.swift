//
//  EnrouteModalPicker.swift
//  ATLAS
//
//  Created by phuong phan on 01/07/2023.
//

import SwiftUI

struct EnrouteModalPicker: View {
    @Binding var isShowing: Bool
    @Binding var selectionOutput: Double
    @State var stepper = 1.0
    @State private var selection: Double = 0
    
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
                if stepper == 1 {
                    Text(String(format: "%.0f", selection)).foregroundColor(Color.theme.azure).font(.system(size: 17, weight: .regular))
                } else {
                    Text(String(format: "%.1f", selection)).foregroundColor(Color.theme.azure).font(.system(size: 17, weight: .regular))
                }
                
                
                VStack(spacing: 5) {
                    CustomButton(onPress: increment, label: {
                        Image(systemName: "chevron.up").foregroundColor(Color.theme.azure)
                    })
                    
                    CustomButton(onPress: decrement, label: {
                        Image(systemName: "chevron.down").foregroundColor(Color.theme.azure)
                    })
                }
            }
            Spacer()
        }.onAppear {
            self.selection = selectionOutput
        }
    }
    
    func increment() {
        self.selection += stepper
    }
    
    func decrement() {
        self.selection -= stepper
    }
}

//struct ModalPicker_Previews: PreviewProvider {
//    static var previews: some View {
//        ModalPicker(items: 0...100, selectionOutput: .constant(0), isShowing: .constant(true))
//    }
//}
