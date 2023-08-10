//
//  FlightPlanNOTAMView.swift
//  ATLAS
//
//  Created by Muhammad Adil on 25/6/23.
//

import Foundation
import SwiftUI

struct FlightPlanNOTAMView: View {
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
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Text("NOTAMS")
                    .font(.system(size: 20, weight: .semibold))
                    .padding(.leading, 30)
            }
            .padding(.bottom, 10)
            
            Text("Plan \(coreDataModel.dataSummaryInfo.unwrappedPlanNo) | Last updated 0820LT")
                .font(.system(size: 15, weight: .semibold))
                .padding(.leading, 30)
                .padding(.bottom, 10)
            //scrollable outer list section
            List {
                // Dep NOTAM section
                Section(header:
                    HStack {
                        Text("DEP NOTAMS").foregroundStyle(Color.black).font(.system(size: 15, weight: .semibold))
                        Spacer().frame(maxWidth: .infinity)
                        HStack {
                            Toggle(isOn: $isSortDateDep) {
                                Text("Most Relevant")
                                    .font(.system(size: 17, weight: .regular))
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }.padding(.horizontal)
                            Text("Most Recent")
                                .font(.system(size: 17, weight: .regular))
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }.fixedSize()
                    }
                ) {
                    ForEach(arrDepNotams, id: \.id) { item in
                        HStack(alignment: .top) {
                            // notam text
                            Text(item.unwrappedNotam)
                                .font(.system(size: 17, weight: .regular))
                            Spacer()
                            // star function to add to reference
                            Button(action: {
                                item.isChecked.toggle()
                                coreDataModel.save()
                                coreDataModel.dataNotams = coreDataModel.readDataNotamsList()
                                coreDataModel.dataNotamsRef = coreDataModel.readDataNotamsRefList()
                            }) {
                                if item.isChecked {
                                    Image(systemName: "star.fill").foregroundColor(Color.theme.azure)
                                } else {
                                    Image(systemName: "star").foregroundColor(Color.theme.azure)
                                }
                            }.fixedSize()
                                .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                // Enr NOTAM section
                Section(header:
                    HStack {
                        Text("ENROUTE NOTAMS").foregroundStyle(Color.black).font(.system(size: 15, weight: .semibold))
                        
                        Spacer().frame(maxWidth: .infinity)
                    
                        HStack {
                            Toggle(isOn: $isSortDateEnr) {
                                Text("Most Relevant")
                                    .font(.system(size: 17, weight: .regular))
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }.padding(.horizontal)
                            Text("Most Recent")
                                .font(.system(size: 17, weight: .regular))
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }.fixedSize()
                    }
                ) {
                    ForEach(arrEnrNotams, id: \.id) { item in
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
                            }) {
                                if item.isChecked {
                                    Image(systemName: "star.fill").foregroundColor(Color.theme.azure)
                                } else {
                                    Image(systemName: "star").foregroundColor(Color.theme.azure)
                                }
                            }.fixedSize()
                                .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                
                // Arr NOTAM section
                Section(header:
                    HStack {
                        Text("ARR NOTAMS").foregroundStyle(Color.black)
                        .font(.system(size: 15, weight: .semibold))
                        
                        Spacer().frame(maxWidth: .infinity)
                    
                        HStack {
                            Toggle(isOn: $isSortDateArr) {
                                Text("Most Relevant")
                                    .font(.system(size: 17, weight: .regular))
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }.padding(.horizontal)
                            Text("Most Recent")
                                .font(.system(size: 17, weight: .regular))
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }.fixedSize()
                    }
                ) {
                    ForEach(arrArrNotams, id: \.id) { item in
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
                            }) {
                                if item.isChecked {
                                    Image(systemName: "star.fill").foregroundColor(Color.theme.azure)
                                } else {
                                    Image(systemName: "star").foregroundColor(Color.theme.azure)
                                }
                            }.fixedSize()
                                .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            }
        }
        .onChange(of: isSortDateDep) { newValue in
            arrDepNotams = sortNotams(notamsDict: arrDepNotams, sortKey: isSortDateDep)
        }
        .onChange(of: isSortDateEnr) { newValue in
            arrEnrNotams = sortNotams(notamsDict: arrEnrNotams, sortKey: isSortDateEnr)
        }
        .onChange(of: isSortDateArr) { newValue in
            arrArrNotams = sortNotams(notamsDict: arrEnrNotams, sortKey: isSortDateArr)
        }
        .onAppear {
            coreDataModel.dataNotams.forEach { item in
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
        .navigationTitle("NOTAMS")
        .background(Color(.systemGroupedBackground))
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

