//
//  OverviewSubSectionView.swift
//  ATLAS
//
//  Created by phuong phan on 21/09/2023.
//

import SwiftUI

struct IData: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var date: String
    var time: String
    var color: String
}

let MOCK_DATA = [
    IData(id: UUID(), name: "Max 900 flight hours in 365 days", date: "DD/MM/YY to DD/MM/YY", time: "922:47 / 900:00", color: "red"),
    IData(id: UUID(), name: "Max 20 flight hours in 30 days", date: "DD/MM/YY to DD/MM/YY", time: "922:47 / 900:00", color: "yellow"),
]

struct IDataTime: Identifiable, Hashable {
    var id = UUID()
    var total: String
    var pic1: String
    var pic2: String
    var p1: String
    var p2: String
    var instr: String
    var exam: String
    var totalTime: String
}


let MOCK_DATA_TIME = [
    IDataTime(id: UUID(), total: "B777-300ER/SF", pic1: "H,HHH:MM", pic2: "H,HHH:MM", p1: "H,HHH:MM", p2: "H,HHH:MM", instr: "HH:MM", exam: "HH:MM", totalTime: "H,HHH:MM"),
    IDataTime(id: UUID(), total: "A320-200", pic1: "H,HHH:MM", pic2: "H,HHH:MM", p1: "H,HHH:MM", p2: "H,HHH:MM", instr: "HH:MM", exam: "HH:MM", totalTime: "H,HHH:MM"),
    IDataTime(id: UUID(), total: "A350-1000", pic1: "H,HHH:MM", pic2: "H,HHH:MM", p1: "H,HHH:MM", p2: "H,HHH:MM", instr: "HH:MM", exam: "HH:MM", totalTime: "H,HHH:MM"),
]

struct OverviewSubSectionView: View {
    @Environment(\.calendar) var calendar
    @Environment(\.timeZone) var timeZone
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @ObservedObject var logbookDropDown = LogbookDropDown()
    let formatter = DateFormatter()
    @State var isCollapse = false
    @State private var selectedDates: Set<DateComponents> = []
    @State private var selectedDatesFormatted: Set<DateComponents> = []
    
    @State private var selectedDate: String = "Selected Date"
    @State private var selectedStartDate: String = ""
    @State private var selectedEndDate: String = ""
    @State private var selectedDayNight: String = ""
    @State private var selectedAircraft = ""
    @State private var isShowModal: Bool = false
    @State private var isShowDateModal: Bool = false
    
    @State private var dataTable = [ILobookTotalTimeDataResponse]()
    @State private var dataTotalTime = [String: [String: Int]]()
    @State private var dataLogbookEntries = [String]()
    
    @State private var isLoading = false
    @State private var firstLoading = true
    
    @State var dataLimitation: [ILimitationResult] = []

