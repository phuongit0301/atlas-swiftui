//
//  RecencyNumberModalView.swift
//  ATLAS
//
//  Created by phuong phan on 01/10/2023.
//

import SwiftUI

struct RecencyNumberModalView: View {
    @Binding var isShowing: Bool
    @Binding var selectionInOut: String
    let header: String
    @State var itemsA: ClosedRange<Int> = 0...9
    @State var itemsB: ClosedRange<Int> = 0...9
    @State private var selectionA = 0
    @State private var selectionB = 0
    
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
                    self.selectionInOut = "\(selectionA)\(selectionB)"
                    self.isShowing = false
                }) {
                    Text("Done").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                }
            }.padding()
                .background(.white)
                .roundedCorner(12, corners: [.topLeft, .topRight])
            
            Divider()
            
            VStack {
                HStack(alignment: .center, spacing: 8) {
                    Picker(selection: $selectionA, label: Text("")) {
                        ForEach(itemsA, id: \.self) {
                            Text("\($0)").tag("\($0)")
                        }
                    }.pickerStyle(.wheel)
                    .labelsHidden()
                    
                    Picker(selection: $selectionB, label: Text("")) {
                        ForEach(itemsB, id: \.self) {
                            Text("\($0)").tag("\($0)")
                        }
                    }.pickerStyle(.wheel)
                    .labelsHidden()
                }
            }
            Spacer()
            
        }.onAppear {
            if selectionInOut.count == 2 {
                self.selectionA = Int(selectionInOut.suffix(selectionInOut.count).prefix(1)) ?? 0
                self.selectionB = Int(selectionInOut.suffix(selectionInOut.count - 2).prefix(1)) ?? 0
            }
        }
    }
}
