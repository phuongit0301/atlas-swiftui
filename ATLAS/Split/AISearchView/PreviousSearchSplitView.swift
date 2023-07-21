//
//  PreviousSearchSplitView.swift
//  ATLAS
//
//  Created by phuong phan on 13/07/2023.
//

import SwiftUI
import SwiftData

struct PreviousSearchSplitView: View {
    @Environment(\.modelContext) private var context
    var title = "Previous Searches"
    
    @Query(filter: #Predicate { $0.isFavorite }, sort: \.creationDate, order: .forward)
    var results: [SDAISearchModel]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HeaderViewSplit(isMenu: true)
            
            if results.count == 0 {
                List {
                    Text("No search saved").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.philippineGray2)
                }.frame(maxHeight: .infinity)
            } else {
                NavigationStack {
                    List {
                        Section {
                            Text(title).font(.system(size: 20, weight: .semibold)).foregroundColor(.black).padding(.vertical)
                            
                            ForEach(results, id: \.id) {item in
                                NavigationLink(destination: AISearchDetailSplitView(item: item)) {
                                    Text(item.question).font(.system(size: 20, weight: .regular)).foregroundColor(.black).padding(.trailing)
                                    
                                    if item.isFavorite {
                                        Button(action: {
                                            item.isFavorite.toggle()
                                        }, label: {
                                            Image(systemName: "star.fill")
                                                .foregroundColor(Color.theme.azure)
                                                .frame(width: 22, height: 22)
                                                .scaledToFit()
                                                .aspectRatio(contentMode: .fit)
                                        })
                                        
                                    } else {
                                        Button(action: {
                                            item.isFavorite.toggle()
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
                    }.listStyle(.plain)
                        .navigationBarHidden(true)
                }
            }
            
        }
        
    }
}

#Preview {
    PreviousSearchSplitView()
}
