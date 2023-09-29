//
//  ClipboardDepature.swift
//  ATLAS
//
//  Created by phuong phan on 29/09/2023.
//

import SwiftUI

struct ClipboardDepature: View {
    @EnvironmentObject var viewModel: CoreDataModelState
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
                    ClipboardNotamView(itemList: $viewModel.dataNotamsRef)
                    ClipboardDepartureNoteView(width: proxy.size.width)
                }
            }
            
        }.padding(.horizontal, 16)
            .padding(.bottom, 32)
            .background(Color.theme.antiFlashWhite)
    }
    
    func resetData() {
        viewModel.dataNotams = viewModel.readDataNotamsList()
        viewModel.dataNotamsRef = viewModel.readDataNotamsRefList()
    }
}
