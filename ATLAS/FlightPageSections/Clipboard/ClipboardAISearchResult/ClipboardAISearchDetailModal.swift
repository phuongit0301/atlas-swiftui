//
//  ClipboardAISearchDetailModal.swift
//  ATLAS
//
//  Created by phuong phan on 29/09/2023.
//

import SwiftUI

struct ClipboardAISearchDetailModal: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var aiSearchState: AISearchModelState
    
    @Binding var isShowing: Bool
    @Binding var index: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center) {
                if coreDataModel.dataAISearchFavorite.count > 0 {
                    AIButton(isFavorite: $coreDataModel.dataAISearchFavorite[index].isFavorite)
                }
                
                Spacer()
                
                Text("AI Search Result").font(Font.custom("SF Pro", size: 15).weight(.semibold)).foregroundColor(Color.black)
                
                Spacer()
                
                Button(action: {
                    coreDataModel.dataAISearch = coreDataModel.readAISearch()
                    coreDataModel.dataAISearchFavorite = coreDataModel.readAISearch(target: true)
                    self.isShowing.toggle()
                }) {
                    Text("Done").font(Font.custom("SF Pro", size: 15).weight(.semibold)).foregroundColor(Color.theme.azure)
                }
            }.padding()
                .background(.white)
                .roundedCorner(12, corners: [.topLeft, .topRight])
            
            VStack(alignment: .leading, spacing: 0) {
                if coreDataModel.dataAISearchFavorite.count > 0 {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(coreDataModel.dataAISearchFavorite[index].question ?? "")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.black).padding(.bottom, 8)
                        
                        Text(coreDataModel.dataAISearchFavorite[index].answer ?? "").font(.system(size: 17, weight: .regular)).foregroundColor(.black)
                    }.padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 0))
                }
            }.padding()
                .frame(maxWidth: .infinity)
            
            Spacer()
        }.background(Color.theme.antiFlashWhite)
    }
}

struct AIButton: View {
    @Binding var isFavorite: Bool
    @EnvironmentObject var coreDataModel: CoreDataModelState
    
    var body: some View {
        Button(action: {
            isFavorite.toggle()
//            coreDataModel.save()
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
