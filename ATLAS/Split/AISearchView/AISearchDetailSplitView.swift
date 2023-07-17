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
    
    @State var item: SDAISearchModel?
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderViewSplit(isMenu: true, isNext: true)
            
            VStack(alignment: .leading) {
                HStack(spacing: 0) {
                    Text(item?.question ?? "").font(.system(size: 20, weight: .semibold)).foregroundColor(.black).padding(.trailing)
                    
                    Spacer()
                    
                    HStack(spacing: 0) {
                        if item?.isFavorite == true {
                            Button(action: {
                                if item?.isFavorite != nil {
                                    item?.isFavorite.toggle()
                                }
                            }, label: {
                                Image(systemName: "star.fill")
                                    .foregroundColor(Color.theme.azure)
                                    .frame(width: 22, height: 22)
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fit)
                            }).padding(.horizontal)
                        } else {
                            Button(action: {
                                if item?.isFavorite != nil {
                                    item?.isFavorite.toggle()
                                }
                            }, label: {
                                Image(systemName: "star")
                                    .foregroundColor(Color.theme.azure)
                                    .frame(width: 22, height: 22)
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fit)
                            }).padding(.horizontal)
                        }
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Text("Done").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.theme.azure)
                        })
                    }
                }
                
                Divider()
                
                Text(item?.answer ?? "").font(.system(size: 17, weight: .regular)).foregroundColor(.black).padding(.vertical)
            }.padding()
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}
