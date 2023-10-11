//
//  CustomModalView.swift
//  ATLAS
//
//  Created by phuong phan on 11/10/2023.
//

import SwiftUI

struct CustomModal<Content: View>: View {
    @Binding var isPresented: Bool
    let content: Content

    var body: some View {
        ZStack {
            // Background
            RoundedRectangle(cornerRadius: 30)
                .stroke(Color.gray, lineWidth: 1)

            // Content
            content
                .padding()
        }
        .transition(.move(edge: .bottom))
        .animation(.spring())
    }
}
