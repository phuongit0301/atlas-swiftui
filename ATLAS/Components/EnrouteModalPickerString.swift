//
//  EnrouteModalPickerString.swift
//  ATLAS
//
//  Created by phuong phan on 01/07/2023.
//

import SwiftUI

struct EnrouteModalPickerString: View {
    @Binding var isShowing: Bool
    @Binding var items: [String]
    @Binding var selectionInOut: String
    @State private var selection: String = ""
    
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
                    self.selectionInOut = selection
                    self.isShowing = false
                }) {
                    Text("Done").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                }
            }.padding()
                .background(.white)
                .roundedCorner(12, corners: [.topLeft, .topRight])
            
            HStack {
                Picker("", selection: $selection) {
                    ForEach(items, id: \.self) {
                        Text($0).tag($0)
                    }
                }
            }
            Spacer()
        }.onAppear {
            selection = selectionInOut
        }
    }
}

//struct ModalPicker_Previews: PreviewProvider {
//    static var previews: some View {
//        ModalPicker(items: 0...100, selectionOutput: .constant(0), isShowing: .constant(true))
//    }
//}
