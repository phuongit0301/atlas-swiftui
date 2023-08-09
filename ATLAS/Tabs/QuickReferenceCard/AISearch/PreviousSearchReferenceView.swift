//
//  PreviousSearchReferenceView.swift
//  ATLAS
//
//  Created by phuong phan on 13/07/2023.
//

import SwiftUI
import Foundation

struct PreviousSearchReferenceView: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    
    var title = "Previous Searches"
    
    var body: some View {
        NavigationStack {
            List {
                if coreDataModel.dataAISearchFavorite.count == 0 {
                    Section {
                        Text(title).font(.system(size: 20, weight: .semibold)).foregroundColor(.black).padding(.vertical)
                        Text("No search saved").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.philippineGray2)
                    }
                } else {
                    Section {
                        Text(title).font(.system(size: 20, weight: .semibold)).foregroundColor(.black).padding(.vertical)
                        
                        ForEach(coreDataModel.dataAISearchFavorite.indices, id: \.self) { index in
                            NavigationLink(destination: AISearchDetailReferenceView(index: index)) {
                                Text(coreDataModel.dataAISearchFavorite[index].question ?? "").font(.system(size: 20, weight: .regular)).foregroundColor(.black)
                                
                                Spacer().frame(maxWidth: .infinity)
                                
                                if coreDataModel.dataAISearchFavorite[index].isFavorite {
                                    Button(action: {
                                        coreDataModel.dataAISearchFavorite[index].isFavorite.toggle()
                                        coreDataModel.save()
                                        coreDataModel.dataAISearchFavorite = coreDataModel.readAISearch(target: true)
                                        coreDataModel.dataAISearch = coreDataModel.readAISearch()
                                    }, label: {
                                        Image(systemName: "star.fill")
                                            .foregroundColor(Color.theme.azure)
                                            .frame(width: 22, height: 22)
                                            .scaledToFit()
                                            .aspectRatio(contentMode: .fit)
                                    })
                                    
                                } else {
                                    Button(action: {
                                        coreDataModel.dataAISearchFavorite[index].isFavorite.toggle()
                                        coreDataModel.save()
                                        coreDataModel.dataAISearchFavorite = coreDataModel.readAISearch(target: true)
                                        coreDataModel.dataAISearch = coreDataModel.readAISearch()
                                    }, label: {
                                        Image(systemName: "star")
                                            .foregroundColor(Color.theme.azure)
                                            .frame(width: 22, height: 22)
                                            .scaledToFit()
                                            .aspectRatio(contentMode: .fit)
                                    })
                                }
                            }.buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            }.listStyle(.plain)
//                .navigationBarHidden(true)
        }
    }
}
