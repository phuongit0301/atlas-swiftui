//
//  SlideoverEnroute.swift
//  ATLAS
//
//  Created by phuong phan on 29/09/2023.
//

import SwiftUI

struct SlideoverEnroute: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var mapIconModel: MapIconModel
    @EnvironmentObject var refState: ScreenReferenceModel
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading, spacing: 0) {
                HeaderViewSplit(isMenu: true)
                
                VStack(spacing: 0) {
                    
                    HStack(alignment: .center) {
                        HStack {
                            Text("Enroute").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.black)
                        }
                        Spacer()
                        
                    }.frame(height: 52)
                    // End header
                    ScrollView {
                        VStack(spacing: 8) {
                            SlideoverEnrouteNotamView(itemList: $coreDataModel.enrNotamClipboard, dates: coreDataModel.enrAirportNotam, suffix: "ETA")
                            SlideoverEnrouteNoteView(width: proxy.size.width)
                        }
                    }
                }.padding(.horizontal, 16)
            }.padding(.bottom, 32)
                .background(Color.theme.antiFlashWhite)
                .onAppear {
                    prepareData()
                }.onChange(of: mapIconModel.num) { _ in
                    prepareData()
                }
        }
    }
    
    func prepareData() {
        coreDataModel.dataNotams = coreDataModel.readDataNotamsList()
        var temp = [String: [NotamsDataList]]()
        
        coreDataModel.dataNotams.forEach { item in
            if item.type == "enrNotams" && item.isChecked {
                if let airport = item.airport {
                    if temp[airport] != nil {
                        temp[airport]?.append(item)
                    } else {
                        temp.updateValue([item], forKey: airport)
                    }
                }
            }
        }
        
        coreDataModel.enrNotamClipboard = temp
        coreDataModel.prepareRouteAlternate()
    }
}
