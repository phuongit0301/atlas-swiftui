//
//  SummarySubSectionView.swift
//  ATLAS
//
//  Created by phuong phan on 22/08/2023.
//

import SwiftUI
import Combine
import UIKit
import OSLog

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
    @EnvironmentObject var preflightModel: PreflightModel
    @EnvironmentObject var mapIconModel: MapIconModel
    
    @AppStorage("uid") var userID: String = ""
    
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
    
    @State private var dataFlightOverview: FlightOverviewList?
    
    @State var isLoading = false
    
    let logger = Logger(subsystem: "atlas", category: "persistence")
    
    var body: some View {
        var std: String {
            if showUTC {
                return dataFlightOverview?.unwrappedStd ?? ""
            } else {
                return convertUTCToLocalTime(timeString: dataFlightOverview?.unwrappedStd ?? "", timeDiff: dataFlightOverview?.unwrappedTimeDiffDep ?? "")
            }
        }
        
        var sta: String {
            if showUTC {
                return dataFlightOverview?.unwrappedSta ?? ""
            } else {
                return convertUTCToLocalTime(timeString: dataFlightOverview?.unwrappedSta ?? "", timeDiff: dataFlightOverview?.unwrappedTimeDiffArr ?? "")
            }
        }
        
        var eta: String {
            if showUTC {
                return dataFlightOverview?.unwrappedEta ?? ""
            } else {
                return convertUTCToLocalTime(timeString: dataFlightOverview?.unwrappedEta ?? "", timeDiff: dataFlightOverview?.unwrappedTimeDiffArr ?? "")
            }
        }
        
        GeometryReader { proxy in
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .center) {
                    Text("Summary").font(.system(size: 17, weight: .semibold))
                    
                    Spacer()
                    
//                    HStack {
//                        Toggle(isOn: $showUTC) {
//                            Text("Local").font(.system(size: 17, weight: .regular))
//                                .foregroundStyle(Color.black)
//                        }
//                        Text("UTC").font(.system(size: 17, weight: .regular))
//                            .foregroundStyle(Color.black)
//                    }.fixedSize()
//
                }.frame(height: 52)
                    .padding(.leading, 16)
                    .padding(.bottom, 8)
                // End header
                ScrollView {
//                    VStack(spacing: 0) {
//                        HStack(alignment: .center, spacing: 0) {
//                            Button(action: {
//                                self.isCollapseFlightInfo.toggle()
//                            }, label: {
//                                HStack(alignment: .center, spacing: 8) {
//                                    Text("Flight Information").font(.system(size: 17, weight: .semibold)).foregroundStyle(Color.black)
//
//                                    if isCollapseFlightInfo {
//                                        Image(systemName: "chevron.down")
//                                            .foregroundColor(Color.blue)
//                                            .scaledToFit()
//                                            .aspectRatio(contentMode: .fit)
//                                    } else {
//                                        Image(systemName: "chevron.up")
//                                            .foregroundColor(Color.blue)
//                                            .scaledToFit()
//                                            .aspectRatio(contentMode: .fit)
//                                    }
//                                }.frame(alignment: .leading)
//                            }).buttonStyle(PlainButtonStyle())
//
//                            Spacer()
//                        }.frame(height: 52)
//
//                        if isCollapseFlightInfo {
//                            VStack(spacing: 0) {
//                                HStack(spacing: 0) {
//                                    Text("Callsign")
//                                        .foregroundStyle(Color.black)
//                                        .font(.system(size: 15, weight: .semibold))
//                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
//                                    Text("Model")
//                                        .foregroundStyle(Color.black)
//                                        .font(.system(size: 15, weight: .semibold))
//                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
//                                    Text("Aircraft")
//                                        .foregroundStyle(Color.black)
//                                        .font(.system(size: 15, weight: .semibold))
//                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
//                                }.frame(height: 44)
//
//                                Divider().padding(.horizontal, -16)
//
//                                HStack(spacing: 0) {
//                                    Text(dataFlightOverview?.unwrappedCallsign ?? "")
//                                        .foregroundStyle(Color.black)
//                                        .font(.system(size: 15, weight: .regular))
//                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
//                                    Text(dataFlightOverview?.unwrappedModel ?? "")
//                                        .foregroundStyle(Color.black)
//                                        .font(.system(size: 15, weight: .regular))
//                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
//                                    Text(dataFlightOverview?.unwrappedAircraft ?? "")
//                                        .foregroundStyle(Color.black)
//                                        .font(.system(size: 15, weight: .regular))
//                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
//                                }.frame(height: 44)
//
//                                HStack(spacing: 0) {
//                                    Text("Dep")
//                                        .foregroundStyle(Color.black)
//                                        .font(.system(size: 15, weight: .semibold))
//                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
//                                    Text("Dest")
//                                        .foregroundStyle(Color.black)
//                                        .font(.system(size: 15, weight: .semibold))
//                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
//                                    Text("POB").foregroundStyle(Color.black)
//                                        .font(.system(size: 15, weight: .semibold))
//                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
//                                }.frame(height: 44)
//
//                                Divider().padding(.horizontal, -16)
//
//                                HStack(spacing: 0) {
//                                    Text(dataFlightOverview?.unwrappedDep ?? "")
//                                        .foregroundStyle(Color.black)
//                                        .font(.system(size: 15, weight: .regular))
//                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
//                                    Text(dataFlightOverview?.unwrappedDest ?? "")
//                                        .foregroundStyle(Color.black)
//                                        .font(.system(size: 15, weight: .regular))
//                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
//                                    Text(dataFlightOverview?.unwrappedPob ?? "")
//                                        .foregroundStyle(Color.black)
//                                        .font(.system(size: 15, weight: .regular))
//                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
//                                }.frame(height: 44)
//                            } //end VStack
//                        }// end if
//                    }.padding(.horizontal)
//                        .background(Color.white)
//                        .cornerRadius(8)
//                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 0))
//
//                    VStack(spacing: 0) {
//                        HStack(alignment: .center, spacing: 0) {
//                            Button(action: {
//                                self.isCollapsePlanTime.toggle()
//                            }, label: {
//                                HStack(alignment: .center, spacing: 8) {
//                                    Text("Planned times").font(.system(size: 17, weight: .semibold)).foregroundStyle(Color.black)
//                                    if isCollapsePlanTime {
//                                        Image(systemName: "chevron.down")
//                                            .foregroundColor(Color.blue)
//                                            .scaledToFit()
//                                            .aspectRatio(contentMode: .fit)
//                                    } else {
//                                        Image(systemName: "chevron.up")
//                                            .foregroundColor(Color.blue)
//                                            .scaledToFit()
//                                            .aspectRatio(contentMode: .fit)
//                                    }
//                                }.frame(alignment: .leading)
//                            }).buttonStyle(PlainButtonStyle())
//
//                            Spacer()
//                        }.frame(height: 52)
//
//                        if isCollapsePlanTime {
//                            VStack(spacing: 0) {
//                                HStack(spacing: 0) {
//                                    Text("STD")
//                                        .foregroundStyle(Color.black)
//                                        .font(.system(size: 15, weight: .semibold))
//                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
//                                    Text("STA")
//                                        .foregroundStyle(Color.black)
//                                        .font(.system(size: 15, weight: .semibold))
//                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
//                                }.frame(height: 44)
//
//                                Divider().padding(.horizontal, -16)
//
//                                HStack(spacing: 0) {
//                                    Text(std).font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black)
//                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
//                                    Text(sta).font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black)
//                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
//                                }.frame(height: 44)
//
//                                HStack(spacing: 0) {
//                                    Text("Block Time")
//                                        .foregroundStyle(Color.black)
//                                        .font(.system(size: 15, weight: .semibold))
//                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
//                                    Text("Flight Time")
//                                        .foregroundStyle(Color.black)
//                                        .font(.system(size: 15, weight: .semibold))
//                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
//
//                                }.frame(height: 44)
//
//                                Divider().padding(.horizontal, -16)
//
//                                HStack(spacing: 0) {
//                                    Text(renderTime(std, sta)).font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
//                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
//
//                                    Text(dataFlightOverview?.unwrappedFlightTime ?? "").font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
//                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
//
//                                }.frame(height: 44)
//
//                                HStack(spacing: 0) {
//                                    Text("Block Time - Flight Time")
//                                        .foregroundStyle(Color.black)
//                                        .font(.system(size: 15, weight: .semibold))
//                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 1), alignment: .leading)
//                                }.frame(height: 44)
//
//                                Divider().padding(.horizontal, -16)
//
//                                HStack(spacing: 0) {
//                                    Text(renderBlockFlightTime(dataFlightOverview?.unwrappedFlightTime ?? "00:00", renderTime(std, sta)))
//                                        .font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
//                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 1), alignment: .leading)
//                                }.frame(height: 44)
//                            }// End VStack
//                        }// end If
//                    }.padding(.horizontal)
//                        .background(Color.white)
//                        .cornerRadius(8)
//                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 0))
//
                    
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
                                        if coreDataModel.selectedEvent?.flightStatus != FlightStatusEnum.COMPLETED.rawValue {
                                            Button(action: {
                                                self.isEdit.toggle()
                                            }, label: {
                                                Text("Edit").foregroundColor(Color.theme.azure).font(.system(size: 17, weight: .regular))
                                            })
                                        } else {
                                            Text("Edit").foregroundColor(Color.black).font(.system(size: 17, weight: .regular))
                                        }
                                    }
                                    
                                }.frame(alignment: .leading)
                            }).buttonStyle(PlainButtonStyle())
                            
                            Spacer()
                        }.frame(height: 52)
                        
                        if isCollapseRoute {
                            VStack(spacing: 8) {
                                VStack(spacing: 0) {
                                    HStack {
                                        Text("Route").frame(alignment: .leading)
                                            .foregroundStyle(Color.black)
                                            .font(.system(size: 15, weight: .semibold))
                                        
                                        Spacer()
                                        
                                        if isEdit {
                                            Button(action: {
                                            }, label: {
                                                Image(systemName: "camera").foregroundColor(Color.theme.philippineGray3)
                                            }).padding(.trailing, 8)
                                        }
                                    }.frame(width: calculateWidthSummary(proxy.size.width - 32, 1), height: 44, alignment: .leading)
                                    
                                    Divider().padding(.horizontal, -16)
                                    
                                    HStack {
                                        TextField("Enter route",text: $tfRoute)
                                            .textInputAutocapitalization(.characters)
                                            .disabled(!isEdit)
                                            .frame(width: proxy.size.width - 64, alignment: .leading)
                                            .onSubmit {
                                                if dataFlightOverview != nil, let item = dataFlightOverview {
                                                    item.route = tfRoute
                                                } else {
                                                    let item = FlightOverviewList(context: persistenceController.container.viewContext)
                                                    item.route = tfRoute
                                                }
                                                
                                                isRouteFormChange = true
                                                coreDataModel.save()
                                            }
                                    }.frame(width: calculateWidthSummary(proxy.size.width - 32, 1), height: 44, alignment: .leading)
                                }
                                
                                // Enroute Alternates
                                VStack(spacing: 0) {
                                    HStack(alignment: .center, spacing: 0) {
                                        HStack {
                                            Text("Enroute Alternate").foregroundColor(Color.black).font(.system(size: 15, weight: .medium))
                                            Spacer()
                                            
                                            if isEdit {
                                                Button(action: {
                                                    enrouteAlternates.append(IAlternate(altn: "Select Airport", eta: "", isNew: true))
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
                                                RowAlternates(width: proxy.size.width, item: item, itemList: $enrouteAlternates, isRouteFormChange: $isRouteFormChange, create: create, routeAlternateType: "enroute").id(UUID())
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
                                                    destinationAlternates.append(IAlternate(altn: "Select Airport", eta: "", isNew: true))
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
                                                RowAlternates(width: proxy.size.width, item: item, itemList: $destinationAlternates, isRouteFormChange: $isRouteFormChange, create: create, routeAlternateType: "destination").id(UUID())
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
                    if let overviewList = coreDataModel.selectedEvent?.flightOverviewList?.allObjects as? [FlightOverviewList] {
                        dataFlightOverview = overviewList.first
                        
                        if dataFlightOverview?.route != "" {
                            tfRoute = dataFlightOverview?.route ?? ""
                        }
                        
                        prepareData()
                    }
                }
                .overlay(Group {
                    if isLoading {
                        VStack {
                            ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.black))
                        }.frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.black.opacity(0.3))
                    }
                })
                .sheet(isPresented: $preflightModel.isShowingAutoComplete) {
                    if preflightModel.routeAlternateType == "enroute" {
                        AutoCompleteView(isShowing: $preflightModel.isShowingAutoComplete, itemList: $enrouteAlternates, isRouteFormChange: $isRouteFormChange).interactiveDismissDisabled(true)
                    } else {
                        AutoCompleteView(isShowing: $preflightModel.isShowingAutoComplete, itemList: $destinationAlternates, isRouteFormChange: $isRouteFormChange).interactiveDismissDisabled(true)
                    }
                }
        }//end geometry
    }
    
    func prepareData() {
        if let dataAlternate = coreDataModel.selectedEvent?.routeAlternate?.allObjects as? [RouteAlternateList], dataAlternate.count > 0 {
            enrouteAlternates = []
            destinationAlternates = []
            
            for item in dataAlternate {
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
            await withTaskGroup(of: Void.self) { group in
                //            self.isLoading = true
                
                var payloadEnroute: [Any] = []
                var payloadDestination: [Any] = []
                
                var payloadEnrouteMap: [String] = []
                var payloadDestinationMap: [String] = []
                
                var enrAirportNotam: [String: String] = [:]
                
                if enrouteAlternates.count > 0 {
                    for item in enrouteAlternates {
                        if item.altn != "Select Airport" {
                            payloadEnroute.append([
                                "Airport": item.altn,
                                "eta": item.eta
                            ])
                            payloadEnrouteMap.append(item.altn)
                            enrAirportNotam[item.altn] = item.eta
                        }
                    }
                }
                
                var destAirportNotam: [String: String] = [:]
                if destinationAlternates.count > 0 {
                    for item in destinationAlternates {
                        if item.altn != "Select Airport" {
                            payloadDestination.append([
                                "Airport": item.altn,
                                "eta": item.eta
                            ])
                            payloadDestinationMap.append(item.altn)
                            destAirportNotam[item.altn] = item.eta
                        }
                    }
                }
                
                var depAirportNotam: [String: String] = [:]
                depAirportNotam[dataFlightOverview?.unwrappedDep ?? ""] = dataFlightOverview?.unwrappedStd
                
                var arrAirportNotam: [String: String] = [:]
                arrAirportNotam[dataFlightOverview?.unwrappedDest ?? ""] = dataFlightOverview?.unwrappedSta
                
                coreDataModel.enrAirportNotam = enrAirportNotam
                coreDataModel.destAirportNotam = destAirportNotam
                coreDataModel.depAirportNotam = depAirportNotam
                coreDataModel.arrAirportNotam = arrAirportNotam
                
                readData()
                
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
                
                let payloadMap: [String: Any] = [
                    "depAirport": dataFlightOverview?.unwrappedDep ?? "",
                    "arrAirport": dataFlightOverview?.unwrappedDest ?? "",
                    "enrAirports": payloadEnrouteMap,
                    "altnAirports": payloadDestinationMap,
                    "route": tfRoute
                ]
                
                let payloadAabbaNote: [String: Any] = [
                    "depAirport": dataFlightOverview?.unwrappedDep ?? "",
                    "arrAirport": dataFlightOverview?.unwrappedDest ?? "",
                    "enrALTNS": payloadEnrouteMap,
                    "destALTNS": payloadDestinationMap,
                ]
                
                print("payloadNotam========\(payloadNotam)")
                coreDataModel.isTrafficLoading = true
                coreDataModel.isMapAabbaLoading = true
                coreDataModel.isMapWaypointLoading = true
                coreDataModel.isMapAirportColorLoading = true
                coreDataModel.isAabbaNoteLoading = true
                coreDataModel.isNotamLoading = true
                
                group.addTask(priority: .background) {
                    await handleTraffic(payloadMap)
                }
                
                group.addTask(priority: .background) {
                    await handleMapAabba(payloadMap)
                }
                
                group.addTask(priority: .background) {
                    await handleWaypoint(payloadMap)
                }
                
                group.addTask(priority: .background) {
                    await handleAirport(payloadMap)
                }
                
                group.addTask(priority: .background) {
                    await handleAabbaNote(payloadAabbaNote)
                }
                
                group.addTask(priority: .background) {
                    await handleNotam(payloadNotam)
                }
                
                //
                //        group.addTask {
                //            await handleWaypoint(payloadMap)
                //        }
                //
                //        group.addTask {
                //            await handleAirport(payloadMap)
                //        }
                //
                //        group.addTask {
                //            await handleAabbaNote(payloadAabbaNote)
                //        }
                //
                //        group.addTask {
                //            await handleNotam(payloadNotam)
                //        }
                //
                var routeAlternateList = [RouteAlternateList]()
                
                persistenceController.container.viewContext.performAndWait {
                    if (enrouteAlternates.count > 0) {
                        for item in enrouteAlternates {
                            do {
                                let isNew = item.isNew ?? false
                                if isNew {
                                    if item.eta != "" && item.altn != "" {
                                        let newObject = RouteAlternateList(context: persistenceController.container.viewContext)
                                        newObject.id = UUID()
                                        newObject.altn = item.altn
                                        newObject.vis = item.vis
                                        newObject.minima = item.minima
                                        newObject.eta = item.eta
                                        newObject.type = "enroute"
                                        
                                        routeAlternateList.append(newObject)
                                        try persistenceController.container.viewContext.save()
                                        print("saved Enroute successfully")
                                    }
                                } else {
                                    if let newObject = coreDataModel.readDataAlternateById(item.id) {
                                        newObject.altn = item.altn
                                        newObject.vis = item.vis
                                        newObject.minima = item.minima
                                        newObject.eta = item.eta
                                        routeAlternateList.append(newObject)
                                    }
                                }
                            } catch {
                                print("Failed to Enroute save: \(error)")
                                // Rollback any changes in the managed object context
                                persistenceController.container.viewContext.rollback()
                            }
                        }
                        
                        if (destinationAlternates.count > 0) {
                            for item in destinationAlternates {
                                do {
                                    let isNew = item.isNew ?? false
                                    
                                    if isNew {
                                        if item.eta != "" && item.altn != "" {
                                            let newObject = RouteAlternateList(context: persistenceController.container.viewContext)
                                            newObject.id = UUID()
                                            newObject.altn = item.altn
                                            newObject.vis = item.vis
                                            newObject.minima = item.minima
                                            newObject.eta = item.eta
                                            newObject.type = "destination"
                                            routeAlternateList.append(newObject)
                                            
                                            try persistenceController.container.viewContext.save()
                                            print("saved Enroute successfully")
                                        }
                                    } else {
                                        if let newObject = coreDataModel.readDataAlternateById(item.id) {
                                            newObject.altn = item.altn
                                            newObject.vis = item.vis
                                            newObject.minima = item.minima
                                            newObject.eta = item.eta
                                            routeAlternateList.append(newObject)
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
                    
                    coreDataModel.selectedEvent?.routeAlternate = NSSet(array: routeAlternateList)
                    
                    if tfRoute != "" {
                        dataFlightOverview?.route = tfRoute
                    }
                    
                }
                
                coreDataModel.save()
                
                readData()
                enrouteAlternates = []
                destinationAlternates = []
                
                coreDataModel.dataAlternate = coreDataModel.readDataAlternate()
                coreDataModel.dataAabbaMap = coreDataModel.readDataAabbaMapList()
                mapIconModel.firstLoading = true
                prepareData()
                
                self.isLoading = false
            }
        }
    }
    
    func readData() {
        coreDataModel.dataTrafficMap = coreDataModel.readDataTrafficMapList()
        coreDataModel.dataAabbaMap = coreDataModel.readDataAabbaMapList()
        coreDataModel.dataWaypointMap = coreDataModel.readDataWaypontMapList()
        coreDataModel.dataAirportColorMap = coreDataModel.readDataAirportMapColorList()
        coreDataModel.dataAirportMap = coreDataModel.readDataAirportMapList()
        coreDataModel.dataNoteAabba = coreDataModel.readDataNoteAabbaPostList("")
        coreDataModel.dataNoteAabbaPreflight = coreDataModel.readDataNoteAabbaPostList("preflight")
        coreDataModel.dataNoteAabbaDeparture = coreDataModel.readDataNoteAabbaPostList("departure")
        coreDataModel.dataNoteAabbaEnroute = coreDataModel.readDataNoteAabbaPostList("enroute")
        coreDataModel.dataNoteAabbaArrival = coreDataModel.readDataNoteAabbaPostList("arrival")
        coreDataModel.dataNotams = coreDataModel.readDataNotamsList()
    }
    
    func handleTraffic(_ payload: [String: Any]) async {
        print("handle traffic")
        
        coreDataModel.isTrafficLoading = true
        await remoteService.getMapTrafficData(payload, completion: { (success, responseTraffic) in
            Task {
                if success {
                    if responseTraffic.count > 0 {
                        print("inside handle traffic======\(responseTraffic)")
                        await coreDataModel.deleteAllTrafficMap()
                        coreDataModel.initDataTraffic(responseTraffic)
                    }
                    print("end handle traffic")
                    coreDataModel.isTrafficLoading = false
                }
            }
        })
    }
    
    func handleMapAabba(_ payload: [String: Any]) async {
        print("handle map aabba")
        coreDataModel.isMapAabbaLoading = true
        
        await remoteService.getMapAabbaData(payload, completion: { (success, responseMapAabba) in
            Task {
                if success {
                    if responseMapAabba.count > 0 {
                        await coreDataModel.deleteAllMapAabbaCommentList()
                        await  coreDataModel.deleteAllMapAabbaPostList()
                        await coreDataModel.deleteAllMapAabbMapList()
                        
                        coreDataModel.initDataAabba(responseMapAabba)
                    }
                    print("end map aabba")
                    coreDataModel.isMapAabbaLoading = false
                }
            }
        })
    }
    
    func handleWaypoint(_ payload: [String: Any]) async {
        print("handle waypoint")
        coreDataModel.isMapWaypointLoading = true
        
        await remoteService.getMapWaypointData(payload, completion: { (success, responseWaypoint) in
            Task {
                if success {
                    if responseWaypoint.count > 0 {
                        print("inside waypoint======\(responseWaypoint)")
                        await coreDataModel.deleteAllWaypointList()
                        coreDataModel.initDataWaypoint(responseWaypoint)
                    }
                    print("end waypoint")
                    coreDataModel.isMapWaypointLoading = false
                }
            }
        })
    }
    
    func handleAirport(_ payload: [String: Any]) async {
        print("handle aiport")
        
        coreDataModel.isMapAirportColorLoading = true
        await remoteService.getMapAirportColorData(payload, completion: { (success, responseColorAirport) in
            Task {
                if success {
                    if responseColorAirport.colour_airports_data.count > 0 {
                        await coreDataModel.deleteAllAirportColorList()
                        coreDataModel.initDataAirportMapColor(responseColorAirport.colour_airports_data, payload)
                    }
                    print("end aiport")
                    coreDataModel.isMapAirportColorLoading = false
                }
            }
        })
    }
    
    func handleAabbaNote(_ payload: [String: Any]) async {
        print("handle aabba note")
        coreDataModel.isAabbaNoteLoading = true
        
        await remoteService.getAabbaNoteDataCallback(payload, completion: { (success, responseAabbaNote) in
            Task {
                if success {
                    if responseAabbaNote.count > 0, let eventList = coreDataModel.selectedEvent {
                        await coreDataModel.deleteAllAabbaNoteList(eventList)
                        coreDataModel.initDataMapAabbaNotes(responseAabbaNote, eventList)
                    }
                    print("end aabba note")
                    coreDataModel.isAabbaNoteLoading = false
                }
            }
        })
    }
    
    func handleNotam(_ payload: [String: Any]) async {
        print("handle notam")
        coreDataModel.isNotamLoading = true
        
        await remoteService.getNotamDataCallback(payload, completion: { (success, responseNotam) in
            Task {
                if success {
                    if let metarTafData = responseNotam?.metarTafData {
                        print("inside metar")
                        await coreDataModel.deleteAllMetarTaf()
                        
                        coreDataModel.initDepDataMetarTaf(metarTafData.depMetarTaf, type: "depMetarTaf")
                        coreDataModel.initArrDataMetarTaf(metarTafData.arrMetarTaf, type: "arrMetarTaf")
                        
                        if metarTafData.altnMetarTaf.count > 0 {
                            coreDataModel.initEnrDataMetarTaf(metarTafData.altnMetarTaf, type: "altnMetarTaf")
                        }
                        
                        if metarTafData.enrMetarTaf.count > 0 {
                            coreDataModel.initEnrDataMetarTaf(metarTafData.enrMetarTaf, type: "enrMetarTaf")
                        }
                    }
                    
                    if let notamsData = responseNotam?.notamsData {
                        print("inside notam")
                        await coreDataModel.deleteAllNotam()
                        coreDataModel.initDataNotams(notamsData)
                    }
                    
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
                    
                    print("end Notam")
                    coreDataModel.isNotamLoading = false
                }
            }
        })
    }
    
    func renderTime(_ startDate: String, _ endDate: String) -> String {
        if startDate != "" && endDate != "" {
            return calculateDateTime(startDate, endDate)
        }
        return ""
    }
    
    func renderBlockFlightTime(_ startDate: String, _ endDate: String) -> String {
        if startDate != "" && endDate != "" {
            return calculateTime(startDate, endDate)
        }
        return ""
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
