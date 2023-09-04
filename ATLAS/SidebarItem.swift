//
//  SidebarItem.swift
//  ATLAS
//
//  Created by phuong phan on 16/06/2023.
//

import Foundation
import SwiftUI

struct SidebarItem: View {
    let item: SubMenuItem
    @Binding var selectedItem: SubMenuItem?
    
    var body: some View {
        NavigationLink(value: selectedItem) {
            HStack {
                if item == selectedItem {
                    renderImage
                    VStack {
                        Text(item.name).foregroundColor(.white).font(.system(size: 17, weight: .regular))
                        Text(item.flight ?? "").foregroundColor(.white).font(.system(size: 13, weight: .regular))
                    }
                    Spacer()
                    Text(item.date ?? "").foregroundColor(.white).font(.system(size: 17, weight: .regular))
                } else {
                    renderImage
                    VStack {
                        Text(item.name).background(Color.clear).font(.system(size: 17, weight: .regular))
                        Text(item.flight ?? "").background(Color.clear).font(.system(size: 13, weight: .regular))
                    }
                    Spacer()
                    Text(item.date ?? "").background(Color.clear).font(.system(size: 17, weight: .regular))
                }
            }.padding(.horizontal, 15)
        }
    }
    
    @ViewBuilder private var renderImage: some View {
        if item.status == EMenuStatus.none {
            Image(systemName: "circle").foregroundColor(Color.theme.azure)
        } else if (item.status == EMenuStatus.working) {
            Image(systemName: "circle.circle").foregroundColor(Color.theme.azure)
        } else if (item.status == EMenuStatus.done) {
            Image(systemName: "circle.fill").foregroundColor(Color.theme.ufoGreen)
        } else if (item.status == EMenuStatus.notDone) {
            Image(systemName: "circle.fill").foregroundColor(Color.theme.tangerineYellow)
        }
    }
}
