//
//  ClipboardArrival.swift
//  ATLAS
//
//  Created by phuong phan on 29/09/2023.
//

import SwiftUI

struct ClipboardArrival: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var mapIconModel: MapIconModel
    @EnvironmentObject var refState: ScreenReferenceModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center) {
                HStack(alignment: .center, spacing: 8) {
                    Button {
                        refState.isActive = false
                    } label: {
                        HStack {
                            Text("Clipboard").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.theme.azure)
                        }
                    }
                    
                    Image(systemName: "chevron.forward").font(.system(size: 17, weight: .regular))
                    
                    if let currentItem = refState.selectedItem, let screenName = currentItem.screenName {
                        Text("\(convertScreenNameToString(screenName))").font(.system(size: 17, weight: .semibold)).foregroundColor(.black)
                    }
                    
                    Spacer()
                }.padding(.leading)
                
            }.frame(height: 52)
            
            GeometryReader { proxy in
                // End header
                ScrollView {
                    ClipboardArrivalNotamView(itemList: $coreDataModel.arrNotamClipboard, dates: coreDataModel.arrAirportNotam, suffix: "STA")
                    
                    ClipboardDestNotamView(itemList: $coreDataModel.destNotamClipboard, dates: coreDataModel.destAirportNotam, suffix: "ETA")
                    
                    ClipboardArrivalNoteView(width: proxy.size.width)
                }
            }
            
        }.padding(.horizontal, 16)
            .padding(.bottom, 32)
            .background(Color.theme.antiFlashWhite)
            .onAppear {
                prepareData()
            }.onChange(of: mapIconModel.num) { _ in
                prepareData()
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
