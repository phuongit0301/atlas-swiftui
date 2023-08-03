//
//  Collapsible.swift
//  ATLAS
//
//  Created by phuong phan on 21/05/2023.
//

import Foundation

import SwiftUI

struct CollapsibleTab<Content: View, HeaderContent: View>: View {
    var label: () -> Text
    var content: () -> Content
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
        VStack(alignment: .leading, spacing: 0) {
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
            .padding(.bottom, 8)
            if collapsed {
                Rectangle().fill(Color.theme.eerieBlack).frame(height: 1)
                withAnimation(.easeInOut(duration: 1)) {
                    VStack {
                        self.content()
                    }
                    //            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: collapsed ? .none : 0)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .clipped()
                    .transition(.opacity)
                }
            }
        }
    }
}

extension CollapsibleTab {
  init(label: @escaping () -> Text, @ViewBuilder content: @escaping () -> Content) where HeaderContent == EmptyView{
    self.init(label: label, content: content, headerContent: nil)
  }
}
