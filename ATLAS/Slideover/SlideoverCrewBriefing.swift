//
//  ClipboardCrewBriefing.swift
//  ATLAS
//
//  Created by phuong phan on 28/09/2023.
//

import SwiftUI

struct SlideoverCrewBriefing: View {
    @EnvironmentObject var refState: ScreenReferenceModel
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var mapIconModel: MapIconModel
    
    @State private var showUTC = true
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading, spacing: 0) {
                HeaderViewSplit(isMenu: true)
                
                VStack(spacing: 0) {
                    
                    HStack(alignment: .center) {
                        HStack {
                            Text("Crew Briefing").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.black)
                        }
                        Spacer()
                        
                    }.frame(height: 52)
                    // End header
                    
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
                }.padding(.horizontal, 16)
            }.padding(.bottom, 32)
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
}
