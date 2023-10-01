//
//  OverviewView.swift
//  ATLAS
//
//  Created by phuong phan on 20/05/2023.
//

import Foundation
import SwiftUI

struct OverviewSplitView: View {
    var viewInformationModel = ListReferenceModel()
    var viewUtilitiesModel = ListUtilitiesModel()
    
    var body: some View {
        // flight informations
        VStack (spacing: 0) {
            HStack {
                Text("Clipboard").foregroundColor(Color.theme.eerieBlack).font(.system(size: 17, weight: .semibold))
                
                Spacer()
            }.padding()
                .background(Color.theme.antiFlashWhite)
                .zIndex(10)
            
            List {
                ForEach(viewInformationModel.ListItem.indices, id: \.self) { index in
                    NavigationLink(destination: getDestinationSplit(viewInformationModel.ListItem[index])) {
                        HStack {
                            Text(viewInformationModel.ListItem[index].name).foregroundColor(Color.theme.eerieBlack).font(.system(size: 17, weight: .medium))
                        }
                        
                        if index + 1 < viewInformationModel.ListItem.count {
                            Divider().padding(.horizontal, -16)
                        }
                    }
                }
                
//                HStack {
//                    Text("Utilities").foregroundColor(Color.theme.eerieBlack).font(.system(size: 20, weight: .semibold))
//
//                    Spacer()
//
////                    HStack {
////                        Image(systemName: "plus")
////                            .resizable()
////                            .frame(width: 16, height: 16)
////                            .foregroundColor(Color.theme.azure)
////                        Text("Add Item").foregroundColor(Color.theme.azure)
////                            .font(.system(size: 17, weight: .regular))
////                    }
//                }.padding(.vertical, 10)
//                ForEach(viewUtilitiesModel.ListItem, id: \.self) { item in
//                    NavigationLink(destination: getDestinationSplitTable(item)) {
//                        HStack {
//                            Text(item.name).foregroundColor(Color.theme.eerieBlack).font(.system(size: 17, weight: .regular))
//                        }
//                    }
//                }
            }.scrollContentBackground(.hidden)
                .listRowSeparator(.hidden)
                .padding(.top, -32)
                
        }
    }
    
    struct OverviewView_Previews: PreviewProvider {
        static var previews: some View {
            OverviewView()
        }
    }
}
