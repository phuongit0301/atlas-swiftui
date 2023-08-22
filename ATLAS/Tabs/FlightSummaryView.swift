//
//  FlightSummaryView.swift
//  ATLAS
//
//  Created by phuong phan on 22/08/2023.
//

import SwiftUI
import Combine

struct FlightSummaryView: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController
    @State private var selectedCA = SummaryDataDropDown.pic
    @State private var selectedFO = SummaryDataDropDown.pic
    @State private var pob: String = ""
    @State private var showUTC = true
    
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
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    Text("Flight Summary")
                        .font(.system(size: 20, weight: .semibold))
                    
                    Spacer().frame(maxWidth: .infinity)
                    
                    HStack {
                        Toggle(isOn: $showUTC) {
                            Text("Local").font(.system(size: 17, weight: .regular))
                                .foregroundStyle(Color.black)
                        }
                        Text("UTC").font(.system(size: 17, weight: .regular))
                            .foregroundStyle(Color.black)
                    }.fixedSize(horizontal: true, vertical: false)
                    
                }.padding(.vertical)
                    .padding(.horizontal, 30)
                // End header
                List {
                    Section(header:
                                Text("Flight info")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Color.black)
                    ) {
                        VStack(spacing: 12) {
                            HStack {
                                Group {
                                    Text("Callsign").frame(width: calculateWidth(proxy.size.width - 65, 4), alignment: .leading)
                                    Text("Sector").frame(width: calculateWidth(proxy.size.width - 65, 4), alignment: .leading)
                                    Text("Aircraft").frame(width: calculateWidth(proxy.size.width - 65, 4), alignment: .leading)
                                    Text("POB").frame(width: calculateWidth(proxy.size.width - 65, 4), alignment: .leading)
                                }
                                .foregroundStyle(Color.blue)
                                .font(.system(size: 15, weight: .medium))
                            }
                            HStack {
                                Group {
                                    Text(coreDataModel.dataSummaryInfo.unwrappedFltNo).frame(width: calculateWidth(proxy.size.width - 65, 4), alignment: .leading)
                                    Text("\(coreDataModel.dataSummaryInfo.unwrappedDep+" / "+coreDataModel.dataSummaryInfo.unwrappedDest)").frame(width: calculateWidth(proxy.size.width - 65, 4), alignment: .leading)
                                    Text(coreDataModel.dataSummaryInfo.unwrappedTailNo).frame(width: calculateWidth(proxy.size.width - 65, 4), alignment: .leading)
                                    
                                    TextField(
                                        "POB",
                                        text: $pob
                                    )
                                    .keyboardType(.numberPad)
                                    .onReceive(Just(pob)) { output in
                                        let newOutput = output.filter { "0123456789".contains($0) }
                                        pob = String(newOutput.prefix(3))
                                    }
                                    .onSubmit {
                                        if coreDataModel.existDataSummaryInfo {
                                            coreDataModel.dataSummaryInfo.pob = pob
                                        } else {
                                            let item = SummaryInfoList(context: persistenceController.container.viewContext)
                                            item.pob = pob
                                        }
                                        coreDataModel.save()
                                        coreDataModel.readSummaryInfo()
                                    }
                                    .frame(width: calculateWidth(proxy.size.width - 65, 4), alignment: .leading)
                                }.font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                            }
                        }
                    }// end section Flight Info
                    
                    Section(header:
                                Text("Planned times")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Color.black)
                    ) {
                        VStack(spacing: 16) {
                            VStack(spacing: 12) {
                                HStack {
                                    Group {
                                        Text("STD").frame(width: calculateWidth(proxy.size.width - 65, 2), alignment: .leading)
                                        Text("STA").frame(width: calculateWidth(proxy.size.width - 65, 2), alignment: .leading)
                                    }
                                    .foregroundStyle(Color.blue)
                                    .font(.system(size: 15, weight: .medium))
                                }
                                
                                HStack {
                                    Group {
                                        Text(showUTC ? coreDataModel.dataSummaryInfo.unwrappedStdUTC : coreDataModel.dataSummaryInfo.unwrappedStdLocal).frame(width: calculateWidth(proxy.size.width - 65, 2), alignment: .leading)
                                        Text(showUTC ? coreDataModel.dataSummaryInfo.unwrappedStaUTC : coreDataModel.dataSummaryInfo.unwrappedStaLocal).frame(width: calculateWidth(proxy.size.width - 65, 2), alignment: .leading)
                                    }.font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                }
                            }.padding(.leading, -5)
                            
                            VStack(spacing: 12) {
                                HStack {
                                    Group {
                                        Text("Block Time").frame(width: calculateWidth(proxy.size.width - 65, 3), alignment: .leading)
                                        Text("Flight Time").frame(width: calculateWidth(proxy.size.width - 65, 3), alignment: .leading)
                                        Text("Block Time - Flight Time").frame(width: calculateWidth(proxy.size.width - 65, 3), alignment: .leading)
                                    }
                                    .foregroundStyle(Color.blue)
                                    .font(.system(size: 15, weight: .medium))
                                }
                                
                                HStack {
                                    Group {
                                        Text(coreDataModel.dataSummaryInfo.unwrappedBlkTime).frame(width: calculateWidth(proxy.size.width - 65, 3), alignment: .leading)
                                        Text(coreDataModel.dataSummaryInfo.unwrappedFltTime).frame(width: calculateWidth(proxy.size.width - 65, 3), alignment: .leading)
                                        Text(calculateTime(coreDataModel.dataSummaryInfo.unwrappedFltTime, coreDataModel.dataSummaryInfo.unwrappedBlkTime)).frame(width: calculateWidth(proxy.size.width - 65, 3), alignment: .leading)
                                    }
                                    .font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                }
                            }
                            
                            VStack(spacing: 12) {
                                HStack {
                                    Group {
                                        Text("Chocks Off").frame(width: calculateWidth(proxy.size.width - 65, 3), alignment: .leading)
                                        Text("ETA").frame(width: calculateWidth(proxy.size.width - 65, 3), alignment: .leading)
                                        Text("Chocks On").frame(width: calculateWidth(proxy.size.width - 65, 3), alignment: .leading)
                                    }
                                    .foregroundStyle(Color.blue)
                                    .font(.system(size: 15, weight: .medium))
                                }
                                
                                HStack {
                                    Group {
                                        Text(showUTC ? chocksOffUTC : chocksOffLocal).frame(width: calculateWidth(proxy.size.width - 65, 3), alignment: .leading)
                                        Text(showUTC ? etaUTC : etaLocal).frame(width: calculateWidth(proxy.size.width - 65, 3), alignment: .leading)
                                        Text(showUTC ? chocksOnUTC : chocksOnLocal).frame(width: calculateWidth(proxy.size.width - 65, 3), alignment: .leading)
                                    }.font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                }
                            }
                        }
                    }// end section ETA
                    
                    Section(header:
                                Text("Actual Times")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Color.black)
                    ) {
                        VStack(spacing: 16) {
                            HStack {
                                Group {
                                    Text("Day").frame(width: calculateWidth(proxy.size.width - 65, 3), alignment: .leading)
                                    Text("Night").frame(width: calculateWidth(proxy.size.width - 65, 3), alignment: .leading)
                                    Text("Total Time").frame(width: calculateWidth(proxy.size.width - 65, 3), alignment: .leading)
                                }
                                .foregroundStyle(Color.blue)
                                .font(.system(size: 15, weight: .medium))
                            }
                            
                            HStack {
                                Group {
                                    Text("TODO").frame(width: calculateWidth(proxy.size.width - 65, 3), alignment: .leading)
                                    Text("TODO").frame(width: calculateWidth(proxy.size.width - 65, 3), alignment: .leading)
                                    Text(calculateDateTime(showUTC ? chocksOffUTC : chocksOffLocal, showUTC ? chocksOnUTC : chocksOnLocal)).frame(width: calculateWidth(proxy.size.width - 65, 3), alignment: .leading)
                                }
                                .font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                            }
                        }
                    }
                    
                    Section(header:
                                Text("Crew")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Color.black)
                    ) {
                        VStack(spacing: 16) {
                            Group {
                                HStack {
                                    HStack {
                                        Text("CA Caleb")
                                        HStack {
                                            Picker("", selection: $selectedCA) {
                                                ForEach(SummaryDataDropDown.allCases, id: \.self) {
                                                    Text($0.rawValue).tag($0.rawValue)
                                                }
                                            }.pickerStyle(MenuPickerStyle()).fixedSize()
                                            Spacer()
                                        }.fixedSize()
                                    }.frame(width: (proxy.size.width - 95) / 2, alignment: .leading)
                                    
                                    HStack {
                                        Text("FO Danial")
                                        HStack {
                                            Picker("", selection: $selectedFO) {
                                                ForEach(SummaryDataDropDown.allCases, id: \.self) {
                                                    Text($0.rawValue).tag($0.rawValue)
                                                }
                                            }.pickerStyle(MenuPickerStyle()).fixedSize()
                                        }.fixedSize()
                                    }.frame(width: (proxy.size.width - 95) / 2, alignment: .leading)
                                }
                            }// end group
                            
                            Group {
                                HStack {
                                    HStack {
                                        Text("CIC").foregroundStyle(Color.blue).font(.system(size: 15, weight: .medium))
                                        Text("Adam").font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                    }.frame(width: calculateWidth(proxy.size.width, 3), alignment: .leading)
                                    
                                    HStack {
                                        Text("CL").foregroundStyle(Color.blue).font(.system(size: 15, weight: .medium))
                                        Text("Amanda").font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                    }.frame(width: calculateWidth(proxy.size.width, 3), alignment: .leading)
                                    
                                    HStack {
                                        Text("CL").foregroundStyle(Color.blue).font(.system(size: 15, weight: .medium))
                                        Text("Bryan").font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                    }.frame(width: calculateWidth(proxy.size.width, 3), alignment: .leading)
                                }
                            }// end group
                            
                            Group {
                                HStack {
                                    HStack {
                                        Text("CC").foregroundStyle(Color.blue).font(.system(size: 15, weight: .medium))
                                        Text("Aliza").font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                    }.frame(width: calculateWidth(proxy.size.width, 3), alignment: .leading)
                                    
                                    HStack {
                                        Text("CC").foregroundStyle(Color.blue).font(.system(size: 15, weight: .medium))
                                        Text("Pree").font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                    }.frame(width: calculateWidth(proxy.size.width, 3), alignment: .leading)
                                    
                                    HStack {
                                        Text("CC").foregroundStyle(Color.blue).font(.system(size: 15, weight: .medium))
                                        Text("Firdaus").font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                    }.frame(width: calculateWidth(proxy.size.width, 3), alignment: .leading)
                                }
                            }// end group
                            
                            Group {
                                HStack {
                                    HStack {
                                        Text("CC").foregroundStyle(Color.blue).font(.system(size: 15, weight: .medium))
                                        Text("Ben").font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                    }.frame(width: calculateWidth(proxy.size.width, 3), alignment: .leading)
                                    
                                    HStack {
                                        Text("CC").foregroundStyle(Color.blue).font(.system(size: 15, weight: .medium))
                                        Text("Sarah").font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                    }.frame(width: calculateWidth(proxy.size.width, 3), alignment: .leading)
                                    
                                    HStack {
                                        Text("CC").foregroundStyle(Color.blue).font(.system(size: 15, weight: .medium))
                                        Text("Michael").font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                    }.frame(width: calculateWidth(proxy.size.width, 3), alignment: .leading)
                                }
                            }// end group
                        }
                    }// END CREW
                }// end List
            }// end VStack
            .onAppear {
                selectedCA = SummaryDataDropDown(rawValue: coreDataModel.dataSummaryInfo.unwrappedCrewCA) ?? SummaryDataDropDown.pic
                selectedFO = SummaryDataDropDown(rawValue: coreDataModel.dataSummaryInfo.unwrappedCrewFO) ?? SummaryDataDropDown.pic
                pob = coreDataModel.dataSummaryInfo.unwrappedPob
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

struct FlightSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        FlightSummaryView()
    }
}
