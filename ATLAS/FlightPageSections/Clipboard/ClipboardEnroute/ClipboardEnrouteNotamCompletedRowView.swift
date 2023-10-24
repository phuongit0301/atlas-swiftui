//
//  ClipboardEnrouteNotamCompletedRowView.swift
//  ATLAS
//
//  Created by phuong phan on 21/10/2023.
//

import SwiftUI

struct ClipboardEnrouteNotamCompletedRowView: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var mapIconModel: MapIconModel
    let itemList: [NotamsDataList]
    
    var body: some View {
        ForEach(itemList.indices, id: \.self) { index in
            HStack(alignment: .center, spacing: 0) {
                // notam text
                Text(itemList[index].unwrappedNotam)
                    .font(.system(size: 15, weight: .regular))
                Spacer()
                // star function to add to reference
                Button(action: {
                }) {
                    if itemList[index].isChecked {
                        Image(systemName: "star.fill")
                            .foregroundColor(Color.theme.azure)
                            .font(.system(size: 22))
                    } else {
                        Image(systemName: "star")
                            .foregroundColor(Color.theme.azure)
                            .font(.system(size: 22))
                    }
                }.fixedSize()
                    .buttonStyle(PlainButtonStyle())
            }
            
            if index + 1 < itemList.count {
                Divider().padding(.horizontal, -16)
            }
        }
    }
}

