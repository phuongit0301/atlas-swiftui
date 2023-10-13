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
    @Binding var isEventActive: Bool
    
    var body: some View {
        HStack {
            if item == selectedItem {
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.unwrappedName).foregroundColor(.white).font(.system(size: 17, weight: .semibold))
                        
                        if let dep = item.dep, let dest = item.dest {
                            Text("\(dep)-\(dest)").foregroundColor(.white).font(.system(size: 13, weight: .regular))
                        }
                    }
                    Spacer()
                    Text(item.unwrappedStartDate).foregroundColor(.white).font(.system(size: 15, weight: .regular))
                }.padding(.vertical, 4)
                .padding(.horizontal)
                    .background(Color.theme.azure)
                    .cornerRadius(8)
                    .frame(height: 44)
            } else {
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.unwrappedName).foregroundColor(Color.black).font(.system(size: 17, weight: .semibold))
                        
                        if let dep = item.dep, let dest = item.dest {
                            Text("\(dep)-\(dest)").foregroundColor(Color.black).font(.system(size: 13, weight: .regular))
                        }
                    }
                    Spacer()
                    Text(item.unwrappedStartDate).background(Color.clear).font(.system(size: 15, weight: .regular))
                }.padding(.vertical, 4)
                    .padding(.horizontal)
                    .background(Color.theme.cultured)
                    .cornerRadius(8)
                    .frame(height: 44)
            }
        }.onTapGesture {
            selectedItem = item
            isEventActive = true
        }
    }
}
