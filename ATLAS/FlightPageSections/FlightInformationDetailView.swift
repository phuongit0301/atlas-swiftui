//
//  FlightInformationView.swift
//  ATLAS
//
//  Created by phuong phan on 06/07/2023.
//

import SwiftUI

struct FlightInformationDetailView: View {
    @State private var showUTC = true
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @State var pasteboard = UIPasteboard.general
    @State private var selectedCm1 = SummaryDataDropDown.pic
    @State private var selectedCm2 = SummaryDataDropDown.pic
    
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
            VStack {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .center) {
                        Text("Flight Summary")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(Color.black)
                        
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
                        Section {
                            // grouped row using hstack
                            VStack(alignment: .leading) {
                                HStack(alignment: .center) {
                                    Group {
                                        Text("Chocks Off")
                                            .font(.system(size: 17, weight: .semibold))
                                            .foregroundStyle(Color.black)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Text("Chocks On")
                                            .font(.system(size: 17, weight: .semibold))
                                            .foregroundStyle(Color.black)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                                Divider()
                                HStack(alignment: .center) {
                                    Group {
                                        Text(showUTC ? chocksOffUTC : chocksOffLocal)
                                        //Text(coreDataModel.dataDepartureEntries.unwrappedEntOff)
                                            .font(.system(size: 17, weight: .regular))
                                            .foregroundStyle(Color.black)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Text(showUTC ? chocksOnUTC : chocksOnLocal)
                                        //Text(coreDataModel.dataArrivalEntries.unwrappedEntOn)
                                            .font(.system(size: 17, weight: .regular))
                                            .foregroundStyle(Color.black)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                            }
                        }.listRowBackground(Color.theme.antiFlashWhite)
                        
                        Section {
                            // grouped row using hstack
                            VStack(alignment: .leading) {
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
                                        Text("ETA")
                                            .font(.system(size: 17, weight: .semibold))
                                            .foregroundStyle(Color.black)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                                Divider()
                                HStack(alignment: .center) {
                                    Group {
                                        //coreDataModel.dataDepartureEntries.stdUTC
                                        Text(showUTC ? coreDataModel.dataSummaryInfo.unwrappedStdUTC : coreDataModel.dataSummaryInfo.unwrappedStdLocal)
                                            .font(.system(size: 17, weight: .regular))
                                            .foregroundStyle(Color.black)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Text(showUTC ? coreDataModel.dataSummaryInfo.unwrappedStaUTC : coreDataModel.dataSummaryInfo.unwrappedStaLocal)
                                            .font(.system(size: 17, weight: .regular))
                                            .foregroundStyle(Color.black)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Text(showUTC ? etaUTC : etaLocal)
                                        //Text(eta)
                                            .font(.system(size: 17, weight: .regular))
                                            .foregroundStyle(Color.black)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                            }
                        }.listRowBackground(Color.theme.antiFlashWhite)
                        
                        Section {
                            // grouped row using hstack
                            VStack(alignment: .leading) {
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
                                }
                                Divider()
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
                        }.listRowBackground(Color.theme.antiFlashWhite)
                        
                        Section {
                            // grouped row using hstack
                            VStack(alignment: .leading) {
                                HStack(alignment: .center) {
                                    Group {
                                        Text("POB")
                                            .font(.system(size: 17, weight: .semibold))
                                            .foregroundStyle(Color.black)
                                            .frame(width: (proxy.size.width - 200) / 3, alignment: .leading)
                                        Text("CM1")
                                            .font(.system(size: 17, weight: .semibold))
                                            .foregroundStyle(Color.black)
                                            .frame(width: (proxy.size.width - 200) / 3, alignment: .leading)
                                            .padding(.leading, 16)
                                        Text("CM2")
                                            .font(.system(size: 17, weight: .semibold))
                                            .foregroundStyle(Color.black)
                                            .frame(width: (proxy.size.width - 200) / 3, alignment: .leading)
                                    }
                                }
                                Divider()
                                HStack(alignment: .center) {
                                    Group {
                                        Text(coreDataModel.dataSummaryInfo.unwrappedPob)
                                            .font(.system(size: 17, weight: .regular))
                                            .foregroundStyle(Color.black)
                                            .frame(width: (proxy.size.width - 200) / 3, alignment: .leading)
                                        HStack {
                                            Picker("", selection: $selectedCm1) {
                                                ForEach(SummaryDataDropDown.allCases, id: \.self) {
                                                    Text($0.rawValue).tag($0.rawValue)
                                                }
                                            }.pickerStyle(MenuPickerStyle()).fixedSize()
                                            Spacer()
                                        }.frame(width: (proxy.size.width - 200) / 3)
                                        
                                        HStack {
                                            Picker("", selection: $selectedCm2) {
                                                ForEach(SummaryDataDropDown.allCases, id: \.self) {
                                                    Text($0.rawValue).tag($0.rawValue)
                                                }
                                            }.pickerStyle(MenuPickerStyle()).fixedSize()
                                            Spacer()
                                        }.frame(width: (proxy.size.width - 200) / 3)
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
                        .scrollContentBackground(.hidden)
                        .padding(.leading, -16)
                        .padding(.trailing, -16)
                }.padding(.top, 32)
                    .onAppear {
                        selectedCm1 = SummaryDataDropDown(rawValue: coreDataModel.dataSummaryInfo.unwrappedCm1) ?? SummaryDataDropDown.pic
                        selectedCm2 = SummaryDataDropDown(rawValue: coreDataModel.dataSummaryInfo.unwrappedCm2) ?? SummaryDataDropDown.pic
                    }
                    .onChange(of: selectedCm1) { value in
                        if coreDataModel.existDataSummaryInfo {
                            coreDataModel.dataSummaryInfo.cm1 = value.rawValue
                            coreDataModel.save()
                        }
                    }
                    .onChange(of: selectedCm2) { value in
                        if coreDataModel.existDataSummaryInfo {
                            coreDataModel.dataSummaryInfo.cm2 = value.rawValue
                            coreDataModel.save()
                        }
                    }
            }
        }
    }
    
    func parseDate(from dateString: String, with formatter: DateFormatter) -> Date? {
        // split date to array and join to new format
        let arr = dateString.components(separatedBy: " | ")
        if arr.count > 0 {
            let dateMonth = arr[0].components(separatedBy: "/")
            let currentYear = Calendar.current.component(.year, from: Date())
            let formattedDateString = "\(currentYear)-\(dateMonth[1])-\(dateMonth[0]) \(arr[1])"
            
            return formatter.date(from: formattedDateString);
        }
        
        let currentDate = formatter.string(from: Date())
        
        return formatter.date(from: currentDate)
    }
}

struct FlightInformationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FlightInformationDetailView()
    }
}
