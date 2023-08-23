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
                Section(content: {
                    VStack(spacing: 0) {
                        HStack(alignment: .center, spacing: 0) {
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
                        }.padding(.vertical)
                        
                        if isDepShow {
                            Divider()
                            
                            ForEach(arrDepNotams, id: \.id) { item in
                                HStack(alignment: .center, spacing: 0) {
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
                                }.padding(.vertical)
                                
                                Divider()
                            }
                        }
                    }
                }).listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets.init(top: 0, leading: 16, bottom: 0, trailing: 16))

                // Enr NOTAM section
                Section(content: {
                    VStack(spacing: 0) {
                        HStack(alignment: .center, spacing: 0) {
                            HStack {
                                Text("ENROUTE NOTAMS").foregroundStyle(Color.black).font(.system(size: 15, weight: .semibold))
                                Spacer().frame(maxWidth: .infinity)
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                self.isEnrShow.toggle()
                            }
                        }.padding(.vertical, 24)
                        
                        if isEnrShow {
                            Divider()
                            
                            ForEach(arrEnrNotams, id: \.id) { item in
                                HStack(alignment: .center, spacing: 0) {
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
                                }.padding(.vertical)
                                
                                Divider()
                            }
                        }
                    }
                }).listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets.init(top: 0, leading: 16, bottom: 0, trailing: 16))
                
                // Arr NOTAM section
                Section(content: {
                    VStack(spacing: 0) {
                        HStack(alignment: .center, spacing: 0) {
                            HStack(alignment: .center, spacing: 0) {
                                Text("ARR NOTAMS").foregroundStyle(Color.black).font(.system(size: 15, weight: .semibold))
                                Spacer().frame(maxWidth: .infinity)
                            }.contentShape(Rectangle())
                                .onTapGesture {
                                    self.isArrShow.toggle()
                                }
                            
                            HStack(alignment: .center, spacing: 0) {
                                Picker("", selection: $selectionArr) {
                                    ForEach(notamSection.dataDropDown, id: \.self) {
                                        Text($0).tag($0)
                                    }
                                }
                            }.fixedSize()
                        }.padding(.vertical)
                        
                        if isArrShow {
                            Divider()
                            
                            ForEach(arrArrNotams, id: \.id) { item in
                                HStack(alignment: .center, spacing: 0) {
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
                                }.padding(.vertical)
                                
                                Divider()
                            }
                        }
                    }
                }).listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets.init(top: 0, leading: 16, bottom: 0, trailing: 16))
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