    var body: some View {
        GeometryReader { proxy in
            HStack(spacing: 0) {
                if isLoading {
                    ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.white)).padding(.leading)
                } else {
                    List {
                        Section {
                            VStack(alignment: .leading, spacing: 0) {
                                HStack {
                                    HStack(alignment: .center) {
                                        Text("Approaching Limitations").font(.system(size: 17, weight: .semibold)).foregroundStyle(Color.black)
                                        
                                        Button(action: {
                                            self.isCollapse.toggle()
                                        }, label: {
                                            if isCollapse {
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
                                            
                                        }).buttonStyle(PlainButtonStyle())
                                    }
                                    
                                    Spacer()
                                    
//                                    Button(action: {
//                                        // ToDo
//                                    }, label: {
//                                        Text("See All")
//                                            .font(.system(size: 17, weight: .regular)).textCase(nil)
//                                            .foregroundColor(Color.theme.azure)
//                                    }).buttonStyle(PlainButtonStyle())
                                }.contentShape(Rectangle())
                                    .padding()
                                
                                if !isCollapse {
                                    VStack(alignment: .leading) {
                                        Grid(alignment: .topLeading, horizontalSpacing: 8, verticalSpacing: 12) {
                                            GridRow {
                                                Text("Limitation")
                                                    .font(.system(size: 15, weight: .medium))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                                
                                                Text("Period")
                                                    .font(.system(size: 15, weight: .medium))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                                
                                                Text("Status")
                                                    .font(.system(size: 15, weight: .medium))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                            }
                                            
                                            Divider().padding(.horizontal, -16)
                                            
                                            if dataLimitation.count == 0 {
                                                GridRow {
                                                    Group {
                                                        Text("No limitations")
                                                            .font(.system(size: 15, weight: .regular))
                                                            .frame(alignment: .leading)
                                                    }.frame(height: 44)
                                                }
                                            }
                                            ForEach(dataLimitation.indices, id: \.self) {index in
                                                GridRow {
                                                    Group {
                                                        Text(dataLimitation[index].text)
                                                            .font(.system(size: 15, weight: .regular))
                                                            .frame(alignment: .leading)
                                                        
                                                        Text(dataLimitation[index].period)
                                                            .font(.system(size: 15, weight: .regular))
                                                            .frame(alignment: .leading)
                                                        
                                                        Text(dataLimitation[index].status)
                                                            .font(.system(size: 15, weight: .regular))
                                                            .frame(alignment: .leading)
                                                    }.foregroundColor(fontColor(dataLimitation[index].color))
                                                }
                                                
                                                if index + 1 < dataLimitation.count {
                                                    Divider().padding(.horizontal, -16)
                                                }
                                            }
                                        }
                                    }.padding()
                                }
                                
                            }.listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                        } // End Sectionnpx
                        
                        Section {
                            VStack(alignment: .leading, spacing: 0) {
                                HStack {
                                    HStack(alignment: .center) {
                                        Text("Total Function Time").font(.system(size: 17, weight: .semibold)).foregroundStyle(Color.black)
                                    }
                                    
                                    Spacer()
                                    
                                    HStack(spacing: 16) {
                                        CommonStepper(onToggle: onToggleDate, value: $selectedDate, suffix: "").fixedSize()
                                        
                                        Picker("", selection: $selectedAircraft) {
                                            Text("All Aircraft").tag("")
                                            ForEach(dataLogbookEntries, id: \.self) {
                                                Text($0).tag($0)
                                            }
                                        }.pickerStyle(MenuPickerStyle()).fixedSize()
                                        
                                        Picker("", selection: $selectedDayNight) {
                                            ForEach(logbookDropDown.dataDayNight, id: \.self) {
                                                Text($0).tag($0)
                                            }
                                        }.pickerStyle(MenuPickerStyle()).fixedSize()
                                    }
                                }.contentShape(Rectangle())
                                    .padding()
                                
                                if !isCollapse {
                                    VStack(alignment: .leading) {
                                        Grid(alignment: .topLeading, horizontalSpacing: 16, verticalSpacing: 16) {
                                            GridRow {
                                                Text("Aircraft Model")
                                                    .font(.system(size: 15, weight: .medium))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                                
                                                Text("PIC")
                                                    .font(.system(size: 15, weight: .medium))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                                
                                                Text("PIC(u/us)")
                                                    .font(.system(size: 15, weight: .medium))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                                
                                                Text("P1")
                                                    .font(.system(size: 15, weight: .medium))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                                
                                                Text("P2")
                                                    .font(.system(size: 15, weight: .medium))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                                
                                                Text("Instr")
                                                    .font(.system(size: 15, weight: .medium))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                                
                                                Text("Exam")
                                                    .font(.system(size: 15, weight: .medium))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                                
                                                Text("Total Time (P1+P2)")
                                                    .font(.system(size: 15, weight: .medium))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                            }
                                            
                                            Divider().padding(.horizontal, -16)
                                                                                        
                                            GridRow {
                                                Text("Total")
                                                    .font(.system(size: 17, weight: .semibold))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)

                                                Text(seconds2Timestamp(dataTotalTime["total"]?["pic"] ?? 0))
                                                    .font(.system(size: 17, weight: .semibold))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)

                                                Text(seconds2Timestamp(dataTotalTime["total"]?["picUs"] ?? 0))
                                                    .font(.system(size: 17, weight: .semibold))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)

                                                Text(seconds2Timestamp(dataTotalTime["total"]?["p1"] ?? 0))
                                                    .font(.system(size: 17, weight: .semibold))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)

                                                Text(seconds2Timestamp(dataTotalTime["total"]?["p2"] ?? 0))
                                                    .font(.system(size: 17, weight: .semibold))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)

                                                Text(seconds2Timestamp(dataTotalTime["total"]?["instr"] ?? 0))
                                                    .font(.system(size: 17, weight: .semibold))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)

                                                Text(seconds2Timestamp(dataTotalTime["total"]?["exam"] ?? 0))
                                                    .font(.system(size: 17, weight: .semibold))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)

                                                Text(seconds2Timestamp((dataTotalTime["total"]?["p1"] ?? 0) + (dataTotalTime["total"]?["p2"] ?? 0)))
                                                    .font(.system(size: 17, weight: .semibold))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                            }

                                            Divider().padding(.horizontal, -16)
                                            
                                            ForEach(dataTable.indices, id: \.self) {index in
                                                GridRow {
                                                    Text(dataTable[index].aircraftType)
                                                        .font(.system(size: 17, weight: .regular))
                                                        .foregroundColor(Color.black)
                                                        .frame(alignment: .leading)
                                                    
                                                    Text("\(dataTable[index].pic)")
                                                        .font(.system(size: 17, weight: .regular))
                                                        .foregroundColor(Color.black)
                                                        .frame(alignment: .leading)
                                                    
                                                    Text("\(dataTable[index].picUUs)")
                                                        .font(.system(size: 17, weight: .regular))
                                                        .foregroundColor(Color.black)
                                                        .frame(alignment: .leading)
                                                    
                                                    Text("\(dataTable[index].p1)")
                                                        .font(.system(size: 17, weight: .regular))
                                                        .foregroundColor(Color.black)
                                                        .frame(alignment: .leading)
                                                    
                                                    Text("\(dataTable[index].p2)")
                                                        .font(.system(size: 17, weight: .regular))
                                                        .foregroundColor(Color.black)
                                                        .frame(alignment: .leading)
                                                    
                                                    Text("\(dataTable[index].instr)")
                                                        .font(.system(size: 17, weight: .regular))
                                                        .foregroundColor(Color.black)
                                                        .frame(alignment: .leading)
                                                    
                                                    Text("\(dataTable[index].exam)")
                                                        .font(.system(size: 17, weight: .regular))
                                                        .foregroundColor(Color.black)
                                                        .frame(alignment: .leading)
                                                    
                                                    Text("\(dataTable[index].totalTime)")
                                                        .font(.system(size: 17, weight: .regular))
                                                        .foregroundColor(Color.black)
                                                        .frame(alignment: .leading)
                                                }
                                                
                                                if index + 1 < dataTable.count {
                                                    Divider().padding(.horizontal, -16)
                                                }
                                                
                                            }
                                            
                                        }
                                        
                                    }.padding()
                                }
                            }.listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                        } // End Section
                    }// End List
                }
                
            }// End HStack
            .formSheet(isPresented: $isShowModal) {
                MultiDatePicker("Dates Available", selection: $selectedDates, in: .now...)
            }
            .sheet(isPresented: $isShowDateModal) {
                ModalDateRangeView(isShowing: $isShowDateModal, selectedDate: $selectedDate, selectedStartDate: $selectedStartDate, selectedEndDate: $selectedEndDate)
            }
            .onAppear {
                dateFormatter.dateFormat = "yyyy-MM-dd"
                selectedDayNight = logbookDropDown.dataDayNight.first ?? ""
                
                for row in coreDataModel.dataLogbookEntries {
                    if !dataLogbookEntries.contains(row.unwrappedAircraftType) {
                        dataLogbookEntries.append(row.unwrappedAircraftType)
                    }
                }
                
                let (earliestDate, latestDate) = findEarliestAndLatestDates(logbookEntries: coreDataModel.dataLogbookEntries)
                if let earliestDate = earliestDate, let latestDate = latestDate {
                    let dataArr = filterDataByAircraftType(coreDataModel.dataLogbookEntries, selectedAircraft)
                    let (dataTable, dataTotalTime) = prepareTableData(logbookEntries: dataArr, startDate: earliestDate, endDate: latestDate, dayNightFilter: selectedDayNight, previousTotalTimeData: coreDataModel.dataRecencyExperience)
                    
                    selectedStartDate = dateFormatter.string(from: earliestDate)
                    selectedEndDate = dateFormatter.string(from: latestDate)
                    selectedDate = "From \(selectedStartDate) to \(selectedEndDate)"
                    self.dataTable = dataTable
                    self.dataTotalTime = dataTotalTime
                    firstLoading = false
                }
                
                //Handle data limitation
                dataLimitation = checkLimitations(coreDataModel.dataLogbookEntries, coreDataModel.dataLogbookLimitation)
                dataLimitation = dataLimitation.filter { item in
                    return item.color == "red" || item.color == "amber"
                }
            }.onChange(of: selectedDate) {newValue in
                if !firstLoading {
                    dateFormatter.dateFormat = "yyyy-MM-dd"

                    if let earliestDate = dateFormatter.date(from: selectedStartDate), let latestDate = dateFormatter.date(from: selectedEndDate) {
                        let dataArr = filterDataByAircraftType(coreDataModel.dataLogbookEntries, selectedAircraft)
                        let (dataTable, dataTotalTime) = prepareTableData(logbookEntries: dataArr, startDate: earliestDate, endDate: latestDate, dayNightFilter: selectedDayNight, previousTotalTimeData: coreDataModel.dataRecencyExperience)
                        self.dataTable = dataTable
                        self.dataTotalTime = dataTotalTime
                    }


                }
            }.onChange(of: selectedDayNight) {newValue in
                if !firstLoading {
                    dateFormatter.dateFormat = "yyyy-MM-dd"

                    if let earliestDate = dateFormatter.date(from: selectedStartDate), let latestDate = dateFormatter.date(from: selectedEndDate) {
                        let dataArr = filterDataByAircraftType(coreDataModel.dataLogbookEntries, selectedAircraft)
                        let (dataTable, dataTotalTime) = prepareTableData(logbookEntries: dataArr, startDate: earliestDate, endDate: latestDate, dayNightFilter: newValue, previousTotalTimeData: coreDataModel.dataRecencyExperience)
                        self.dataTable = dataTable
                        self.dataTotalTime = dataTotalTime
                    }
                }
            }
            .onChange(of: selectedAircraft) {newValue in
                if !firstLoading {
                    dateFormatter.dateFormat = "yyyy-MM-dd"

                    if let earliestDate = dateFormatter.date(from: selectedStartDate), let latestDate = dateFormatter.date(from: selectedEndDate) {
                        let dataArr = filterDataByAircraftType(coreDataModel.dataLogbookEntries, newValue)
                        let (dataTable, dataTotalTime) = prepareTableData(logbookEntries: dataArr, startDate: earliestDate, endDate: latestDate, dayNightFilter: selectedDayNight, previousTotalTimeData: coreDataModel.dataRecencyExperience)
                        self.dataTable = dataTable
                        self.dataTotalTime = dataTotalTime
                    }
                }
            }
            
        }// End GeometryReader
    }
    
    func findEarliestAndLatestDates(logbookEntries: [LogbookEntriesList]) -> (earliestDate: Date?, latestDate: Date?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        var earliestDate: Date? = nil
        var latestDate: Date? = nil
        
        for entry in logbookEntries {
            if let dateString = entry.date,
               let entryDate = dateFormatter.date(from: dateString) {
                
                if earliestDate == nil || entryDate < earliestDate! {
                    earliestDate = entryDate
                }
                
                if latestDate == nil || entryDate > latestDate! {
                    latestDate = entryDate
                }
            }
        }
        
        return (earliestDate , latestDate)
    }
    
    func filterDataByAircraftType(_ data: [LogbookEntriesList], _ selectedAircraft: String) -> [LogbookEntriesList] {
        if selectedAircraft == "" {
            return data
        } else {
            var arr = [LogbookEntriesList]()
            
            for row in coreDataModel.dataLogbookEntries {
                if row.unwrappedAircraftType == selectedAircraft {
                    arr.append(row)
                }
            }
            
            return arr
        }
        
    }
    
    func prepareTableData(logbookEntries: [LogbookEntriesList], startDate: Date, endDate: Date, dayNightFilter: String, previousTotalTimeData: [RecencyExperienceList]) -> ([ILobookTotalTimeDataResponse], [String: [String: Int]]) {

        let dateFormatter = DateFormatter()
        let dateFormatter1 = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter1.dateFormat = "HH:mm:ss"
        
        // Initialize aircraftTypeTotals and rowTotals here
        var aircraftTypeTotals: [String: [String: Int]] = [:]
        var rowTotals: [String: [String: Int]] = [:]
        
        // Find the earliest date in logbookEntries
        var earliestLogbookEntryDate: Date? = logbookEntries.map { dateFormatter.date(from: $0.date ?? "")! }.min()
        
        // Check if the selected start date is before the earliest date
        if let earliestDate = earliestLogbookEntryDate, startDate < earliestDate {
            for entry in previousTotalTimeData {
                if var totals = aircraftTypeTotals[entry.unwrappedModel] {
                    totals["pic"] = (totals["pic"] ?? 0) + parseTime(entry.pic)
                    totals["picUs"] = (totals["picUs"] ?? 0) + parseTime(entry.picUs)
                    totals["p1"] = (totals["p1"] ?? 0) + parseTime(entry.p1)
                    totals["p2"] = (totals["p2"] ?? 0) + parseTime(entry.p2)
                    totals["instr"] = (totals["instr"] ?? 0) // Add logic for instr if needed
                    totals["exam"] = (totals["exam"] ?? 0) // Add logic for exam if needed
                    aircraftTypeTotals[entry.unwrappedModel] = totals
                } else {
                    aircraftTypeTotals[entry.unwrappedModel] = [
                        "pic": parseTime(entry.pic),
                        "picUs": parseTime(entry.picUs),
                        "p1": parseTime(entry.p1),
                        "p2": parseTime(entry.p2),
                        "instr": 0, // Add default value for instr if needed
                        "exam": 0 // Add default value for exam if needed
                    ]
                }
                
                // Add the previousTotalTimeData to rowTotals as well
                if var rowTotal = rowTotals["total"] {
                    rowTotal["pic"] = (rowTotal["pic"] ?? 0) + parseTime(entry.pic)
                    rowTotal["picUs"] = (rowTotal["picUs"] ?? 0) + parseTime(entry.picUs)
                    rowTotal["p1"] = (rowTotal["p1"] ?? 0) + parseTime(entry.p1)
                    rowTotal["p2"] = (rowTotal["p2"] ?? 0) + parseTime(entry.p2)
                    rowTotal["instr"] = (rowTotal["instr"] ?? 0) // Add logic for instr if needed
                    rowTotal["exam"] = (rowTotal["exam"] ?? 0) // Add logic for exam if needed
                    rowTotals["total"] = rowTotal
                } else {
                    rowTotals["total"] = [
                        "pic": parseTime(entry.pic),
                        "picUs": parseTime(entry.picUs),
                        "p1": parseTime(entry.p1),
                        "p2": parseTime(entry.p2),
                        "instr": 0, // Add default value for instr if needed
                        "exam": 0 // Add default value for exam if needed
                    ]
                }
            }
        }
        
        var filteredEntries = [ILobookTotalTimeData]()
        for entry in logbookEntries {
            if let dateString = entry.date, let entryDate = dateFormatter.date(from: dateString),
               entryDate >= startDate && entryDate <= endDate {
                let aircraftType = entry.unwrappedAircraftType
                let pic = calculateTotalTime(entry, dayNightFilter: dayNightFilter, timeKey: "pic")
                let picUs = calculateTotalTime(entry, dayNightFilter: dayNightFilter, timeKey: "picUUs")
                let p1 = calculateTotalTime(entry, dayNightFilter: dayNightFilter, timeKey: "p1")
                let p2 = calculateTotalTime(entry, dayNightFilter: dayNightFilter, timeKey: "p2")
                let instr = parseTime(entry.unwrappedInstr)
                let exam = parseTime(entry.unwrappedExam)
                
                let logbookEntry = ILobookTotalTimeData(aircraftType: aircraftType, pic: pic, picUUs: picUs, p1: p1, p2: p2, instr: instr, exam: exam, date: entryDate, totalTime: p1 + p2)
                
                filteredEntries.append(logbookEntry)
            }
        }
        
        for entry in filteredEntries {
            if var totals = aircraftTypeTotals[entry.aircraftType] {
                totals["pic"] = (totals["pic"] ?? 0) + entry.pic
                totals["picUs"] = (totals["picUs"] ?? 0) + entry.picUUs
                totals["p1"] = (totals["p1"] ?? 0) + entry.p1
                totals["p2"] = (totals["p2"] ?? 0) + entry.p2
                totals["instr"] = (totals["instr"] ?? 0) + entry.instr
                totals["exam"] = (totals["exam"] ?? 0) + entry.exam
                aircraftTypeTotals[entry.aircraftType] = totals
            } else {
                aircraftTypeTotals[entry.aircraftType] = [
                    "pic": entry.pic,
                    "picUs": entry.picUUs,
                    "p1": entry.p1,
                    "p2": entry.p2,
                    "instr": entry.instr,
                    "exam": entry.exam
                ]
            }
            
            if var rowTotal = rowTotals["total"] {
                rowTotal["pic"] = (rowTotal["pic"] ?? 0) + entry.pic
                rowTotal["picUs"] = (rowTotal["picUs"] ?? 0) + entry.picUUs
                rowTotal["p1"] = (rowTotal["p1"] ?? 0) + entry.p1
                rowTotal["p2"] = (rowTotal["p2"] ?? 0) + entry.p2
                rowTotal["instr"] = (rowTotal["instr"] ?? 0) + entry.instr
                rowTotal["exam"] = (rowTotal["exam"] ?? 0) + entry.exam
                rowTotals["total"] = rowTotal
            } else {
                rowTotals["total"] = [
                    "pic": entry.pic,
                    "picUs": entry.picUUs,
                    "p1": entry.p1,
                    "p2": entry.p2,
                    "instr": entry.instr,
                    "exam": entry.exam
                ]
            }
        }
        
        var tableData: [ILobookTotalTimeDataResponse] = []
        
        for (aircraftType, totals) in aircraftTypeTotals {
            let totalPic = seconds2Timestamp(totals["pic"]!)
            let totalPicUs = seconds2Timestamp(totals["picUs"]!)
            let totalP1 = seconds2Timestamp(totals["p1"]!)
            let totalP2 = seconds2Timestamp(totals["p2"]!)
            let totalInstr = seconds2Timestamp(totals["instr"]!)
            let totalExam = seconds2Timestamp(totals["exam"]!)
            let totalP1P2 = seconds2Timestamp(totals["p1"]! + totals["p2"]!)
            
            let tableRow = ILobookTotalTimeDataResponse(aircraftType: aircraftType, pic: totalPic, picUUs: totalPicUs, p1: totalP1, p2: totalP2, instr: totalInstr, exam: totalExam, totalTime: totalP1P2)
            tableData.append(tableRow)
        }
        
        return (tableData, rowTotals)
    }
    
    func onToggle() {
        self.isShowModal.toggle()
    }
    
    func onToggleDate() {
        self.isShowDateModal.toggle()
    }
    
    func datesRange(from: Date, to: Date) -> Set<DateComponents> {
        // in case of the "from" date is more than "to" date,
        // it should returns an empty array:
        if from > to { return Set<DateComponents>() }

        var tempDate = from
        var array: Set<DateComponents> = [Calendar.current.dateComponents([.year, .month, .day], from: tempDate)]
        
        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            let components = Calendar.current.dateComponents([.year, .month, .day], from: tempDate)
            array.insert(components)
        }

        return array
    }
    
    func calculateTotalTime(_ entry: LogbookEntriesList, dayNightFilter: String, timeKey: String) -> Int {
        var dayTime = parseTime(entry.unwrappedPicDay)
        var nightTime = parseTime(entry.unwrappedPicNight)
        
        if timeKey == "picUUs" {
            dayTime = parseTime(entry.unwrappedPicUUsDay)
            nightTime = parseTime(entry.unwrappedPicUUsNight)
        } else if timeKey == "p1" {
            dayTime = parseTime(entry.unwrappedP1Day)
            nightTime = parseTime(entry.unwrappedP1Night)
        } else if timeKey == "p2" {
            dayTime = parseTime(entry.unwrappedP2Day)
            nightTime = parseTime(entry.unwrappedP2Night)
        }
        
        switch dayNightFilter {
            case "Day":
                return dayTime
            case "Night":
                return nightTime
            default:
                return dayTime + nightTime
            }
    }

    
    func fontColor(_ color: String) -> Color {
        if color == "red" {
            return Color.theme.coralRed
        } else if color == "amber" {
            return Color.theme.vividGamboge
        } else {
            return Color.black
        }
    }
}

func parseTime(_ timeString: String?) -> Int {
    guard let timeString = timeString else {
        return 0
    }

    let arr = timeString.components(separatedBy: " ")
    
    if arr.count == 3 {
        let timeComponents = arr[2].components(separatedBy: ":")
        if timeComponents.count == 3 {
            if let hours = Int(timeComponents[0]), let minutes = Int(timeComponents[1]), let seconds = Int(timeComponents[2]) {
                return hours * 3600 + minutes * 60 + seconds
            }
        }
    }
    

    return 0
}

func seconds2Timestamp(_ intSeconds: Int) -> String {
   let mins:Int = (intSeconds % 3600) / 60
   let hours:Int = intSeconds / 3600
   let secs:Int = intSeconds % 60

   let strTimestamp: String = ((hours<10) ? "0" : "") + String(hours) + ":" + ((mins<10) ? "0" : "") + String(mins) + ":" + ((secs<10) ? "0" : "") + String(secs)
   return strTimestamp
}

struct OverviewSubSectionView_Previews: PreviewProvider {
    static var previews: some View {
        OverviewSubSectionView()
    }
}
