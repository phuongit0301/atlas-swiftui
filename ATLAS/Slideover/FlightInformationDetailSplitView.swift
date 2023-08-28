//
//  FlightInformationView.swift
//  ATLAS
//
//  Created by phuong phan on 06/07/2023.
//

import SwiftUI

struct FlightInformationDetailSplitView: View {
    @State private var showUTC = true
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @State var pasteboard = UIPasteboard.general
    
    @State private var selectedCA = SummaryDataDropDown.pic
    @State private var selectedFO = SummaryDataDropDown.pic
    
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
            VStack(spacing: 0) {
                HeaderViewSplit(isMenu: true)
                
                VStack {
                    HStack(alignment: .center) {
                        Text("Flight Summary")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(Color.black)
                            .padding(.leading, 8)
                        
                        Spacer()
                        
                        HStack {
                            Toggle(isOn: $showUTC) {
                                Text("Local").font(.system(size: 17, weight: .regular))
                                    .foregroundStyle(Color.black)
                            }
                            Text("UTC").font(.system(size: 17, weight: .regular))
                                .foregroundStyle(Color.black)
                        }.fixedSize(horizontal: true, vertical: false)
                    }
                    
                    List {
                        Section(header:
                            Text("Flight info").font(.system(size: 15, weight: .semibold)).foregroundStyle(Color.black)
                        ) {
                            // grouped row using hstack
                            VStack(alignment: .leading) {
                                Group {
                                    HStack(alignment: .center) {
                                        Group {
                                            Text("Callsign")
                                                .font(.system(size: 17, weight: .semibold))
                                                .foregroundStyle(Color.black)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            Text("Sector")
                                                .font(.system(size: 17, weight: .semibold))
                                                .foregroundStyle(Color.black)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                    }.padding(.bottom, 4)
                                    HStack(alignment: .center) {
                                        Group {
                                            Text(coreDataModel.dataSummaryInfo.unwrappedFltNo)
                                                .font(.system(size: 17, weight: .regular))
                                                .foregroundStyle(Color.black)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            Text("\(coreDataModel.dataSummaryInfo.unwrappedDep+" / "+coreDataModel.dataSummaryInfo.unwrappedDest)")
                                                .font(.system(size: 17, weight: .regular))
                                                .foregroundStyle(Color.black)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                    }
                                }
                                
                                Divider()
                                
                                Group {
                                    HStack(alignment: .center) {
                                        Group {
                                            Text("Aircraft")
                                                .font(.system(size: 17, weight: .semibold))
                                                .foregroundStyle(Color.black)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            Text("POB")
                                                .font(.system(size: 17, weight: .semibold))
                                                .foregroundStyle(Color.black)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                    }.padding(.bottom, 4)
                                    HStack(alignment: .center) {
                                        Group {
                                            Text(coreDataModel.dataSummaryInfo.unwrappedTailNo)
                                                .font(.system(size: 17, weight: .regular))
                                                .foregroundStyle(Color.black)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            Text(coreDataModel.dataSummaryInfo.unwrappedPob)
                                                .font(.system(size: 17, weight: .regular))
                                                .foregroundStyle(Color.black)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                    }
                                }
                            }
                        }.listRowBackground(Color.theme.antiFlashWhite)
                        
                        Section(header: Text("Planned times").font(.system(size: 15, weight: .semibold)).foregroundStyle(Color.black)) {
                            // grouped row using hstack
                            VStack(alignment: .leading) {
                                Group {
                                    HStack(alignment: .center) {
                                        Group {
                                            Text("STD")
                                                .font(.system(size: 17, weight: .semibold))
                                                .foregroundStyle(Color.black)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            Text("STA")
                                                .font(.system(size: 17, weight: .semibold))
                                                .foregroundStyle(Color.black)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                    }.padding(.bottom, 4)
                                    
                                    HStack(alignment: .center) {
                                        Group {
                                            Text(showUTC ? coreDataModel.dataSummaryInfo.unwrappedStdUTC : coreDataModel.dataSummaryInfo.unwrappedStdLocal)
                                                .font(.system(size: 17, weight: .regular))
                                                .foregroundStyle(Color.black)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            Text(showUTC ? coreDataModel.dataSummaryInfo.unwrappedStaUTC : coreDataModel.dataSummaryInfo.unwrappedStaLocal)
                                                .font(.system(size: 17, weight: .regular))
                                                .foregroundStyle(Color.black)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                    }
                                }
                                
                                Divider()
                                
                                Group {
                                    HStack(alignment: .center) {
                                        Group {
                                            Text("Block Time")
                                                .font(.system(size: 17, weight: .semibold))
                                                .foregroundStyle(Color.black)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            Text("Flight Time")
                                                .font(.system(size: 17, weight: .semibold))
                                                .foregroundStyle(Color.black)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                    }.padding(.bottom, 4)
                                    HStack(alignment: .center) {
                                        Group {
                                            Text(coreDataModel.dataSummaryInfo.unwrappedBlkTime)
                                                .font(.system(size: 17, weight: .regular))
                                                .foregroundStyle(Color.black)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            Text(coreDataModel.dataSummaryInfo.unwrappedFltTime)
                                                .font(.system(size: 17, weight: .regular))
                                                .foregroundStyle(Color.black)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                    }
                                }
                                
                                Divider()
                                
                                Group {
                                    HStack(alignment: .center) {
                                        Group {
                                            Text("Block Time - Flight Time")
                                                .font(.system(size: 17, weight: .semibold))
                                                .foregroundStyle(Color.black)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                    }.padding(.bottom, 4)
                                    HStack(alignment: .center) {
                                        Group {
                                            Text(calculateTime(coreDataModel.dataSummaryInfo.unwrappedFltTime, coreDataModel.dataSummaryInfo.unwrappedBlkTime))
                                                .font(.system(size: 17, weight: .regular))
                                                .foregroundStyle(Color.black)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                    }
                                }
                            }
                        }.listRowBackground(Color.theme.antiFlashWhite)
                        
                        Section(header:
                                    Text("Actual Times")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(Color.black)
                        ) {
                            // grouped row using hstack
                            VStack(alignment: .leading) {
                                Group {
                                    HStack(alignment: .center) {
                                        Group {
                                            Text("Chocks Off")
                                                .font(.system(size: 17, weight: .semibold))
                                                .foregroundStyle(Color.black)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            Text("ETA")
                                                .font(.system(size: 17, weight: .semibold))
                                                .foregroundStyle(Color.black)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            Text("Chocks On")
                                                .font(.system(size: 17, weight: .semibold))
                                                .foregroundStyle(Color.black)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                    }.padding(.bottom, 4)

                                    HStack(alignment: .center) {
                                        Group {
                                            Text(showUTC ? chocksOffUTC : chocksOffLocal)
                                                .font(.system(size: 17, weight: .regular))
                                                .foregroundStyle(Color.black)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            Text(showUTC ? etaUTC : etaLocal)
                                                .font(.system(size: 17, weight: .regular))
                                                .foregroundStyle(Color.black)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            Text(showUTC ? chocksOnUTC : chocksOnLocal)
                                                .font(.system(size: 17, weight: .regular))
                                                .foregroundStyle(Color.black)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                    }
                                }
                                
                                Divider()
                                
                                Group {
                                    HStack(alignment: .center) {
                                        Group {
                                            Text("Day")
                                                .font(.system(size: 17, weight: .semibold))
                                                .foregroundStyle(Color.black)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            Text("Night")
                                                .font(.system(size: 17, weight: .semibold))
                                                .foregroundStyle(Color.black)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            Text("Total Time")
                                                .font(.system(size: 17, weight: .semibold))
                                                .foregroundStyle(Color.black)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                    }.padding(.bottom, 4)

                                    HStack(alignment: .center) {
                                        Group {
                                            Text("TODO")
                                                .font(.system(size: 17, weight: .regular))
                                                .foregroundStyle(Color.black)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            Text("TODO")
                                                .font(.system(size: 17, weight: .regular))
                                                .foregroundStyle(Color.black)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            Text(calculateDateTime(chocksOffUTC, chocksOnUTC))
                                                .font(.system(size: 17, weight: .regular))
                                                .foregroundStyle(Color.black)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                    }
                                }
                            }
                        }.listRowBackground(Color.theme.antiFlashWhite)
                        
                        Section(header:
                                    Text("Crew")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(Color.black)
                        ) {
                            // grouped row using hstack
                            VStack(alignment: .leading) {
                                HStack(alignment: .center) {
                                    Text("CA")
                                        .foregroundStyle(Color.blue).font(.system(size: 15, weight: .medium))
                                        .frame(width: proxy.size.width / 4, alignment: .leading)
                                    Text("Caleb")
                                        .font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                        .frame(width: proxy.size.width / 4, alignment: .leading)
                                    HStack {
                                        Picker("", selection: $selectedCA) {
                                            ForEach(SummaryDataDropDown.allCases, id: \.self) {
                                                Text($0.rawValue).tag($0.rawValue)
                                            }
                                        }.pickerStyle(MenuPickerStyle()).fixedSize()
                                        Spacer()
                                    }.fixedSize()
                                }
                                
                                Divider()
                                
                                HStack(alignment: .center) {
                                    Text("FO")
                                        .foregroundStyle(Color.blue).font(.system(size: 15, weight: .medium))
                                        .frame(width: proxy.size.width / 4, alignment: .leading)
                                    Text("Danial")
                                        .font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                        .frame(width: proxy.size.width / 4, alignment: .leading)
                                    HStack {
                                        Picker("", selection: $selectedFO) {
                                            ForEach(SummaryDataDropDown.allCases, id: \.self) {
                                                Text($0.rawValue).tag($0.rawValue)
                                            }
                                        }.pickerStyle(MenuPickerStyle()).fixedSize()
                                        Spacer()
                                    }.fixedSize()
                                }
                                
                                Divider()
                                
                                VStack {
                                    HStack {
                                        HStack(alignment: .center) {
                                            Text("CIC")
                                                .foregroundStyle(Color.blue).font(.system(size: 15, weight: .medium))
                                            Text("Adam")
                                                .font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                        }.frame(width: proxy.size.width / 4, alignment: .leading)
                                            .padding(.trailing, 4)
                                        
                                        HStack(alignment: .center) {
                                            Text("CL")
                                                .foregroundStyle(Color.blue).font(.system(size: 15, weight: .medium))
                                            Text("Amanda")
                                                .font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                        }.frame(width: proxy.size.width / 4, alignment: .leading)
                                            .padding(.trailing, 4)
                                        
                                        HStack(alignment: .center) {
                                            Text("CL")
                                                .foregroundStyle(Color.blue).font(.system(size: 15, weight: .medium))
                                            Text("Bryan")
                                                .font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                        }.frame(width: proxy.size.width / 4, alignment: .leading)
                                    }
                                    
                                    Divider()
                                    
                                    HStack {
                                        HStack(alignment: .center) {
                                            Text("CIC")
                                                .foregroundStyle(Color.blue).font(.system(size: 15, weight: .medium))
                                            Text("Aliza")
                                                .font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                        }.frame(width: proxy.size.width / 4, alignment: .leading)
                                            .padding(.trailing, 4)
                                        
                                        HStack(alignment: .center) {
                                            Text("CL")
                                                .foregroundStyle(Color.blue).font(.system(size: 15, weight: .medium))
                                            Text("Pree")
                                                .font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                        }.frame(width: proxy.size.width / 4, alignment: .leading)
                                            .padding(.trailing, 4)
                                        
                                        HStack(alignment: .center) {
                                            Text("CL")
                                                .foregroundStyle(Color.blue).font(.system(size: 15, weight: .medium))
                                            Text("Firdaus")
                                                .font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                        }.frame(width: proxy.size.width / 4, alignment: .leading)
                                    }
                                    
                                    Divider()
                                    
                                    HStack {
                                        HStack(alignment: .center) {
                                            Text("CIC")
                                                .foregroundStyle(Color.blue).font(.system(size: 15, weight: .medium))
                                            Text("Ben")
                                                .font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                        }.frame(width: proxy.size.width / 4, alignment: .leading)
                                            .padding(.trailing, 4)
                                        
                                        HStack(alignment: .center) {
                                            Text("CL")
                                                .foregroundStyle(Color.blue).font(.system(size: 15, weight: .medium))
                                            Text("Sarah")
                                                .font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                        }.frame(width: proxy.size.width / 4, alignment: .leading)
                                            .padding(.trailing, 4)
                                        
                                        HStack(alignment: .center) {
                                            Text("CL")
                                                .foregroundStyle(Color.blue).font(.system(size: 15, weight: .medium))
                                            Text("Michael")
                                                .font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                        }
                                    }
                                }
                            }
                        }.listRowBackground(Color.theme.antiFlashWhite)
                        
                        Section {
                            // grouped row using hstack
                            VStack(alignment: .leading) {
                                HStack(alignment: .center) {
                                    Group {
                                        Text("Route")
                                            .font(.system(size: 17, weight: .semibold))
                                            .foregroundStyle(Color.black)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            pasteboard.string = coreDataModel.dataSummaryRoute.unwrappedRoute
                                        }) {
                                            Text("Copy")
                                                .font(.system(size: 17, weight: .regular))
                                                .foregroundColor(Color.white)
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 4)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .stroke(Color.init(
                                                            Color.RGBColorSpace.sRGB, red: 0, green: 0, blue: 0, opacity: 0.1), lineWidth: 0)
                                                )
                                        }.padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Color.theme.azure)
                                            .cornerRadius(12)
                                            .border(Color.theme.azure, width: 1, cornerRadius: 12)
                                            .buttonStyle(PlainButtonStyle())
                                    }
                                }
                                Divider()
                                HStack(alignment: .center) {
                                    Group {
                                        Text(coreDataModel.dataSummaryRoute.unwrappedRoute)
                                            .font(.system(size: 17, weight: .regular))
                                            .foregroundStyle(Color.black)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                            }
                        }.listRowBackground(Color.theme.antiFlashWhite)
                    }.listStyle(.insetGrouped)
                        .padding(.leading, -16)
                        .padding(.trailing, -16)
                        .scrollContentBackground(.hidden)
                }.padding()
            }.navigationBarBackButtonHidden()
                .ignoresSafeArea()
                .onAppear {
                    selectedCA = SummaryDataDropDown(rawValue: coreDataModel.dataSummaryInfo.unwrappedCrewCA) ?? SummaryDataDropDown.pic
                    selectedFO = SummaryDataDropDown(rawValue: coreDataModel.dataSummaryInfo.unwrappedCrewFO) ?? SummaryDataDropDown.pic
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
        }
    }
}

//struct FlightInformationDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        FlightInformationDetailView()
//    }
//}
