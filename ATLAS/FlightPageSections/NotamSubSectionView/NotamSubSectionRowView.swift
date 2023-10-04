//
//  NotamSubSectionRowView.swift
//  ATLAS
//
//  Created by phuong phan on 04/10/2023.
//

import SwiftUI

struct NotamSubSectionRowView: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    
    var item: [NotamsDataList]
    let key: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 0) {
                Text("\(key) ETD DD/MM/YY HHMM").font(.system(size: 15, weight: .semibold)).foregroundColor(Color.black)
                Spacer()
            }.frame(height: 44)

            if item.count > 0 {
                Divider().padding(.horizontal, -16)
            }

            ForEach(item.indices, id: \.self) { index in
                HStack(alignment: .center, spacing: 0) {
                    // notam text
                    Text(item[index].unwrappedNotam)
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(Color.black)
                    Spacer()
                    // star function to add to reference
                    Button(action: {
                        item[index].isChecked.toggle()
                        coreDataModel.save()
                        coreDataModel.dataNotams = coreDataModel.readDataNotamsList()
                        coreDataModel.dataNotamsRef = coreDataModel.readDataNotamsRefList()
                        coreDataModel.dataEnrouteNotamsRef = coreDataModel.readDataNotamsByType("enrNotams")
                        coreDataModel.dataDestinationNotamsRef = coreDataModel.readDataNotamsByType("destNotams")
                    }) {
                        if item[index].isChecked {
                            Image(systemName: "star.fill").foregroundColor(Color.theme.azure)
                        } else {
                            Image(systemName: "star").foregroundColor(Color.theme.azure)
                        }
                    }.fixedSize()
                        .buttonStyle(PlainButtonStyle())
                }.padding(.bottom, 8)

                if item.count > 0 && index + 1 < item.count {
                    Divider().padding(.horizontal, -16)
                }
            }
        }
    }
}
