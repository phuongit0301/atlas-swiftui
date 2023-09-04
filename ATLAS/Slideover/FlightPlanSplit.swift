//
//  NoteDetailSplit.swift
//  ATLAS
//
//  Created by phuong phan on 29/05/2023.
//

import Foundation
import SwiftUI

struct FlightPlanSplit: View {
    @EnvironmentObject var viewModel: FPModelSplitState
    
    var body: some View {
        VStack (spacing: 0) {
            HeaderViewSplit(isMenu: true)
            
            List {
                HStack {
                    Text("Flight Plan").foregroundColor(Color.theme.eerieBlack).font(.system(size: 20, weight: .semibold))
                }.padding(.vertical, 10)
                ForEach(viewModel.fpSplitArray.indices, id: \.self) { index in
                    HStack {
                        Text(viewModel.fpSplitArray[index].name).foregroundColor(Color.theme.eerieBlack).font(.system(size: 17, weight: .regular))
                        
                        Spacer()
                        Text(viewModel.fpSplitArray[index].date).foregroundColor(Color.theme.eerieBlack).font(.system(size: 17, weight: .regular)).padding(.horizontal, 8)
                        
                        Button(action: {
                            viewModel.fpSplitArray[index].isFavourite.toggle()
                        }) {
                            viewModel.fpSplitArray[index].isFavourite ?
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
                    }
                }
            }.scrollContentBackground(.hidden)
                
        }.navigationBarBackButtonHidden()
        .ignoresSafeArea()
    }
}
