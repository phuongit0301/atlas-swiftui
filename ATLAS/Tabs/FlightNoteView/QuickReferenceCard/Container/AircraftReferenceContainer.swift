//
//  AircraftReferenceContainer.swift
//  ATLAS
//
//  Created by phuong phan on 23/05/2023.
//

import Foundation
import SwiftUI

struct AircraftReferenceContainer: View {
    @Binding var itemList: [IFlightInfoModel]
    @State var aircraftTags: [ITag] = []
    
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
                        }
                    }.padding(.horizontal, 16)
                        .padding(.vertical, 32)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.white)
                }.onMove(perform: move)
            }.listStyle(.plain)
                .listRowBackground(Color.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            QuickReferenceForm(tagList: self.$aircraftTags, itemList: self.$itemList, resetData: self.resetData).frame(height: 98)
        }
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        print("Move");
        itemList.move(fromOffsets: source, toOffset: destination)
    }
    
    private func resetData() {
        self.aircraftTags = []
    }
    
    private func backgroundColor(for isDefault: Bool) -> Color {
        return isDefault ? Color.theme.champagne : Color.white
    }
}
