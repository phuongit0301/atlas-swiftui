//
//  HeaderViewSplit.swift
//  ATLAS
//
//  Created by phuong phan on 18/06/2023.
//

import Foundation
import SwiftUI

struct HeaderViewSplit: View {
    @EnvironmentObject var sideMenuState: SideMenuModelState
    @Environment(\.dismiss) private var dismiss
    var viewInformationModel = ListReferenceModel()
    
    @State var searchText: String = ""
    var isBack: Bool = false
    var isMenu: Bool = false
    var isNext: Bool = false
    @State var item: ListFlightInformationItem?
    @State private var isActive: Bool = false
    
    var body: some View {
//        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading) {
                    Rectangle().fill(.clear).frame(height: 30)
                    
                    HStack(spacing: 0) {
                        if isBack {
                            Button(action: {
                                dismiss()
                            }) {
                                HStack(spacing: 0) {
                                    Image(systemName: "chevron.left")
                                        .frame(width: 17, height: 22)
                                        .foregroundColor(Color.theme.azure)
                                        .scaledToFit()
                                        .aspectRatio(contentMode: .fit)
                                    Text("Back")
                                        .font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                                }
                            }
                        }
                        
                        if isMenu {
                            Button(action: {
                                dismiss()
                            }) {
                                Text("Menu").foregroundColor(Color.theme.azure).font(.system(size: 17, weight: .semibold))
                            }
                        }
                        
                        HStack(alignment: .center, spacing: 0) {
                            
                            Text(sideMenuState.selectedMenu?.name ?? "").foregroundColor(Color.theme.eerieBlack).font(.system(size: 17, weight: .semibold))
                            
                            if sideMenuState.selectedMenu?.date != nil {
                                Text(sideMenuState.selectedMenu?.date ?? "").foregroundColor(Color.theme.eerieBlack).padding(.horizontal, 5).font(.system(size: 17, weight: .semibold))
                            }
                        }.frame(maxWidth: .infinity)
                        
                        if isNext {
                            if let screen = item {
                                NavigationLink(destination: NoteDestinationSplit(item: screen)) {
                                    Text("Next").foregroundColor(Color.theme.azure).font(.system(size: 17, weight: .semibold))
                                }
//                                NavigationLink(destination: getDestinationNextSplit(screen, viewInformationModel.ListItem)) {
//                                    Text("Next").foregroundColor(Color.theme.azure).font(.system(size: 17, weight: .semibold))
//                                }
                            }
                        }
                    }
                    //                ZStack(alignment: .leading) {
                    //                    HStack {
                    //                        Image(systemName: "magnifyingglass").resizable().frame(width: 22, height: 22).aspectRatio(contentMode: .fit).foregroundColor(Color.theme.arsenic.opacity(0.6))
                    //                        
                    //                        TextField("Can this be AI Search?", text: $searchText)
                    //                        
                    //                        Image(systemName: "mic.fill").resizable().frame(width: 17, height: 22).aspectRatio(contentMode: .fit).foregroundColor(Color.theme.arsenic.opacity(0.6))
                    //                    }.padding()
                    //                        .background(Color.theme.sonicSilver.opacity(0.12))
                    //                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    //                }
                    
                }.padding()
            }.background(.white)
//        }
        Rectangle().fill(Color.black.opacity(0.3)).frame(height: 1)
    }
}
