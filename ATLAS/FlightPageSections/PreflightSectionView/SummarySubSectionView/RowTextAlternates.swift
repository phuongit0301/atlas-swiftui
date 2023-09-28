//
//  RowAlternates.swift
//  ATLAS
//
//  Created by phuong phan on 25/09/2023.
//

import SwiftUI

struct RowTextAlternates: View {
    let width: CGFloat
    let index: Int
    @Binding var itemList: [IAlternate]
    
    @State private var selectAltn = ""
    @State private var tfVis: String = ""
    @State private var tfMinima: String = ""
    @State private var tfEta: String = ""
    var ALTN_DROP_DOWN: [String] = ["ALTN 1", "ALTN 1", "ALTN 1"]
    
    var body: some View {
        HStack {
            Text(itemList[index].altn).frame(width: calculateWidthSummary(width - 56, 4), alignment: .leading)
            
            Text(itemList[index].eta).frame(width: calculateWidthSummary(width - 56, 4), alignment: .leading)
            
            Text(itemList[index].vis ?? "").frame(width: calculateWidthSummary(width - 56, 4), alignment: .leading)
            
            Text(itemList[index].minima ?? "").frame(width: calculateWidthSummary(width - 56, 4), alignment: .leading)
            
        }.frame(height: 44)
    }
}
