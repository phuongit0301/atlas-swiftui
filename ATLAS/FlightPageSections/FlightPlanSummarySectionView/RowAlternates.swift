//
//  RowAlternates.swift
//  ATLAS
//
//  Created by phuong phan on 25/09/2023.
//

import SwiftUI

struct RowAlternates: View {
    let width: CGFloat
    @State private var selectAltn = ""
    @State private var tfVis: String = ""
    @State private var tfMinima: String = ""
    @State private var tfEta: String = ""
    var ALTN_DROP_DOWN: [String] = ["ALTN 1", "ALTN 1", "ALTN 1"]
    
    var body: some View {
        HStack {
            HStack {
                Picker("", selection: $selectAltn) {
                    Text("Select ALTN").tag("")
                    ForEach(ALTN_DROP_DOWN, id: \.self) {
                        Text($0).tag($0)
                    }
                }.pickerStyle(MenuPickerStyle()).fixedSize()
                    .padding(.leading, -12)
            }.fixedSize()
                .frame(width: calculateWidthSummary(width - 56, 4), alignment: .leading)
            
            TextField("Enter VIS",text: $tfVis)
                .frame(width: calculateWidthSummary(width - 56, 4), alignment: .leading)
                .onSubmit {
                    //Todo
                }
            
            TextField("Enter Minima",text: $tfMinima)
                .frame(width: calculateWidthSummary(width - 56, 4), alignment: .leading)
                .onSubmit {
                    //Todo
                }
            
            TextField("Enter ETA",text: $tfEta)
                .frame(width: calculateWidthSummary(width - 56, 4), alignment: .leading)
                .onSubmit {
                    //Todo
                }
        }.frame(height: 44)
    }
}
