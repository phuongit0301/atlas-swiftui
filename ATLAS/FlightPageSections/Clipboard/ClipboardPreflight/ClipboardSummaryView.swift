//
//  SummarySubSectionView.swift
//  ATLAS
//
//  Created by phuong phan on 22/08/2023.
//

import SwiftUI
import Combine
import UIKit

struct ClipboardSummaryView: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController
    
    @Binding var showUTC: Bool
    let width: CGFloat
    
    @State private var isCollapseFlightInfo = true
    @State private var isCollapsePlanTime = true
    @State private var isCollapseRoute = true
    @State private var isCollapseCrew = true
    
    @State var enrouteAlternates: [IAlternate] = []
    @State var destinationAlternates: [IAlternate] = []
    
    var body: some View {
        VStack(spacing: 8) {
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
                                .frame(width: calculateWidthSummary(width - 32, 3), alignment: .leading)
                            Text("Model")
                                .foregroundStyle(Color.black)
                                .font(.system(size: 15, weight: .semibold))
                                .frame(width: calculateWidthSummary(width - 32, 3), alignment: .leading)
                            Text("Aircraft")
                                .foregroundStyle(Color.black)
                                .font(.system(size: 15, weight: .semibold))
                                .frame(width: calculateWidthSummary(width - 32, 3), alignment: .leading)
                        }.frame(height: 44)
                        
                        Divider().padding(.horizontal, -16)
                        
                        HStack(spacing: 0) {
                            Text(coreDataModel.dataSummaryInfo.unwrappedFltNo)
                                .foregroundStyle(Color.black)
                                .font(.system(size: 15, weight: .regular))
                                .frame(width: calculateWidthSummary(width - 32, 3), alignment: .leading)
                            Text(coreDataModel.dataSummaryInfo.unwrappedModel)
                                .foregroundStyle(Color.black)
                                .font(.system(size: 15, weight: .regular))
                                .frame(width: calculateWidthSummary(width - 32, 3), alignment: .leading)
                            Text(coreDataModel.dataSummaryInfo.unwrappedAircraft)
                                .foregroundStyle(Color.black)
                                .font(.system(size: 15, weight: .regular))
                                .frame(width: calculateWidthSummary(width - 32, 3), alignment: .leading)
                        }.frame(height: 44)
                        
                        HStack(spacing: 0) {
                            Text("Dep")
                                .foregroundStyle(Color.black)
                                .font(.system(size: 15, weight: .semibold))
                                .frame(width: calculateWidthSummary(width - 32, 3), alignment: .leading)
                            Text("Dest")
                                .foregroundStyle(Color.black)
                                .font(.system(size: 15, weight: .semibold))
                                .frame(width: calculateWidthSummary(width - 32, 3), alignment: .leading)
                            Text("POB").foregroundStyle(Color.black)
                                .font(.system(size: 15, weight: .semibold))
                                .frame(width: calculateWidthSummary(width - 32, 3), alignment: .leading)
                        }.frame(height: 44)
                        
                        Divider().padding(.horizontal, -16)
                        
                        HStack(spacing: 0) {
                            Text(coreDataModel.dataSummaryInfo.unwrappedDep)
                                .foregroundStyle(Color.black)
                                .font(.system(size: 15, weight: .regular))
                                .frame(width: calculateWidthSummary(width - 32, 3), alignment: .leading)
                            Text(coreDataModel.dataSummaryInfo.unwrappedDest)
                                .foregroundStyle(Color.black)
                                .font(.system(size: 15, weight: .regular))
                                .frame(width: calculateWidthSummary(width - 32, 3), alignment: .leading)
                            Text(coreDataModel.dataSummaryInfo.unwrappedPob)
                                .foregroundStyle(Color.black)
                                .font(.system(size: 15, weight: .regular))
                                .frame(width: calculateWidthSummary(width - 32, 3), alignment: .leading)
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
                                .frame(width: calculateWidthSummary(width - 32, 3), alignment: .leading)
                            Text("STA")
                                .foregroundStyle(Color.black)
                                .font(.system(size: 15, weight: .semibold))
                                .frame(width: calculateWidthSummary(width - 32, 3), alignment: .leading)
                            Text("")
                                .foregroundStyle(Color.black)
                                .font(.system(size: 15, weight: .semibold))
                                .frame(width: calculateWidthSummary(width - 32, 3), alignment: .leading)
                        }.frame(height: 44)
                        
                        Divider().padding(.horizontal, -16)
                        
                        HStack(spacing: 0) {
                            Text(showUTC ? coreDataModel.dataSummaryInfo.unwrappedStdUTC : coreDataModel.dataSummaryInfo.unwrappedStdLocal).font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                .frame(width: calculateWidthSummary(width - 32, 3), alignment: .leading)
                            Text(showUTC ? coreDataModel.dataSummaryInfo.unwrappedStaUTC : coreDataModel.dataSummaryInfo.unwrappedStaLocal).font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                .frame(width: calculateWidthSummary(width - 32, 3), alignment: .leading)
                            Text("").frame(width: calculateWidthSummary(width - 32, 3), alignment: .leading)
                        }.frame(height: 44)
                        
                        HStack(spacing: 0) {
                            Text("Block Time")
                                .foregroundStyle(Color.black)
                                .font(.system(size: 15, weight: .semibold))
                                .frame(width: calculateWidthSummary(width - 32, 3), alignment: .leading)
                            Text("Flight Time")
                                .foregroundStyle(Color.black)
                                .font(.system(size: 15, weight: .semibold))
                                .frame(width: calculateWidthSummary(width - 32, 3), alignment: .leading)
                            Text("Block Time - Flight Time")
                                .foregroundStyle(Color.black)
                                .font(.system(size: 15, weight: .semibold))
                                .frame(width: calculateWidthSummary(width - 32, 3), alignment: .leading)
                        }.frame(height: 44)
                        
                        Divider().padding(.horizontal, -16)
                        
                        HStack(spacing: 0) {
                            Text(coreDataModel.dataSummaryInfo.unwrappedBlkTime).font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                .frame(width: calculateWidthSummary(width - 32, 3), alignment: .leading)
                            
                            Text("XXXXX").font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                .frame(width: calculateWidthSummary(width - 32, 3), alignment: .leading)
                            
                            Text(calculateTime(coreDataModel.dataSummaryInfo.unwrappedFltTime, coreDataModel.dataSummaryInfo.unwrappedBlkTime))
                                .font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                .frame(width: calculateWidthSummary(width - 32, 3), alignment: .leading)
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
                            
                        }.frame(alignment: .leading)
                    }).buttonStyle(PlainButtonStyle())
                    
                    Spacer()
                }.frame(height: 52)
                
                if isCollapseRoute {
                    VStack(spacing: 8) {
                        VStack(spacing: 0) {
                            HStack {
                                Text("Route")
                                    .frame(width: width - 64, alignment: .leading)
                                    .foregroundStyle(Color.black)
                                    .font(.system(size: 15, weight: .semibold))
                            }.frame(height: 44)
                            
                            Divider().padding(.horizontal, -16)
                            
                            HStack {
                                Text("XXXX")
                                    .frame(width: width - 64, alignment: .leading)
                                    .foregroundStyle(Color.black)
                                    .font(.system(size: 15, weight: .regular))
                            }.frame(height: 44)
                        }
                        
                        // Enroute Alternates
                        VStack(spacing: 0) {
                            HStack(alignment: .center, spacing: 0) {
                                HStack {
                                    Text("Enroute Alternate").foregroundColor(Color.black).font(.system(size: 15, weight: .medium))
                                    Spacer()
                                }.frame(width: calculateWidthSummary(width - 32, 4), alignment: .leading)
                                
                                Text("ETA")
                                    .foregroundColor(Color.black).font(.system(size: 15, weight: .medium))
                                    .frame(width: calculateWidthSummary(width - 32, 4), alignment: .leading)
                                Text("VIS")
                                    .foregroundColor(Color.black).font(.system(size: 15, weight: .medium))
                                    .frame(width: calculateWidthSummary(width - 32, 4), alignment: .leading)
                                Text("Minima")
                                    .foregroundColor(Color.black).font(.system(size: 15, weight: .medium))
                                    .frame(width: calculateWidthSummary(width - 32, 4), alignment: .leading)
                            }.frame(height: 44)
                            
                            Divider().padding(.horizontal, -16)
                            
                            if enrouteAlternates.count > 0 {
                                ForEach(enrouteAlternates, id: \.self) {item in
                                    RowTextAlternates(width: width, item: item, itemList: $enrouteAlternates)
                                        .id("enroute\(index)")
                                }
                            }
                        }
                        
                        // Destination Alternates
                        VStack(spacing: 0) {
                            HStack(spacing: 0) {
                                HStack {
                                    Text("Destination Alternate").foregroundColor(Color.black).font(.system(size: 15, weight: .medium))
                                    Spacer()
                                }.frame(width: calculateWidthSummary(width - 32, 4), alignment: .leading)
                                
                                Text("ETA")
                                    .foregroundColor(Color.black).font(.system(size: 15, weight: .medium))
                                    .frame(width: calculateWidthSummary(width - 32, 4), alignment: .leading)
                                
                                Text("VIS")
                                    .foregroundColor(Color.black).font(.system(size: 15, weight: .medium))
                                    .frame(width: calculateWidthSummary(width - 32, 4), alignment: .leading)
                                Text("Minima")
                                    .foregroundColor(Color.black).font(.system(size: 15, weight: .medium))
                                    .frame(width: calculateWidthSummary(width - 32, 4), alignment: .leading)
                            }.frame(height: 44)
                            
                            Divider().padding(.horizontal, -16)
                            
                            if destinationAlternates.count > 0 {
                                ForEach(destinationAlternates, id: \.self) {item in
                                    RowTextAlternates(width: width, item: item, itemList: $destinationAlternates)
                                }
                            }
                            
                        }
                    }// End VStack
                    .padding(.bottom)
                }// End if
            }.padding(.horizontal)
                .background(Color.white)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 0))
        }// end VStack
    }
}
