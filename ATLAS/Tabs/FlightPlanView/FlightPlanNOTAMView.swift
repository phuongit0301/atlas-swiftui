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

    var body: some View {
        // here we sort the notams according to the toogle selection
        let sortedDepNotams: [String] = sortNotams(notamsDict: coreDataModel.dataNotams.unwrappedDepNotams, sortKey: isSortDateDep)
        let sortedEnrNotams: [String] = sortNotams(notamsDict: coreDataModel.dataNotams.unwrappedEnrNotams, sortKey: isSortDateEnr)
        let sortedArrNotams: [String] = sortNotams(notamsDict: coreDataModel.dataNotams.unwrappedArrNotams, sortKey: isSortDateArr)
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Text("NOTAMS")
                    .font(.title)
                    .padding(.leading, 30)
            }
            .padding(.bottom, 10)
            Text("Plan \(coreDataModel.dataSummaryInfo.unwrappedPlanNo) | Last updated 0820LT")
            .padding(.leading, 30)
            .padding(.bottom, 10)
            //scrollable outer list section
            List {
                // Dep NOTAM section
                Section(header:
                    HStack {
                        Text("DEP NOTAMS").foregroundStyle(Color.black)
                        Spacer()
                        // toggle to sort by rank or date
                        Toggle(isOn: $isSortDateDep) {
                        Text("Most Relevant")
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        Text("Most Recent")
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, alignment: .trailing)
//                        Button(action: {
//                            coreDataModel.dataNotams.isDepReference.toggle()
//                            coreDataModel.save()
//                            
//                            coreDataModel.readDataNotamsList()
//                        }) {
//                            if coreDataModel.dataNotams.isDepReference {
//                                Image(systemName: "star.fill").foregroundColor(Color.theme.azure)
//                            } else {
//                                Image(systemName: "star").foregroundColor(Color.theme.azure)
//                            }
//                        }
                    }
                ) {
                    ForEach(sortedDepNotams, id: \.self) { notam in
                        VStack {
                            // notam text
                            Text(notam)
                                .padding(.leading, 25)
                            // star function to add to reference
                            Button(action: {
                                coreDataModel.dataNotams.isDepReference.toggle()
                                coreDataModel.save()
                                
                                coreDataModel.readDataNotamsList()
                            }) {
                                if coreDataModel.dataNotams.isDepReference {
                                    Image(systemName: "star.fill").foregroundColor(Color.theme.azure)
                                } else {
                                    Image(systemName: "star").foregroundColor(Color.theme.azure)
                                }
                            }
                        }
                    }
                }
                // Enr NOTAM section
                Section(header:
                        HStack {
                            Text("ENROUTE NOTAMS").foregroundStyle(Color.black)
                            Spacer()
                            // toggle to sort by rank or date
                            Text("Most Relevant")
                                .font(.subheadline)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            Toggle(isOn: $isSortDateEnr) {
                            Text("Most Relevant")
                                .font(.subheadline)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                            Text("Most Recent")
                                .font(.subheadline)
                                .frame(maxWidth: .infinity, alignment: .trailing)
//                            Button(action: {
//                                coreDataModel.dataNotams.isEnrReference.toggle()
//                                coreDataModel.save()
//                                
//                                coreDataModel.readDataNotamsList()
//                            }) {
//                                if coreDataModel.dataNotams.isEnrReference {
//                                    Image(systemName: "star.fill").foregroundColor(Color.theme.azure)
//                                } else {
//                                    Image(systemName: "star").foregroundColor(Color.theme.azure)
//                                }
//                            }
                        }
                    ) {
//                    ForEach(coreDataModel.dataNotams.unwrappedEnrNotams, id: \.self) { notam in
//                        Text(notam["notam"] ?? "")
//                            .padding(.leading, 25)
//                    }
                    ForEach(sortedEnrNotams, id: \.self) { notam in
                        VStack {
                            // notam text
                            Text(notam)
                                .padding(.leading, 25)
                            // star function to add to reference
                            Button(action: {
                                coreDataModel.dataNotams.isDepReference.toggle()
                                coreDataModel.save()
                                
                                coreDataModel.readDataNotamsList()
                            }) {
                                if coreDataModel.dataNotams.isDepReference {
                                    Image(systemName: "star.fill").foregroundColor(Color.theme.azure)
                                } else {
                                    Image(systemName: "star").foregroundColor(Color.theme.azure)
                                }
                            }
                        }
                    }
                }
                // Arr NOTAM section
                Section(header:
                        HStack {
                            Text("ARR NOTAMS").foregroundStyle(Color.black)
                            Spacer()
                            // toggle to sort by rank or date
                            Text("Most Relevant")
                                .font(.subheadline)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            Toggle(isOn: $isSortDateArr) {
                            Text("Most Relevant")
                                .font(.subheadline)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                            Text("Most Recent")
                                .font(.subheadline)
                                .frame(maxWidth: .infinity, alignment: .trailing)
//                            Button(action: {
//                                coreDataModel.dataNotams.isArrReference.toggle()
//                                coreDataModel.save()
//                                
//                                coreDataModel.readDataNotamsList()
//                            }) {
//                                if coreDataModel.dataNotams.isArrReference {
//                                    Image(systemName: "star.fill").foregroundColor(Color.theme.azure)
//                                } else {
//                                    Image(systemName: "star").foregroundColor(Color.theme.azure)
//                                }
//                            }
                        }
                    ) {
//                    ForEach(coreDataModel.dataNotams.unwrappedArrNotams, id: \.self) { notam in
//                        Text(notam["notam"] ?? "")
//                            .padding(.leading, 25)
//                    }
                    ForEach(sortedArrNotams, id: \.self) { notam in
                        VStack {
                            // notam text
                            Text(notam)
                                .padding(.leading, 25)
                            // star function to add to reference
                            Button(action: {
                                coreDataModel.dataNotams.isDepReference.toggle()
                                coreDataModel.save()
                                
                                coreDataModel.readDataNotamsList()
                            }) {
                                if coreDataModel.dataNotams.isDepReference {
                                    Image(systemName: "star.fill").foregroundColor(Color.theme.azure)
                                } else {
                                    Image(systemName: "star").foregroundColor(Color.theme.azure)
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("NOTAMS")
        .background(Color(.systemGroupedBackground))
    }
    func sortNotams(notamsDict: [[String: Any]], sortKey: Bool) -> [String] {
        var sortedNotams: [[String: Any]]
        
        switch sortKey {
        case true:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyMMddHHmm"
            
            sortedNotams = notamsDict.sorted {
                guard let dateString1 = $0["date"] as? String,
                      let date1 = dateFormatter.date(from: dateString1),
                      let dateString2 = $1["date"] as? String,
                      let date2 = dateFormatter.date(from: dateString2) else {
                    return false
                }
                
                return date1 < date2
            }
        case false:
            sortedNotams = notamsDict.sorted {
                guard let rankString1 = $0["rank"] as? String,
                      let rank1 = Int(rankString1),
                      let rankString2 = $1["rank"] as? String,
                      let rank2 = Int(rankString2) else {
                    return false
                }
                
                return rank1 < rank2
            }
        }
        
        let result = sortedNotams.map { $0["notam"] as? String ?? "" }
        
        return result
    }

}

