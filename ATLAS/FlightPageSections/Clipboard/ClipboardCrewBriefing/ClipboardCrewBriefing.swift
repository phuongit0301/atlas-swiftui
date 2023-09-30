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
            }
            
        }.padding(.horizontal, 16)
            .padding(.bottom, 32)
            .background(Color.theme.antiFlashWhite)
    }
}
