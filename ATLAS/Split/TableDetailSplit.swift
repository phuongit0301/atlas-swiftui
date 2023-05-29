//
//  TableDetailSplit.swift
//  ATLAS
//
//  Created by phuong phan on 29/05/2023.
//

import Foundation
import SwiftUI

struct TableDetailSplit: View {
    @State var row: ListFlightSplitItem
    var data = ListDetailModel().ListItem
    
    var body: some View {
        if let dataTable = data.first(where: {$0.id == row.idReference}) {
            
            GeometryReader { geo in
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(dataTable.name).foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-SemiBold", size: 22))
                            .background(Color.white)
                            .padding(8)
                        
                        VStack(alignment: .center) {
                            Rectangle().fill(Color.theme.chineseSilver2).frame(height: 1)
                            
                            VStack(alignment: .leading, spacing: 0) {
                                VStack(alignment: .center, spacing: 0) {
                                    Text(dataTable.location).foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-SemiBold", size: 12))
                                    HStack {
                                        Text(dataTable.fromDegree)
                                        Text(" - ")
                                        Text(dataTable.toDegree)
                                    }
                                }
                                .frame(maxWidth: geo.size.width)
                                .padding(.vertical, 8)
                                
                                Rectangle().fill(Color.theme.chineseSilver2).frame(height: 1)
                                
                                HStack(spacing: 0) {
                                    VStack(alignment: .center, spacing: 0) {
                                        Text("Cleared").foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-SemiBold", size: 12))
                                        Text("Metre FL").foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-Regular", size: 12))
                                    }.frame(maxWidth: .infinity)
                                        .padding(.vertical, 8)
                                    
                                    Rectangle().fill(Color.theme.chineseSilver2).frame(width: 1)
                                    
                                    VStack(alignment: .center, spacing: 0) {
                                        Text("Select").foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-SemiBold", size: 12))
                                        Text("FL in Feet").foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-Regular", size: 12))
                                    }.frame(maxWidth: .infinity)
                                        .padding(.vertical, 8)
                                }.frame(maxWidth: .infinity) // header
                                
                                Rectangle().fill(Color.theme.chineseSilver2).frame(height: 1)
                                
                                VStack(alignment: .center, spacing: 0) {
                                    ForEach(0..<dataTable.cleared.count) { i in
                                        HStack(spacing: 0) {
                                            Text("\(dataTable.cleared[i])").foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-Regular", size: 12))
                                                .padding(10)
                                                .frame(maxWidth: .infinity)
                                                .border(Color.theme.chineseSilver2, width: 1)
                                            
                                            Text("\(dataTable.select[i])").foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-Regular", size: 12))
                                                .padding(10)
                                                .frame(maxWidth: .infinity)
                                                .border(Color.theme.chineseSilver2, width: 1)
                                            
                                        }.background(i % 2 == 0 ? Color.theme.azureishWhite : Color.white)
                                    }
                                }//content
                            }
                        }
                        .border(Color.theme.chineseSilver2, width: 1)
                        .cornerRadius(4)
                        .frame(maxWidth: .infinity)                        
                    }
                }.padding()
            }
        }
    }
}
