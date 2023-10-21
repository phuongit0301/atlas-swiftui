//
//  MetarTafDepSubSectionView.swift
//  ATLAS
//
//  Created by phuong phan on 21/10/2023.
//

import SwiftUI

struct MetarTafDepSubSectionView: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @State private var isDepShow = true
    let redWords: [String] = ["TEMPO", "RA", "SHRA", "RESHRA", "-SHRA", "+SHRA", "TS", "TSRA", "-TSRA", "+TSRA", "RETS"]
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(alignment: .center, spacing: 8) {
                Text("Departure METAR & TAF").foregroundStyle(Color.black).font(.system(size: 15, weight: .semibold))
                
                if isDepShow {
                    Image(systemName: "chevron.down")
                        .foregroundColor(Color.blue)
                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                } else {
                    Image(systemName: "chevron.up")
                        .foregroundColor(Color.blue)
                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                }
                
                Spacer()
            }.frame(height: 52)
                .contentShape(Rectangle())
                .onTapGesture {
                    self.isDepShow.toggle()
                }
            
            if isDepShow {
                if coreDataModel.dataDepartureMetarTaf == nil {
                    HStack(alignment: .center) {
                        Text("No Departure METAR & TAF saved").foregroundColor(Color.theme.philippineGray2).font(.system(size: 17, weight: .regular))
                        Spacer()
                    }.frame(height: 44)
                } else {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("\(coreDataModel.dataDepartureMetarTaf?.unwrappedAirport ?? "") \(coreDataModel.dataDepartureMetarTaf?.unwrappedStd ?? "")")
                            .font(.system(size: 15, weight: .semibold)).foregroundColor(Color.black)
                            .frame(height: 44)
                        
                        Text("METAR")
                            .font(.system(size: 15, weight: .medium)).foregroundColor(Color.black)
                            .frame(height: 44)
                        
                        Divider().padding(.horizontal, -16)
                        
                        if let departureMetarTaf = coreDataModel.dataDepartureMetarTaf?.unwrappedMetar {
                            HStack {
                                NewFlowLayout(alignment: .leading) {
                                    ForEach(departureMetarTaf.components(separatedBy: " "), id: \.self) { word in
                                        if redWords.contains(word) {
                                            Text(word)
                                                .font(.system(size: 15, weight: .regular))
                                                .foregroundColor(.red)
                                        } else if let number = Int(word), number < 3000 {
                                            Text(word)
                                                .font(.system(size: 15, weight: .regular))
                                                .foregroundColor(.red)
                                        } else if word.range(of: #"^\d{3}$"#, options: .regularExpression) != nil {
                                            Text(word)
                                                .font(.system(size: 15, weight: .regular))
                                                .foregroundColor(.green)
                                        } else if word.range(of: #"\d+KT"#, options: .regularExpression) != nil || word.range(of: #"^\d{4}$"#, options: .regularExpression) != nil {
                                            Text(word)
                                                .font(.system(size: 15, weight: .regular))
                                                .foregroundColor(.green)
                                        } else {
                                            Text(word).font(.system(size: 15, weight: .regular))
                                        }
                                    }
                                }
                            }.padding(.vertical, 8)
                        }
                        
                        Text("TAF")
                            .font(.system(size: 15, weight: .medium)).foregroundColor(Color.black)
                            .frame(height: 44)
                        
                        Divider().padding(.horizontal, -16)
                        
                        if let departureTaf = coreDataModel.dataDepartureMetarTaf?.unwrappedTaf {
                            HStack {
                                NewFlowLayout(alignment: .leading) {
                                    ForEach(departureTaf.components(separatedBy: " "), id: \.self) { word in
                                        if redWords.contains(word) {
                                            Text(word)
                                                .font(.system(size: 15, weight: .regular))
                                                .foregroundColor(.red)
                                        } else if let number = Int(word), number < 3000 {
                                            Text(word)
                                                .font(.system(size: 15, weight: .regular))
                                                .foregroundColor(.red)
                                        } else if word.range(of: #"^\d{3}$"#, options: .regularExpression) != nil {
                                            Text(word)
                                                .font(.system(size: 15, weight: .regular))
                                                .foregroundColor(.green)
                                        } else if word.range(of: #"\d+KT"#, options: .regularExpression) != nil || word.range(of: #"^\d{4}$"#, options: .regularExpression) != nil {
                                            Text(word)
                                                .font(.system(size: 15, weight: .regular))
                                                .foregroundColor(.green)
                                        } else {
                                            Text(word).font(.system(size: 15, weight: .regular))
                                        }
                                    }
                                }
                            }.padding(.vertical, 8)
                        }
                    }.padding(.bottom)
                }
                
            }
        }.padding(.horizontal)
            .background(Color.white)
            .cornerRadius(8)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 0))
    }
}
