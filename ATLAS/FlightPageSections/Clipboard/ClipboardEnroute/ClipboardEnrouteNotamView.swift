//
//  ClipboardEnrouteNotamView.swift
//  ATLAS
//
//  Created by phuong phan on 29/09/2023.
//

import SwiftUI

struct ClipboardEnrouteNotamView: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @Binding var itemList: [String: [NotamsDataList]]
    var dates: [String: String]
    let suffix: String
    
    @State private var isShow = true
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 0) {
                HStack(alignment: .center, spacing: 8) {
                    Text("Enroute NOTAMs").foregroundStyle(Color.black).font(.system(size: 17, weight: .semibold))
                    
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
                        }
                            .frame(height: 44)
                    } else {
                        ForEach(Array(itemList.keys), id: \.self) {key in
                            VStack(spacing: 8) {
                                HStack(spacing: 0) {
                                    if suffix == "STD" || suffix == "STA" {
                                        Text("\(key) \(suffix): \(dates["date"] ?? "")").font(.system(size: 15, weight: .semibold)).foregroundColor(Color.black)
                                    } else {
                                        Text("\(key) \(suffix): \(dates[key] ?? "")").font(.system(size: 15, weight: .semibold)).foregroundColor(Color.black)
                                    }
                                    Spacer()
                                }.frame(height: 44)
                                
                                Divider().padding(.horizontal, -16)
                                
                                if coreDataModel.selectedEvent?.flightStatus == FlightStatusEnum.COMPLETED.rawValue {
                                    ClipboardEnrouteNotamCompletedRowView(itemList: itemList[key] ?? [])
                                } else {
                                    ClipboardEnrouteNotamRowView(itemList: itemList[key] ?? [])
                                }
                            }.padding(.bottom, 24)
                        }
                    }
                    
                    
                }
            }
        }.padding(.horizontal)
            .background(Color.white)
            .cornerRadius(8)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 0))
    }
}
