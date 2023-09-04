//
//  TagItem.swift
//  ATLAS
//
//  Created by phuong phan on 26/06/2023.
//

import Foundation
import SwiftUI

struct TagItem: View {
    @Binding var tagList: [TagList]
    @State var item: TagList
    @State var isChecked: Bool = false
    @State var animate: Bool = false
    @Binding var tagListSelected: [TagList]
    
    var body: some View {
        Button(action: {
            if tagListSelected.count > 0 {
                if let matchingIndex = self.tagListSelected.firstIndex(where: { $0.id == item.id }) {
                    tagListSelected.remove(at: matchingIndex)
                } else {
                    tagListSelected.append(item)
                }
            } else {
                tagListSelected.append(item)
            }
            withAnimation(.easeInOut(duration: 0.5)) {
                self.animate = true
            }
        }, label: {
            Text(item.name)
                .font(.system(size: 12, weight: .regular))
        }).padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background(handleBgColor(tagListSelected))
            .foregroundColor(handleTextColor(tagListSelected))
            .cornerRadius(16)
    }
    
    func handleBgColor(_ tagListSelected: [TagList] = []) -> Color {
        if let matchingIndex = tagListSelected.firstIndex(where: { $0.id == item.id }) {
            return matchingIndex >= 0  ? Color.theme.tealDeer : Color.theme.brightGray
        }
        return Color.theme.brightGray
    }
    
    func handleTextColor(_ tagListSelected: [TagList] = []) -> Color {
        if let matchingIndex = self.tagListSelected.firstIndex(where: { $0.id == item.id }) {
            return matchingIndex >= 0 ? Color.theme.eerieBlack : Color.theme.philippineGray
        }
        return Color.theme.philippineGray
    }
}
