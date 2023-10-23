//
//  FlightOverviewCompleteSectionView.swift
//  ATLAS
//
//  Created by phuong phan on 22/08/2023.
//

import SwiftUI
import Combine
import CoreLocation

struct FlightOverviewCompleteSectionView: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController
    @EnvironmentObject var remoteService: RemoteService
    
    @State var isReference = false
    @State private var selectedCA = SummaryDataDropDown.pic
    @State private var selectedFO = SummaryDataDropDown.pic
    @State private var tfAircraft: String = ""
    @State private var tfPob: String = ""
    @State private var tfPassword: String = ""
    @State private var tfCrewName: String = ""
    
    //For Modal Flight Time
    @State private var currentDateFlightTime: String = "00:00"
    @State private var currentDateFlightTimeTemp = Date()
    @State private var isShowFlightTimeModal = false
    
    //For Modal Chock Off
    @State private var currentDateChockOff = Date()
    @State private var currentDateChockOffTemp = Date()
    @State private var isShowChockOffModal = false
    
    //For Modal Chock On
    @State private var currentDateChockOn = Date()
    @State private var currentDateChockOnTemp = Date()
    @State private var isShowChockOnModal = false
    
    @State private var showUTC = true
    
    @State private var isCollapseFlightInfo = true
    @State private var isCollapsePlanTime = true
    @State private var isCollapseActualTime = true
    @State private var isCollapseCrew = true
    @State private var selectedModelPicker = ""
    
    // For signature
    @State private var isSignatureViewModalPresented = false
    @State private var isSignatureModalPresented = false
    @State private var signatureImage: UIImage?
    @State private var signatureTfLicense: String = ""
    @State private var signatureTfComment: String = ""
    
    @State private var dataFlightOverview: FlightOverviewList?
    @State private var dataEventSector: EventSectorList?
    
    @State private var dayHours: String = ""
    @State private var nightHours: String = ""
    
    
    //For switch crew
    @State private var isSync = false
    
    let dateFormatter = DateFormatter()
    
    var body: some View {
        var stdLocal: String {
            return convertUTCToLocalTime(timeString: dataFlightOverview?.unwrappedStd ?? "", timeDiff: dataEventSector?.unwrappedDepTimeDiff ?? "")
        }
        
        var staLocal: String {
            return convertUTCToLocalTime(timeString: dataFlightOverview?.unwrappedSta ?? "", timeDiff: dataEventSector?.unwrappedDepTimeDiff ?? "")
        }
        
        var stdUTC: String {
            return dataFlightOverview?.unwrappedStd ?? ""
        }
        
        var staUTC: String {
            return dataFlightOverview?.unwrappedSta ?? ""
        }

        var std: String {
            if showUTC {
                return stdUTC
            } else {
                return stdLocal
            }
        }
        
        var sta: String {
            if showUTC {
                return staUTC
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
                    Text("Flight Overview")
                        .font(.system(size: 17, weight: .semibold))
                        .padding(.leading, 16)
                    
                    Spacer().frame(maxWidth: .infinity)
                    
                    HStack {
                        Toggle(isOn: $showUTC) {
                            Text("Local").font(.system(size: 15, weight: .regular))
                                .foregroundStyle(Color.black)
                        }
                        Text("UTC").font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(Color.black)
                        
                        Button(action: {
                            if checkBtnValid() {
                                isSignatureModalPresented.toggle()
                            }
                        }, label: {
                            Text("Close Flight").font(.system(size: 17, weight: .regular)).foregroundColor(Color.white)
                        }).padding(.vertical, 11)
                            .padding(.horizontal)
                            .background(checkBtnValid() ? Color.theme.azure : Color.theme.philippineGray3)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.white, lineWidth: 0)
                            )
                    }.fixedSize(horizontal: true, vertical: false)
                    
                }.frame(height: 52)
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
                                    HStack {
                                        Text(dataFlightOverview?.unwrappedCallsign ?? "")
                                            .foregroundStyle(Color.black)
                                            .font(.system(size: 15, weight: .regular))
                                            
                                        Spacer()
                                    }.frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    
                                    HStack {
                                        Text(selectedModelPicker)
                                            .foregroundStyle(Color.black)
                                            .font(.system(size: 15, weight: .regular))
                                        Spacer()
                                    }.frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    
                                    HStack {
                                        Text(tfAircraft)
                                            .foregroundStyle(Color.black)
                                            .font(.system(size: 15, weight: .regular))
                                        Spacer()
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
                                    HStack {
                                        Text(dataFlightOverview?.unwrappedDep ?? "")
                                            .foregroundStyle(Color.black)
                                            .font(.system(size: 15, weight: .regular))
                                            
                                        Spacer()
                                    }.frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    
                                    HStack {
                                        Text(dataFlightOverview?.unwrappedDest ?? "")
                                            .foregroundStyle(Color.black)
                                            .font(.system(size: 15, weight: .regular))
                                            
                                        Spacer()
                                    }.frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    
                                    HStack {
                                        Text(tfPob)
                                            .foregroundStyle(Color.black)
                                            .font(.system(size: 15, weight: .regular))
                                        
                                        Spacer()
                                    }.frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
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
                                    Text(renderTime(stdUTC, staUTC))
                                        .font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black)
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                    
                                    Text(currentDateFlightTime)
                                        .font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black)
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
                                    Text(renderBlockFlightTime(currentDateFlightTime, renderTime(stdUTC, staUTC)))
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
                        }.padding(.horizontal)
                            .frame(height: 52)

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
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .regular))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)

                                    Text(dataFlightOverview?.unwrappedChockOn ?? "")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .regular))
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
                                        .font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black)
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                    Text(nightHours)
                                        .font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black)
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

                                HStack {
                                    Text(eta)
                                        .font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)

                                    Text(calculateTotalTime())
                                        .font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black)
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                }.frame(height: 44)
                            }// End VStack
                        }// End if
                    }.background(Color.white)
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

                                        Button(action: {

                                        }, label: {
                                            Image("icon_sync")
                                                .scaledToFit()
                                                .aspectRatio(contentMode: .fit)
                                        }).padding(.trailing)
                                            .buttonStyle(PlainButtonStyle())

                                    }.frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)


                                    Text(tfCrewName).foregroundStyle(Color.black).font(.system(size: 15, weight: .semibold)).frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)

                                }.frame(height: 44, alignment: .leading)

                                Divider().padding(.horizontal, -16)

                                HStack(alignment: .top, spacing: 0) {
                                    VStack(alignment: .leading) {
                                        HStack(alignment: .center) {
                                            Text(tfPassword).foregroundStyle(Color.black).font(.system(size: 15, weight: .regular)).frame(alignment: .leading)
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

                                                Text(dataFlightOverview?.unwrappedCaName ?? "").font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black)

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
                                                Text(dataFlightOverview?.unwrappedF0Name ?? "").font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black)

                                                HStack {
                                                    Text(dataFlightOverview?.unwrappedF0Picker ?? "").font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black)
                                                }.fixedSize()
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
                .keyboardAvoidView()
            // end VStack
                .onAppear {
                    if let sectorList = coreDataModel.selectedEvent?.eventSector as? EventSectorList {
                        dataEventSector = sectorList
                    }
                    
                    if let overviewList = coreDataModel.selectedEvent?.flightOverviewList?.allObjects as? [FlightOverviewList] {
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                        dataFlightOverview = overviewList.first
                        
                        if let ca = dataFlightOverview?.unwrappedCaPicker {
                            selectedCA = SummaryDataDropDown(rawValue: ca) ?? SummaryDataDropDown.pic
                        } else {
                            selectedCA = SummaryDataDropDown.pic
                        }
                        
                        if let f0 = dataFlightOverview?.unwrappedF0Picker {
                            selectedFO = SummaryDataDropDown(rawValue: f0) ?? SummaryDataDropDown.pic
                        } else {
                            selectedFO = SummaryDataDropDown.pic
                        }
                        
                        if let model = dataFlightOverview?.model {
                            selectedModelPicker = model
                        }
                        
                        if let crewName = dataFlightOverview?.unwrappedCrewName {
                            tfCrewName = crewName
                        }
                        
                        if let password = dataFlightOverview?.unwrappedPassword {
                            tfPassword = password
                        }
                        
                        if let tempDateChockOff = dataFlightOverview?.unwrappedChockOff, let tempChockOffFormat = dateFormatter.date(from: tempDateChockOff) {
                            currentDateChockOff = tempChockOffFormat
                            currentDateChockOffTemp = tempChockOffFormat
                        }
                        
                        if let tempDateChockOn = dataFlightOverview?.unwrappedChockOn, let tempChockOnFormat = dateFormatter.date(from: tempDateChockOn) {
                            currentDateChockOn = tempChockOnFormat
                            currentDateChockOnTemp = tempChockOnFormat
                        }
                        
                        currentDateFlightTime = dataFlightOverview?.unwrappedFlightTime ?? ""
                        tfPob = dataFlightOverview?.unwrappedPob ?? ""
                        tfAircraft = dataFlightOverview?.unwrappedAircraft ?? ""
                    }
                    let dayNight = calculateDayNight()
                    self.dayHours = dayNight.day
                    self.nightHours = dayNight.night
                }
                .onChange(of: coreDataModel.selectedEvent?.id) {_ in
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                    if let sectorList = coreDataModel.selectedEvent?.eventSector as? EventSectorList {
                        dataEventSector = sectorList
                    }
                    
                    if let overviewList = coreDataModel.selectedEvent?.flightOverviewList?.allObjects as? [FlightOverviewList] {
                        dataFlightOverview = overviewList.first
                        
                        if let ca = dataFlightOverview?.unwrappedCaPicker {
                            selectedCA = SummaryDataDropDown(rawValue: ca) ?? SummaryDataDropDown.pic
                        }
                        
                        if let f0 = dataFlightOverview?.unwrappedF0Picker {
                            selectedFO = SummaryDataDropDown(rawValue: f0) ?? SummaryDataDropDown.pic
                        }
                        
                        if let model = dataFlightOverview?.model {
                            selectedModelPicker = model
                        }
                        
                        if let tempDateChockOff = dataFlightOverview?.unwrappedChockOff, let tempChockOffFormat = dateFormatter.date(from: tempDateChockOff) {
                            currentDateChockOff = tempChockOffFormat
                        }
                        
                        if let tempDateChockOn = dataFlightOverview?.unwrappedChockOn, let tempChockOnFormat = dateFormatter.date(from: tempDateChockOn) {
                            currentDateChockOn = tempChockOnFormat
                        }
                        
                        currentDateFlightTime = dataFlightOverview?.unwrappedFlightTime ?? ""
                        
                        tfPob = dataFlightOverview?.unwrappedPob ?? ""
                        tfAircraft = dataFlightOverview?.unwrappedAircraft ?? ""
                    }
                    
                    let dayNight = calculateDayNight()
                    self.dayHours = dayNight.day
                    self.nightHours = dayNight.night
                }
                .onChange(of: selectedCA) { value in
                    if dataFlightOverview != nil, let item = dataFlightOverview {
                        item.caPicker = value.rawValue
                        coreDataModel.save()
                        if let id = item.id {
                            dataFlightOverview = coreDataModel.readFlightOverviewById(id)
                        }
                    }
                }
                .onChange(of: selectedFO) { value in
                    if dataFlightOverview != nil, let item = dataFlightOverview {
                        item.f0Picker = value.rawValue
                        coreDataModel.save()
                        if let id = item.id {
                            dataFlightOverview = coreDataModel.readFlightOverviewById(id)
                        }
                    }
                }
                .onChange(of: selectedModelPicker) { value in
                    if dataFlightOverview != nil, let item = dataFlightOverview {
                        item.model = value
                        coreDataModel.save()
                        if let id = item.id {
                            dataFlightOverview = coreDataModel.readFlightOverviewById(id)
                        }
                    }
                }
                .onChange(of: currentDateFlightTime) { value in
                    if dataFlightOverview != nil, let item = dataFlightOverview {
                        item.flightTime = value
                        coreDataModel.save()
                        if let id = item.id {
                            dataFlightOverview = coreDataModel.readFlightOverviewById(id)
                        }
                    }
                }
                .onChange(of: currentDateChockOff) { value in
                    if dataFlightOverview != nil, let item = dataFlightOverview {
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                        item.chockOff = dateFormatter.string(from: value)
                        coreDataModel.save()
                        if let id = item.id {
                            dataFlightOverview = coreDataModel.readFlightOverviewById(id)
                        }
                    }
                    
                    let dayNight = calculateDayNight()
                    self.dayHours = dayNight.day
                    self.nightHours = dayNight.night
                }
                .onChange(of: currentDateChockOn) { value in
                    if dataFlightOverview != nil, let item = dataFlightOverview {
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                        item.chockOn = dateFormatter.string(from: value)
                        coreDataModel.save()
                        if let id = item.id {
                            dataFlightOverview = coreDataModel.readFlightOverviewById(id)
                        }
                    }
                    
                    let dayNight = calculateDayNight()
                    self.dayHours = dayNight.day
                    self.nightHours = dayNight.night
                }
                .onChange(of: signatureImage) { _ in
                    if let signatureImage = signatureImage {
                        if let flightNum = coreDataModel.selectedEvent?.unwrappedName, let newObj = coreDataModel.getSignature(flightNum) {
                            newObj.flightNumber = dataFlightOverview?.unwrappedCallsign
                            newObj.licenseNumber = signatureTfLicense
                            newObj.comment = signatureTfComment
                            
                            coreDataModel.save()
                        } else {
                            let str = convertImageToBase64(image: signatureImage)
                            let newObj = SignatureList(context: persistenceController.container.viewContext)
                            newObj.id = UUID()
                            newObj.flightNumber = dataFlightOverview?.unwrappedCallsign
                            newObj.imageString = str
                            newObj.licenseNumber = signatureTfLicense
                            newObj.comment = signatureTfComment
                            
                            coreDataModel.save()
                        }
                        
                        
                        
                        Task {
                            await withTaskGroup(of: Void.self) { group in
                                coreDataModel.dataSignature = coreDataModel.readSignature()
                                coreDataModel.dataEvents = coreDataModel.readEvents()
                                coreDataModel.dataEventDateRange = coreDataModel.readEventDateRange()
                                coreDataModel.dataLogbookEntries = coreDataModel.readDataLogbookEntries()
                                coreDataModel.dataLogbookLimitation = coreDataModel.readDataLogbookLimitation()
                                coreDataModel.dataRecency = coreDataModel.readDataRecency()
                                coreDataModel.dataRecencyExpiry = coreDataModel.readDataRecencyExpiry()
                                // For Flight Overview
                                // NoteList
                                coreDataModel.dataNoteList = coreDataModel.readNoteList()
                                
                                coreDataModel.dataAirportColorMap = coreDataModel.readDataAirportMapColorList()
                                
                                coreDataModel.dataRouteMap = coreDataModel.readDataRouteMapList()
                                
                                coreDataModel.dataNotams = coreDataModel.readDataNotamsList()
                                
                                coreDataModel.dataMetarTaf = coreDataModel.readDataMetarTafList()
                                
                                coreDataModel.dataNoteAabba = coreDataModel.readDataNoteAabbaPostList("")
                                coreDataModel.dataNoteAabbaPreflight = coreDataModel.readDataNoteAabbaPostList("preflight")
                                coreDataModel.dataNoteAabbaDeparture = coreDataModel.readDataNoteAabbaPostList("departure")
                                coreDataModel.dataNoteAabbaEnroute = coreDataModel.readDataNoteAabbaPostList("enroute")
                                coreDataModel.dataNoteAabbaArrival = coreDataModel.readDataNoteAabbaPostList("arrival")
                                
                                if let selectedEvent = coreDataModel.selectedEvent, let id = selectedEvent.id {
                                    coreDataModel.selectedEvent?.status = 2
                                    coreDataModel.selectedEvent?.flightStatus = FlightStatusEnum.COMPLETED.rawValue
                                    coreDataModel.save()
                                    coreDataModel.selectedEvent = coreDataModel.readEventsById(id)
                                }
                                
                                
                                if let overview = dataFlightOverview, let id = overview.id {
                                    dataFlightOverview = coreDataModel.readFlightOverviewById(id)
                                }
                                
                                dateFormatter.dateFormat = "yyyy-MM-dd"
                                
                                var picDay = "00:00"
                                var picNight = "00:00"
                                var p1Day = "00:00"
                                var p1Night = "00:00"
                                var picUsDay = "00:00"
                                var picUsNight = "00:00"
                                var p2Day = "00:00"
                                var p2Night = "00:00"
                                
                                if isSync {
                                    if selectedFO == SummaryDataDropDown.pic {
                                        picDay = dataFlightOverview?.day ?? "00:00"
                                        picNight = dataFlightOverview?.night ?? "00:00"
                                    } else if selectedFO == SummaryDataDropDown.p1 || selectedFO == SummaryDataDropDown.p1us {
                                        p1Day = dataFlightOverview?.day ?? "00:00"
                                        p1Night = dataFlightOverview?.night ?? "00:00"
                                    } else if selectedFO == SummaryDataDropDown.picus {
                                        picUsDay = dataFlightOverview?.day ?? "00:00"
                                        picUsNight = dataFlightOverview?.night ?? "00:00"
                                    } else if selectedFO == SummaryDataDropDown.p2 {
                                        p2Day = dataFlightOverview?.day ?? "00:00"
                                        p2Night = dataFlightOverview?.night ?? "00:00"
                                    }
                                } else {
                                    if selectedCA == SummaryDataDropDown.pic {
                                        picDay = dataFlightOverview?.day ?? "00:00"
                                        picNight = dataFlightOverview?.night ?? "00:00"
                                    } else if selectedCA == SummaryDataDropDown.p1 || selectedCA == SummaryDataDropDown.p1us {
                                        p1Day = dataFlightOverview?.day ?? "00:00"
                                        p1Night = dataFlightOverview?.night ?? "00:00"
                                    } else if selectedCA == SummaryDataDropDown.picus {
                                        picUsDay = dataFlightOverview?.day ?? "00:00"
                                        picUsNight = dataFlightOverview?.night ?? "00:00"
                                    } else if selectedCA == SummaryDataDropDown.p2 {
                                        p2Day = dataFlightOverview?.day ?? "00:00"
                                        p2Night = dataFlightOverview?.night ?? "00:00"
                                    }
                                }
                                
                                if let flightNumber = dataFlightOverview?.callsign, let foundItem = coreDataModel.readSignatureByFlightNumber(flightNumber) {
                                    let payload = ILogbookEntriesData(log_id: UUID().uuidString, date: dateFormatter.string(from: Date()), aircraft_category: "", aircraft_type: selectedModelPicker, aircraft: dataFlightOverview?.unwrappedAircraft ?? "", departure: dataFlightOverview?.unwrappedDep ?? "", destination: dataFlightOverview?.unwrappedDest ?? "", pic_day: picDay, pic_u_us_day: picUsDay, p1_day: p1Day, p2_day: p2Day, pic_night: picNight, pic_u_us_night: picUsNight, p1_night: p1Night, p2_night: p2Night, instr: "", exam: "", comments: foundItem.unwrappedComment , sign_file_name: "", sign_file_url: foundItem.unwrappedImageString , licence_number: foundItem.unwrappedLicenseNumber )
                                    
                                    coreDataModel.initDataLogbookEntries([payload])
                                }
                                
                                
                                coreDataModel.dataLogbookEntries = coreDataModel.readDataLogbookEntries()
                                
                                group.addTask {
                                    await coreDataModel.postLogbookEntries(coreDataModel.dataLogbookEntries)
                                }
                                
                                group.addTask {
                                    await coreDataModel.postEvent(coreDataModel.dataEvents)
                                }
                                
                                group.addTask {
                                    await coreDataModel.postFlightPlanObject()
                                }
                            }
                        }
                    }
                }
                .sheet(isPresented: $isSignatureModalPresented) {
                    SignatureModalView(signatureImage: $signatureImage, signatureTfLicense: $signatureTfLicense, signatureTfComment: $signatureTfComment, isSignatureModalPresented: $isSignatureModalPresented)
                }
                .formSheet(isPresented: $isShowFlightTimeModal) {
                    VStack {
                        HStack(alignment: .center) {
                            Button(action: {
                                self.isShowFlightTimeModal.toggle()
                            }) {
                                Text("Cancel").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                            }
                            
                            Spacer()
                            
                            Text("Flight Time").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.black)
                            
                            Spacer()
                            Button(action: {
                                // assign value from modal to entries form
                                dateFormatter.dateFormat = "HH:mm"
                                self.currentDateFlightTime = dateFormatter.string(from: currentDateFlightTimeTemp)
                                
                                self.isShowFlightTimeModal.toggle()
                            }) {
                                Text("Done").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                            }
                        }.padding()
                            .background(.white)
                            .roundedCorner(12, corners: [.topLeft, .topRight])
                        
                        Divider()
                        
                        VStack {
                            DatePicker("", selection: $currentDateFlightTimeTemp, displayedComponents: [ .hourAndMinute]).labelsHidden().datePickerStyle(WheelDatePickerStyle())
                                .environment(\.locale, Locale(identifier: "en_GB"))
                        }
                        Spacer()
                    }
                }
                .formSheet(isPresented: $isShowChockOffModal) {
                    VStack {
                        HStack(alignment: .center) {
                            Button(action: {
                                self.isShowChockOffModal.toggle()
                            }) {
                                Text("Cancel").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                            }
                            
                            Spacer()
                            
                            Text("Chocks Off").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.black)
                            
                            Spacer()
                            Button(action: {
                                // assign value from modal to entries form
                                self.currentDateChockOff = currentDateChockOffTemp
//                                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                
                                self.isShowChockOffModal.toggle()
                            }) {
                                Text("Done").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                            }
                        }.padding()
                            .background(.white)
                            .roundedCorner(12, corners: [.topLeft, .topRight])
                        
                        Divider()
                        
                        VStack {
                            DatePicker("", selection: $currentDateChockOffTemp, displayedComponents: [.date, .hourAndMinute]).labelsHidden().datePickerStyle(WheelDatePickerStyle())
                                .environment(\.locale, Locale(identifier: "en_GB"))
                        }
                        Spacer()
                    }
                }
                .formSheet(isPresented: $isShowChockOnModal) {
                    VStack {
                        HStack(alignment: .center) {
                            Button(action: {
                                self.isShowChockOnModal.toggle()
                            }) {
                                Text("Cancel").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                            }
                            
                            Spacer()
                            
                            Text("Chocks On").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.black)
                            
                            Spacer()
                            Button(action: {
                                // assign value from modal to entries form
                                self.currentDateChockOn = currentDateChockOnTemp
                                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                
                                self.isShowChockOnModal.toggle()
                            }) {
                                Text("Done").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                            }
                        }.padding()
                            .background(.white)
                            .roundedCorner(12, corners: [.topLeft, .topRight])
                        
                        Divider()
                        
                        VStack {
                            DatePicker("", selection: $currentDateChockOnTemp, displayedComponents: [.date, .hourAndMinute]).labelsHidden().datePickerStyle(WheelDatePickerStyle())
                                .environment(\.locale, Locale(identifier: "en_GB"))
                        }
                        Spacer()
                    }
                }
        }//end geometry
    }
    
    func onFlightTime() {
        self.isShowFlightTimeModal.toggle()
    }
    
    func onChockOff() {
        self.isShowChockOffModal.toggle()
    }
    
    func onChockOn() {
        self.isShowChockOnModal.toggle()
    }
    
    func checkBtnValid() -> Bool {
        let overview = dataFlightOverview
        return coreDataModel.selectedEvent?.flightStatus != FlightStatusEnum.COMPLETED.rawValue && selectedModelPicker != "" && overview?.unwrappedFlightTime != "" && overview?.unwrappedChockOff != "" && overview?.unwrappedChockOn != "" && selectedCA.rawValue != "" && selectedFO.rawValue != ""
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
        let timeChockOff = dateFormatter.string(from: currentDateChockOff)
        return addDurationToDateTime(timeChockOff, currentDateFlightTime) ?? ""
    }

    
    func calculateTotalTime() -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let diffComponents = Calendar.current.dateComponents([.hour, .minute], from: currentDateChockOff, to: currentDateChockOn)
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
        
    func calculateDayNight() -> (day: String, night: String) {
        if dataFlightOverview == nil || dataFlightOverview?.unwrappedChockOff == "" {
//            print("dataFlightOverview=========\(dataFlightOverview)")
//            print("dataEventSector=========\(dataEventSector)")
//            print("dataFlightOverview?.unwrappedChockOff=========\(dataFlightOverview?.unwrappedChockOff)")
            return (day: "00:00", night: "00:00")
        }
        
        let departureLocation = CLLocationCoordinate2D(latitude: Double(dataEventSector?.unwrappedDepLat ?? "") ?? 0, longitude: Double(dataEventSector?.unwrappedDepLong ?? "") ?? 0)
        let destinationLocation = CLLocationCoordinate2D(latitude: Double(dataEventSector?.unwrappedArrLat ?? "") ?? 0, longitude: Double(dataEventSector?.unwrappedArrLong ?? "") ?? 0)
        
        print("dataFlightOverview?.unwrappedChockOff=========\(dataFlightOverview?.unwrappedChockOff)")
        print("dataFlightOverview?.unwrappedChockOn=========\(dataFlightOverview?.unwrappedChockOn)")
        print("currentDateChockOff=========\(dateFormatter.string(from: currentDateChockOff))")
        print("currentDateChockOn=========\(dateFormatter.string(from: currentDateChockOn))")
        
        let dayNight = segmentFlightAndCalculateDaylightAndNightHours(departureLocation: departureLocation, destinationLocation: destinationLocation, chocksOff: currentDateChockOff, chocksOn: currentDateChockOn, averageGroundSpeedKph: 900)
        
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
