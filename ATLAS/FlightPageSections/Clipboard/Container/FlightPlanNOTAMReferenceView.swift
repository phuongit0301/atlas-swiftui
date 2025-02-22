//
//  FlightPlanNOTAMView.swift
//  ATLAS
//
//  Created by Muhammad Adil on 25/6/23.
//

import Foundation
import SwiftUI

struct FlightPlanNOTAMReferenceView: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController
    // initialise state variables
    @State private var isSortDateDep = true
    @State private var isSortDateEnr = true
    @State private var isSortDateArr = true
    @State var arrDepNotams = [NotamsDataList]()
    @State var arrEnrNotams = [NotamsDataList]()
    @State var arrArrNotams = [NotamsDataList]()

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center) {
                Text("NOTAMs")
                    .font(.system(size: 20, weight: .semibold))
            }.padding(.vertical, 16)
            
            if arrDepNotams.count == 0 && arrEnrNotams.count == 0 && arrArrNotams.count == 0 {
                Rectangle().fill(Color.theme.arsenic.opacity(0.36)).frame(height: 1)
                VStack(alignment: .leading) {
                    Text("No NOTAMs saved.").foregroundColor(Color.theme.philippineGray2).font(.system(size: 17, weight: .regular)).padding()
                    Rectangle().fill(Color.theme.arsenic.opacity(0.36)).frame(height: 1)
                }
                Spacer()
            } else {
                //scrollable outer list section
                List {
                    // Dep NOTAM section
                    if arrDepNotams.count > 0 {
                        Section(header:
                        VStack {
                            HStack {
                                Text("DEP NOTAMS").font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(Color.black)
                                Spacer().frame(maxWidth: .infinity)
//                                HStack {
//                                    Toggle(isOn: $isSortDateDep) {
//                                        Text("Most Relevant")
//                                            .font(.system(size: 17, weight: .regular))
//                                            .frame(maxWidth: .infinity, alignment: .trailing)
//                                    }.padding(.horizontal)
//                                    Text("Most Recent")
//                                        .font(.system(size: 17, weight: .regular))
//                                        .frame(maxWidth: .infinity, alignment: .trailing)
//                                }.fixedSize()
                            }
                            
                            Divider()
                        }
                        ) {
                            ForEach(arrDepNotams, id: \.id) { item in
                                VStack {
                                    HStack(alignment: .top) {
                                        // notam text
                                        Text(item.unwrappedNotam).font(.system(size: 17, weight: .regular))
                                        Spacer()
                                        // star function to add to reference
                                        Button(action: {
                                            item.isChecked.toggle()
                                            coreDataModel.save()
                                            coreDataModel.dataNotams = coreDataModel.readDataNotamsList()
                                            coreDataModel.dataNotamsRef = coreDataModel.readDataNotamsRefList()
                                            arrDepNotams.removeAll(where: {$0.id == item.id})
                                        }) {
                                            if item.isChecked {
                                                Image(systemName: "star.fill").foregroundColor(Color.theme.azure)
                                            } else {
                                                Image(systemName: "star").foregroundColor(Color.theme.azure)
                                            }
                                        }.fixedSize()
                                            .buttonStyle(PlainButtonStyle())
                                    }
                                    
                                    Divider()
                                }.listRowBackground(Color.white)
                                    .listRowSeparator(.hidden)
                            }
                        }
                    }
                    
                    if arrEnrNotams.count > 0 {
                        // Enr NOTAM section
                        Section(header:
                            VStack {
                                HStack {
                                    Text("ENROUTE NOTAMS").font(.system(size: 15, weight: .semibold))
                                    .foregroundStyle(Color.black)
                                    
                                    Spacer().frame(maxWidth: .infinity)
                                
    //                                HStack {
    //                                    Toggle(isOn: $isSortDateEnr) {
    //                                        Text("Most Relevant")
    //                                            .font(.system(size: 17, weight: .regular))
    //                                            .frame(maxWidth: .infinity, alignment: .trailing)
    //                                    }.padding(.horizontal)
    //                                    Text("Most Recent")
    //                                        .font(.system(size: 17, weight: .regular))
    //                                        .frame(maxWidth: .infinity, alignment: .trailing)
    //                                }.fixedSize()
                                }
                                Divider()
                            }
                        ) {
                            ForEach(arrEnrNotams, id: \.id) { item in
                                VStack {
                                    HStack(alignment: .top) {
                                        // notam text
                                        Text(item.unwrappedNotam).font(.system(size: 17, weight: .regular))
                                        Spacer()
                                        // star function to add to reference
                                        Button(action: {
                                            item.isChecked.toggle()
                                            coreDataModel.save()
                                            coreDataModel.dataNotams = coreDataModel.readDataNotamsList()
                                            coreDataModel.dataNotamsRef = coreDataModel.readDataNotamsRefList()
                                            arrEnrNotams.removeAll(where: {$0.id == item.id})
                                        }) {
                                            if item.isChecked {
                                                Image(systemName: "star.fill").foregroundColor(Color.theme.azure)
                                            } else {
                                                Image(systemName: "star").foregroundColor(Color.theme.azure)
                                            }
                                        }.fixedSize()
                                            .buttonStyle(PlainButtonStyle())
                                    }
                                    Divider()
                                }.listRowBackground(Color.white)
                                    .listRowSeparator(.hidden)
                                
                            }
                        }
                    }
                    
                    if arrArrNotams.count > 0 {
                        // Arr NOTAM section
                        Section(header:
                            VStack {
                                HStack {
                                    Text("ARR NOTAMS").font(.system(size: 15, weight: .semibold))
                                    .foregroundStyle(Color.black)
                                    
                                    Spacer().frame(maxWidth: .infinity)
                                
    //                                HStack {
    //                                    Toggle(isOn: $isSortDateArr) {
    //                                        Text("Most Relevant")
    //                                            .font(.system(size: 17, weight: .regular))
    //                                            .frame(maxWidth: .infinity, alignment: .trailing)
    //                                    }.padding(.horizontal)
    //                                    Text("Most Recent")
    //                                        .font(.system(size: 17, weight: .regular))
    //                                        .frame(maxWidth: .infinity, alignment: .trailing)
    //                                }.fixedSize()
                                }
                                Divider()
                            }
                        ) {
                            ForEach(arrArrNotams, id: \.id) { item in
                                VStack {
                                    HStack(alignment: .top) {
                                        // notam text
                                        Text(item.unwrappedNotam).font(.system(size: 17, weight: .regular))
                                        Spacer()
                                        // star function to add to reference
                                        Button(action: {
                                            item.isChecked.toggle()
                                            coreDataModel.save()
                                            coreDataModel.dataNotams = coreDataModel.readDataNotamsList()
                                            coreDataModel.dataNotamsRef = coreDataModel.readDataNotamsRefList()
                                            arrArrNotams.removeAll(where: {$0.id == item.id})
                                        }) {
                                            if item.isChecked {
                                                Image(systemName: "star.fill").foregroundColor(Color.theme.azure)
                                            } else {
                                                Image(systemName: "star").foregroundColor(Color.theme.azure)
                                            }
                                        }.fixedSize()
                                            .buttonStyle(PlainButtonStyle())
                                    }
                                    Divider()
                                }.listRowBackground(Color.white)
                                    .listRowSeparator(.hidden)
                            }
                        }
                    }
                }.background(Color.white)
                .scrollContentBackground(.hidden)
                .padding(.horizontal, -32)
            }
            
        }
        .onChange(of: isSortDateDep) { newValue in
            arrDepNotams = sortNotams(notamsDict: arrDepNotams, sortKey: isSortDateDep)
        }
        .onChange(of: isSortDateEnr) { newValue in
            arrEnrNotams = sortNotams(notamsDict: arrEnrNotams, sortKey: isSortDateEnr)
        }
        .onChange(of: isSortDateArr) { newValue in
            arrArrNotams = sortNotams(notamsDict: arrArrNotams, sortKey: isSortDateArr)
        }
        .onAppear {
            coreDataModel.dataNotamsRef.forEach { item in
                if item.type == "arrNotams" {
                    arrArrNotams.append(item)
                } else if item.type == "depNotams" {
                    arrDepNotams.append(item)
                } else {
                    arrEnrNotams.append(item)
                }
            }
            arrDepNotams = sortNotams(notamsDict: arrDepNotams, sortKey: isSortDateDep)
            arrArrNotams = sortNotams(notamsDict: arrArrNotams, sortKey: isSortDateArr)
            arrEnrNotams = sortNotams(notamsDict: arrEnrNotams, sortKey: isSortDateEnr)
        }
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
        
//        let result = sortedNotams.map { $0["notam"] as? String ?? "" }
        
        return sortedNotams
    }

}

