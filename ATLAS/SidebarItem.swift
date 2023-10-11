//
//  SidebarItem.swift
//  ATLAS
//
//  Created by phuong phan on 16/06/2023.
//

import Foundation
import SwiftUI

struct SidebarItem: View {
    @Binding var item: EventList
    @Binding var selectedItem: EventList?
    
    var body: some View {
        HStack {
            if item == selectedItem {
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.unwrappedName).foregroundColor(.white).font(.system(size: 17, weight: .semibold))
                        Text("\(item.dep ?? "")-\(item.dest ?? "")").foregroundColor(.white).font(.system(size: 13, weight: .regular))
                    }
                    Spacer()
                    Text(item.unwrappedStartDate).foregroundColor(.white).font(.system(size: 15, weight: .regular))
                }.padding(.horizontal)
                    .background(Color.theme.cultured)
                    .cornerRadius(8)
                    .frame(height: 44)
                    .padding(.vertical, 4)
            } else {
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.unwrappedName).foregroundColor(Color.black).font(.system(size: 17, weight: .semibold))
                        Text("\(item.dep ?? "")-\(item.dest ?? "")").foregroundColor(Color.black).font(.system(size: 13, weight: .regular))
                    }
                    Spacer()
                    Text(item.unwrappedStartDate).background(Color.clear).font(.system(size: 15, weight: .regular))
                }.padding(.horizontal)
                    .background(Color.theme.cultured)
                    .cornerRadius(8)
                    .frame(height: 44)
                    .padding(.vertical, 4)
            }
        }.onTapGesture {
            selectedItem = item
        }
    }
}
