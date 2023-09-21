//
//  LimitationsSubSectionView.swift
//  ATLAS
//
//  Created by phuong phan on 21/09/2023.
//

import SwiftUI

struct IDataLimitation: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var period: String
    var status: String
    var color: String
}

let MOCK_DATA_LIMITATION = [
    IDataLimitation(id: UUID(), name: "Max 900 flight hours in 365 days", period: "DD/MM/YY to DD/MM/YY", status: "922:47 / 900:00", color: "red"),
    IDataLimitation(id: UUID(), name: "Max 20 flight hours in 30 days", period: "DD/MM/YY to DD/MM/YY", status: "922:47 / 900:00", color: "yellow"),
    IDataLimitation(id: UUID(), name: "Max 900 flight hours in 365 days ", period: "DD/MM/YY to DD/MM/YY", status: "922:47 / 900:00", color: "black"),
    IDataLimitation(id: UUID(), name: "Max 900 flight hours in 365 days ", period: "DD/MM/YY to DD/MM/YY", status: "922:47 / 900:00", color: "black"),
    IDataLimitation(id: UUID(), name: "Max 900 flight hours in 365 days ", period: "DD/MM/YY to DD/MM/YY", status: "922:47 / 900:00", color: "black"),
]

struct LimitationsSubSectionView: View {
    
    @State var isCollapse = false
    
    var body: some View {
        GeometryReader { proxy in
            HStack(spacing: 0) {
                List {
                    Section {
                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                HStack(alignment: .center) {
                                    Text("Limitations").font(.system(size: 20, weight: .semibold)).foregroundStyle(Color.black)
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    // Todo
                                }, label: {
                                    Text("Add Item")
                                        .font(.system(size: 17, weight: .regular)).textCase(nil)
                                        .foregroundColor(Color.theme.azure)
                                }).buttonStyle(PlainButtonStyle())
                            }.contentShape(Rectangle())
                                .padding()
                            
                            if !isCollapse {
                                VStack(alignment: .leading) {
                                    Grid(alignment: .topLeading, horizontalSpacing: 8, verticalSpacing: 12) {
                                        GridRow {
                                            Text("Limitation")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundColor(Color.black)
                                                .frame(width: proxy.size.width - 534, alignment: .leading)
                                            
                                            Text("Period")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundColor(Color.black)
                                                .frame(width: 240, alignment: .leading)
                                            
                                            Text("Status")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundColor(Color.black)
                                                .frame(width: 208, alignment: .leading)
                                        }
                                        
                                        Divider().padding(.horizontal, -16)
                                        
                                        ForEach(MOCK_DATA_LIMITATION.indices, id: \.self) {index in
                                            GridRow {
                                                Group {
                                                    Text(MOCK_DATA_LIMITATION[index].name)
                                                        .font(.system(size: 17, weight: .regular))
                                                        .frame(alignment: .leading)
                                                    
                                                    Text(MOCK_DATA_LIMITATION[index].period)
                                                        .font(.system(size: 17, weight: .regular))
                                                        .frame(alignment: .leading)
                                                    
                                                    Text(MOCK_DATA_LIMITATION[index].status)
                                                        .font(.system(size: 17, weight: .regular))
                                                        .frame(alignment: .leading)
                                                }.foregroundColor(fontColor(MOCK_DATA_LIMITATION[index].color))
                                            }
                                            
                                            if index + 1 < MOCK_DATA_LIMITATION.count {
                                                Divider().padding(.horizontal, -16)
                                            }
                                        }
                                    }
                                    
                                }.padding()
                                
                            }
                            
                        }.listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    } // End Section
                    
                }
                
            }
        }
    }
    
    func fontColor(_ color: String) -> Color {
        if color == "red" {
            return Color.theme.coralRed
        } else if color == "yellow" {
            return Color.theme.vividGamboge
        } else {
            return Color.black
        }
    }
}

struct LimitationsSubSectionView_Previews: PreviewProvider {
    static var previews: some View {
        LimitationsSubSectionView()
    }
}
