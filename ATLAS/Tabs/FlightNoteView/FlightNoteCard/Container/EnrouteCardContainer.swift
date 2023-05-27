//
//  EnrouteCardContainer.swift
//  ATLAS
//
//  Created by phuong phan on 23/05/2023.
//

import Foundation
import SwiftUI

struct EnrouteCardContainer: View {
    @Binding var itemList: [IFlightInfoModel]
    @State var enrouteTags: [ITag] = EnrouteTags().TagList
    
    var body: some View {
        VStack(spacing: 0) {
            List {
                
                ForEach(itemList, id: \.self) { item in
                    VStack(alignment: .leading) {
                        HStack(alignment: .top) {
                            Image("icon_dots_group")
                                .frame(width: 14, height: 16)
                                .scaledToFit()
                                .aspectRatio(contentMode: .fit)
                            
                            Text(item.name)
                                .foregroundColor(Color.theme.eerieBlack)
                                .font(.custom("Inter-Regular", size: 16))
                            
                            if !item.tags.isEmpty {
                                ForEach(item.tags, id: \.self) { tag in
                                    Text(tag.name)
                                        .padding(.vertical, 4)
                                        .padding(.horizontal, 8)
                                        .font(.custom("Inter-Medium", size: 12))
                                        .foregroundColor(Color.theme.eerieBlack)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color.theme.eerieBlack, lineWidth: 1)
                                        )
                                }
                            }
                        }
                    }.padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.theme.champagne)
                }.onMove(perform: move)
            }.listStyle(.plain)
                .listRowBackground(Color.theme.champagne)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            DepartureForm(tagList: self.$enrouteTags, itemList: self.$itemList, resetData: self.resetData).frame(height: 98)
        }
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        print("Move");
        itemList.move(fromOffsets: source, toOffset: destination)
    }
    
    private func resetData() {
        self.enrouteTags = DepartureTags().TagList
    }
    
    private func backgroundColor(for isDefault: Bool) -> Color {
        return isDefault ? Color.theme.champagne : Color.white
    }
}
