//
//  ClipboardDepartureNotamView.swift
//  ATLAS
//
//  Created by phuong phan on 29/09/2023.
//

import SwiftUI

struct ClipboardDepartureNotamView: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @Binding var itemList: [NotamsDataList]
//    var resetData: () -> Void
    
    @State private var isShow = true
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 0) {
                HStack(alignment: .center, spacing: 8) {
                    Text("Departure NOTAMs").foregroundStyle(Color.black).font(.system(size: 17, weight: .semibold))
                    
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
                    
                }.contentShape(Rectangle())
                    .onTapGesture {
                        self.isShow.toggle()
                    }
                
                Spacer()
                
            }.frame(height: 54)
            
            if isShow {
                VStack(alignment: .leading, spacing: 0) {
                    if itemList.count <= 0 {
                        HStack {
                            Text("No NOTAMs saved").foregroundColor(Color.theme.philippineGray2).font(.system(size: 17, weight: .regular))
                            Spacer()
                        }.frame(height: 44)
                    } else {
                        VStack(spacing: 8) {
                            HStack(spacing: 0) {
                                Text("[STATION NAME]: ETD DD/MM/YY HHMM")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(Color.black)
                                Spacer()
                            }.frame(height: 44)
                            
                            Divider().padding(.horizontal, -16)
                            
                            ForEach(itemList.indices, id: \.self) { index in
                                HStack(alignment: .center, spacing: 0) {
                                    // notam text
                                    Text(itemList[index].unwrappedNotam)
                                        .font(.system(size: 15, weight: .regular))
                                    Spacer()
                                    // star function to add to reference
                                    Button(action: {
                                        itemList[index].isChecked.toggle()
                                        coreDataModel.save()
                                        coreDataModel.dataNotams = coreDataModel.readDataNotamsList()
                                        coreDataModel.dataDepartureNotamsRef = coreDataModel.readDataNotamsByType("depNotams")
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
                        }.padding(.bottom, 24)
                    }
                }
            }
        }.padding(.horizontal)
            .background(Color.white)
            .cornerRadius(8)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 0))
    }
}
