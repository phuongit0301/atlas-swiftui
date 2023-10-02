//
//  LimitationNumberModalView.swift
//  ATLAS
//
//  Created by phuong phan on 01/10/2023.
//

import SwiftUI

struct LimitationNumberModalView: View {
    @Binding var isShowing: Bool
    @Binding var currentNumber: Int
    
    var header: String = "Limitation"
    var minNumber: Int = 0
    var maxNumber: Int = 100
    @State private var currentNumberTemp = 0
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Button(action: {
                    self.isShowing.toggle()
                }) {
                    Text("Cancel").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                }
                
                Spacer()
                
                Text(header).font(.system(size: 17, weight: .semibold)).foregroundColor(Color.black)
                
                Spacer()
                
                Button(action: {
                    // assign value from modal to entries form
                    self.currentNumber = currentNumberTemp
                    self.isShowing.toggle()
                }) {
                    Text("Done").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                }
            }.padding()
                .background(.white)
                .roundedCorner(12, corners: [.topLeft, .topRight])
            
            Divider()
            
            VStack {
                HStack(alignment: .center, spacing: 8) {
                    Picker("", selection: $currentNumberTemp) {
                        ForEach(minNumber..<maxNumber) { number in
                            Text("\(number)")
                        }
                    }
                }
            }
            Spacer()
            
        }.onAppear {
            currentNumberTemp = currentNumber
        }
    }
}
