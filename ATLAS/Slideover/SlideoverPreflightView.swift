//
//  SlideoverPreflightView.swift
//  ATLAS
//
//  Created by phuong phan on 26/09/2023.
//

import SwiftUI

struct SlideoverPreflightView: View {
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
    @State private var isEdit = false
    
    @State private var isCollapseFlightInfo = true
    @State private var isCollapsePlanTime = true
    @State private var isCollapseRoute = true
    @State private var isCollapseCrew = true
    @State private var selectedAircraftPicker = ""
    @State private var tfFlightTime = ""

    @State var enrouteAlternates: [IAlternate] = []
    @State var destinationAlternates: [IAlternate] = []
    @State private var dataFlightOverview: FlightOverviewList?
    
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
        
        GeometryReader { proxy in
            VStack(alignment: .leading, spacing: 0) {
                HeaderViewSplit(isMenu: true)
                
                VStack(spacing: 0) {
                    HStack(alignment: .center) {
                        Text("Summary").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.black)
                        
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
                                        Text(dataFlightOverview?.unwrappedCallsign ?? "")
                                            .foregroundStyle(Color.black)
                                            .font(.system(size: 15, weight: .regular))
                                            .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                        Text(dataFlightOverview?.unwrappedModel ?? "")
                                            .foregroundStyle(Color.black)
                                            .font(.system(size: 15, weight: .regular))
                                            .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                        Text(dataFlightOverview?.unwrappedAircraft ?? "")
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
                                        Text(dataFlightOverview?.unwrappedDep ?? "")
                                            .foregroundStyle(Color.black)
                                            .font(.system(size: 15, weight: .regular))
                                            .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                        Text(dataFlightOverview?.unwrappedDest ?? "")
                                            .foregroundStyle(Color.black)
                                            .font(.system(size: 15, weight: .regular))
                                            .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                        Text(dataFlightOverview?.unwrappedPob ?? "")
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
                                        Text(std).font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black)
                                            .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                        Text(sta).font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black)
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
                                        Text(renderTime(std, sta)).font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black)
                                            .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                        
                                        Text(dataFlightOverview?.unwrappedFlightTime ?? "").font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black)
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
                                        Text(renderBlockFlightTime(dataFlightOverview?.unwrappedFlightTime ?? "00:00", renderTime(std, sta)))
                                            .font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black)
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
                                        
                                    }.frame(alignment: .leading)
                                }).buttonStyle(PlainButtonStyle())
                                
                                Spacer()
                            }.frame(height: 52)
                            
                            if isCollapseRoute {
                                VStack(spacing: 8) {
                                    VStack(spacing: 0) {
                                        HStack {
                                            Text("Route").frame(width: calculateWidthSummary(proxy.size.width - 32, 1), alignment: .leading)
                                                .foregroundStyle(Color.black)
                                                .font(.system(size: 15, weight: .semibold))
                                        }.frame(height: 44)
                                        
                                        Divider().padding(.horizontal, -16)
                                        
                                        HStack {
                                            Text(dataFlightOverview?.unwrappedRoute ?? "").foregroundStyle(Color.black)
                                                .font(.system(size: 15, weight: .regular))
                                        }.frame(width: calculateWidthSummary(proxy.size.width - 32, 1))
                                            .padding(.top, 8)
                                    }
                                    
                                    // Enroute Alternates
                                    VStack(spacing: 0) {
                                        HStack(spacing: 0) {
                                            Text("Enroute Alternate").foregroundColor(Color.black).font(.system(size: 15, weight: .medium))
                                                .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                            
                                            Text("ETA")
                                                .foregroundColor(Color.black).font(.system(size: 15, weight: .medium))
                                                .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                        }.frame(height: 44)
                                        
                                        HStack(spacing: 0) {
                                            Text("VIS")
                                                .foregroundColor(Color.black).font(.system(size: 15, weight: .medium))
                                                .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                            Text("Minima")
                                                .foregroundColor(Color.black).font(.system(size: 15, weight: .medium))
                                                .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                        }.frame(height: 44)
                                        
                                        Divider().padding(.horizontal, -16)
                                        
                                        if enrouteAlternates.count > 0 {
                                            ForEach(enrouteAlternates, id: \.self) {item in
                                                SlideoverRowTextAlternates(width: proxy.size.width, item: item, itemList: $enrouteAlternates)
                                                    .id("enroute\(index)")
                                            }
                                        }
                                    }
                                    
                                    // Destination Alternates
                                    VStack(spacing: 0) {
                                        HStack(spacing: 0) {
                                            Text("Destination Alternate").foregroundColor(Color.black).font(.system(size: 15, weight: .medium))
                                                .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                            
                                            Text("ETA")
                                                .foregroundColor(Color.black).font(.system(size: 15, weight: .medium))
                                                .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                        }.frame(height: 44)
                                        
                                        HStack(spacing: 0) {
                                            Text("VIS")
                                                .foregroundColor(Color.black).font(.system(size: 15, weight: .medium))
                                                .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                            Text("Minima")
                                                .foregroundColor(Color.black).font(.system(size: 15, weight: .medium))
                                                .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                        }.frame(height: 44)
                                        
                                        Divider().padding(.horizontal, -16)
                                        
                                        if destinationAlternates.count > 0 {
                                            ForEach(destinationAlternates, id: \.self) {item in
                                                SlideoverRowTextAlternates(width: proxy.size.width, item: item, itemList: $destinationAlternates)
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
                    }// end List
                }.padding(.horizontal, 16)
            }.padding(.bottom, 32)
                .background(Color.theme.antiFlashWhite)
                .onAppear {
                    if let overviewList = coreDataModel.selectedEvent?.flightOverviewList?.allObjects as? [FlightOverviewList] {
                        dataFlightOverview = overviewList.first
                        
                        prepareData()
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
    
    func renderTime(_ startDate: String, _ endDate: String) -> String {
        if startDate != "" && endDate != "" {
            if startDate != "" && endDate != "" {
                return calculateDateTime(startDate, endDate)
            }
        }
        return ""
    }
    
    func renderBlockFlightTime(_ startDate: String, _ endDate: String) -> String {
        if startDate != "" && endDate != "" {
            return calculateTime(startDate, endDate)
        }
        return ""
    }
    
    func calculateEta() -> String {
        return calculateTime(dataFlightOverview?.unwrappedFlightTime ?? "00:00", dataFlightOverview?.unwrappedChockOff ?? "00:00")
    }
    
    func calculateTotalTime() -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        var hour = "00"
        var minute = "00"
        
        if let unwrappedChockOff = dataFlightOverview?.unwrappedChockOff, let unwrappedChockOn = dataFlightOverview?.unwrappedChockOn {
            if let chockOff = dateFormatter.date(from: unwrappedChockOff), let chockOn = dateFormatter.date(from: unwrappedChockOn) {
                let diffComponents = Calendar.current.dateComponents([.hour, .minute], from: chockOff, to: chockOn)
                
                if let dhour = diffComponents.hour, dhour > 0 {
                    hour = "\(dhour)"
                }
                
                if let dminute = diffComponents.minute, dminute > 0 {
                    minute = "\(dminute)"
                }
            }
        }
        return "\(hour):\(minute)"
    }
}
