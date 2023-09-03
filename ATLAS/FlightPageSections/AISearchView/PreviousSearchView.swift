//
//  PreviousSearchView.swift
//  ATLAS
//
//  Created by phuong phan on 13/07/2023.
//

import SwiftUI

struct PreviousSearchView: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    
    var title = "Previous Searches"
//
//    @Query(sort: \.creationDate, order: .forward)
//    var results: [AISearchView]
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text(title).font(.system(size: 20, weight: .semibold)).foregroundColor(.black).padding(.vertical)
                    
                    ForEach(coreDataModel.dataAISearch.indices, id: \.self) {index in
                        NavigationLink(destination: AISearchDetailView(dataAISearch: $coreDataModel.dataAISearch, index: index)) {
                            Text(coreDataModel.dataAISearch[index].question ?? "").font(.system(size: 20, weight: .regular)).foregroundColor(.black)
                            
                            Spacer().frame(maxWidth: .infinity)
                            
                            Button(action: { onUpdate(index) }) {
                                coreDataModel.dataAISearch[index].isFavorite ?
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
                            }
                        }.buttonStyle(PlainButtonStyle())
                    }
                }
            }.listStyle(.plain)
        }
    }
    
    func onUpdate(_ index: Int) {
        coreDataModel.dataAISearch[index].isFavorite.toggle()
        coreDataModel.save()
        coreDataModel.dataAISearch = coreDataModel.readAISearch()
        coreDataModel.dataAISearchFavorite = coreDataModel.readAISearch(target: true)
    }
}
