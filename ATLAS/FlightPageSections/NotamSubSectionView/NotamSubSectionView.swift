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
    @StateObject var notamSection = NotamSection()
    // initialise state variables
    @State private var isSortDate = true
    @State var arrDepNotams = [NotamsDataList]()
    @State var arrArrNotams = [NotamsDataList]()
    @State var arrEnrNotams = [String: [NotamsDataList]]()
    @State var arrDestNotams = [String: [NotamsDataList]]()
    
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
                        VStack(alignment: .leading) {
                            HStack(spacing: 0) {
                                Text("[STATION NAME]: ETD DD/MM/YY HHMM")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(Color.black)
                                Spacer()
                            }.frame(height: 44)
                            
                            if arrDepNotams.count > 0 {
                                Divider().padding(.horizontal, -16)
                            }
                            
                            ForEach(arrDepNotams.indices, id: \.self) { index in
                                HStack(alignment: .center, spacing: 0) {
                                    // notam text
                                    Text(arrDepNotams[index].unwrappedNotam)
                                        .font(.system(size: 15, weight: .regular))
                                    Spacer()
                                    // star function to add to reference
                                    Button(action: {
                                        arrDepNotams[index].isChecked.toggle()
                                        coreDataModel.save()
                                        coreDataModel.dataNotams = coreDataModel.readDataNotamsList()
                                        coreDataModel.dataNotamsRef = coreDataModel.readDataNotamsRefList()
                                        coreDataModel.dataDepartureNotamsRef = coreDataModel.readDataNotamsByType("depNotams")
                                    }) {
                                        if arrDepNotams[index].isChecked {
                                            Image(systemName: "star.fill").foregroundColor(Color.theme.azure)
                                        } else {
                                            Image(systemName: "star").foregroundColor(Color.theme.azure)
                                        }
                                    }.fixedSize()
                                        .buttonStyle(PlainButtonStyle())
                                }.padding(.bottom, 8)
                                
                                if index + 1 < arrDepNotams.count {
                                    Divider().padding(.horizontal, -16)
                                }
                            }
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
                            NotamSubSectionRowView(item: arrEnrNotams[key] ?? [], key: key)
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
                        VStack(alignment: .leading) {
                            HStack(spacing: 0) {
                                Text("[STATION NAME]: ETD DD/MM/YY HHMM")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(Color.black)
                                Spacer()
                            }.frame(height: 44)

                            if arrArrNotams.count > 0 {
                                Divider().padding(.horizontal, -16)
                            }

                            ForEach(arrArrNotams.indices, id: \.self) { index in
                                HStack(alignment: .center, spacing: 0) {
                                    // notam text
                                    Text(arrArrNotams[index].unwrappedNotam).font(.system(size: 15, weight: .regular))
                                    Spacer()
                                    // star function to add to reference
                                    Button(action: {
                                        arrArrNotams[index].isChecked.toggle()
                                        coreDataModel.save()
                                        coreDataModel.dataNotams = coreDataModel.readDataNotamsList()
                                        coreDataModel.dataNotamsRef = coreDataModel.readDataNotamsRefList()
                                        coreDataModel.dataArrivalNotamsRef = coreDataModel.readDataNotamsByType("arrNotams")
                                    }) {
                                        if arrArrNotams[index].isChecked {
                                            Image(systemName: "star.fill").foregroundColor(Color.theme.azure)
                                        } else {
                                            Image(systemName: "star").foregroundColor(Color.theme.azure)
                                        }
                                    }.fixedSize()
                                        .buttonStyle(PlainButtonStyle())
                                }.padding(.bottom, 8)

                                if arrArrNotams.count > 0 && index + 1 < arrArrNotams.count {
                                    Divider().padding(.horizontal, -16)
                                }
                            }
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
                            NotamSubSectionRowView(item: arrDestNotams[key] ?? [], key: key)
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
                var temp = [NotamsDataList]()
                coreDataModel.dataNotams.forEach { item in
                    let category = item.category ?? ""
                    
                    if item.type == "depNotams" && category == selectionDep {
                        temp.append(item)
                    }
                }
                arrDepNotams = sortNotams(notamsDict: temp, sortKey: isSortDate)
            }
//            .onChange(of: selectionEnr) { newValue in
//                var temp = [NotamsDataList]()
//                coreDataModel.dataNotams.forEach { item in
//                    let category = item.category ?? ""
//
//                    if item.type == "enrNotams" && category == selectionEnr  {
//                        temp.append(item)
//                    }
//                }
//                arrEnrNotams = sortNotams(notamsDict: temp, sortKey: isSortDate)
//            }
            .onChange(of: selectionArr) { newValue in
                var temp = [NotamsDataList]()
                coreDataModel.dataNotams.forEach { item in
                    let category = item.category ?? ""

                    if item.type == "arrNotams" && category == selectionArr  {
                        temp.append(item)
                    }
                }
                arrArrNotams = sortNotams(notamsDict: temp, sortKey: isSortDate)
            }
//            .onChange(of: selectionDest) { newValue in
//                var temp = [NotamsDataList]()
//                coreDataModel.dataNotams.forEach { item in
//                    let category = item.category ?? ""
//
//                    if item.type == "destNotams" && category == selectionDest  {
//                        temp.append(item)
//                    }
//                }
//                arrDestNotams = sortNotams(notamsDict: temp, sortKey: isSortDate)
//            }
            .onAppear {
                coreDataModel.dataNotams.forEach { item in
                    if item.type == "arrNotams" {
                        arrArrNotams.append(item)
                    } else if item.type == "depNotams" {
                        arrDepNotams.append(item)
                    } else if item.type == "enrNotams" {
                        if let airport = item.airport {
                            if arrEnrNotams[airport] != nil {
                                arrEnrNotams[airport]?.append(item)
                            } else {
                                arrEnrNotams.updateValue([item], forKey: airport)
                            }
                        }
                    } else {
                        if let airport = item.airport {
                            if arrDestNotams[airport] != nil {
                                arrDestNotams[airport]?.append(item)
                            } else {
                                arrDestNotams.updateValue([item], forKey: airport)
                            }
                        }
                    }
                }
                
                arrDepNotams = sortNotams(notamsDict: arrDepNotams, sortKey: isSortDate)
                arrArrNotams = sortNotams(notamsDict: arrArrNotams, sortKey: isSortDate)
                arrEnrNotams = sortNotamsArray(notamsDict: arrEnrNotams, sortKey: isSortDate)
                arrDestNotams = sortNotamsArray(notamsDict: arrDestNotams, sortKey: isSortDate)
            }
            .navigationTitle("NOTAMS")
            .background(Color(.systemGroupedBackground))
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

