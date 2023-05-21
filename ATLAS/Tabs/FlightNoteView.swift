//
//  FlightNoteView.swift
//  ATLAS
//
//  Created by phuong phan on 20/05/2023.
//

import Foundation
import SwiftUI

struct FlightNoteView: View {
    var viewModel = ListFlightNoteInformationModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            // flight informations
            Collapsible {
                Text("Flight Information")
                    .font(.custom("Inter-SemiBold", size: 20))
                    .foregroundColor(.black)
            } content: {
                VStack(spacing: 0) {
                    ForEach(viewModel.ListItem, id: \.self) { item in
                        Button(action: {
                            print("Clicked 11!")
                        }) {
                            HStack {
                                Text(item.name).foregroundColor(Color.theme.eerieBlack).fontWeight(.semibold).font(.system(size: 16))
                                Spacer()
                                Text(item.date).foregroundColor(Color.theme.eerieBlack).fontWeight(.regular).font(.system(size: 16))
                            }
                        }.buttonStyle(PlainButtonStyle())
                    }
                }
            } headerContent: {
                HStack {
                    Text("Last updated: 28 May 2023, 22:30 (UTC+8)")
                        .padding(.horizontal, 32)
                        .foregroundColor(Color.theme.eerieBlack)
                        .font(.custom("Inter-Regular", size: 11))
                    Spacer()
                    Button(action: {
                        print("Three dot clicked!!")
                    }) {
                        Image("icon_ellipsis_circle")
                            .frame(width: 24, height: 24)
                            .scaledToFit()
                            .aspectRatio(contentMode: .fit)
                    }.padding(.horizontal, 32)
                }
            }
        }.padding(16)
        .background(Color.theme.cultured)
    }
}
