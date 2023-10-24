//
//  NotamCompletedSubSectionRowView.swift
//  ATLAS
//
//  Created by phuong phan on 04/10/2023.
//

import SwiftUI

struct NotamCompletedSubSectionRowView: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @State var isShow = true
    
    var item: [NotamsDataList]
    var dates: [String: String]
    let key: String
    let suffix: String
    let hasCollapse: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            if hasCollapse {
                HStack(spacing: 8) {
                    if suffix == "STD" || suffix == "STA" {
                        Text("\(key) \(suffix): \(dates["date"] ?? "")").font(.system(size: 15, weight: .semibold)).foregroundColor(Color.black)
                    } else {
                        Text("\(key) \(suffix): \(dates[key] ?? "")").font(.system(size: 15, weight: .semibold)).foregroundColor(Color.black)
                    }
                    
                    if isShow {
                        Image(systemName: "chevron.down")
                            .foregroundColor(Color.blue)
                            .scaledToFit()
                            .aspectRatio(contentMode: .fit)
                    } else {
                        Image(systemName: "chevron.up")
                            .foregroundColor(Color.blue)
                            .scaledToFit()
                            .aspectRatio(contentMode: .fit)
                    }
                    Spacer()
                }.frame(height: 44)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        self.isShow.toggle()
                    }
            } else {
                HStack(spacing: 8) {
                    if suffix == "STD" || suffix == "STA" {
                        Text("\(key) \(suffix): \(dates["date"] ?? "")").font(.system(size: 15, weight: .semibold)).foregroundColor(Color.black)
                    } else {
                        Text("\(key) \(suffix): \(dates[key] ?? "")").font(.system(size: 15, weight: .semibold)).foregroundColor(Color.black)
                    }
                    Spacer()
                }.frame(height: 44)
            }

            if item.count > 0 {
                Divider().padding(.horizontal, -16)
            }
            
            if isShow {
                ForEach(item.indices, id: \.self) { index in
                    HStack(alignment: .center, spacing: 0) {
                        // notam text
                        Text(item[index].unwrappedNotam)
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(Color.black)
                        Spacer()
                        // star function to add to reference
                        Button(action: {
                            
                        }) {
                            if item[index].isChecked {
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
                    }.padding(.bottom, 8)
                    
                    if item.count > 0 && index + 1 < item.count {
                        Divider().padding(.horizontal, -16)
                    }
                }
            }
        }
    }
}
