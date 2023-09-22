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
    
    @State private var dataTable = [ILobookTotalTimeData]()
    @State private var dataTotalTime = [String: [String: Int]]()
    
    @State private var isLoading = true
    @State private var firstLoading = true

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
                                    
                                    Button(action: {
                                        // ToDo
                                    }, label: {
                                        Text("See All")
                                            .font(.system(size: 17, weight: .regular)).textCase(nil)
                                            .foregroundColor(Color.theme.azure)
                                    }).buttonStyle(PlainButtonStyle())
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
                                            
                                            Divider()
                                            
                                            ForEach(MOCK_DATA.indices, id: \.self) {index in
                                                GridRow {
                                                    Group {
                                                        Text(MOCK_DATA[index].name)
                                                            .font(.system(size: 17, weight: .regular))
                                                            .frame(alignment: .leading)
                                                        
                                                        Text(MOCK_DATA[index].date)
                                                            .font(.system(size: 17, weight: .regular))
                                                            .frame(alignment: .leading)
                                                        
                                                        Text(MOCK_DATA[index].time)
                                                            .font(.system(size: 17, weight: .regular))
                                                            .frame(alignment: .leading)
                                                    }.foregroundColor(fontColor(MOCK_DATA[index].color))
                                                }
                                                
                                                if index + 1 < MOCK_DATA.count {
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
                                            ForEach(AircraftDataDropDown.allCases, id: \.self) {
                                                Text($0.rawValue).tag($0)
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
                                                
                                                Text("\(dataTotalTime["total"]!["pic"] ?? 0)")
                                                    .font(.system(size: 17, weight: .semibold))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                                
                                                Text("\(dataTotalTime["total"]!["picUs"] ?? 0)")
                                                    .font(.system(size: 17, weight: .semibold))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                                
                                                Text("\(dataTotalTime["total"]!["p1"] ?? 0)")
                                                    .font(.system(size: 17, weight: .semibold))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                                
                                                Text("\(dataTotalTime["total"]!["p2"] ?? 0)")
                                                    .font(.system(size: 17, weight: .semibold))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                                
                                                Text("\(dataTotalTime["total"]!["instr"] ?? 0)")
                                                    .font(.system(size: 17, weight: .semibold))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                                
                                                Text("\(dataTotalTime["total"]!["exam"] ?? 0)")
                                                    .font(.system(size: 17, weight: .semibold))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                                
                                                Text("\((dataTotalTime["total"]!["p1"] ?? 0) + (dataTotalTime["total"]!["p2"] ?? 0))")
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

                let (earliestDate, latestDate) = findEarliestAndLatestDates(logbookEntries: coreDataModel.dataLogbookEntries)
                if let earliestDate = earliestDate, let latestDate = latestDate {
                    let (dataTable, dataTotalTime) = prepareTableData(logbookEntries: coreDataModel.dataLogbookEntries, startDate: earliestDate, endDate: latestDate, dayNightFilter: selectedDayNight)
                    
                    selectedStartDate = dateFormatter.string(from: earliestDate)
                    selectedEndDate = dateFormatter.string(from: latestDate)
                    selectedDate = "From \(selectedStartDate) to \(selectedEndDate)"
                    self.dataTable = dataTable
                    self.dataTotalTime = dataTotalTime
                    firstLoading = false
                }
            }.onChange(of: selectedDate) {newValue in
                if !firstLoading {
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    
                    if let earliestDate = dateFormatter.date(from: selectedStartDate), let latestDate = dateFormatter.date(from: selectedEndDate) {
                        let (dataTable, dataTotalTime) = prepareTableData(logbookEntries: coreDataModel.dataLogbookEntries, startDate: earliestDate, endDate: latestDate, dayNightFilter: selectedDayNight)
                        self.dataTable = dataTable
                        self.dataTotalTime = dataTotalTime
                    }
                    
                   
                }
            }.onChange(of: selectedDayNight) {newValue in
                if !firstLoading {
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    
                    if let earliestDate = dateFormatter.date(from: selectedStartDate), let latestDate = dateFormatter.date(from: selectedEndDate) {
                        let (dataTable, dataTotalTime) = prepareTableData(logbookEntries: coreDataModel.dataLogbookEntries, startDate: earliestDate, endDate: latestDate, dayNightFilter: newValue)
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
    
    func prepareTableData(logbookEntries: [LogbookEntriesList], startDate: Date, endDate: Date, dayNightFilter: String) -> ([ILobookTotalTimeData], [String: [String: Int]]) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        var filteredEntries = [ILobookTotalTimeData]()

        for entry in logbookEntries {
            if let dateString = entry.date, let entryDate = dateFormatter.date(from: dateString),
               entryDate >= startDate && entryDate <= endDate {

                let aircraftType = entry.unwrappedAircraftType
                let pic = parseTime(entry.unwrappedPicDay) + parseTime(entry.unwrappedPicNight)
                let picUs = parseTime(entry.unwrappedPicUUsDay) + parseTime(entry.unwrappedPicUUsNight)
                let p1 = parseTime(entry.unwrappedP1Day) + parseTime(entry.unwrappedP1Night)
                let p2 = parseTime(entry.unwrappedP2Day) + parseTime(entry.unwrappedP2Night)
                let instr = parseTime(entry.unwrappedInstr)
                let exam = parseTime(entry.unwrappedExam)

                // Apply day/night filter
                if dayNightFilter == "Day" && (pic + picUs + p1 + p2) == 0 {
                    continue
                } else if dayNightFilter == "Night" && (pic + picUs + p1 + p2) == 0 {
                    continue
                }
                
                let logbookEntry = ILobookTotalTimeData(aircraftType: aircraftType, pic: pic, picUUs: picUs, p1: p1, p2: p2, instr: instr, exam: exam, date: entryDate, totalTime: p1 + p2)
                
                filteredEntries.append(logbookEntry)
            }
        }
        
        var aircraftTypeTotals: [String: [String: Int]] = [:]
        
        for entry in filteredEntries {
            if var totals = aircraftTypeTotals["total"] {
                totals["pic"] = (totals["pic"] ?? 0) + entry.pic
                totals["picUs"] = (totals["picUs"] ?? 0) + entry.picUUs
                totals["p1"] = (totals["p1"] ?? 0) + entry.p1
                totals["p2"] = (totals["p2"] ?? 0) + entry.p2
                totals["instr"] = (totals["instr"] ?? 0) + entry.instr
                totals["exam"] = (totals["exam"] ?? 0) + entry.exam
                aircraftTypeTotals["total"] = totals
            } else {
                aircraftTypeTotals["total"] = [
                    "pic": entry.pic,
                    "picUs": entry.picUUs,
                    "p1": entry.p1,
                    "p2": entry.p2,
                    "instr": entry.instr,
                    "exam": entry.exam
                ]
            }
        }
        
        isLoading = false
        return (filteredEntries, aircraftTypeTotals)
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
    
    func fontColor(_ color: String) -> Color {
        if color == "red" {
            return Color.theme.coralRed
        } else if color == "yellow" {
            return Color.theme.vividGamboge
        } else {
            return Color.black
        }
    }
}

struct OverviewSubSectionView_Previews: PreviewProvider {
    static var previews: some View {
        OverviewSubSectionView()
    }
}
