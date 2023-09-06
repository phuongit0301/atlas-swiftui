//
//  CommonStepper.swift
//  ATLAS
//
//  Created by phuong phan on 06/09/2023.
//

import SwiftUI

struct CommonStepper: View {
    @State var onToggle: () -> Void
    @Binding var value: String
    @State var suffix: String? = ""
    
    var body: some View {
        Button(action: { onToggle() }, label: {
            HStack {
                Text("\(value)\(suffix ?? "")").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                    .padding(.trailing, 16)
                
                Spacer()
                
                VStack {
                    Image(systemName: "chevron.up").foregroundColor(Color.theme.azure)
                    Image(systemName: "chevron.down").foregroundColor(Color.theme.azure)
                }
            }
        }).buttonStyle(.plain)
    }
}
