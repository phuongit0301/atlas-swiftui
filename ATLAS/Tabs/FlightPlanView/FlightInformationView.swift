//
//  FlightInformationView.swift
//  ATLAS
//
//  Created by phuong phan on 17/06/2023.
//

import Foundation
import SwiftUI

struct TextBox: View {
    @State private var textNote: String = ""
    
    var body: some View {
        HStack {
            TextField("Value", text: $textNote).fixedSize()
        }
    }
}

struct FlightInformationView: View {
    @State private var viewModel = ListFlightInformationModel()
    @State private var isUTC = true
    
    
    var body: some View {
        // flight informations
        List {
            HStack {
                Text("Flight Information").foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-SemiBold", size: 20))
                Spacer()
                Toggle(isOn: $isUTC) {
                    Text("UTC").foregroundColor(Color.black).font(.custom("Inter-SemiBold", size: 17))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            ForEach(viewModel.ListItem, id: \.self) { item in
                Button(action: {
                    print("Clicked 11!")
                }) {
                    HStack {
                        Text(item.name).foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-SemiBold", size: 16))
                        Spacer()
                        
                        if item.isTextBox {
                            TextBox()
                        } else {
                            Text(item.date).foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-Regular", size: 16))
                        }
                    }
                }
            }
        }
        .keyboardAvoiding()
        .scrollContentBackground(.hidden)
        .background(Color.theme.cultured)
        .listStyle(.insetGrouped)

    }
}

struct FlightInformationView_Previews: PreviewProvider {
    static var previews: some View {
        FlightInformationView()
    }
}
