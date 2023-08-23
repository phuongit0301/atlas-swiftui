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
    @StateObject var notamSection = NotamSection()
    // initialise state variables
//    @State private var isSortDateDep = true
    @State private var isSortDateEnr = true
    @State private var isSortDateArr = true
    @State var arrDepNotams = [NotamsDataList]()
    @State var arrEnrNotams = [NotamsDataList]()
    @State var arrArrNotams = [NotamsDataList]()
    
    //For collpase and expand
    @State private var isDepShow = true
    @State private var isEnrShow = true
    @State private var isArrShow = true
    
    //For picker
    @State private var selectionDep = ""
    @State private var selectionArr = ""

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Text("NOTAMS")
                    .font(.system(size: 20, weight: .semibold))
                    .padding(.leading, 30)
            }
            .padding(.bottom, 13)
            
            Text("Plan \(coreDataModel.dataSummaryInfo.unwrappedPlanNo) | Last updated 0820LT")
                .font(.system(size: 15, weight: .semibold))
                .padding(.leading, 30)
                .padding(.bottom, 10)
            //scrollable outer list section
            List {
                // Dep NOTAM section
                Section(header:
                    HStack {
                        HStack {
                            Text("DEP NOTAMS").foregroundStyle(Color.black).font(.system(size: 15, weight: .semibold))
                            Spacer().frame(maxWidth: .infinity)
                        }.contentShape(Rectangle())
                        .onTapGesture {
                            self.isDepShow.toggle()
                        }
                        
                        HStack {
                            Picker("", selection: $selectionDep) {
                                ForEach(notamSection.dataDropDown, id: \.self) {
                                    Text($0).tag($0)
                                }
                            }
                        }.fixedSize()
                }) {
                    if isDepShow {
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
                }
                // Enr NOTAM section
                Section(header:
                    HStack {
                        HStack {
                            Text("ENROUTE NOTAMS").foregroundStyle(Color.black).font(.system(size: 15, weight: .semibold))
                            Spacer().frame(maxWidth: .infinity)
                        }.contentShape(Rectangle())
                        .onTapGesture {
                            self.isEnrShow.toggle()
                        }
                    }) {
                    if isEnrShow {
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
                    
                }
                
                // Arr NOTAM section
                Section(header:
                    HStack {
                        HStack {
                            Text("ARR NOTAMS").foregroundStyle(Color.black).font(.system(size: 15, weight: .semibold))
                            Spacer().frame(maxWidth: .infinity)
                        }.contentShape(Rectangle())
                        .onTapGesture {
                            self.isArrShow.toggle()
                        }
                    
                        HStack {
                            Picker("", selection: $selectionArr) {
                                ForEach(notamSection.dataDropDown, id: \.self) {
                                    Text($0).tag($0)
                                }
                            }
                        }.fixedSize()
                    }) {
                    if isArrShow {
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
        }.padding(.vertical)
        .onChange(of: selectionArr) { newValue in
            var temp = [NotamsDataList]()
            coreDataModel.dataNotams.forEach { item in
                let category = item.category ?? ""
                
                if item.type == "arrNotams" && category == selectionArr  {
                    temp.append(item)
                }
            }
            arrArrNotams = temp
        }
        .onChange(of: selectionDep) { newValue in
            var temp = [NotamsDataList]()
            coreDataModel.dataNotams.forEach { item in
                let category = item.category ?? ""
                
                if item.type == "depNotams" && category == selectionDep {
                    temp.append(item)
                }
            }
            arrDepNotams = temp
        }
        .onAppear {
            selectionDep = notamSection.dataDropDown.first ?? ""
            selectionArr = notamSection.dataDropDown.first ?? ""
            
            coreDataModel.dataNotams.forEach { item in
                if item.type == "arrNotams" {
                    if item.category == selectionArr {
                        arrArrNotams.append(item)
                    }
                } else if item.type == "depNotams" {
                    if item.category == selectionDep {
                        arrDepNotams.append(item)
                    }
                } else {
                    arrEnrNotams.append(item)
                }
            }
        }
        .navigationTitle("NOTAMS")
        .background(Color(.systemGroupedBackground))
    }

}

