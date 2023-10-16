//
//  SlideoverRowTextAlternates.swift
//  ATLAS
//
//  Created by phuong phan on 25/09/2023.
//

import SwiftUI

struct SlideoverRowTextAlternates: View {
    let width: CGFloat
    let item: IAlternate
    @Binding var itemList: [IAlternate]
    
    @State private var selectAltn = ""
    @State private var tfVis: String = ""
    @State private var tfMinima: String = ""
    @State private var tfEta: String = ""
//    var ALTN_DROP_DOWN: [String] = ["ALTN 1", "ALTN 1", "ALTN 1"]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(item.altn).frame(width: calculateWidthSummary(width - 56, 2), alignment: .leading)
                
                Text(item.eta).frame(width: calculateWidthSummary(width - 56, 2), alignment: .leading)
            }.frame(height: 44)
            
            HStack {
                Text(item.vis ?? "").frame(width: calculateWidthSummary(width - 56, 2), alignment: .leading)
                
                Text(item.minima ?? "").frame(width: calculateWidthSummary(width - 56, 2), alignment: .leading)
            }.frame(height: 44)
        }
    }
}
