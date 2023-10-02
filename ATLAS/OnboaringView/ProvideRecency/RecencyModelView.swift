//
//  RecencyModelView.swift
//  ATLAS
//
//  Created by phuong phan on 01/10/2023.
//

import SwiftUI

struct RecencyModelView: View {
    @Binding var isShowing: Bool
    @Binding var currentItem: String
    var data: [IRecencyModel]
    
    var header: String = "Common"
    @State var currentItemTemp: String = ""
    
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
                    self.currentItem = currentItemTemp
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
                    Picker("", selection: $currentItemTemp) {
                        ForEach(data, id: \.self) { item in
                            Text("\(item.name)").tag(item.name)
                        }
                    }
                }
            }
            Spacer()
            
        }.onAppear {
            currentItemTemp = currentItem
        }
    }
}
