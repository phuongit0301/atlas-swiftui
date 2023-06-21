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
    @EnvironmentObject var modelState: TabModelState
    
    var body: some View {
        // flight informations
        VStack (spacing: 0) {
            List {
                HStack {
                    Text("Notes").foregroundColor(Color.theme.eerieBlack).font(.system(size: 20, weight: .semibold))
                }.padding(.vertical, 10)
                ForEach(viewInformationModel.ListItem, id: \.self) { item in
                    NavigationLink(destination: getDestination(item)) {
                        Text(item.name).foregroundColor(Color.theme.eerieBlack).font(.system(size: 17, weight: .regular))
                    }
                }
                
                HStack {
                    Text("Utilities").foregroundColor(Color.theme.eerieBlack).font(.system(size: 20, weight: .semibold))
                    
                    Spacer()
                    
                    HStack {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 16, height: 16)
                            .foregroundColor(Color.theme.azure)
                        Text("Add Item").foregroundColor(Color.theme.azure)
                            .font(.system(size: 17, weight: .regular))
                    }
                }.padding(.vertical, 10)
                
                ForEach(viewUtilitiesModel.ListItem, id: \.self) { item in
                    NavigationLink(destination: getDestinationTable(item)) {
                        HStack {
                            Text(item.name).foregroundColor(Color.theme.eerieBlack).font(.system(size: 17, weight: .regular))
                        }
                    }
                }
            }.scrollContentBackground(.hidden)
        }
    }
    
    struct OverviewView_Previews: PreviewProvider {
        static var previews: some View {
            OverviewView().environmentObject(TabModelState())
                .environmentObject(SideMenuModelState())
        }
    }
}
