//
//  Collapsible.swift
//  ATLAS
//
//  Created by phuong phan on 21/05/2023.
//

import Foundation

import SwiftUI

struct Collapsible<Content: View, HeaderContent: View>: View {
    @State var label: () -> Text
    @State var content: () -> Content
    private var headerContent: (() -> HeaderContent)?
    
    @State private var collapsed: Bool = false
    
    init(label: @escaping () -> Text, @ViewBuilder content: @escaping () -> Content) {
        self.label = label
        self.content = content
    }
    
    init(label: @escaping () -> Text, @ViewBuilder content: @escaping () -> Content, headerContent: (() -> HeaderContent)?) {
        self.label = label
        self.content = content
        self.headerContent = headerContent
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Button(
                action: { self.collapsed.toggle() },
                label: {
                    HStack(alignment: .center) {
                        self.label()
                        headerContent?()
                        Image(self.collapsed ? "icon_arrow_up" : "icon_arrow_down")
                    }
                }
            )
            .buttonStyle(PlainButtonStyle())
            if collapsed {
                Rectangle().fill(Color.theme.eerieBlack).frame(height: 1)
                VStack {
                    self.content()
                }
                //            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: collapsed ? .none : 0)
                .frame(minWidth: 0, maxWidth: .infinity)
                .clipped()
                .animation(.easeOut(duration: 1.0))
                .transition(.opacity)
            }
        }.background(Color.theme.cultured)
            .cornerRadius(8)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

extension Collapsible {
  init(label: @escaping () -> Text, @ViewBuilder content: @escaping () -> Content) where HeaderContent == EmptyView{
    self.init(label: label, content: content, headerContent: nil)
  }
}
