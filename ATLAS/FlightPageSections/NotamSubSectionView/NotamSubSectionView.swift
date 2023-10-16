//
//  NotamSubSectionView.swift
//  ATLAS
//
//  Created by phuong phan on 24/9/23.
//

import Foundation
import SwiftUI

struct NotamSubSectionView: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController
    @EnvironmentObject var flightPlanDetailModel: FlightPlanDetailModel
    @StateObject var notamSection = NotamSection()
    // initialise state variables
    @State private var isSortDate = true
    @State var arrDepNotams = [String: [NotamsDataList]]()
    @State var arrDepNotamsDate = [String: String]()
    @State var arrArrNotams = [String: [NotamsDataList]]()
    @State var arrArrNotamsDate = [String: String]()
    @State var arrEnrNotams = [String: [NotamsDataList]]()
    @State var arrEnrNotamsDate = [String: String]()
    @State var arrDestNotams = [String: [NotamsDataList]]()
    @State var arrDestNotamsDate = [String: String]()
    
    //For collpase and expand
    @State private var isDepShow = true
    @State private var isEnrShow = true
    @State private var isArrShow = true
    @State private var isDestShow = true
    
    //For picker
    @State private var selectionDep = ""
    @State private var selectionEnr = ""
    @State private var selectionArr = ""
    @State private var selectionDest = ""
    
    @State private var showUTC = true

    var body: some View {
        if coreDataModel.isNotamLoading {
            HStack(alignment: .center) {
                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.black)).controlSize(.large)
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .background(Color.black.opacity(0.3))
        } else {
            
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .center) {
                    Text("NOTAMS")
                        .font(.system(size: 17, weight: .semibold))
                        .padding(.leading)
                    Spacer()
                    
                    HStack {
                        Toggle(isOn: $showUTC) {
                            Text("Local").font(.system(size: 17, weight: .regular))
                                .foregroundStyle(Color.black)
                        }
                        Text("UTC").font(.system(size: 17, weight: .regular))
                            .foregroundStyle(Color.black)
                    }.fixedSize()
                }.frame(height: 52)
                    .padding(.bottom, 8)
                
                //scrollable outer list section
                ScrollView {
                    // Dep NOTAM section
                    VStack(spacing: 0) {
                        HStack(alignment: .center, spacing: 0) {
                            HStack(alignment: .center, spacing: 8) {
                                Text("Departure NOTAMs").foregroundStyle(Color.black).font(.system(size: 17, weight: .semibold))
                                
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
                                
                            }.contentShape(Rectangle())
                                .onTapGesture {
                                    self.isDepShow.toggle()
                                }
                            
                            Spacer()
                            
                            HStack(alignment: .center, spacing: 16) {
                                HStack(alignment: .center, spacing: 0) {
                                    Toggle(isOn: $isSortDate) {
                                        Text("Most Recent")
                                            .font(.system(size: 17, weight: .regular))
                                            .frame(maxWidth: .infinity, alignment: .trailing)
                                    }.padding(.horizontal)
                                    
                                    Text("Most Relevant")
                                        .font(.system(size: 17, weight: .semibold))
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                }.fixedSize()
                                
                                Picker("", selection: $selectionDep) {
                                    Text("All NOTAMs").tag("").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                                    ForEach(notamSection.dataDropDown, id: \.self) {
                                        Text($0).tag($0)
                                    }
                                }
                            }.fixedSize()
                        }.frame(height: 54)
                        
                        if isDepShow {
                            ForEach(Array(arrDepNotams.keys), id: \.self) {key in
                                NotamSubSectionRowView(item: arrDepNotams[key] ?? [], dates: flightPlanDetailModel.depAirportNotam, key: key)
                            }
                        }
                    }.padding(.horizontal)
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 0))
                    
                    // Enr NOTAM section
                    
                    VStack(spacing: 0) {
                        HStack(alignment: .center, spacing: 0) {
                            HStack(alignment: .center, spacing: 8) {
                                Text("Enroute Alternates NOTAMs").foregroundStyle(Color.black).font(.system(size: 17, weight: .semibold))
                                
                                if isEnrShow {
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
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                self.isEnrShow.toggle()
                            }
                            
                            Spacer()
                            
                            HStack(alignment: .center, spacing: 16) {
                                HStack(alignment: .center, spacing: 0) {
                                    Toggle(isOn: $isSortDate) {
                                        Text("Most Recent")
                                            .font(.system(size: 17, weight: .regular))
                                            .frame(maxWidth: .infinity, alignment: .trailing)
                                    }.padding(.horizontal)
                                    
                                    Text("Most Relevant")
                                        .font(.system(size: 17, weight: .semibold))
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                }.fixedSize()
                                
                                Picker("", selection: $selectionEnr) {
                                    Text("All NOTAMs").tag("").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                                    ForEach(notamSection.dataDropDown, id: \.self) {
                                        Text($0).tag($0)
                                    }
                                }
                            }.fixedSize()
                        }.frame(height: 54)
                        
                        if isEnrShow {
                            ForEach(Array(arrEnrNotams.keys), id: \.self) {key in
                                NotamSubSectionRowView(item: arrEnrNotams[key] ?? [], dates: flightPlanDetailModel.enrAirportNotam, key: key)
                            }
                        }
                    }.padding(.horizontal)
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 0))
                    
                    // Arr NOTAM section
                    VStack(spacing: 0) {
                        HStack(alignment: .center, spacing: 0) {
                            HStack(alignment: .center, spacing: 8) {
                                Text("Arrival NOTAMs").foregroundStyle(Color.black).font(.system(size: 17, weight: .semibold))
                                
                                if isArrShow {
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
                            }.contentShape(Rectangle())
                                .onTapGesture {
                                    self.isArrShow.toggle()
                                }
                            
                            Spacer()
                            
                            HStack(alignment: .center, spacing: 16) {
                                HStack(alignment: .center, spacing: 0) {
                                    Toggle(isOn: $isSortDate) {
                                        Text("Most Recent")
                                            .font(.system(size: 17, weight: .regular))
                                            .frame(maxWidth: .infinity, alignment: .trailing)
                                    }.padding(.horizontal)
                                    
                                    Text("Most Relevant")
                                        .font(.system(size: 17, weight: .semibold))
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                }.fixedSize()
                                
                                Picker("", selection: $selectionArr) {
                                    Text("All NOTAMs").tag("").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                                    ForEach(notamSection.dataDropDown, id: \.self) {
                                        Text($0).tag($0)
                                    }
                                }
                            }.fixedSize()
                        }.frame(height: 54)
                        
                        if isArrShow {
                            ForEach(Array(arrArrNotams.keys), id: \.self) {key in
                                NotamSubSectionRowView(item: arrArrNotams[key] ?? [], dates: flightPlanDetailModel.arrAirportNotam, key: key)
                            }
                        }
                    }.padding(.horizontal)
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 0))
                    
                    // Destination NOTAM section
                    VStack(spacing: 0) {
                        HStack(alignment: .center, spacing: 0) {
                            HStack(alignment: .center, spacing: 8) {
                                Text("Destination Alternates NOTAMs").foregroundStyle(Color.black).font(.system(size: 17, weight: .semibold))
                                
                                if isDestShow {
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
                            }.contentShape(Rectangle())
                                .onTapGesture {
                                    self.isDestShow.toggle()
                                }
                            
                            Spacer()
                            
                            HStack(alignment: .center, spacing: 16) {
                                HStack(alignment: .center, spacing: 0) {
                                    Toggle(isOn: $isSortDate) {
                                        Text("Most Recent")
                                            .font(.system(size: 17, weight: .regular))
                                            .frame(maxWidth: .infinity, alignment: .trailing)
                                    }.padding(.horizontal)
                                    
                                    Text("Most Relevant")
                                        .font(.system(size: 17, weight: .semibold))
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                }.fixedSize()
                                
                                Picker("", selection: $selectionDest) {
                                    Text("All NOTAMs").tag("").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                                    ForEach(notamSection.dataDropDown, id: \.self) {
                                        Text($0).tag($0)
                                    }
                                }
                            }.fixedSize()
                        }.frame(height: 54)
                        
                        if isDestShow {
                            ForEach(Array(arrDestNotams.keys), id: \.self) {key in
                                NotamSubSectionRowView(item: arrDestNotams[key] ?? [], dates: flightPlanDetailModel.destAirportNotam, key: key)
                            }
                        }
                    }.padding(.horizontal)
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 0))
                }.padding(.bottom, 32)
            }.padding(.horizontal, 16)
                .background(Color.theme.antiFlashWhite)
                .onChange(of: selectionDep) { newValue in
                    var temp = [String: [NotamsDataList]]()
                    coreDataModel.dataNotams.forEach { item in
                        let category = item.category ?? ""
                        
                        if item.type == "depNotams" && category == selectionDep {
                            if let airport = item.airport {
                                if temp[airport] != nil {
                                    temp[airport]?.append(item)
                                } else {
                                    temp.updateValue([item], forKey: airport)
                                }
                            }
                        }
                    }
                    arrDepNotams = sortNotamsArray(notamsDict: temp, sortKey: isSortDate)
                }
                .onChange(of: selectionEnr) { newValue in
                    var temp = [String: [NotamsDataList]]()
                    coreDataModel.dataNotams.forEach { item in
                        let category = item.category ?? ""

                        if item.type == "enrNotams" && category == selectionEnr  {
                            if let airport = item.airport {
                                if temp[airport] != nil {
                                    temp[airport]?.append(item)
                                } else {
                                    temp.updateValue([item], forKey: airport)
                                }
                            }
                        }
                    }
                    arrEnrNotams = sortNotamsArray(notamsDict: temp, sortKey: isSortDate)
                }
                .onChange(of: selectionArr) { newValue in
                    var temp = [String: [NotamsDataList]]()
                    coreDataModel.dataNotams.forEach { item in
                        let category = item.category ?? ""
                        
                        if item.type == "arrNotams" && category == selectionArr  {
                            if let airport = item.airport {
                                if temp[airport] != nil {
                                    temp[airport]?.append(item)
                                } else {
                                    temp.updateValue([item], forKey: airport)
                                }
                            }
                        }
                    }
                    arrArrNotams = sortNotamsArray(notamsDict: temp, sortKey: isSortDate)
                }
                .onChange(of: selectionDest) { newValue in
                    var temp = [String: [NotamsDataList]]()
                    
                    coreDataModel.dataNotams.forEach { item in
                        let category = item.category ?? ""
                        
                        if item.type == "destNotams" && category == selectionArr  {
                            if let airport = item.airport {
                                if temp[airport] != nil {
                                    temp[airport]?.append(item)
                                } else {
                                    temp.updateValue([item], forKey: airport)
                                }
                            }
                        }
                    }
                    arrDestNotams = sortNotamsArray(notamsDict: temp, sortKey: isSortDate)
                }
                .onAppear {
                    coreDataModel.dataNotams = coreDataModel.readDataNotamsList()
                    
                    coreDataModel.dataNotams.forEach { item in
                        if item.type == "arrNotams" {
                            if let airport = item.airport {
                                if arrArrNotams[airport] != nil {
                                    arrArrNotams[airport]?.append(item)
                                } else {
                                    arrArrNotams.updateValue([item], forKey: airport)
                                    arrArrNotamsDate.updateValue(item.date ?? "", forKey: "\(airport)")
                                }
                            }
                        } else if item.type == "depNotams" {
                            if let airport = item.airport {
                                if arrDepNotams[airport] != nil {
                                    arrDepNotams[airport]?.append(item)
                                } else {
                                    arrDepNotams.updateValue([item], forKey: airport)
                                    arrDepNotamsDate.updateValue(item.date ?? "", forKey: "\(airport)")
                                }
                            }
                        } else if item.type == "enrNotams" {
                            if let airport = item.airport {
                                if arrEnrNotams[airport] != nil {
                                    arrEnrNotams[airport]?.append(item)
                                } else {
                                    arrEnrNotams.updateValue([item], forKey: airport)
                                    arrEnrNotamsDate.updateValue(item.date ?? "", forKey: "\(airport)")
                                }
                            }
                        } else {
                            if let airport = item.airport {
                                if arrDestNotams[airport] != nil {
                                    arrDestNotams[airport]?.append(item)
                                } else {
                                    arrDestNotams.updateValue([item], forKey: airport)
                                    arrDestNotamsDate.updateValue(item.date ?? "", forKey: "\(airport)")
                                }
                            }
                        }
                    }
                    
                    arrDepNotams = sortNotamsArray(notamsDict: arrDepNotams, sortKey: isSortDate)
                    arrArrNotams = sortNotamsArray(notamsDict: arrArrNotams, sortKey: isSortDate)
                    arrEnrNotams = sortNotamsArray(notamsDict: arrEnrNotams, sortKey: isSortDate)
                    arrDestNotams = sortNotamsArray(notamsDict: arrDestNotams, sortKey: isSortDate)
                }
                .navigationTitle("NOTAMS")
                .background(Color(.systemGroupedBackground))
        }
    }
    
    func sortNotamsArray(notamsDict: [String: [NotamsDataList]], sortKey: Bool) -> [String: [NotamsDataList]] {
        
        var res = [String: [NotamsDataList]]()
        
        for (key, row) in notamsDict {
            let reponse = sortNotams(notamsDict: row, sortKey: sortKey)
            res.updateValue(reponse, forKey: key)
        }
        
        return res
    }
    
    func sortNotams(notamsDict: [NotamsDataList], sortKey: Bool) -> [NotamsDataList] {
            var sortedNotams: [NotamsDataList]
            
            switch sortKey {
            case true:
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyMMddHHmm"
                
                sortedNotams = notamsDict.sorted {
                    guard let dateString1 = $0.date,
                          let date1 = dateFormatter.date(from: dateString1),
                          let dateString2 = $1.date,
                          let date2 = dateFormatter.date(from: dateString2) else {
                        return false
                    }
                    
                    return date1 < date2
                }
            case false:
                sortedNotams = notamsDict.sorted {
                    guard let rankString1 = $0.rank,
                          let rank1 = Int(rankString1),
                          let rankString2 = $1.rank,
                          let rank2 = Int(rankString2) else {
                        return false
                    }
                    
                    return rank1 < rank2
                }
            }
            
            return sortedNotams
        }
}

