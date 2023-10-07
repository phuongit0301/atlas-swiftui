//
//  SummarySubSectionView.swift
//  ATLAS
//
//  Created by phuong phan on 22/08/2023.
//

import SwiftUI
import Combine
import UIKit

struct IAlternate: Identifiable, Hashable {
    var id = UUID()
    var altn: String
    var vis: String?
    var minima: String?
    var eta: String
    var type: String?
    var isNew: Bool?
    var isDeleted: Bool?
}

struct SummarySubSectionView: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController
    @EnvironmentObject var remoteService: RemoteService
    
    @State var isReference = false
    @State private var selectedCA = SummaryDataDropDown.pic
    @State private var selectedFO = SummaryDataDropDown.pic
    @State private var selectAltn = ""
    @State private var tfPob: String = ""
    @State private var tfRoute: String = ""
    @State private var tfVis: String = ""
    @State private var tfMinima: String = ""
    @State private var tfEta: String = ""
    @State private var showUTC = true
    @State private var isEdit = false
    
    // if user change data on route alternative
    @State var isRouteFormChange = false
    
    @State private var isCollapseFlightInfo = true
    @State private var isCollapsePlanTime = true
    @State private var isCollapseRoute = true
    @State private var isCollapseCrew = true
    @State private var selectedAircraftPicker = ""
    @State private var tfFlightTime = ""

    @State var enrouteAlternates: [IAlternate] = []
    @State var destinationAlternates: [IAlternate] = []
    
    @State var isLoading = false
