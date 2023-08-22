//
//  MapModal.swift
//  ATLAS
//
//  Created by phuong phan on 22/08/2023.
//

import SwiftUI

struct MapModal: View {
    @Binding var isShowing: Bool
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Spacer()
                
                Text("Maps").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.black)
                
                Spacer()
                Button(action: {
                    self.isShowing.toggle()
                }) {
                    Text("Done").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                }
            }.padding()
                .background(.white)
                .roundedCorner(12, corners: [.topLeft, .topRight])
            
            MapView()
        }
    }
}

struct MapModal_Previews: PreviewProvider {
    static var previews: some View {
        MapModal(isShowing: .constant(true))
    }
}
