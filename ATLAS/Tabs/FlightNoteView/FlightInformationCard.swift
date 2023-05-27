//
//  FlightInformation.swift
//  ATLAS
//
//  Created by phuong phan on 21/05/2023.
//

import Foundation
import SwiftUI

struct FlightInformationCard: View {
    var viewModel = ListFlightNoteInformationModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // flight informations
            Collapsible {
                Text("Flight Information")
                    .font(.custom("Inter-SemiBold", size: 20))
                    .foregroundColor(.black)
            } content: {
                VStack(spacing: 0) {
                    Rectangle().fill(Color.theme.eerieBlack).frame(height: 1)
                    
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
                            .padding(.vertical, 12)
                        Divider()
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
            }.padding(.horizontal, 16)
                .padding(.vertical, 8)
        }.background(.white)
            .cornerRadius(8)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}