//    var ALTN_DROP_DOWN: [String] = ["ALTN 1", "ALTN 1", "ALTN 1"]
    
    var body: some View {
        
        GeometryReader { proxy in
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .center) {
                    Text("Summary").font(.system(size: 17, weight: .semibold))
                    
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
                    .padding(.leading, 16)
                    .padding(.bottom, 8)
                // End header
                ScrollView {
                    VStack(spacing: 0) {
                        HStack(alignment: .center, spacing: 0) {
                            Button(action: {
                                self.isCollapseFlightInfo.toggle()
                            }, label: {
                                HStack(alignment: .center, spacing: 8) {
                                    Text("Flight Information").font(.system(size: 17, weight: .semibold)).foregroundStyle(Color.black)
                                    
                                    if isCollapseFlightInfo {
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
                                }.frame(alignment: .leading)
                            }).buttonStyle(PlainButtonStyle())
                            
                            Spacer()
                        }.frame(height: 52)
                        
                        if isCollapseFlightInfo {
                            VStack(spacing: 0) {
                                HStack(spacing: 0) {
                                    Text("Callsign")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    Text("Model")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    Text("Aircraft")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                }.frame(height: 44)
                                
                                Divider().padding(.horizontal, -16)
                                
                                HStack(spacing: 0) {
                                    Text(coreDataModel.dataSummaryInfo.unwrappedFltNo)
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .regular))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    Text(coreDataModel.dataSummaryInfo.unwrappedModel)
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .regular))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    Text(coreDataModel.dataSummaryInfo.unwrappedAircraft)
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .regular))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                }.frame(height: 44)
                                
                                HStack(spacing: 0) {
                                    Text("Dep")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    Text("Dest")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    Text("POB").foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                }.frame(height: 44)
                                
                                Divider().padding(.horizontal, -16)
                                
                                HStack(spacing: 0) {
                                    Text(coreDataModel.dataSummaryInfo.unwrappedDep)
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .regular))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    Text(coreDataModel.dataSummaryInfo.unwrappedDest)
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .regular))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    Text(coreDataModel.dataSummaryInfo.unwrappedPob)
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .regular))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                }.frame(height: 44)
                            } //end VStack
                        }// end if
                    }.padding(.horizontal)
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 0))
                    
                    VStack(spacing: 0) {
                        HStack(alignment: .center, spacing: 0) {
                            Button(action: {
                                self.isCollapsePlanTime.toggle()
                            }, label: {
                                HStack(alignment: .center, spacing: 8) {
                                    Text("Planned times").font(.system(size: 17, weight: .semibold)).foregroundStyle(Color.black)
                                    if isCollapsePlanTime {
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
                                }.frame(alignment: .leading)
                            }).buttonStyle(PlainButtonStyle())
                            
                            Spacer()
                        }.frame(height: 52)
                        
                        if isCollapsePlanTime {
                            VStack(spacing: 0) {
                                HStack(spacing: 0) {
                                    Text("STD")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                    Text("STA")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                }.frame(height: 44)
                                
                                Divider().padding(.horizontal, -16)
                                
                                HStack(spacing: 0) {
                                    Text(showUTC ? coreDataModel.dataSummaryInfo.unwrappedStdUTC : coreDataModel.dataSummaryInfo.unwrappedStdLocal).font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                    Text(showUTC ? coreDataModel.dataSummaryInfo.unwrappedStaUTC : coreDataModel.dataSummaryInfo.unwrappedStaLocal).font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                }.frame(height: 44)
                                
                                HStack(spacing: 0) {
                                    Text("Block Time")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                    Text("Flight Time")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                    
                                }.frame(height: 44)
                                
                                Divider().padding(.horizontal, -16)
                                
                                HStack(spacing: 0) {
                                    Text(coreDataModel.dataSummaryInfo.unwrappedBlkTime).font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                    
                                    Text(coreDataModel.dataSummaryInfo.unwrappedFlightTime).font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)

                                }.frame(height: 44)
                                
                                HStack(spacing: 0) {
                                    Text("Block Time - Flight Time")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 1), alignment: .leading)
                                }.frame(height: 44)
                                
                                Divider().padding(.horizontal, -16)
                                
                                HStack(spacing: 0) {
                                    Text(calculateTime(coreDataModel.dataSummaryInfo.unwrappedFltTime, coreDataModel.dataSummaryInfo.unwrappedBlkTime))
                                        .font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 1), alignment: .leading)
                                }.frame(height: 44)
                            }// End VStack
                        }// end If
                    }.padding(.horizontal)
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 0))
                    
                    
                    VStack(spacing: 0) {
                        HStack(alignment: .center, spacing: 0) {
                            Button(action: {
                                self.isCollapseRoute.toggle()
                            }, label: {
                                HStack(alignment: .center, spacing: 8) {
                                    Text("Route").font(.system(size: 17, weight: .semibold)).foregroundStyle(Color.black)
                                    if isCollapseRoute {
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
                                    
                                    if isEdit {
                                        Button(action: {
                                            self.isEdit.toggle()
                                            
                                            if isRouteFormChange {
                                                create()
                                            }
                                        }, label: {
                                            Text("Done").foregroundColor(Color.theme.azure).font(.system(size: 17, weight: .regular))
                                        })
                                    } else {
                                        Button(action: {
                                            self.isEdit.toggle()
                                        }, label: {
                                            Text("Edit").foregroundColor(Color.theme.azure).font(.system(size: 17, weight: .regular))
                                        })
                                    }
                                    
                                }.frame(alignment: .leading)
                            }).buttonStyle(PlainButtonStyle())
                            
                            Spacer()
                        }.frame(height: 52)
                        
                        if isCollapseRoute {
                            VStack(spacing: 8) {
                                VStack(spacing: 0) {
                                    HStack {
                                        Text("Route").frame(width: proxy.size.width - 64, alignment: .leading)
                                            .foregroundStyle(Color.black)
                                            .font(.system(size: 15, weight: .semibold))
                                    }.frame(height: 44)
                                    
                                    Divider().padding(.horizontal, -16)
                                    
                                    HStack {
                                        TextField("Enter route",text: $tfRoute)
                                            .disabled(!isEdit)
                                            .frame(width: proxy.size.width - 64, alignment: .leading)
                                            .onSubmit {
                                                if coreDataModel.existDataSummaryInfo {
                                                    coreDataModel.dataSummaryInfo.route = tfRoute
                                                } else {
                                                    let item = SummaryInfoList(context: persistenceController.container.viewContext)
                                                    item.route = tfRoute
                                                }
                                                
                                                isRouteFormChange = true
                                                coreDataModel.save()
                                                coreDataModel.readSummaryInfo()
                                            }
                                    }.frame(height: 44)
                                }
                                
                                // Enroute Alternates
                                VStack(spacing: 0) {
                                    HStack(alignment: .center, spacing: 0) {
                                        HStack {
                                            Text("Enroute Alternate").foregroundColor(Color.black).font(.system(size: 15, weight: .medium))
                                            Spacer()
                                            
                                            if isEdit {
                                                Button(action: {
                                                    enrouteAlternates.append(IAlternate(altn: "", eta: "", isNew: true))
                                                }, label: {
                                                    Text("Add").foregroundColor(Color.theme.azure).font(.system(size: 15, weight: .medium))
                                                }).padding(.trailing)
                                            }
                                            
                                        }.frame(width: calculateWidthSummary(proxy.size.width - 32, 4), alignment: .leading)
                                        
                                        Text("ETA")
                                            .foregroundColor(Color.black).font(.system(size: 15, weight: .medium))
                                            .frame(width: calculateWidthSummary(proxy.size.width - 32, 4), alignment: .leading)
                                        Text("VIS (Optional)")
                                            .foregroundColor(Color.black).font(.system(size: 15, weight: .medium))
                                            .frame(width: calculateWidthSummary(proxy.size.width - 32, 4), alignment: .leading)
                                        Text("Minima (Optional)")
                                            .foregroundColor(Color.black).font(.system(size: 15, weight: .medium))
                                            .frame(width: calculateWidthSummary(proxy.size.width - 32, 4), alignment: .leading)
                                    }.frame(height: 44)
                                    
                                    Divider().padding(.horizontal, -16)
                                    
                                    if enrouteAlternates.count > 0 {
                                        ForEach(enrouteAlternates, id: \.self) {item in
                                            if isEdit {
                                                RowAlternates(width: proxy.size.width, item: item, itemList: $enrouteAlternates, isRouteFormChange: $isRouteFormChange, create: create).id(UUID())
                                            } else {
                                                RowTextAlternates(width: proxy.size.width, item: item, itemList: $enrouteAlternates).id(UUID())
                                            }
                                        }
                                    } else {
                                        HStack(alignment: .center) {
                                            if isEdit {
                                                Text("Tap \"Add\" to add enroute alternate").foregroundColor(Color.theme.silverSand).font(.system(size: 15, weight: .regular))
                                            } else {
                                                Text("Tap \"Edit\" to add enroute alternate").foregroundColor(Color.theme.silverSand).font(.system(size: 15, weight: .regular))
                                            }
                                            
                                            Spacer()
                                        }.frame(height: 44)
                                    }
                                }
                                
                                // Destination Alternates
                                VStack(spacing: 0) {
                                    HStack(spacing: 0) {
                                        HStack {
                                            Text("Destination Alternate").foregroundColor(Color.black).font(.system(size: 15, weight: .medium))
                                            Spacer()
                                            
                                            if isEdit {
                                                Button(action: {
                                                    destinationAlternates.append(IAlternate(altn: "", eta: "", isNew: true))
                                                }, label: {
                                                    Text("Add").foregroundColor(Color.theme.azure).font(.system(size: 15, weight: .medium))
                                                }).padding(.trailing)
                                            }
                                        }.frame(width: calculateWidthSummary(proxy.size.width - 32, 4), alignment: .leading)
                                        
                                        Text("ETA")
                                            .foregroundColor(Color.black).font(.system(size: 15, weight: .medium))
                                            .frame(width: calculateWidthSummary(proxy.size.width - 32, 4), alignment: .leading)
                                        
                                        Text("VIS (Optional)")
                                            .foregroundColor(Color.black).font(.system(size: 15, weight: .medium))
                                            .frame(width: calculateWidthSummary(proxy.size.width - 32, 4), alignment: .leading)
                                        Text("Minima (Optional)")
                                            .foregroundColor(Color.black).font(.system(size: 15, weight: .medium))
                                            .frame(width: calculateWidthSummary(proxy.size.width - 32, 4), alignment: .leading)
                                    }.frame(height: 44)
                                    
                                    Divider().padding(.horizontal, -16)
                                    
                                    if destinationAlternates.count > 0 {
                                        ForEach(destinationAlternates, id: \.self) {item in
                                            if isEdit {
                                                RowAlternates(width: proxy.size.width, item: item, itemList: $destinationAlternates, isRouteFormChange: $isRouteFormChange, create: create).id(UUID())
                                            } else {
                                                RowTextAlternates(width: proxy.size.width, item: item, itemList: $destinationAlternates).id(UUID())
                                            }
                                        }
                                    } else {
                                        HStack(alignment: .center) {
                                            if isEdit {
                                                Text("Tap \"Add\" to add destination alternate").foregroundColor(Color.theme.silverSand).font(.system(size: 15, weight: .regular))
                                            } else {
                                                Text("Tap \"Edit\" to add destination alternate").foregroundColor(Color.theme.silverSand).font(.system(size: 15, weight: .regular))
                                            }
                                            
                                            Spacer()
                                        }.frame(height: 44)
                                    }
                                    
                                }
                            }// End VStack
                            .padding(.bottom)
                        }// End if
                    }.padding(.horizontal)
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 0))
                        .padding(.bottom, 32)
                }
                // end List
            }.padding(.horizontal, 16)
                .background(Color.theme.antiFlashWhite)
                .keyboardAvoidView()
                .onAppear {
                    if coreDataModel.dataSummaryInfo.route != "" {
                        tfRoute = coreDataModel.dataSummaryInfo.route ?? ""
                    }
                    
                    prepareData()
                }
                .overlay(Group {
                    if isLoading {
                        VStack {
                            ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.black))
                        }.frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.black.opacity(0.3))
                    }
                })
        }//end geometry
    }
    
    func prepareData() {
        if coreDataModel.dataAlternate.count > 0 {
            enrouteAlternates = []
            destinationAlternates = []
            
            for item in coreDataModel.dataAlternate {
                if item.type == "enroute" {
                    enrouteAlternates.append(
                        IAlternate(id: item.id ?? UUID(), altn: item.altn ?? "", vis: item.vis, minima: item.minima, eta: item.eta ?? "", isNew: false, isDeleted: false)
                    )
                } else {
                    destinationAlternates.append(
                        IAlternate(id: item.id ?? UUID(), altn: item.altn ?? "", vis: item.vis, minima: item.minima, eta: item.eta ?? "", isNew: false, isDeleted: false)
                    )
                }
                
            }
        }
    }
    
    func create() {
        Task {
            self.isLoading = true
        
        var payloadEnroute: [Any] = []
        var payloadDestination: [Any] = []
            
        var payloadEnrouteMap: [String] = []
        var payloadDestinationMap: [String] = []
        
        if enrouteAlternates.count > 0 {
            for item in enrouteAlternates {
                payloadEnroute.append([
                    "Airport": item.altn,
                    "std": item.eta
                ])
                payloadEnrouteMap.append(item.altn)
            }
        }
        
        if destinationAlternates.count > 0 {
            for item in destinationAlternates {
                payloadDestination.append([
                    "Airport": item.altn,
                    "std": item.eta
                ])
                payloadDestinationMap.append(item.altn)
            }
        }
        
            let payloadNotam: [String: Any] = [
                "depAirport": [
                    "Airport": "VTBS",
                    "std": "2023-09-08 20:00"
                ],
                "arrAirport": [
                    "Airport": "WSSS",
                    "sta": "2023-09-08 23:00"
                ],
                "enrAirports": payloadEnroute,
                "altnAirports": payloadDestination
            ]
            
            let payloadMap: [String: Any] = [
                "depAirport": coreDataModel.dataSummaryInfo.unwrappedDepICAO,
                "arrAirport": coreDataModel.dataSummaryInfo.unwrappedDestICAO,
                "enrAirports": payloadEnrouteMap,
                "altnAirports": payloadDestinationMap,
                "route": tfRoute
            ]
            
            async let trafficService = remoteService.updateMapTrafficData(payloadMap)
            async let aabbaService = remoteService.updateMapAabbaData(payloadMap)
            async let waypointService = remoteService.updateMapWaypointData(payloadMap)
            async let airportService = remoteService.updateMapAirportData()
            
            // For Notam, MetarTaf
//            async let notamService = remoteService.updateNotamData(payloadNotam)
            
            //array handle call API parallel
            let services = try await [trafficService, aabbaService, waypointService, airportService]
            let servicesNotam: INotamWXDataJson = self.remoteService.load("testing_data.json")
            
            if (services[0] as! [ITrafficData]).count > 0 {
                await coreDataModel.deleteAllTrafficMap()
                coreDataModel.initDataTraffic(services[0] as! [ITrafficData])
            }

            if (services[1] as! [IAabbaData]).count > 0 {
                await coreDataModel.deleteAllAabbaCommentList()
                await coreDataModel.deleteAllAabbaPostList()
                await coreDataModel.deleteAllAabbMapList()
                coreDataModel.initDataAabba(services[1] as! [IAabbaData])
            }

            if (services[2] as! [IWaypointData]).count > 0 {
                await coreDataModel.deleteAllWaypointList()
                coreDataModel.initDataWaypoint(services[2] as! [IWaypointData])
            }

            if (services[3] as! [IAirportData]).count > 0 {
                await coreDataModel.deleteAllAirportList()
                coreDataModel.initDataAirport(services[3] as! [IAirportData])
                coreDataModel.initDataAirportMapColor(services[3] as! [IAirportData])
            }
            
            await coreDataModel.deleteAllMetaTaf()
            await coreDataModel.deleteAllNotam()
            coreDataModel.initDepDataMetarTaf(servicesNotam.metarTafData.depMetarTaf, type: "depMetarTaf")
            coreDataModel.initArrDataMetarTaf(servicesNotam.metarTafData.arrMetarTaf, type: "arrMetarTaf")
            
            if servicesNotam.metarTafData.altnMetarTaf.count > 0 {
                for item in servicesNotam.metarTafData.altnMetarTaf {
                    coreDataModel.initEnrDataMetarTaf(item, type: "altnMetarTaf")
                }
            }
            
            if servicesNotam.metarTafData.enrMetarTaf.count > 0 {
                for item in servicesNotam.metarTafData.enrMetarTaf {
                    coreDataModel.initEnrDataMetarTaf(item, type: "enrMetarTaf")
                }
            }
            
            coreDataModel.initDataNotams(servicesNotam.notamsData)
            
            coreDataModel.dataDepartureMetarTaf = coreDataModel.readDataMetarTafByType("depMetarTaf")
            coreDataModel.dataEnrouteMetarTaf = coreDataModel.readDataMetarTafByType("enrMetarTaf")
            coreDataModel.dataArrivalMetarTaf = coreDataModel.readDataMetarTafByType("arrMetarTaf")
            coreDataModel.dataDestinationMetarTaf = coreDataModel.readDataMetarTafByType("altnMetarTaf")
            coreDataModel.dataNotams = coreDataModel.readDataNotamsList()
            coreDataModel.dataNotamsRef = coreDataModel.readDataNotamsRefList()
            coreDataModel.dataDepartureNotamsRef = coreDataModel.readDataNotamsByType("depNotams")
            coreDataModel.dataEnrouteNotamsRef = coreDataModel.readDataNotamsByType("enrNotams")
            coreDataModel.dataArrivalNotamsRef = coreDataModel.readDataNotamsByType("arrNotams")
            coreDataModel.dataDestinationNotamsRef = coreDataModel.readDataNotamsByType("destNotams")
            
            if (enrouteAlternates.count > 0) {
                persistenceController.container.viewContext.performAndWait {
                    for item in enrouteAlternates {
                        do {
                            if let isNew = item.isNew {
                                if isNew && item.eta != "" && item.altn != "" {
                                   let newObject = RouteAlternateList(context: persistenceController.container.viewContext)
                                   newObject.id = UUID()
                                   newObject.altn = item.altn
                                   newObject.vis = item.vis
                                   newObject.minima = item.minima
                                   newObject.eta = item.eta
                                   newObject.type = "enroute"

                                   try persistenceController.container.viewContext.save()
                                   print("saved Enroute successfully")

                                   enrouteAlternates = []
                               }
                            }
                             
                        } catch {
                            print("Failed to Enroute save: \(error)")
                            // Rollback any changes in the managed object context
                            persistenceController.container.viewContext.rollback()
                        }
                    }
                }
            }

            if (destinationAlternates.count > 0) {
                persistenceController.container.viewContext.performAndWait {
                    for item in destinationAlternates {
                        do {
                            if let isNew = item.isNew {
                                if isNew && item.eta != "" && item.altn != "" {
                                    let newObject = RouteAlternateList(context: persistenceController.container.viewContext)
                                    newObject.id = UUID()
                                    newObject.altn = item.altn
                                    newObject.vis = item.vis
                                    newObject.minima = item.minima
                                    newObject.eta = item.eta
                                    newObject.type = "destination"
                                    
                                    try persistenceController.container.viewContext.save()
                                    print("saved Enroute successfully")
                                    
                                    destinationAlternates = []
                                }
                            }
                        } catch {
                            print("Failed to Destination save: \(error)")
                            // Rollback any changes in the managed object context
                            persistenceController.container.viewContext.rollback()
                        }
                    }
                }
            }
            
            coreDataModel.dataAlternate = coreDataModel.readDataAlternate()
            coreDataModel.dataAabbaMap = coreDataModel.readDataAabbaMapList()
            prepareData()
            
            self.isLoading = false
        }
            
        
        //todo
//        /ATLAS_get_map_traffic_data,
        // inputJSON = {
        //            "depAirport": "VTBS", Dep Field
        //            "arrAirport": "WSSS", Dest Field
        //            "enrAirports": ["WMKP", "WMKK"], Enroute airport
        //            "altnAirports": ["WMKJ", "WIDD"], destination airport
        //            "route": "VTBS/19L F410 KIGOB Y11 PASVA/F410 Y514 NUFFA DCT PIBAP DCT PASPU DCT NYLON DCT POSUB DCT SANAT WSSS/02L"
        //        }
        
        
//        /ATLAS_get_map_aabba_data,
//        inputJSON = {
        //            "depAirport": "VTBS", Dep Field
        //            "arrAirport": "WSSS", Dest Field
        //            "enrAirports": ["WMKP", "WMKK"], Enroute airport
        //            "altnAirports": ["WMKJ", "WIDD"], destination airport
        //            "route": "VTBS/19L F410 KIGOB Y11 PASVA/F410 Y514 NUFFA DCT PIBAP DCT PASPU DCT NYLON DCT POSUB DCT SANAT WSSS/02L"
        //        }

        
        //        /ATLAS_get_map_waypoints_data
//        inputJSON = {
        //            "depAirport": "VTBS", Dep Field
        //            "arrAirport": "WSSS", Dest Field
        //            "enrAirports": ["WMKP", "WMKK"], Enroute airport
        //            "altnAirports": ["WMKJ", "WIDD"], destination airport
        //            "route": "VTBS/19L F410 KIGOB Y11 PASVA/F410 Y514 NUFFA DCT PIBAP DCT PASPU DCT NYLON DCT POSUB DCT SANAT WSSS/02L"
        //        }
        
        
//        /ATLAS_get_map_airports_data
        
        
        // todo send POST to API /ATLAS_get_notam_wx_data
//        inputJSON = {
//                    "depAirport": {
//                        "Airport": "VTBS",
//                        "std": "2023-09-08 20:00"
//                    },
//                    "arrAirport": {
//                        "Airport": "WSSS",
//                        "sta": "2023-09-08 23:00"
//                    },
//                    "enrAirports": [
//                        {
//                            "Airport": "WMKK",
//                            "eta": "2023-09-08 22:00"
//                        },
//                        {
//                            "Airport": "WMKP",
//                            "eta": "2023-09-08 22:00"
//                        }
//                    ],
//                    "altnAirports": [
//                        {
//                            "Airport": "WMKJ",
//                            "eta": "2023-09-08 22:00"
//                        },
//                        {
//                            "Airport": "WIDD",
//                            "eta": "2023-09-08 22:00"
//                        }
//                    ]
//                }
    }
}

struct WarningPopover: View {
    // 1
    var text: String
    // 2
    var shouldDisplay: Bool
    // 3
    @State private var showPopover = false

    var body: some View {
        HStack { // 4
            Spacer()
            // 5
            if shouldDisplay {
                // 6
                Image(systemName: "xmark.octagon")
                    .foregroundColor(.red)
                    .padding(2)
                    // 7
                    .popover(isPresented: $showPopover) {
                        Text(text)
                            .padding()
                    }
                    // 8
                    .onHover { (hoverring) in
                        showPopover = hoverring
                    }
            }
        }
    }
}
