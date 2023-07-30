//
//  AISearchDetailSplitView.swift
//  ATLAS
//
//  Created by phuong phan on 16/07/2023.
//

import Foundation
import SwiftUI

struct AISearchDetailSplitView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var coreDataModel: CoreDataModelState
    
    @State var index = 0
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderViewSplit(isMenu: true)
            
            VStack(alignment: .leading) {
                HStack(spacing: 0) {
                    if coreDataModel.dataAISearchFavorite.count > 0 {
                        Text(coreDataModel.dataAISearchFavorite[index].question ?? "").font(.system(size: 20, weight: .semibold)).foregroundColor(.black).padding(.trailing)
                    }
                    
                    Spacer().frame(maxWidth: .infinity)
                    
                    HStack(spacing: 0) {
                        if coreDataModel.dataAISearchFavorite.count > 0 {
                            AIButton(isFavorite: $coreDataModel.dataAISearchFavorite[index].isFavorite)
                        }
                        
                        Button(action: {
                            coreDataModel.dataAISearch = coreDataModel.readAISearch()
                            coreDataModel.dataAISearchFavorite = coreDataModel.readAISearch(target: true)
                            index = 0
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Text("Done").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.theme.azure)
                        })
                    }
                }
                
                Divider()
                
                if coreDataModel.dataAISearchFavorite.count > 0 {
                    Text(coreDataModel.dataAISearchFavorite[index].answer ?? "").font(.system(size: 17, weight: .regular)).foregroundColor(.black).padding(.vertical)
                }
            }.padding()
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}
