//
//  GeneralPopoverView.swift
//  ATLAS
//
//  Created by phuong phan on 17/09/2023.
//

import SwiftUI

struct GeneralPopoverView: View {
    @State var selectedStation: StationDataDropDown = StationDataDropDown.item1
    @State var selectedRunway: RunwayDataDropDown = RunwayDataDropDown.item1
    @State var tfPost: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Picker("", selection: $selectedStation) {
                ForEach(StationDataDropDown.allCases, id: \.self) {
                    Text($0.rawValue).tag($0.rawValue)
                }
            }.pickerStyle(MenuPickerStyle())
                .padding(.leading, -12)
            
            HStack {
                TextField("Write Post", text: $tfPost)
                    .font(.system(size: 15)).frame(maxWidth: .infinity)
                    .frame(height: 44)
                
                Button(action: {
                    //Todo
                }, label: {
                    Text("Post").font(.system(size: 15, weight: .regular)).foregroundColor(Color.white)
                }).padding(.vertical, 4)
                    .padding(.horizontal, 24)
                    .background(Color.theme.philippineGray3)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.theme.coralRed1, lineWidth: 0))
                    .cornerRadius(12)
            }
            
        }.padding()
    }
}
