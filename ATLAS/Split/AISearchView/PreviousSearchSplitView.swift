//
//  PreviousSearchSplitView.swift
//  ATLAS
//
//  Created by phuong phan on 13/07/2023.
//

import SwiftUI

struct PreviousSearchSplitView: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    var title = "Previous Searches"

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HeaderViewSplit(isMenu: true)
            
            if coreDataModel.dataAISearchFavorite.count == 0 {
                List {
                    Text("No search saved").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.philippineGray2)
                }.frame(maxHeight: .infinity)
            } else {
                NavigationStack {
                    List {
                        Section {
                            Text(title).font(.system(size: 20, weight: .semibold)).foregroundColor(.black).padding(.vertical)
                            
                            ForEach(coreDataModel.dataAISearchFavorite.indices, id: \.self) {index in
                                NavigationLink(destination: AISearchDetailSplitView(index: index)) {
                                    HStack {
                                        Text(coreDataModel.dataAISearchFavorite[index].question ?? "").font(.system(size: 20, weight: .regular)).foregroundColor(.black).padding(.trailing)
                                        
                                        Spacer()
                                        
                                        if coreDataModel.dataAISearchFavorite[index].isFavorite {
                                            Button(action: {
                                                coreDataModel.dataAISearchFavorite[index].isFavorite.toggle()
                                                coreDataModel.save()
                                                coreDataModel.dataAISearch = coreDataModel.readAISearch()
                                                coreDataModel.dataAISearchFavorite = coreDataModel.readAISearch(target: true)
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
                                                coreDataModel.dataAISearch = coreDataModel.readAISearch()
                                                coreDataModel.dataAISearchFavorite = coreDataModel.readAISearch(target: true)
                                            }, label: {
                                                Image(systemName: "star")
                                                    .foregroundColor(Color.theme.azure)
                                                    .frame(width: 22, height: 22)
                                                    .scaledToFit()
                                                    .aspectRatio(contentMode: .fit)
                                            })
                                        }
                                    }
                                }.buttonStyle(PlainButtonStyle())
                            }
                        }
                    }.listStyle(.plain)
                        .navigationBarHidden(true)
                }
            }
            
        }
        
    }
}
