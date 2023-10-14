//
//  ClipboardCrewBriefing.swift
//  ATLAS
//
//  Created by phuong phan on 28/09/2023.
//

import SwiftUI

struct ClipboardCrewBriefing: View {
    @EnvironmentObject var refState: ScreenReferenceModel
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var mapIconModel: MapIconModel
    
    @State private var showUTC = true
    
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
                    VStack(spacing: 8) {
                        ClipboardCrewBriefingSummaryView(width: proxy.size.width)
                        
                        if coreDataModel.tagListCabinDefects.count > 0 {
                            ClipboardTagView(itemList: $coreDataModel.tagListCabinDefects, tag: "Cabin Defects")
                        }

                        if coreDataModel.tagListWeather.count > 0 {
                            ClipboardTagView(itemList: $coreDataModel.tagListWeather, tag: "Weather")
                        }
                        
                        ClipboardCrewBriefingNoteView(width: proxy.size.width)
                    }
                }
            }
            
        }.padding(.horizontal, 16)
            .padding(.bottom, 32)
            .background(Color.theme.antiFlashWhite)
            .onAppear {
                coreDataModel.tagListCabinDefects = coreDataModel.readTagByName("Cabin Defects")
                coreDataModel.tagListWeather = coreDataModel.readTagByName("Weather")
            }
            .onChange(of: mapIconModel.num) { _ in
                coreDataModel.tagListCabinDefects = coreDataModel.readTagByName("Cabin Defects")
                coreDataModel.tagListWeather = coreDataModel.readTagByName("Weather")
            }
    }
}
