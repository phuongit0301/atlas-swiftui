//
//  Collapsible.swift
//  ATLAS
//
//  Created by phuong phan on 21/05/2023.
//

import Foundation

import SwiftUI

struct Collapsible<HeaderContent: View, Content: View>: View {
    @State var header: () -> HeaderContent
    @State var content: () -> Content
    
    @State private var collapsed: Bool = false
    @State private var isShowIcon: Bool = false
    
    init(@ViewBuilder header: @escaping () -> HeaderContent, @ViewBuilder content: @escaping () -> Content) {
        self.header = header
        self.content = content
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            self.header().onTapGesture {
                withAnimation {
                    self.collapsed.toggle()
                }
            }.animation(nil)
                .frame(alignment: .top)
            
            if collapsed {
                VStack {
                    self.content()
                }.frame(height: collapsed ? nil : 0, alignment: .top)
                    .clipped()
            }
        }
    }
}

extension Collapsible {
  init(@ViewBuilder header: @escaping () -> Content, @ViewBuilder content: @escaping () -> Content) {
    self.init(header: header, content: content)
  }
}
