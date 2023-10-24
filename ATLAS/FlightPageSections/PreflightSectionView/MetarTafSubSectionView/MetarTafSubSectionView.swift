//
//  MetarTafSubSectionView.swift
//  ATLAS
//
//  Created by phuong phan on 24/9/23.
//

import Foundation
import SwiftUI

struct MetarTafSubSectionView: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var remoteService: RemoteService
    @EnvironmentObject var persistenceController: PersistenceController
    @State var isLoading = false
    
    @State private var isDepShow = true
    @State private var isEnrShow = true
    @State private var isArrShow = true
    @State private var isDestShow = true
    @State private var number = 0
    
    @State private var metarTafList = [MetarTafDataList]()
    let redWords: [String] = ["TEMPO", "RA", "SHRA", "RESHRA", "-SHRA", "+SHRA", "TS", "TSRA", "-TSRA", "+TSRA", "RETS"]
    
    var body: some View {
        if coreDataModel.isNotamLoading {
            HStack(alignment: .center) {
                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.black)).controlSize(.large)
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .background(Color.black.opacity(0.3))
        } else {
            GeometryReader { proxy in
                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .center) {
                        Text("METAR & TAF")
                            .font(.system(size: 17, weight: .semibold))
                        
                        Spacer()
                        
                        if let metarTaf = coreDataModel.dataSectionDateUpdate?.unwrappedMetarTaf {
                            Text("Last Update: \(metarTaf)").foregroundColor(.black).font(.system(size: 15, weight: .regular))
                        }
                        
                        if coreDataModel.selectedEvent?.flightStatus == FlightStatusEnum.COMPLETED.rawValue {
                            Button(action: {
                            }, label: {
                                HStack {
                                    Text("Refresh").font(.system(size: 17, weight: .regular))
                                        .foregroundColor(Color.white)
                                        .padding(.horizontal)
                                        .padding(.vertical, 8)
                                }
                            }).background(Color.theme.philippineGray3)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(.white, lineWidth: 0)
                                )
                                .padding(.vertical, 8)
                                .disabled(isLoading)
                        } else {
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
                        }
                        
                    }.frame(height: 52)
                        .padding(.bottom)
                    
                    //scrollable outer list section
                    ScrollView {
                        MetarTafDepSubSectionView()
                        
                        MetarTafEnrSubSectionView()
                        
                        MetarTafArrSubSectionView()
                        
                        MetarTafDestSubSectionView()
                    }
                }.padding(.bottom)
                    .padding(.horizontal, 16)
                    .background(Color.theme.antiFlashWhite)
                    .overlay(Group {
                        if isLoading {
                            VStack {
                                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.black))
                            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color.black.opacity(0.3))
                        }
                    })
                    .onAppear {
                        prepareData()
                    }
                    .onChange(of: number) {_ in
                        prepareData()
                    }
            }
        }
    }
    
    func prepareData() {
        if let eventMetarTafList = coreDataModel.selectedEvent?.metarTafList?.allObjects as? [MetarTafDataList] {
            metarTafList = eventMetarTafList
            
            for item in eventMetarTafList {
                if item.unwrappedType == "depMetarTaf" {
                    coreDataModel.dataDepartureMetarTaf = item
                } else if item.unwrappedType == "enrMetarTaf" {
                    coreDataModel.dataEnrouteMetarTaf = item
                } else if item.unwrappedType == "arrMetarTaf" {
                    coreDataModel.dataArrivalMetarTaf = item
                } else {
                    coreDataModel.dataDestinationMetarTaf = item
                }
            }
        }
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
                newObj.metarTaf = dateFormatter.string(from: Date())
            } else {
                let newObj = SectionDateUpdateList(context: persistenceController.container.viewContext)
                newObj.metarTaf = dateFormatter.string(from: Date())
            }
            coreDataModel.save()
            coreDataModel.dataSectionDateUpdate = coreDataModel.readSectionDateUpdate()
        }
    }
    
    func handleNotam(_ payload: [String: Any]) {
        Task {
            print("handle metar")
            isLoading = true
            let responseNotam = await remoteService.getNotamData(payload)
            
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
            
            number += 1
            print("end MetarTaf")
            isLoading = false
        }
    }
}

