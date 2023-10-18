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
    @EnvironmentObject var remoteService: RemoteService
    @EnvironmentObject var persistenceController: PersistenceController
    @StateObject var notamSection = NotamSection()
    // initialise state variables
    @State private var isSortDateDep = true
    @State private var isSortDateArr = true
    @State private var isSortDateEnr = true
    @State private var isSortDateDest = true
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
    @State private var isLoading = false
    @State private var number = 0
    let dateFormatter = DateFormatter()

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
                    
                    Spacer()
                    
                    if let notams = coreDataModel.dataSectionDateUpdate?.unwrappedNotam {
                        Text("Last Update: \(notams)").foregroundColor(.black).font(.system(size: 15, weight: .regular))
                    }
                    
                    Button(action: {
                        onSyncData()
                    }, label: {
                        HStack {
                            Text("Refresh").font(.system(size: 17, weight: .regular))
                                .foregroundColor(Color.white)
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                        }
                    }).background(Color.theme.azure)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.white, lineWidth: 0)
                        )
                        .padding(.vertical, 8)
                        .disabled(isLoading)
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
                                    Toggle(isOn: $isSortDateDep) {
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
                                NotamSubSectionRowView(item: arrDepNotams[key] ?? [], dates: coreDataModel.depAirportNotam, key: key, suffix: "STD")
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
                                    Toggle(isOn: $isSortDateEnr) {
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
                                NotamSubSectionRowView(item: arrEnrNotams[key] ?? [], dates: coreDataModel.enrAirportNotam, key: key, suffix: "ETA")
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
                                    Toggle(isOn: $isSortDateArr) {
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
                                NotamSubSectionRowView(item: arrArrNotams[key] ?? [], dates: coreDataModel.arrAirportNotam, key: key, suffix: "STA")
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
                                    Toggle(isOn: $isSortDateDest) {
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
                                NotamSubSectionRowView(item: arrDestNotams[key] ?? [], dates: coreDataModel.destAirportNotam, key: key, suffix: "ETA")
                            }
                        }
                    }.padding(.horizontal)
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 0))
                }.padding(.bottom, 32)
            }.padding(.horizontal, 16)
                .overlay(Group {
                    if isLoading {
                        VStack {
                            ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.black))
                        }.frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.black.opacity(0.3))
                    }
                })
                .background(Color.theme.antiFlashWhite)
                .onChange(of: selectionDep) { newValue in
                    var temp = [String: [NotamsDataList]]()
                    coreDataModel.dataNotams.forEach { item in
                        let category = item.category ?? ""
                        
                        if item.type == "depNotams" {
                            if category == selectionDep {
                                if let airport = item.airport {
                                    if temp[airport] != nil {
                                        temp[airport]?.append(item)
                                    } else {
                                        temp.updateValue([item], forKey: airport)
                                    }
                                }
                            } else {
                                if selectionDep == "", let airport = item.airport {
                                    if temp[airport] != nil {
                                        temp[airport]?.append(item)
                                    } else {
                                        temp.updateValue([item], forKey: airport)
                                    }
                                }
                            }
                            
                        }
                    }
                    arrDepNotams = sortNotamsArray(notamsDict: temp, sortKey: isSortDateDep)
                }
                .onChange(of: selectionEnr) { newValue in
                    var temp = [String: [NotamsDataList]]()
                    coreDataModel.dataNotams.forEach { item in
                        let category = item.category ?? ""

                        if item.type == "enrNotams"  {
                            if category == selectionEnr {
                                if let airport = item.airport {
                                    if temp[airport] != nil {
                                        temp[airport]?.append(item)
                                    } else {
                                        temp.updateValue([item], forKey: airport)
                                    }
                                }
                            } else {
                                if selectionEnr == "", let airport = item.airport {
                                    if temp[airport] != nil {
                                        temp[airport]?.append(item)
                                    } else {
                                        temp.updateValue([item], forKey: airport)
                                    }
                                }
                            }
                        }
                    }
                    arrEnrNotams = sortNotamsArray(notamsDict: temp, sortKey: isSortDateEnr)
                }
                .onChange(of: selectionArr) { newValue in
                    var temp = [String: [NotamsDataList]]()
                    coreDataModel.dataNotams.forEach { item in
                        let category = item.category ?? ""
                        
                        if item.type == "arrNotams" {
                            if category == selectionArr {
                                if let airport = item.airport {
                                    if temp[airport] != nil {
                                        temp[airport]?.append(item)
                                    } else {
                                        temp.updateValue([item], forKey: airport)
                                    }
                                }
                            } else {
                                if selectionArr == "", let airport = item.airport {
                                    if temp[airport] != nil {
                                        temp[airport]?.append(item)
                                    } else {
                                        temp.updateValue([item], forKey: airport)
                                    }
                                }
                            }
                            
                        }
                    }
                    arrArrNotams = sortNotamsArray(notamsDict: temp, sortKey: isSortDateArr)
                }
                .onChange(of: selectionDest) { newValue in
                    var temp = [String: [NotamsDataList]]()
                    
                    coreDataModel.dataNotams.forEach { item in
                        let category = item.category ?? ""
                        
                        if item.type == "altnNotams"  {
                            if category == selectionDest {
                                if let airport = item.airport {
                                    if temp[airport] != nil {
                                        temp[airport]?.append(item)
                                    } else {
                                        temp.updateValue([item], forKey: airport)
                                    }
                                }
                            } else {
                                if selectionDest == "", let airport = item.airport {
                                    if temp[airport] != nil {
                                        temp[airport]?.append(item)
                                    } else {
                                        temp.updateValue([item], forKey: airport)
                                    }
                                }
                            }
                            
                        }
                    }
                    arrDestNotams = sortNotamsArray(notamsDict: temp, sortKey: isSortDateDest)
                }
                .onChange(of: isSortDateDep) { newValue in
                    var temp = [String: [NotamsDataList]]()
                    coreDataModel.dataNotams.forEach { item in
                        let category = item.category ?? ""
                        
                        if item.type == "depNotams" {
                            if category == selectionDep {
                                if let airport = item.airport {
                                    if temp[airport] != nil {
                                        temp[airport]?.append(item)
                                    } else {
                                        temp.updateValue([item], forKey: airport)
                                    }
                                }
                            } else {
                                if selectionDep == "", let airport = item.airport {
                                    if temp[airport] != nil {
                                        temp[airport]?.append(item)
                                    } else {
                                        temp.updateValue([item], forKey: airport)
                                    }
                                }
                            }
                            
                        }
                    }
                    arrDepNotams = sortNotamsArray(notamsDict: temp, sortKey: newValue)
                }
                .onChange(of: isSortDateEnr) { newValue in
                    var temp = [String: [NotamsDataList]]()
                    coreDataModel.dataNotams.forEach { item in
                        let category = item.category ?? ""

                        if item.type == "enrNotams"  {
                            if category == selectionEnr {
                                if let airport = item.airport {
                                    if temp[airport] != nil {
                                        temp[airport]?.append(item)
                                    } else {
                                        temp.updateValue([item], forKey: airport)
                                    }
                                }
                            } else {
                                if selectionEnr == "", let airport = item.airport {
                                    if temp[airport] != nil {
                                        temp[airport]?.append(item)
                                    } else {
                                        temp.updateValue([item], forKey: airport)
                                    }
                                }
                            }
                        }
                    }
                    arrEnrNotams = sortNotamsArray(notamsDict: temp, sortKey: newValue)
                }
                .onChange(of: isSortDateArr) { newValue in
                    var temp = [String: [NotamsDataList]]()
                    coreDataModel.dataNotams.forEach { item in
                        let category = item.category ?? ""
                        
                        if item.type == "arrNotams" {
                            if category == selectionArr {
                                if let airport = item.airport {
                                    if temp[airport] != nil {
                                        temp[airport]?.append(item)
                                    } else {
                                        temp.updateValue([item], forKey: airport)
                                    }
                                }
                            } else {
                                if selectionArr == "", let airport = item.airport {
                                    if temp[airport] != nil {
                                        temp[airport]?.append(item)
                                    } else {
                                        temp.updateValue([item], forKey: airport)
                                    }
                                }
                            }
                            
                        }
                    }
                    arrArrNotams = sortNotamsArray(notamsDict: temp, sortKey: newValue)
                }
                .onChange(of: isSortDateDest) { newValue in
                    var temp = [String: [NotamsDataList]]()
                    
                    coreDataModel.dataNotams.forEach { item in
                        let category = item.category ?? ""
                        
                        if item.type == "altnNotams"  {
                            if category == selectionDest {
                                if let airport = item.airport {
                                    if temp[airport] != nil {
                                        temp[airport]?.append(item)
                                    } else {
                                        temp.updateValue([item], forKey: airport)
                                    }
                                }
                            } else {
                                if selectionDest == "", let airport = item.airport {
                                    if temp[airport] != nil {
                                        temp[airport]?.append(item)
                                    } else {
                                        temp.updateValue([item], forKey: airport)
                                    }
                                }
                            }
                            
                        }
                    }
                    arrDestNotams = sortNotamsArray(notamsDict: temp, sortKey: newValue)
                }
                .onChange(of: number) {_ in
                    arrDepNotams = [:]
                    arrArrNotams = [:]
                    arrEnrNotams = [:]
                    arrDestNotams = [:]
                    prepareData()
                }
                .onAppear {
                    prepareData()
                }
                .navigationTitle("NOTAMS")
                .background(Color(.systemGroupedBackground))
        }
    }
    
    func prepareData() {
        coreDataModel.dataNotams = coreDataModel.readDataNotamsList()
        
        coreDataModel.dataNotams.forEach { item in
            if item.type == "arrNotams" {
                if let airport = item.airport {
                    if arrArrNotams[airport] != nil {
                        arrArrNotams[airport]?.append(item)
                    } else {
                        arrArrNotams.updateValue([item], forKey: airport)
                    }
                }
            } else if item.type == "depNotams" {
                if let airport = item.airport {
                    if arrDepNotams[airport] != nil {
                        arrDepNotams[airport]?.append(item)
                    } else {
                        arrDepNotams.updateValue([item], forKey: airport)
                    }
                }
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
        
        arrDepNotams = sortNotamsArray(notamsDict: arrDepNotams, sortKey: isSortDateDep)
        arrArrNotams = sortNotamsArray(notamsDict: arrArrNotams, sortKey: isSortDateArr)
        arrEnrNotams = sortNotamsArray(notamsDict: arrEnrNotams, sortKey: isSortDateEnr)
        arrDestNotams = sortNotamsArray(notamsDict: arrDestNotams, sortKey: isSortDateDest)
        coreDataModel.prepareRouteAlternate()
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
    
    func onSyncData() {
        if let overviewList = coreDataModel.selectedEvent?.flightOverviewList?.allObjects as? [FlightOverviewList] {
            let dataFlightOverview = overviewList.first
            
            var payloadEnroute: [Any] = []
            var payloadDestination: [Any] = []
            var enrAirportNotam: [String: String] = [:]
            var destAirportNotam: [String: String] = [:]
            var depAirportNotam: [String: String] = [:]
            depAirportNotam[dataFlightOverview?.unwrappedDep ?? ""] = dataFlightOverview?.unwrappedStd
            
            var arrAirportNotam: [String: String] = [:]
            arrAirportNotam[dataFlightOverview?.unwrappedDest ?? ""] = dataFlightOverview?.unwrappedSta
            
            let (enrouteAlternates, destinationAlternates) = coreDataModel.prepareRouteAlternateByType()
            
            if enrouteAlternates.count > 0 {
                for item in enrouteAlternates {
                    payloadEnroute.append([
                        "Airport": item.altn,
                        "eta": item.eta
                    ])
                    enrAirportNotam[item.altn ?? ""] = item.eta
                }
            }
            
            if destinationAlternates.count > 0 {
                for item in destinationAlternates {
                    payloadDestination.append([
                        "Airport": item.altn,
                        "eta": item.eta
                    ])
                    destAirportNotam[item.altn ?? ""] = item.eta
                }
            }
            
            coreDataModel.enrAirportNotam = enrAirportNotam
            coreDataModel.destAirportNotam = destAirportNotam
            coreDataModel.depAirportNotam = depAirportNotam
            coreDataModel.arrAirportNotam = arrAirportNotam
            coreDataModel.dataNotams = coreDataModel.readDataNotamsList()
            
            let payloadNotam: [String: Any] = [
                "depAirport": [
                    "Airport": dataFlightOverview?.unwrappedDep ?? "",
                    "std": dataFlightOverview?.unwrappedStd ?? ""
                ],
                "arrAirport": [
                    "Airport": dataFlightOverview?.unwrappedDest ?? "",
                    "sta": dataFlightOverview?.unwrappedSta ?? ""
                ],
                "enrAirports": payloadEnroute,
                "altnAirports": payloadDestination
            ]
            
            handleNotam(payloadNotam)
            
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            if let newObj = coreDataModel.dataSectionDateUpdate {
                newObj.notam = dateFormatter.string(from: Date())
            } else {
                let newObj = SectionDateUpdateList(context: persistenceController.container.viewContext)
                newObj.notam = dateFormatter.string(from: Date())
            }
            coreDataModel.save()
            coreDataModel.dataSectionDateUpdate = coreDataModel.readSectionDateUpdate()
        }
        
    }

    func handleNotam(_ payload: [String: Any]) {
        Task {
            print("handle notam")
            isLoading = true
            let responseNotam = await remoteService.getNotamData(payload)
            
//            if let metarTafData = responseNotam?.metarTafData {
//                print("inside metar")
//                await coreDataModel.deleteAllMetarTaf()
//
//                coreDataModel.initDepDataMetarTaf(metarTafData.depMetarTaf, type: "depMetarTaf")
//                coreDataModel.initArrDataMetarTaf(metarTafData.arrMetarTaf, type: "arrMetarTaf")
//
//                if metarTafData.altnMetarTaf.count > 0 {
//                    coreDataModel.initEnrDataMetarTaf(metarTafData.altnMetarTaf, type: "altnMetarTaf")
//                }
//
//                if metarTafData.enrMetarTaf.count > 0 {
//                    coreDataModel.initEnrDataMetarTaf(metarTafData.enrMetarTaf, type: "enrMetarTaf")
//                }
//            }
//
            if let notamsData = responseNotam?.notamsData {
                print("inside notam")
                await coreDataModel.deleteAllNotam()
                coreDataModel.initDataNotams(notamsData)
            }
            
            coreDataModel.dataNotams = coreDataModel.readDataNotamsList()
            coreDataModel.dataNotamsRef = coreDataModel.readDataNotamsRefList()
            coreDataModel.dataDepartureNotamsRef = coreDataModel.readDataNotamsByType("depNotams")
            coreDataModel.dataEnrouteNotamsRef = coreDataModel.readDataNotamsByType("enrNotams")
            coreDataModel.dataArrivalNotamsRef = coreDataModel.readDataNotamsByType("arrNotams")
            coreDataModel.dataDestinationNotamsRef = coreDataModel.readDataNotamsByType("destNotams")
            number += 1
            print("end Notam")
            isLoading = false
        }
    }
}

