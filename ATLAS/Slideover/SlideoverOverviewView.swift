//
//  SlideoverOverviewView.swift
//  ATLAS
//
//  Created by phuong phan on 22/08/2023.
//

import SwiftUI
import Combine

struct SlideoverOverviewView: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    
    @State private var showUTC = true
    
    @State private var isCollapseFlightInfo = true
    @State private var isCollapsePlanTime = true
    @State private var isCollapseActualTime = true
    @State private var isCollapseCrew = true
    
    @State private var dataFlightOverview: FlightOverviewList?
    @State private var dataEventSector: EventSectorList?
    
    var body: some View {
        var stdLocal: String {
            return convertUTCToLocalTime(timeString: dataFlightOverview?.unwrappedStd ?? "", timeDiff: dataEventSector?.unwrappedDepTimeDiff ?? "")
        }
        
        var staLocal: String {
            return convertUTCToLocalTime(timeString: dataFlightOverview?.unwrappedSta ?? "", timeDiff: dataEventSector?.unwrappedDepTimeDiff ?? "")
        }
        
        var std: String {
            if showUTC {
                return dataFlightOverview?.unwrappedStd ?? ""
            } else {
                return stdLocal
            }
        }
        
        var sta: String {
            if showUTC {
                return dataFlightOverview?.unwrappedSta ?? ""
            } else {
                return staLocal
            }
        }
        
        var eta: String {
            if showUTC {
                return calculateEta()
            } else {
                return convertUTCToLocalTime(timeString: calculateEta(), timeDiff: dataEventSector?.unwrappedArrTimeDiff ?? "")
            }
        }
        
        GeometryReader { proxy in
            VStack(alignment: .leading, spacing: 0) {
                HeaderViewSplit(isMenu: true)
                
                VStack(spacing: 0) {
                    HStack(alignment: .center) {
                        HStack {
                            Text("Flight Overview").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.black)
                        }
                        Spacer()
                        
                        HStack {
                            Toggle(isOn: $showUTC) {
                                Text("Local").font(.system(size: 15, weight: .regular))
                                    .foregroundStyle(Color.black)
                            }
                            Text("UTC").font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(Color.black)
                            
                        }.fixedSize(horizontal: true, vertical: false)
                        
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
                                                .scaledToFit()
                                                .foregroundColor(Color.blue)
                                                .aspectRatio(contentMode: .fit)
                                            
                                        } else {
                                            Image(systemName: "chevron.up")
                                                .scaledToFit()
                                                .foregroundColor(Color.blue)
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
                                        
                                        HStack {
                                            Text(dataFlightOverview?.unwrappedModel ?? "")
                                                .foregroundStyle(Color.black)
                                                .font(.system(size: 15, weight: .regular))
                                        }.frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                        
                                        HStack {
                                            Text(dataFlightOverview?.unwrappedAircraft ?? "")
                                                .foregroundStyle(Color.black)
                                                .font(.system(size: 15, weight: .regular))
                                        }.frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                        
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
                                        Text("POB")
                                            .foregroundStyle(Color.black)
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
                                        Text(std)
                                            .font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black)
                                            .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                        Text(sta)
                                            .font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black)
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
                                        Text(renderTime(std, sta))
                                            .font(.system(size: 15, weight: .regular))
                                            .foregroundStyle(Color.black)
                                            .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)

                                        Text(dataFlightOverview?.unwrappedFlightTime ?? "")
                                            .font(.system(size: 15, weight: .regular))
                                            .foregroundStyle(Color.black)
                                            .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                    }.frame(height: 44)

                                    HStack(spacing: 0) {
                                        Text("Block Time - Flight Time")
                                            .foregroundStyle(Color.black)
                                            .font(.system(size: 15, weight: .semibold))
                                            .frame(width: calculateWidthSummary(proxy.size.width - 32, 1), alignment: .leading)
                                        
                                        Spacer()
                                    }.frame(height: 44)

                                    Divider().padding(.horizontal, -16)

                                    HStack {
                                            Text(renderBlockFlightTime(dataFlightOverview?.unwrappedFlightTime ?? "00:00", renderTime(std, sta)))
                                            .font(.system(size: 15, weight: .regular))
                                            .foregroundStyle(Color.black)
                                            .frame(width: calculateWidthSummary(proxy.size.width - 32, 1), alignment: .leading)
                                        
                                        Spacer()
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
                                    self.isCollapseActualTime.toggle()
                                }, label: {
                                    HStack(alignment: .center, spacing: 8) {
                                        Text("Actual Times").font(.system(size: 17, weight: .semibold)).foregroundStyle(Color.black)
                                        if isCollapseActualTime {
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

                            if isCollapseActualTime {
                                VStack(spacing: 0) {
                                    HStack(spacing: 0) {
                                        Text("Chocks Off")
                                            .foregroundStyle(Color.black)
                                            .font(.system(size: 15, weight: .semibold))
                                            .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                        Text("Chocks On")
                                            .foregroundStyle(Color.black)
                                            .font(.system(size: 15, weight: .semibold))
                                            .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                    }.frame(height: 44)

                                    Divider().padding(.horizontal, -16)

                                    HStack(spacing: 0) {
                                        Text(dataFlightOverview?.unwrappedChockOff ?? "")
                                            .font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black)
                                            .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)

                                        Text(dataFlightOverview?.unwrappedChockOn ?? "")
                                            .font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black)
                                            .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                    }.frame(height: 44)


                                    HStack(spacing: 0) {
                                        Text("Day")
                                            .foregroundStyle(Color.black)
                                            .font(.system(size: 15, weight: .semibold))
                                            .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                        Text("Night")
                                            .foregroundStyle(Color.black)
                                            .font(.system(size: 15, weight: .semibold))
                                            .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                    }.frame(height: 44)

                                    Divider().padding(.horizontal, -16)

                                    HStack(spacing: 0) {
                                        Text(dataFlightOverview?.unwrappedDay ?? "")
                                            .font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                            .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                        Text(dataFlightOverview?.unwrappedNight ?? "")
                                            .font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                            .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)

                                    }.frame(height: 44)

                                    HStack(spacing: 0) {
                                        Text("ETA")
                                            .foregroundStyle(Color.black)
                                            .font(.system(size: 15, weight: .semibold))
                                            .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                        Text("Total Time")
                                            .foregroundStyle(Color.black)
                                            .font(.system(size: 15, weight: .semibold))
                                            .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                    }.frame(height: 44)

                                    Divider().padding(.horizontal, -16)

                                    HStack(spacing: 0) {
                                        Text(calculateEta())
                                            .font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black)
                                            .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)

                                        Text(calculateTotalTime())
                                            .font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                            .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                    }.frame(height: 44)
                                }// End VStack
                            }// End if
                        }.padding(.horizontal)
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 0))

                        VStack(spacing: 0) {
                            HStack(alignment: .center, spacing: 0) {
                                Button(action: {
                                    self.isCollapseCrew.toggle()
                                }, label: {
                                    HStack(alignment: .center, spacing: 8) {
                                        Text("Crew").font(.system(size: 17, weight: .semibold)).foregroundStyle(Color.black)
                                        if isCollapseCrew {
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
                                }).buttonStyle(PlainButtonStyle())

                                Spacer()
                            }.frame(height: 52)

                            if isCollapseCrew {
                                VStack(spacing: 0) {
                                    HStack(spacing: 0) {
                                        Text("Password").font(.system(size: 17, weight: .semibold)).foregroundStyle(Color.black).frame(width: calculateWidthSummary(proxy.size.width - 32, 1), alignment: .leading)
                                    }.frame(height: 44, alignment: .leading)

                                    Divider().padding(.horizontal, -16)

        
                                    HStack {
                                        Text(dataFlightOverview?.unwrappedPassword ?? "").font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black)
                                        Spacer()
                                    }.frame(height: 44)

                                    HStack(spacing: 0) {
                                        HStack(spacing: 0) {
                                            Text("Username").foregroundStyle(Color.black).font(.system(size: 15, weight: .semibold))

                                            Spacer()

                                        }.frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)

                                        Text(dataFlightOverview?.unwrappedCrewName ?? "").font(.system(size: 17, weight: .semibold)).foregroundStyle(Color.black).frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                    }.frame(height: 44)

                                    Divider().padding(.horizontal, -16)

                                    HStack(spacing: 0) {
                                        VStack(alignment: .leading) {
                                            Text(dataFlightOverview?.unwrappedCaPicker ?? "").font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black).frame(height: 44)
                                        }.frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)

                                        VStack(alignment: .leading, spacing: 0) {
                                            Text(dataFlightOverview?.unwrappedF0Picker ?? "").font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black).frame(height: 44)
                                        }.frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                    }.frame(height: 88)
                                }
                            }
                        }.padding(.horizontal)
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 0))
                    }// end ScrollView
                }.padding(.horizontal, 16)
            }.padding(.bottom, 32)
            .background(Color.theme.antiFlashWhite)
            .onAppear {
                if let sectorList = coreDataModel.selectedEvent?.eventSector as? EventSectorList {
                    dataEventSector = sectorList
                }
                
                if let overviewList = coreDataModel.selectedEvent?.flightOverviewList?.allObjects as? [FlightOverviewList] {
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                    dataFlightOverview = overviewList.first
                    
                }
            }
        }//end geometry
    }
     func renderTime(_ startDate: String, _ endDate: String) -> String {
         if startDate != "" && endDate != "" {
             if startDate != "" && endDate != "" {
                 return calculateDateTime(startDate, endDate)
             }
         }
         return ""
     }
    
     func calculateEta() -> String {
         return calculateTime(dataFlightOverview?.unwrappedFlightTime ?? "00:00", dataFlightOverview?.unwrappedChockOff ?? "00:00")
     }
                                             
     func renderBlockFlightTime(_ startDate: String, _ endDate: String) -> String {
         if startDate != "" && endDate != "" {
             return calculateTime(startDate, endDate)
         }
         return ""
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
