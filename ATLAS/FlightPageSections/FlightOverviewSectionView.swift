//
//  FlightOverviewView.swift
//  ATLAS
//
//  Created by phuong phan on 22/08/2023.
//

import SwiftUI
import Combine

struct FlightOverviewSectionView: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController
    @State var isReference = false
    @State private var selectedCA = SummaryDataDropDown.pic
    @State private var selectedFO = SummaryDataDropDown.pic
    @State private var tfAircraft: String = ""
    @State private var tfPob: String = ""
    @State private var tfFlightTime: String = ""
    @State private var showUTC = true
    
    @State private var isCollapseFlightInfo = true
    @State private var isCollapsePlanTime = true
    @State private var isCollapseActualTime = true
    @State private var isCollapseCrew = true
    @State private var selectedAircraftPicker = ""
    var AIRCRAFT_DROP_DOWN: [String] = ["Aircraft 1", "Aircraft 2", "Aircraft 3"]
    
    var body: some View {
        var etaUTC: String {
            // define date format
            let dateFormatterTime = DateFormatter()
            dateFormatterTime.dateFormat = "dd/M | HHmm"
            // convert takeoff time to date
            if let takeoff = coreDataModel.dataDepartureEntries.entTakeoff {
                let entTakeoff =  dateFormatterTime.date(from: takeoff)
                // get flight time
                if let flightTimeComponents = coreDataModel.dataSummaryInfo.fltTime {
                    // convert flight time to seconds
                    let components = flightTimeComponents.components(separatedBy: ":")
                    if components.count > 1 {
                        let flightTime = (Int(components[0])! * 3600) + (Int(components[1])! * 60)
                        // add flight time to takeoff time
                        if let etaTime = entTakeoff?.addingTimeInterval(TimeInterval(flightTime)) {
                            return dateFormatterTime.string(from: etaTime)
                        }
                    }
                    
                }
            }
            return ""
        }
        
        var etaLocal: String {
            // define date format
            let dateFormatterTime = DateFormatter()
            dateFormatterTime.dateFormat = "dd/M | HHmm"
            // convert time diff to format
            let timeDiff = coreDataModel.dataSummaryInfo.unwrappedTimeDiffArr
            let timeDiffFormatted = timeDiff != "" ? Int(timeDiff)! * 3600 : 0
            // convert takeoff time to date
            if let takeoff = coreDataModel.dataDepartureEntries.entTakeoff {
                let entTakeoff =  dateFormatterTime.date(from: takeoff)
                // convert flight time to seconds
                if let flightTimeComponents = coreDataModel.dataSummaryInfo.fltTime {
                    let components = flightTimeComponents.components(separatedBy: ":")
                    if components.count > 1 {
                        // add flight time with time difference
                        let adjTime = (Int(components[0])! * 3600) + (Int(components[1])! * 60) + timeDiffFormatted
                        // add time difference and flight time to takeoff time
                        if let etaTime = entTakeoff?.addingTimeInterval(TimeInterval(adjTime)) {
                            return dateFormatterTime.string(from: etaTime)
                        }
                    }
                }
            }
            return ""
        }
        
        let chocksOffUTC: String = coreDataModel.dataDepartureEntries.entOff!
        
        var chocksOffLocal: String {
            // define date formats
            let dateFormatterTime = DateFormatter()
            dateFormatterTime.dateFormat = "dd/M | HHmm"
            // convert time diff to Int seconds
            let timeDiff = coreDataModel.dataSummaryInfo.unwrappedTimeDiffDep
            let timeDiffFormatted = timeDiff != "" ? Int(timeDiff)! * 3600 : 0
            // convert chocks off format
            if let chocksOff = coreDataModel.dataDepartureEntries.entOff {
                let chocksOffFormatted =  dateFormatterTime.date(from: chocksOff)
                // add time diff to chocks off time
                if let offTime = chocksOffFormatted?.addingTimeInterval(TimeInterval(timeDiffFormatted)) {
                    return dateFormatterTime.string(from: offTime)
                }
            }
            return ""
        }
        
        let chocksOnUTC: String = coreDataModel.dataArrivalEntries.entOn!
        
        var chocksOnLocal: String {
            // define date formats
            let dateFormatterTime = DateFormatter()
            dateFormatterTime.dateFormat = "dd/M | HHmm"
            // convert time diff to Int seconds
            let timeDiff = coreDataModel.dataSummaryInfo.unwrappedTimeDiffArr
            let timeDiffFormatted = timeDiff != "" ? Int(timeDiff)! * 3600 : 0
            // convert chocks on format
            if let chocksOn = coreDataModel.dataArrivalEntries.entOn {
                let chocksOnFormatted =  dateFormatterTime.date(from: chocksOn)
                // add time diff to chocks on time
                if let onTime = chocksOnFormatted?.addingTimeInterval(TimeInterval(timeDiffFormatted)) {
                    return dateFormatterTime.string(from: onTime)
                }
            }
            return ""
        }
        
        GeometryReader { proxy in
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .center) {
                    Text("Flight Overview").font(.system(size: 20, weight: .semibold))
                    
                    Spacer().frame(maxWidth: .infinity)
                    
                    HStack {
                        Toggle(isOn: $showUTC) {
                            Text("Local").font(.system(size: 17, weight: .regular))
                                .foregroundStyle(Color.black)
                        }
                        Text("UTC").font(.system(size: 17, weight: .regular))
                            .foregroundStyle(Color.black)
                        
                        Button(action: {
                            //Todo
                        }, label: {
                            Text("Close Flight").font(Font.custom("SF Pro", size: 17)).foregroundColor(Color.white)
                        }).padding(.vertical, 11)
                            .padding(.horizontal)
                            .background(Color.theme.philippineGray3)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.white, lineWidth: 0)
                            )
                    }.fixedSize(horizontal: true, vertical: false)
                    
                }.padding(.horizontal, 8)
                    .padding(.bottom, 8)
                    // End header
                ScrollView {
                    VStack(spacing: 0) {
                        HStack {
                            Button(action: {
                                self.isCollapseFlightInfo.toggle()
                            }, label: {
                                HStack {
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
                        }.frame(height: 44)
                        
                        if isCollapseFlightInfo {
                            VStack {
                                HStack {
                                    Text("Callsign")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 48, 3), alignment: .leading)
                                    Text("Aircraft Model")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 48, 3), alignment: .leading)
                                    Text("Aircraft")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 48, 3), alignment: .leading)
                                }.frame(height: 44)
                                
                                Divider().padding(.horizontal, -16)
                                
                                HStack {
                                    Text(coreDataModel.dataSummaryInfo.unwrappedFltNo).frame(width: calculateWidthSummary(proxy.size.width - 48, 3), alignment: .leading)
                                    
                                    HStack {
                                        Picker("", selection: $selectedAircraftPicker) {
                                            Text("Select Aircraft Model").tag("")
                                            ForEach(AIRCRAFT_DROP_DOWN, id: \.self) {
                                                Text($0).tag($0)
                                            }
                                        }.pickerStyle(MenuPickerStyle())
                                            .fixedSize()
                                            .padding(.leading, -16)
                                        Spacer()
                                    }.frame(width: calculateWidthSummary(proxy.size.width - 48, 3), alignment: .leading)
                                    
                                    TextField(
                                        "Enter Aircraft",
                                        text: $tfAircraft
                                    ).frame(width: calculateWidthSummary(proxy.size.width - 48, 3), alignment: .leading)
                                        .onSubmit {
                                            //Todo
                                        }
                                }.frame(height: 44)
                                
                                HStack {
                                    Text("Dep")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 48, 3), alignment: .leading)
                                    Text("Dest")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 48, 3), alignment: .leading)
                                    Text("POB")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 56, 3), alignment: .leading)
                                }.frame(height: 44)
                                
                                Divider().padding(.horizontal, -16)
                                
                                HStack {
                                    Text(coreDataModel.dataSummaryInfo.unwrappedDep).frame(width: calculateWidthSummary(proxy.size.width - 48, 3), alignment: .leading)
                                    Text(coreDataModel.dataSummaryInfo.unwrappedDest).frame(width: calculateWidthSummary(proxy.size.width - 48, 3), alignment: .leading)
                                    
                                    TextField(
                                        "Enter POB",
                                        text: $tfPob
                                    ).frame(width: calculateWidthSummary(proxy.size.width - 48, 3), alignment: .leading)
                                        .onSubmit {
                                            //Todo
                                        }
                                }.frame(height: 44)
                            } //end VStack
                        }// end if
                    }.padding(16)
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 0))
                    
                    
                    VStack(spacing: 16) {
                        HStack {
                            Button(action: {
                                self.isCollapsePlanTime.toggle()
                            }, label: {
                                HStack {
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
                        }.frame(height: 44)

                        if isCollapsePlanTime {
                            VStack {
                                HStack {
                                    Text("STD")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 48, 3), alignment: .leading)
                                    Text("STA")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 48, 3), alignment: .leading)
                                    Text("")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 48, 3), alignment: .leading)
                                }.frame(height: 44)

                                Divider().padding(.horizontal, -16)

                                HStack {
                                    Text(showUTC ? coreDataModel.dataSummaryInfo.unwrappedStdUTC : coreDataModel.dataSummaryInfo.unwrappedStdLocal)
                                        .font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                        .frame(width: calculateWidthSummary(proxy.size.width - 48, 3), alignment: .leading)
                                    Text(showUTC ? coreDataModel.dataSummaryInfo.unwrappedStaUTC : coreDataModel.dataSummaryInfo.unwrappedStaLocal)
                                        .font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                        .frame(width: calculateWidthSummary(proxy.size.width - 48, 3), alignment: .leading)
                                    Text("").frame(width: calculateWidthSummary(proxy.size.width - 48, 3), alignment: .leading)
                                }.frame(height: 44)

                                HStack {
                                    Text("Block Time")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 48, 3), alignment: .leading)
                                    Text("Flight Time")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 48, 3), alignment: .leading)
                                    Text("Block Time - Flight Time")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 48, 3), alignment: .leading)
                                }.frame(height: 44)

                                Divider().padding(.horizontal, -16)

                                HStack {
                                    Text(coreDataModel.dataSummaryInfo.unwrappedBlkTime)
                                        .font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                        .frame(width: calculateWidthSummary(proxy.size.width - 48, 3), alignment: .leading)
                                    TextField("Enter Flight Time",text: $tfFlightTime)
                                        .font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                        .frame(width: calculateWidthSummary(proxy.size.width - 48, 3), alignment: .leading)
                                        .onSubmit {
                                            //Todo
                                        }
                                    Text(calculateTime(coreDataModel.dataSummaryInfo.unwrappedFltTime, coreDataModel.dataSummaryInfo.unwrappedBlkTime))
                                        .font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                        .frame(width: calculateWidthSummary(proxy.size.width - 48, 3), alignment: .leading)
                                }.frame(height: 44)
                            }// End VStack
                        }// end If
                    }.padding(16)
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 0))
//
//
                    VStack(spacing: 16) {
                        HStack {
                            Button(action: {
                                self.isCollapseActualTime.toggle()
                            }, label: {
                                HStack {
                                    Text("Actual Times").font(.system(size: 17, weight: .semibold)).foregroundStyle(Color.black)
                                    if isCollapseActualTime {
                                        Image(systemName: "chevron.up")
                                            .foregroundColor(Color.blue)
                                            .scaledToFit()
                                            .aspectRatio(contentMode: .fit)
                                    } else {
                                        Image(systemName: "chevron.down")
                                            .foregroundColor(Color.blue)
                                            .scaledToFit()
                                            .aspectRatio(contentMode: .fit)
                                    }
                                }.frame(alignment: .leading)
                            }).buttonStyle(PlainButtonStyle())
                                .padding(.leading, 12)
                            Spacer()
                        }.frame(height: 44)

                        if isCollapseActualTime {
                            VStack {
                                HStack {
                                    Text("Chocks Off")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 48, 3), alignment: .leading)
                                    Text("ETA")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 48, 3), alignment: .leading)
                                    Text("Chocks On")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 48, 3), alignment: .leading)
                                }.frame(height: 44)

                                Divider().padding(.horizontal, -16)

                                HStack {
                                    Text(showUTC ? chocksOffUTC : chocksOffLocal)
                                        .font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                        .frame(width: calculateWidthSummary(proxy.size.width - 48, 3), alignment: .leading)
                                    Text(showUTC ? etaUTC : etaLocal)
                                        .font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                        .frame(width: calculateWidthSummary(proxy.size.width - 48, 3), alignment: .leading)
                                    Text(showUTC ? chocksOnUTC : chocksOnLocal)
                                        .font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                        .frame(width: calculateWidthSummary(proxy.size.width - 48, 3), alignment: .leading)
                                }.frame(height: 44)


                                HStack {
                                    Text("Day")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 48, 3), alignment: .leading)
                                    Text("Night")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 48, 3), alignment: .leading)
                                    Text("Total Time")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 48, 3), alignment: .leading)
                                }.frame(height: 44)

                                Divider().padding(.horizontal, -16)

                                HStack {
                                    Text("TODO")
                                        .font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                        .frame(width: calculateWidthSummary(proxy.size.width - 48, 3), alignment: .leading)
                                    Text("TODO")
                                        .font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                        .frame(width: calculateWidthSummary(proxy.size.width - 48, 3), alignment: .leading)
                                    Text(calculateDateTime(chocksOffUTC, chocksOnUTC))
                                        .font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                        .frame(width: calculateWidthSummary(proxy.size.width - 48, 3), alignment: .leading)
                                }.frame(height: 44)
                            }// End VStack
                        }// End if
                    }.padding(8)
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 0))


                    VStack(spacing: 16) {
                        HStack {
                            Button(action: {
                                self.isCollapseCrew.toggle()
                            }, label: {
                                HStack {
                                    Text("Crew").font(.system(size: 17, weight: .semibold)).foregroundStyle(Color.black)
                                    if isCollapseCrew {
                                        Image(systemName: "chevron.up")
                                            .foregroundColor(Color.blue)
                                            .scaledToFit()
                                            .aspectRatio(contentMode: .fit)
                                    } else {
                                        Image(systemName: "chevron.down")
                                            .foregroundColor(Color.blue)
                                            .scaledToFit()
                                            .aspectRatio(contentMode: .fit)
                                    }
                                }.frame(alignment: .leading)
                            }).buttonStyle(PlainButtonStyle())

                            Spacer()
                        }.frame(height: 44)

                        if isCollapseCrew {
                            VStack {
                                HStack {
                                    HStack {
                                        Text("CA").foregroundStyle(Color.black).font(.system(size: 15, weight: .semibold))

                                        Spacer()

                                        Image("icon_sync")
                                            .scaledToFit()
                                            .aspectRatio(contentMode: .fit)
                                            .padding(.trailing)
                                    }.frame(width: calculateWidthSummary(proxy.size.width - 48, 3), alignment: .leading)

                                    Text("FO").font(.system(size: 17, weight: .semibold)).foregroundStyle(Color.black).frame(width: calculateWidthSummary(proxy.size.width - 48, 3), alignment: .leading)

                                    Text("Password").font(.system(size: 17, weight: .semibold)).foregroundStyle(Color.black).frame(width: calculateWidthSummary(proxy.size.width - 48, 3), alignment: .leading)

                                }.frame(height: 44, alignment: .leading)

                                Divider().padding(.horizontal, -16)

                                HStack(alignment: .top) {
                                    HStack {
                                        HStack(alignment: .center) {
                                            Circle().strokeBorder(Color.black, lineWidth: 1)
                                                .background(Circle().fill(Color.theme.mountainMeadow))
                                                .frame(width: 48, height: 48)
                                        }

                                        VStack(alignment: .leading) {
                                            HStack {
                                                Text("Muhammad Adil").font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                                HStack {
                                                    Picker("", selection: $selectedFO) {
                                                        ForEach(SummaryDataDropDown.allCases, id: \.self) {
                                                            Text($0.rawValue).tag($0.rawValue)
                                                        }
                                                    }.pickerStyle(MenuPickerStyle()).fixedSize()
                                                }.fixedSize()
                                            }

                                            Spacer()
                                        }
                                    }.frame(width: calculateWidthSummary(proxy.size.width - 48, 3), alignment: .leading)

                                    HStack {
                                        HStack(alignment: .center) {
                                            Circle().strokeBorder(Color.black, lineWidth: 1)
                                                .background(Circle().fill(Color.theme.mountainMeadow))
                                                .frame(width: 48, height: 48)
                                        }

                                        VStack(alignment: .leading) {
                                            HStack {
                                                Text("Other Pilot's Full name").font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                                HStack {
                                                    Picker("", selection: $selectedCA) {
                                                        ForEach(SummaryDataDropDown.allCases, id: \.self) {
                                                            Text($0.rawValue).tag($0.rawValue)
                                                        }
                                                    }.pickerStyle(MenuPickerStyle()).fixedSize()
                                                }.fixedSize()
                                            }

                                            Spacer()

                                            Text("Chat").font(.system(size: 17, weight: .regular)).foregroundStyle(Color.theme.azure).frame(alignment: .leading)
                                        }
                                    }.frame(width: calculateWidthSummary(proxy.size.width - 48, 3), alignment: .leading)

                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text("Chelsea").font(.system(size: 17, weight: .regular)).foregroundStyle(Color.theme.azure)
                                        }
                                    }.frame(width: calculateWidthSummary(proxy.size.width - 48, 3), alignment: .leading)
                                        .padding(.top, 8)
                                        .padding(.leading, 8)

                                }.frame(height: 88)

                            }// End VStack
                        }// end if
                    }// END CREW
                    .padding(16)
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 0))
                }// end ScrollView
            }.padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(Color.theme.antiFlashWhite)
                .keyboardAvoidView()
            // end VStack
            .onAppear {
                selectedCA = SummaryDataDropDown(rawValue: coreDataModel.dataSummaryInfo.unwrappedCrewCA) ?? SummaryDataDropDown.pic
                selectedFO = SummaryDataDropDown(rawValue: coreDataModel.dataSummaryInfo.unwrappedCrewFO) ?? SummaryDataDropDown.pic
                tfPob = coreDataModel.dataSummaryInfo.unwrappedPob
            }
            .onChange(of: selectedCA) { value in
                if coreDataModel.existDataSummaryInfo {
                    coreDataModel.dataSummaryInfo.crewCA = value.rawValue
                    coreDataModel.save()
                }
            }
            .onChange(of: selectedFO) { value in
                if coreDataModel.existDataSummaryInfo {
                    coreDataModel.dataSummaryInfo.crewFO = value.rawValue
                    coreDataModel.save()
                }
            }
        }//end geometry
    }
}
