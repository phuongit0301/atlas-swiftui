//
//  OverviewView.swift
//  ATLAS
//
//  Created by phuong phan on 20/05/2023.
//

import Foundation
import SwiftUI

struct OverviewView: View {
    var viewInformationModel = ListReferenceModel()
    var viewUtilitiesModel = ListUtilitiesModel()
    @EnvironmentObject var refState: ScreenReferenceModel
//    @State private var isActive: Bool = false
//    @State private var selectedItem: ListFlightInformationItem?
    
    var body: some View {
        // flight informations
        VStack (spacing: 0) {
            if refState.isActive {
                if refState.isTable {
                    getDestinationTable(refState.selectedItem!)
                } else {
                    getDestination(refState.selectedItem!)
                }
            } else {
                //            NavigationStack {
                                List {
                                    HStack {
                                        Text("Notes").foregroundColor(Color.theme.eerieBlack).font(.system(size: 20, weight: .semibold))
                                    }.padding(.vertical, 10)
                                    ForEach(viewInformationModel.ListItem, id: \.self) { item in
                                        HStack {
                                            Text(item.name).foregroundColor(Color.theme.eerieBlack).font(.system(size: 17, weight: .regular))
                                            Spacer()
                                        }.contentShape(Rectangle())
                                            .onTapGesture {
                                                refState.isActive = true
                                                refState.selectedItem = item
                                            }
                                    }
                                    
                                    HStack {
                                        Text("Utilities").foregroundColor(Color.theme.eerieBlack).font(.system(size: 20, weight: .semibold))
                                        
                                        Spacer()
                                        
                //                        HStack {
                //                            Image(systemName: "plus")
                //                                .resizable()
                //                                .frame(width: 16, height: 16)
                //                                .foregroundColor(Color.theme.azure)
                //                            Text("Add Item").foregroundColor(Color.theme.azure)
                //                                .font(.system(size: 17, weight: .regular))
                //                        }
                                    }.padding(.vertical, 10)
                                    
                                    ForEach(viewUtilitiesModel.ListItem, id: \.self) { item in
                                        HStack {
                                            Text(item.name).foregroundColor(Color.theme.eerieBlack).font(.system(size: 17, weight: .regular))
                                            Spacer()
                                        }.contentShape(Rectangle())
                                            .onTapGesture {
                                                refState.isActive = true
                                                refState.selectedItem = item
                                                refState.isTable = true
                                            }
                                    }
                                    
                                }.scrollContentBackground(.hidden)
                //                    .navigationBarHidden(true)
                                    .ignoresSafeArea()
                //            }
            }

        }
    }
    
    struct OverviewView_Previews: PreviewProvider {
        static var previews: some View {
            OverviewView().environmentObject(TabModelState())
                .environmentObject(SideMenuModelState())
        }
    }
}
