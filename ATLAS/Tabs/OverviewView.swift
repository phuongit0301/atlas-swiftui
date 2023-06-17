//
//  OverviewView.swift
//  ATLAS
//
//  Created by phuong phan on 20/05/2023.
//

import Foundation
import SwiftUI

struct OverviewView: View {
    var viewInformationModel = ListFlightInformationModel()
    var viewUtilitiesModel = ListFlightUtilitiesModel()
    
    var body: some View {
        // flight informations
        VStack {
            List {
                HStack {
                    Text("Notes").foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-SemiBold", size: 20))
                }
                ForEach(viewInformationModel.ListItem, id: \.self) { item in
                    NavigationLink(destination: ExampleView()) {
                        HStack {
                            Text(item.name).foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-SemiBold", size: 16))
                        }
                    }
                }
                
                HStack {
                    Text("Utilities").foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-SemiBold", size: 20))
                    
                    Spacer()
                    
                    HStack {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 16, height: 16)
                            .foregroundColor(Color.theme.azure)
                        Text("Add Item").foregroundColor(Color.theme.azure)
                            .font(.custom("Inter-Regular", size: 17))
                    }
                }
                ForEach(viewUtilitiesModel.ListItem, id: \.self) { item in
                    NavigationLink(destination: ExampleView()) {
                        HStack {
                            Text(item.name).foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-SemiBold", size: 16))
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.theme.cultured)
            .listStyle(.insetGrouped)
        }
    }
    
    struct OverviewView_Previews: PreviewProvider {
        static var previews: some View {
            OverviewView()
        }
    }
}
