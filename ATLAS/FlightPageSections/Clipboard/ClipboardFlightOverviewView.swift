//
//  ClipboardFlightOverviewView.swift
//  ATLAS
//
//  Created by phuong phan on 22/08/2023.
//

import SwiftUI
import Combine
import CoreLocation

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
    @State private var dataEventSector: EventSectorList?
    
    @State private var dayHours: String = ""
    @State private var nightHours: String = ""
    
    //For switch crew
    @State private var isSync = false
    
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
                                    Text(dayHours)
                                        .font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                    Text(nightHours)
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
                                    Text(eta)
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
                                        Text("\(coreDataModel.dataUser?.unwrappedFirstName ?? "") \(coreDataModel.dataUser?.unwrappedLastName ?? "")").foregroundStyle(Color.black).font(.system(size: 15, weight: .semibold))

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
                
                if let sectorList = coreDataModel.selectedEvent?.eventSector as? EventSectorList {
                    dataEventSector = sectorList
                }
                
                let dayNight = calculateDayNight()
                self.dayHours = dayNight.day
                self.nightHours = dayNight.night
            }.onChange(of: showUTC) { _ in
                let dayNight = calculateDayNight()
                self.dayHours = dayNight.day
                self.nightHours = dayNight.night
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
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        if let timeChockOff = dataFlightOverview?.unwrappedChockOff, let flightTime = dataFlightOverview?.unwrappedFlightTime {
            return addDurationToDateTime(timeChockOff, flightTime) ?? ""
        }
        return ""
    }
    
    func calculateTotalTime() -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        if let chockOff = dataFlightOverview?.unwrappedChockOff, let chockOn = dataFlightOverview?.unwrappedChockOn {
            if let chockOffDate = dateFormatter.date(from: chockOff), let chockOnDate = dateFormatter.date(from: chockOn) {
                let diffComponents = Calendar.current.dateComponents([.hour, .minute], from: chockOffDate, to: chockOnDate)
                var hour: Int = 0
                var minute: Int = 0
                
                if let dhour = diffComponents.hour, dhour > 0 {
                    hour = dhour
                }
                
                if let dminute = diffComponents.minute, dminute > 0 {
                    minute = dminute
                }
                let hourString = String(format: "%02d", hour)
                let minuteString = String(format: "%02d", minute)
                return "\(hourString):\(minuteString)"
            }
        }
        return "00:00"
    }
    
    
    func calculateDayNight() -> (day: String, night: String) {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        if dataFlightOverview == nil || dataEventSector == nil || dataFlightOverview?.unwrappedChockOff == "" {
            return (day: "00:00", night: "00:00")
        }
        
        let departureLocation = CLLocationCoordinate2D(latitude: Double(dataEventSector?.unwrappedDepLat ?? "") ?? 0, longitude: Double(dataEventSector?.unwrappedDepLong ?? "") ?? 0)
        let destinationLocation = CLLocationCoordinate2D(latitude: Double(dataEventSector?.unwrappedArrLat ?? "") ?? 0, longitude: Double(dataEventSector?.unwrappedArrLong ?? "") ?? 0)
        
        var dayNight = (day: (hours: 0, minutes: 0), night: (hours: 0, minutes: 0))
        
        if let dateChockOff = dataFlightOverview?.unwrappedChockOff, let dateChockOn = dataFlightOverview?.unwrappedChockOn {
            if let currentDateChockOff = dateFormatter.date(from: dateChockOff), let currentDateChockOn = dateFormatter.date(from: dateChockOn) {
                dayNight = segmentFlightAndCalculateDaylightAndNightHours(departureLocation: departureLocation, destinationLocation: destinationLocation, chocksOff: currentDateChockOff, chocksOn: currentDateChockOn, averageGroundSpeedKph: 900)
            }
        }
        
        
        func formatTime(hours: Int, minutes: Int) -> String {
            let hourString = String(format: "%02d", hours)
            let minuteString = String(format: "%02d", minutes)
            return "\(hourString):\(minuteString)"
        }
        
        func calculateNightTime(dayTime: (hours: Int, minutes: Int), duration: String) -> String {
            // Convert dayTime to minutes
            let dayTimeMinutes = dayTime.hours * 60 + dayTime.minutes
            
            // Parse the duration string to get hours and minutes
            let durationComponents = duration.components(separatedBy: ":")
            if durationComponents.count == 2,
               let durationHours = Int(durationComponents[0]),
               let durationMinutes = Int(durationComponents[1]) {
                
                // Calculate nightTime in minutes
                let totalMinutes = durationHours * 60 + durationMinutes - dayTimeMinutes
                
                // Convert totalMinutes back to hours and minutes
                let nightTimeHours = totalMinutes / 60
                let nightTimeMinutes = totalMinutes % 60
                
                // Format nightTime as "HH:mm"
                return formatTime(hours: nightTimeHours, minutes: nightTimeMinutes)
            }
            
            // Return a default value or handle an invalid duration string
            return "00:00"
        }
        
        return (day: formatTime(hours: dayNight.day.hours, minutes: dayNight.day.minutes), night: calculateNightTime(dayTime: dayNight.day, duration: calculateTotalTime()))
    }
}
