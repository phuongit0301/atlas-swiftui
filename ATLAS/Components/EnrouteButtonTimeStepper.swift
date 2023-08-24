//
//  EnrouteButtonTimeStepper.swift
//  ATLAS
//
//  Created by phuong phan on 28/06/2023.
//

import SwiftUI

struct EnrouteButtonTimeStepper: View {
    @State var onToggle: (_ index: Int) -> Void
    @State var value: String = "0000"
    @State var index: Int = 0
    
    var body: some View {
        Button(action: { onToggle(index) }, label: {
            HStack {
                Text("\(value)").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                    .padding(.trailing, 12)
                
                Spacer()
                
                VStack {
                    Image(systemName: "chevron.up").foregroundColor(Color.theme.azure)
                    Image(systemName: "chevron.down").foregroundColor(Color.theme.azure)
                }
            }
        }).buttonStyle(.plain)
    }
}
