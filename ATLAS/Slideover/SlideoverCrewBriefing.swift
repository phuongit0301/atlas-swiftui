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
                            
                            if coreDataModel.tagListCabinDefects.count > 0, let firstItem = coreDataModel.tagListCabinDefects.first {
                                if let notes = firstItem.notes?.allObjects as? [NoteList], notes.count > 0 {
                                    ClipboardTagView(notes: notes, tag: firstItem)
                                }
                            }
                            
                            if coreDataModel.tagListWeather.count > 0, let firstItem = coreDataModel.tagListWeather.first {
                                if let notes = firstItem.notes?.allObjects as? [NoteList], notes.count > 0 {
                                    ClipboardTagView(notes: notes, tag: firstItem)
                                }
                            }
                            
                            ClipboardCrewBriefingNoteView(width: proxy.size.width)
                        }
                    }
                }.padding(.horizontal, 16)
            }.padding(.bottom, 32)
                .background(Color.theme.antiFlashWhite)
        }
    }
}
