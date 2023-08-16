//
//  AISearchDetailView.swift
//  ATLAS
//
//  Created by phuong phan on 16/07/2023.
//

import Foundation
import SwiftUI

struct AISearchDetailReferenceView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var aiSearchState: AISearchModelState
    
    @State var index: Int = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if coreDataModel.dataAISearchFavorite.count > 0 {
                    Text(coreDataModel.dataAISearchFavorite[index].question ?? "").font(.system(size: 20, weight: .semibold)).foregroundColor(.black).padding(.vertical)
                }
                
                
                Spacer().frame(maxWidth: .infinity)
                
                HStack {
                    if coreDataModel.dataAISearchFavorite.count > 0 {
                        AIButton(isFavorite: $coreDataModel.dataAISearchFavorite[index].isFavorite)
                    }

                    Button(action: {
                        coreDataModel.dataAISearch = coreDataModel.readAISearch()
                        coreDataModel.dataAISearchFavorite = coreDataModel.readAISearch(target: true)
                        index = 0
                        aiSearchState.currentIndex = -1
//                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Done").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.theme.azure)
                    }).buttonStyle(PlainButtonStyle())
                }
            }
            
            Divider()
            
            if coreDataModel.dataAISearchFavorite.count > 0 {
                Text(coreDataModel.dataAISearchFavorite[index].answer ?? "").font(.system(size: 17, weight: .regular)).foregroundColor(.black).padding(.vertical)
            }
            
            Spacer()
        }.background(RoundedRectangle(cornerRadius: 8, style: .continuous).fill(.white))
            .navigationBarBackButtonHidden(true)
    }
}

struct AIButton: View {
    @Binding var isFavorite: Bool
    @EnvironmentObject var coreDataModel: CoreDataModelState
    
    var body: some View {
        Button(action: {
            isFavorite.toggle()
            coreDataModel.save()
        }, label: {
            isFavorite ?
                Image(systemName: "star.fill")
                    .foregroundColor(Color.theme.azure)
                    .frame(width: 22, height: 22)
                    .scaledToFit()
                    .aspectRatio(contentMode: .fit)
            :
                Image(systemName: "star")
                    .foregroundColor(Color.theme.azure)
                    .frame(width: 22, height: 22)
                    .scaledToFit()
                    .aspectRatio(contentMode: .fit)
        }).padding(.horizontal)
            .buttonStyle(PlainButtonStyle())
    }
}
