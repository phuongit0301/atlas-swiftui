//
//  AISearchDetailView.swift
//  ATLAS
//
//  Created by phuong phan on 16/07/2023.
//

import Foundation
import SwiftUI

struct AISearchDetailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var item: SDAISearchModel?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(item?.question ?? "").font(.system(size: 20, weight: .semibold)).foregroundColor(.black).padding(.vertical)
                
                Spacer().frame(maxWidth: .infinity)
                
                HStack {
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
