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
    
    @State var dataAISearch: [AISearchList] = []
    @State var index: Int = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if dataAISearch.count > 0 {
                    Text(dataAISearch[index].question ?? "").font(.system(size: 20, weight: .semibold)).foregroundColor(.black).padding(.vertical)
                }
                
                
                Spacer().frame(maxWidth: .infinity)
                
                HStack {
                    if dataAISearch[index].isFavorite == true {
                        Button(action: {
                            dataAISearch[index].isFavorite.toggle()
                            coreDataModel.save()
                        }, label: {
                            Image(systemName: "star.fill")
                                .foregroundColor(Color.theme.azure)
                                .frame(width: 22, height: 22)
                                .scaledToFit()
                                .aspectRatio(contentMode: .fit)
                        }).padding(.horizontal)
                    } else {
                        Button(action: {
                            dataAISearch[index].isFavorite.toggle()
                            coreDataModel.save()
                        }, label: {
                            Image(systemName: "star")
                                .foregroundColor(Color.theme.azure)
                                .frame(width: 22, height: 22)
                                .scaledToFit()
                                .aspectRatio(contentMode: .fit)
                        }).padding(.horizontal)
                    }
                    Button(action: {
                        coreDataModel.dataAISearch = coreDataModel.readAISearch()
                        coreDataModel.dataAISearchFavorite = coreDataModel.readAISearch(target: true)
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Done").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.theme.azure)
                    })
                }
            }
            
            Divider()
            
            if dataAISearch.count > 0 {
                Text(dataAISearch[index].answer ?? "").font(.system(size: 17, weight: .regular)).foregroundColor(.black).padding(.vertical)
            }
            
            Spacer()
        }.background(
            RoundedRectangle(cornerRadius: 8, style: .continuous).fill(.white)
        )
        .cornerRadius(8)
        .padding()
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}
