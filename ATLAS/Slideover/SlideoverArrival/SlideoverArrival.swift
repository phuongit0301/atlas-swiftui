//
//  SlideoverArrival.swift
//  ATLAS
//
//  Created by phuong phan on 29/09/2023.
//

import SwiftUI

struct SlideoverArrival: View {
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
                            Text("Arrival").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.black)
                        }
                        Spacer()
                        
                    }.frame(height: 52)
                    // End header
                    ScrollView {
                        VStack(spacing: 8) {
                            SlideoverArrivalNotamView(itemList: $coreDataModel.arrNotamClipboard, dates: coreDataModel.arrAirportNotam, suffix: "STA")
                            SlideoverDestinationNotamView(itemList: $coreDataModel.destNotamClipboard, dates: coreDataModel.destAirportNotam, suffix: "ETA")
                            SlideoverArrivalNoteView(width: proxy.size.width)
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
        var temp1 = [String: [NotamsDataList]]()
        
        coreDataModel.dataNotams.forEach { item in
            if item.type == "arrNotams" && item.isChecked {
                if let airport = item.airport {
                    if temp[airport] != nil {
                        temp[airport]?.append(item)
                    } else {
                        temp.updateValue([item], forKey: airport)
                    }
                }
            }
            
            if item.type == "altnNotams" && item.isChecked {
                if let airport = item.airport {
                    if temp1[airport] != nil {
                        temp1[airport]?.append(item)
                    } else {
                        temp1.updateValue([item], forKey: airport)
                    }
                }
            }
        }
        
        coreDataModel.arrNotamClipboard = temp
        coreDataModel.destNotamClipboard = temp1
        coreDataModel.prepareRouteAlternate()
    }
}
