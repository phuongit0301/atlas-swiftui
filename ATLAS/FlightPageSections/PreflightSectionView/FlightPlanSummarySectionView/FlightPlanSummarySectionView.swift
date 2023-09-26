//
//  FlightOverviewView.swift
//  ATLAS
//
//  Created by phuong phan on 22/08/2023.
//

import SwiftUI
import Combine

struct FlightPlanSummarySectionView: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController
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
    
    @State private var isCollapseFlightInfo = true
    @State private var isCollapsePlanTime = true
    @State private var isCollapseRoute = true
    @State private var isCollapseCrew = true
    @State private var selectedAircraftPicker = ""
    @State private var tfFlightTime = ""
    @State private var enrouteAlternates = 1
    @State private var destinationAlternates = 1
    
    var ALTN_DROP_DOWN: [String] = ["ALTN 1", "ALTN 1", "ALTN 1"]
    
    var body: some View {
        
        GeometryReader { proxy in
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .center) {
                    Text("Summary").font(.system(size: 17, weight: .semibold))
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
                                    Text("Aircraft Model")
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
                                    Text("XXXXXXXX")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .regular))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    Text("XXXXXXXX")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .regular))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    Text("XXXXXXXX")
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
                                    Text("XXXXXXXX")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .regular))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    Text("XXXXXXXX")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .regular))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    Text("XXXXXXXX")
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
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    Text("STA")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    Text("")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                }.frame(height: 44)

                                Divider().padding(.horizontal, -16)

                                HStack(spacing: 0) {
                                    Text(showUTC ? coreDataModel.dataSummaryInfo.unwrappedStdUTC : coreDataModel.dataSummaryInfo.unwrappedStdLocal).font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    Text(showUTC ? coreDataModel.dataSummaryInfo.unwrappedStaUTC : coreDataModel.dataSummaryInfo.unwrappedStaLocal).font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    Text("").frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                }.frame(height: 44)

                                HStack(spacing: 0) {
                                    Text("Block Time")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    Text("Flight Time")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    Text("Block Time - Flight Time")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                }.frame(height: 44)

                                Divider().padding(.horizontal, -16)

                                HStack(spacing: 0) {
                                    Text(coreDataModel.dataSummaryInfo.unwrappedBlkTime).font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)

                                    Text("XXXXX").font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)

                                    Text(calculateTime(coreDataModel.dataSummaryInfo.unwrappedFltTime, coreDataModel.dataSummaryInfo.unwrappedBlkTime))
                                        .font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
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
                                            .frame(width: proxy.size.width - 64, alignment: .leading)
                                            .onSubmit {
                                                //Todo
                                            }
                                    }.frame(height: 44)
                                }

                                // Enroute Alternates
                                VStack(spacing: 0) {
                                    HStack(alignment: .center, spacing: 0) {
                                        HStack {
                                            Text("Enroute Alternates").foregroundColor(Color.black).font(.system(size: 15, weight: .medium))
                                            Spacer()
                                            Button(action: {
                                                enrouteAlternates += 1
                                            }, label: {
                                                Text("Add").foregroundColor(Color.theme.azure).font(.system(size: 15, weight: .medium))
                                            }).padding(.trailing)

                                        }.frame(width: calculateWidthSummary(proxy.size.width - 32, 4), alignment: .leading)

                                        Text("VIS (Optional)")
                                            .foregroundColor(Color.black).font(.system(size: 15, weight: .medium))
                                            .frame(width: calculateWidthSummary(proxy.size.width - 32, 4), alignment: .leading)
                                        Text("Minima (Optional)")
                                            .foregroundColor(Color.black).font(.system(size: 15, weight: .medium))
                                            .frame(width: calculateWidthSummary(proxy.size.width - 32, 4), alignment: .leading)
                                        Text("ETA")
                                            .foregroundColor(Color.black).font(.system(size: 15, weight: .medium))
                                            .frame(width: calculateWidthSummary(proxy.size.width - 32, 4), alignment: .leading)
                                    }.frame(height: 44)

                                    Divider().padding(.horizontal, -16)

                                    ForEach(0..<enrouteAlternates, id: \.self) {index in
                                        RowAlternates(width: proxy.size.width)
                                            .id("enroute\(index)")
                                    }
                                }

                                // Destination Alternates
                                VStack(spacing: 0) {
                                    HStack(spacing: 0) {
                                        HStack {
                                            Text("Destination Alternates").foregroundColor(Color.black).font(.system(size: 15, weight: .medium))
                                            Spacer()
                                            Button(action: {
                                                destinationAlternates += 1
                                            }, label: {
                                                Text("Add").foregroundColor(Color.theme.azure).font(.system(size: 15, weight: .medium))
                                            }).padding(.trailing)

                                        }.frame(width: calculateWidthSummary(proxy.size.width - 32, 4), alignment: .leading)

                                        Text("VIS")
                                            .foregroundColor(Color.black).font(.system(size: 15, weight: .medium))
                                            .frame(width: calculateWidthSummary(proxy.size.width - 32, 4), alignment: .leading)
                                        Text("Minima")
                                            .foregroundColor(Color.black).font(.system(size: 15, weight: .medium))
                                            .frame(width: calculateWidthSummary(proxy.size.width - 32, 4), alignment: .leading)
                                        Text("ETA")
                                            .foregroundColor(Color.black).font(.system(size: 15, weight: .medium))
                                            .frame(width: calculateWidthSummary(proxy.size.width - 32, 4), alignment: .leading)
                                    }.frame(height: 44)

                                    Divider().padding(.horizontal, -16)

                                    ForEach(0..<destinationAlternates, id: \.self) {index in
                                        RowAlternates(width: proxy.size.width)
                                            .id("destination\(index)")
                                    }
                                }
                            }// End VStack
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
        }//end geometry
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
