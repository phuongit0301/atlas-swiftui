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
    @State var showLoading = false
    
    @State private var isDepShow = true
    @State private var isEnrShow = true
    @State private var isArrShow = true
    @State private var isDestShow = true
    
    @State private var metarTafList = [MetarTafDataList]()
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .center) {
                    Text("METAR & TAF")
                        .font(.system(size: 17, weight: .semibold))
                    
                    Spacer()
                    
                    Button(action: {
                        onSyncData()
                    }, label: {
                        HStack {
                            if showLoading {
                                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.white)).padding(.leading)
                            }
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
                        .disabled(showLoading)
                }.frame(height: 52)
                    .padding(.bottom)
                
//                HStack {
//                    Text("Waypoints")
//                        .font(.system(size: 17, weight: .semibold))
//
//                    Spacer()
//
//                    Button(action: {
//                        // Todo
//                    }, label: {
//                        Text("Direct").font(.system(size: 17, weight: .regular))
//                            .foregroundColor(Color.theme.azure)
//                    })
//                }.frame(height: 44)
//                    .padding(.horizontal, 16)
                
                //scrollable outer list section
                ScrollView {
                    VStack(spacing: 8) {
                        HStack(alignment: .center, spacing: 8) {
                            Text("Departure METAR & TAF").foregroundStyle(Color.black).font(.system(size: 15, weight: .semibold))
                            
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
                            
                            Spacer()
                        }.frame(height: 52)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                self.isDepShow.toggle()
                            }
                        
                        if isDepShow {
                            if coreDataModel.dataDepartureMetarTaf == nil {
                                HStack(alignment: .center) {
                                    Text("No Departure METAR & TAF saved").foregroundColor(Color.theme.philippineGray2).font(.system(size: 17, weight: .regular))
                                    Spacer()
                                }.frame(height: 44)
                            } else {
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("\(coreDataModel.dataDepartureMetarTaf?.unwrappedAirport ?? "") \(coreDataModel.dataDepartureMetarTaf?.unwrappedStd ?? "")")
                                        .font(.system(size: 15, weight: .semibold)).foregroundColor(Color.black)
                                        .frame(height: 44)
                                    
                                    Text("METAR")
                                        .font(.system(size: 15, weight: .medium)).foregroundColor(Color.black)
                                        .frame(height: 44)
                                    
                                    Divider().padding(.horizontal, -16)
                                    
                                    Text(coreDataModel.dataDepartureMetarTaf?.unwrappedMetar ?? "")
                                        .font(.system(size: 15, weight: .regular)).foregroundColor(Color.black)
                                        .padding(.vertical, 8)
                                    
                                    Text("TAF")
                                        .font(.system(size: 15, weight: .medium)).foregroundColor(Color.black)
                                        .frame(height: 44)
                                    
                                    Divider().padding(.horizontal, -16)
                                    
                                    Text(coreDataModel.dataDepartureMetarTaf?.unwrappedTaf ?? "")
                                        .font(.system(size: 15, weight: .regular)).foregroundColor(Color.black)
                                        .padding(.vertical, 8)
                                }.padding(.bottom)
                            }
                            
                        }
                    }.padding(.horizontal)
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 0))
                    
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(alignment: .center, spacing: 8) {
                            Text("Enroute Alternates METAR & TAF").foregroundStyle(Color.black).font(.system(size: 15, weight: .semibold))
                            
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
                            
                            Spacer()
                        }.frame(height: 52)
                        .contentShape(Rectangle())
                            .onTapGesture {
                                self.isEnrShow.toggle()
                            }
                        
                        if isEnrShow {
                            if coreDataModel.dataEnrouteMetarTaf == nil {
                                HStack(alignment: .center) {
                                    Text("No Enroute Alternates METAR & TAF saved").foregroundColor(Color.theme.philippineGray2).font(.system(size: 17, weight: .regular))
                                    Spacer()
                                }.frame(height: 44)
                            } else {
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("\(coreDataModel.dataEnrouteMetarTaf?.unwrappedAirport ?? "") \(coreDataModel.dataEnrouteMetarTaf?.unwrappedStd ?? "")")
                                        .font(.system(size: 15, weight: .semibold)).foregroundColor(Color.black)
                                        .frame(height: 44)
                                    
                                    
                                    Text("METAR")
                                        .font(.system(size: 15, weight: .medium)).foregroundColor(Color.black)
                                        .frame(height: 44)
                                    
                                    Divider().padding(.horizontal, -16)
                                    
                                    Text(coreDataModel.dataEnrouteMetarTaf?.unwrappedMetar ?? "")
                                        .font(.system(size: 15, weight: .regular)).foregroundColor(Color.black)
                                        .padding(.vertical, 8)
                                    
                                    Text("TAF")
                                        .font(.system(size: 15, weight: .medium)).foregroundColor(Color.black)
                                        .frame(height: 44)
                                    
                                    Divider().padding(.horizontal, -16)
                                    
                                    Text(coreDataModel.dataEnrouteMetarTaf?.unwrappedTaf ?? "")
                                        .font(.system(size: 15, weight: .regular)).foregroundColor(Color.black)
                                        .padding(.vertical, 8)
                                    
                                }.padding(.bottom)
                            }
                        }
                    }.padding(.horizontal)
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 0))
                    
                    
                    VStack(spacing: 8) {
                        HStack(alignment: .center, spacing: 8) {
                            Text("Arrival METAR & TAF").foregroundStyle(Color.black).font(.system(size: 15, weight: .semibold))
                            
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
                            
                            Spacer()
                        }.frame(height: 52)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                self.isArrShow.toggle()
                            }
                        
                        if isArrShow {
                            if coreDataModel.dataArrivalMetarTaf == nil {
                                HStack(alignment: .center) {
                                    Text("No Arrival METAR & TAF saved").foregroundColor(Color.theme.philippineGray2).font(.system(size: 17, weight: .regular))
                                    Spacer()
                                }.frame(height: 44)
                            } else {
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("\(coreDataModel.dataArrivalMetarTaf?.unwrappedAirport ?? "") \(coreDataModel.dataArrivalMetarTaf?.unwrappedStd ?? "")")
                                        .font(.system(size: 15, weight: .semibold)).foregroundColor(Color.black)
                                        .frame(height: 44)
                                    
                                    Text("METAR")
                                        .font(.system(size: 15, weight: .medium)).foregroundColor(Color.black)
                                        .frame(height: 44)
                                    
                                    Divider().padding(.horizontal, -16)
                                    
                                    Text(coreDataModel.dataArrivalMetarTaf?.unwrappedMetar ?? "")
                                        .font(.system(size: 15, weight: .regular)).foregroundColor(Color.black)
                                        .padding(.vertical, 8)
                                    
                                    Text("TAF")
                                        .font(.system(size: 15, weight: .medium)).foregroundColor(Color.black)
                                        .frame(height: 44)
                                    
                                    Divider().padding(.horizontal, -16)
                                    
                                    Text(coreDataModel.dataArrivalMetarTaf?.unwrappedTaf ?? "")
                                        .font(.system(size: 15, weight: .regular)).foregroundColor(Color.black)
                                        .padding(.vertical, 8)
                                }.padding(.bottom)
                            }
                        }
                    }.padding(.horizontal)
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 0))
                    
                    
                    VStack(spacing: 8) {
                        HStack(alignment: .center, spacing: 8) {
                            Text("Destination Alternates METAR & TAF").foregroundStyle(Color.black).font(.system(size: 15, weight: .semibold))
                            
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
                            
                            Spacer()
                        }.frame(height: 52)
                        .contentShape(Rectangle())
                            .onTapGesture {
                                self.isDestShow.toggle()
                            }
                        
                        if isDestShow {
                            if coreDataModel.dataDestinationMetarTaf == nil {
                                HStack(alignment: .center) {
                                    Text("No Destination Alternates METAR & TAF saved").foregroundColor(Color.theme.philippineGray2).font(.system(size: 17, weight: .regular))
                                    Spacer()
                                }.frame(height: 44)
                            } else {
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("\(coreDataModel.dataDestinationMetarTaf?.unwrappedAirport ?? "") \(coreDataModel.dataDestinationMetarTaf?.unwrappedStd ?? "")")
                                        .font(.system(size: 15, weight: .semibold)).foregroundColor(Color.black)
                                        .frame(height: 44)
                                    
                                    Text("METAR").font(.system(size: 15, weight: .medium)).foregroundColor(Color.black)
                                        .frame(height: 44)
                                    
                                    Divider().padding(.horizontal, -16)
                                    
                                    Text(coreDataModel.dataDestinationMetarTaf?.unwrappedMetar ?? "")
                                        .font(.system(size: 15, weight: .regular)).foregroundColor(Color.black)
                                        .padding(.vertical, 8)
                                    
                                    Text("TAF")
                                        .font(.system(size: 15, weight: .medium)).foregroundColor(Color.black)
                                        .frame(height: 44)
                                    
                                    Divider().padding(.horizontal, -16)
                                    
                                    Text(coreDataModel.dataDestinationMetarTaf?.unwrappedTaf ?? "")
                                        .font(.system(size: 15, weight: .regular)).foregroundColor(Color.black)
                                        .padding(.vertical, 8)
                                }.padding(.bottom)
                            }
                        }
                    }.padding(.horizontal)
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 0))
                }
            }.padding(.bottom)
                .padding(.horizontal, 16)
                .background(Color.theme.antiFlashWhite)
                .onAppear {
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
        }
    }
    
    func onSyncData() {
        Task {
            showLoading = true
            await coreDataModel.syncDataMetarTaf()
            showLoading = false
        }
    }
}

