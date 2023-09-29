//
//  ClipboardPreflight.swift
//  ATLAS
//
//  Created by phuong phan on 28/09/2023.
//

import SwiftUI

struct ClipboardPreflight: View {
    @EnvironmentObject var refState: ScreenReferenceModel
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
                
                HStack {
                    Toggle(isOn: $showUTC) {
                        Text("Local").font(.system(size: 17, weight: .regular))
                            .foregroundStyle(Color.black)
                    }
                    Text("UTC").font(.system(size: 17, weight: .regular))
                        .foregroundStyle(Color.black)
                }.fixedSize()
                
            }.frame(height: 52)
            
            GeometryReader { proxy in
                // End header
                ScrollView {
                    ClipboardSummaryView(showUTC: $showUTC, width: proxy.size.width)
                    ClipboardNoteView(width: proxy.size.width)
                }
            }
            
        }.padding(.horizontal, 16)
            .padding(.bottom, 32)
            .background(Color.theme.antiFlashWhite)
    }
}
