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
    
    var body: some View {
        // flight informations
        List {
            HStack {
                Text("Flight Information").foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-SemiBold", size: 20))
                Rectangle().fill(.white).frame(width: 32)
                Text("Last updated: 28 May 2023, 22:30 (UTC+8)").foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-Regular", size: 11))
                Spacer()
                Button(action: {
                    print("Three dot clicked!!")
                }) {
                    Image("icon_ellipsis_circle")
                        .frame(width: 24, height: 24)
                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                }
            }
            ForEach(viewInformationModel.ListItem, id: \.self) { item in
                Button(action: {
                    print("Clicked 11!")
                }) {
                    HStack {
                        Text(item.name).foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-SemiBold", size: 16))
                        Spacer()
                        Text(item.date).foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-Regular", size: 16))
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.theme.cultured)
        .listStyle(.insetGrouped)
        .navigationBarTitleDisplayMode(.inline)
    }
}
