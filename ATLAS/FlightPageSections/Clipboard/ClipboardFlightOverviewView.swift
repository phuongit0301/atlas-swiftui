//
//  ClipboardFlightOverviewView.swift
//  ATLAS
//
//  Created by phuong phan on 22/08/2023.
//

import SwiftUI
import Combine

struct ClipboardFlightOverviewView: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var refState: ScreenReferenceModel
    
    @State private var selectedCA = SummaryDataDropDown.pic
    @State private var selectedFO = SummaryDataDropDown.pic
    
    @State private var showUTC = true
    
    @State private var isCollapseFlightInfo = true
    @State private var isCollapsePlanTime = true
    @State private var isCollapseActualTime = true
    @State private var isCollapseCrew = true
    
    @State private var dataFlightOverview: FlightOverviewList?
    
    //For switch crew
    @State private var isSync = false
    
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
                    HStack(alignment: .center, spacing: 8) {
                        Button {
                            refState.isActive = false
                        } label: {
                            HStack {
                                Text("Clipboard").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.theme.azure)
                            }
                        }
                        
                        Image(systemName: "chevron.forward").font(.system(size: 17, weight: .regular))
                        
                        if let currentItem = refState.selectedItem, let screenName = currentItem.screenName {
                            Text("\(convertScreenNameToString(screenName))").font(.system(size: 17, weight: .semibold)).foregroundColor(.black)
                        }
                        
                        Spacer()
                    }.padding(.leading)
                    
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
                                    Text("Password").font(.system(size: 17, weight: .semibold)).foregroundStyle(Color.black).frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    
                                    HStack(spacing: 0) {
                                        Text("Username").foregroundStyle(Color.black).font(.system(size: 15, weight: .semibold))

                                        Spacer()
                                        
                                    }.frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)

                                    Text(dataFlightOverview?.unwrappedCrewName ?? "").font(.system(size: 17, weight: .semibold)).foregroundStyle(Color.black).frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)

                                }.frame(height: 44, alignment: .leading)

                                Divider().padding(.horizontal, -16)

                                HStack(alignment: .top, spacing: 0) {
                                    VStack(alignment: .leading) {
                                        HStack(alignment: .center) {
                                            Text(dataFlightOverview?.unwrappedPassword ?? "")
                                                .font(.system(size: 15, weight: .regular))
                                                .foregroundStyle(Color.black)
                                        }.frame(height: 44)
                                        
                                        Spacer()
                                    }.frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    
                                    HStack(alignment: .center) {
                                        HStack(alignment: .center) {
                                            Circle().strokeBorder(Color.black, lineWidth: 1)
                                                .background(Circle().fill(Color.theme.mountainMeadow))
                                                .frame(width: 48, height: 48)
                                        }

                                        VStack(alignment: .leading) {
                                            HStack {
                                                Text(dataFlightOverview?.unwrappedCaPicker ?? "").font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black)
                                            }.frame(height: 44)

                                            Spacer()
                                        }
                                    }.frame(width: calculateWidthSummary(proxy.size.width - 32, 3), height: 88, alignment: .leading)

                                    HStack(alignment: .center) {
                                        HStack(alignment: .center) {
                                            Circle().strokeBorder(Color.black, lineWidth: 1)
                                                .background(Circle().fill(Color.theme.mountainMeadow))
                                                .frame(width: 48, height: 48)
                                        }

                                        VStack(alignment: .leading, spacing: 0) {
                                            HStack {
                                                Text(dataFlightOverview?.unwrappedF0Picker ?? "").font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black)
                                            }.frame(height: 44)
                                            
                                            Spacer()
                                        }
                                    }.frame(width: calculateWidthSummary(proxy.size.width - 32, 3), height: 88, alignment: .leading)
                                }.frame(height: 88)

                            }
                        }
                    }.padding(.horizontal)
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 0))
                }// end ScrollView
                .padding(.bottom, 32)
            }.padding(.horizontal, 16)
                .background(Color.theme.antiFlashWhite)
            // end VStack
            .onAppear {
                if let overviewList = coreDataModel.selectedEvent?.flightOverviewList?.allObjects as? [FlightOverviewList] {
                    dataFlightOverview = overviewList.first
                }
            }
        }//end geometry
    }
    
    func renderTime(_ startDate: String, _ endDate: String) -> String {
        if startDate != "" && endDate != "" {
            let startTime = startDate.components(separatedBy: " ")
            let endTime = endDate.components(separatedBy: " ")
            
            return calculateTime(startTime[1], endTime[1])
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
