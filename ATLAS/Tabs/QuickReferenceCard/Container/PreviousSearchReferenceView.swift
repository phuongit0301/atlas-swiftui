//
//  PreviousSearchReferenceView.swift
//  ATLAS
//
//  Created by phuong phan on 13/07/2023.
//

import SwiftUI
import SwiftData

struct PreviousSearchReferenceView: View {
    @Environment(\.modelContext) private var context
    var title = "Previous Searches"
    
    @Query(filter: #Predicate { $0.isFavorite }, sort: \.creationDate, order: .forward)
    var results: [SDAISearchModel]
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text(title).font(.system(size: 20, weight: .semibold)).foregroundColor(.black).padding(.vertical)
                    
                    if results.count == 0 {
                        Text("No search saved").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.philippineGray2)
                    } else {
                        ForEach(results, id: \.id) {item in
                            NavigationLink(destination: AISearchDetailView(item: item)) {
                                Text(item.question).font(.system(size: 20, weight: .regular)).foregroundColor(.black)
                                
                                Spacer().frame(maxWidth: .infinity)
                                
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
                }
            }.listStyle(.plain)
                .navigationBarHidden(true)
        }
    }
}

#Preview {
    PreviousSearchReferenceView()
}
