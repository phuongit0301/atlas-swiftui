//
//  ClipboardAISearchCompletedResult.swift
//  ATLAS
//
//  Created by phuong phan on 13/07/2023.
//

import SwiftUI
import Foundation

struct ClipboardAISearchCompletedResult: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var aiSearchState: AISearchModelState
    @EnvironmentObject var refState: ScreenReferenceModel
    
    @State private var showSheet: Bool = false
    @State private var currentIndex = -1
    var title = "Previous Searches"
    
    var body: some View {
        VStack {
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
                .padding(.leading)
                .background(Color.theme.antiFlashWhite)
                .zIndex(10)
            
            List {
                Section {
                    if coreDataModel.dataAISearchFavorite.count == 0 {
                        Text("No search saved")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(Color.theme.philippineGray2)
                            .frame(height: 44)
                    } else {
                        ForEach(coreDataModel.dataAISearchFavorite.indices, id: \.self) { index in
                            VStack {
                                HStack(alignment: .center) {
                                    Image(systemName: "line.3.horizontal")
                                        .foregroundColor(Color.theme.arsenic.opacity(0.3))
                                        .frame(width: 22, height: 22)
                                        .scaledToFit()
                                        .aspectRatio(contentMode: .fit)
                                    
                                    VStack(alignment: .leading) {
                                        Text(coreDataModel.dataAISearchFavorite[index].question ?? "").font(.system(size: 15, weight: .regular)).foregroundColor(.black)
                                        Text(renderDate(coreDataModel.dataAISearchFavorite[index].creationDate!)).font(.system(size: 11, weight: .regular)).foregroundColor(Color.theme.arsenic.opacity(0.6))
                                    }
                                    
                                    
                                    Spacer().frame(maxWidth: .infinity)
                                    
                                    if coreDataModel.dataAISearchFavorite[index].isFavorite {
                                        Button(action: {
                                            
                                        }, label: {
                                            Image(systemName: "star.fill")
                                                .foregroundColor(Color.theme.azure)
                                                .frame(width: 22, height: 22)
                                                .scaledToFit()
                                                .aspectRatio(contentMode: .fit)
                                        }).buttonStyle(PlainButtonStyle())
                                        
                                    } else {
                                        Button(action: {
                                            
                                        }, label: {
                                            Image(systemName: "star")
                                                .foregroundColor(Color.theme.azure)
                                                .frame(width: 22, height: 22)
                                                .scaledToFit()
                                                .aspectRatio(contentMode: .fit)
                                        }).buttonStyle(PlainButtonStyle())
                                    }
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color.theme.charlestonGreen)
                                        .scaledToFit()
                                        .aspectRatio(contentMode: .fit)
                                }
                                
                                if index + 1 < coreDataModel.dataAISearchFavorite.count {
                                    Divider().padding(.horizontal, -16)
                                }
                            }.id(UUID())
                                .contentShape(Rectangle())
                                .padding(.vertical, 8)
                                .onTapGesture {
                                    self.currentIndex = index
                                    self.showSheet.toggle()
                                }
                        }
                    }
                }.listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets.init(top: 0, leading: 16, bottom: 0, trailing: 16))
            }.padding(.top, -40)
                .zIndex(-1)
        }.background(Color.theme.antiFlashWhite)
        
    }
    
    func renderDate(_ date: Date) -> String {
        dateFormatter.dateFormat = "dd/MM/yy HHmm"
        return dateFormatter.string(from: date)
    }
}
