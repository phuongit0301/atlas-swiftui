//
//  ModalImageView.swift
//  ATLAS
//
//  Created by phuong phan on 17/10/2023.
//

import SwiftUI

struct ModalImageView: View {
    @Binding var isShowing: Bool
    @Binding var selectedEntry: LogbookEntriesList?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .center) {
                Button(action: {
                    self.isShowing.toggle()
                }) {
                    Text("Cancel").font(Font.custom("SF Pro", size: 15).weight(.regular)).foregroundColor(Color.theme.azure)
                }
                
                Spacer()
                
                Text("Signature").font(Font.custom("SF Pro", size: 15).weight(.semibold)).foregroundColor(Color.black)
                
                Spacer()
                
                Button(action: {
                    self.isShowing.toggle()
                }) {
                    Text("Done").font(Font.custom("SF Pro", size: 15).weight(.semibold)).foregroundColor(Color.theme.azure)
                }
            }.padding()
                .background(.white)
                .overlay(Rectangle().inset(by: 0.17).stroke(.black.opacity(0.3), lineWidth: 0.33))
                .roundedCorner(12, corners: [.topLeft, .topRight])
            
            HStack(alignment: .center) {
                if let fileUrl = selectedEntry?.signFileUrl, fileUrl != "none" {
                    if fileUrl.contains("http") {
                        AsyncImage(url: URL(string: fileUrl)).scaledToFit()
                    } else {
                        if let uiImage = convertBase64ToImage(imageString: fileUrl) {
                            Image(uiImage: uiImage).resizable().scaledToFit()
                        }
                    }
                }
            }.padding()
            
            Spacer()
        }.background(Color.theme.antiFlashWhite)
    }
}
