//
//  FlightForm.swift
//  ATLAS
//
//  Created by phuong phan on 11/09/2023.
//

import SwiftUI

struct FlightForm: View {
    @EnvironmentObject var remoteService: RemoteService
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController
    @EnvironmentObject var calendarModel: CalendarModel
    @Binding var selectedEvent: EventDataDropDown
    @Binding var showModal: Bool
    @Binding var isEdit: Bool
    var width: CGFloat = 0
    @State var isLoading = false
    
    @State private var selectedReminder = ReminderDataDropDown.before
    @State var tfEventName: String = ""
    @State var tfDep: String = ""
    @State var tfDest: String = ""
    @State private var selectedStartDate = Date()
    @State private var selectedStartTime = Date()
    @State private var selectedEndDate = Date()
    @State private var selectedEndTime = Date()
    @State var tfLocation: String = ""
    @State private var isAllDay = false
    @State private var startTime = Date()
    @State private var endTime = Date()
    
    let dateFormatterTime = DateFormatter()
    let dateFormatter = DateFormatter()
    let timeFormatter = DateFormatter()
    let timeFormatterToSave = DateFormatter()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Button(action: {
                        self.showModal.toggle()
                    }) {
                        Text("Cancel").foregroundColor(Color.theme.azure).font(.system(size: 17, weight: .regular))
                    }.buttonStyle(PlainButtonStyle())
                    
                    Spacer()
                    
                    Text("Add Event").foregroundColor(.black).font(.system(size: 17, weight: .semibold))
                    
                    Spacer()
                    
                    Button(action: {
                        addEvent()
                    }) {
                        HStack(alignment: .center, spacing: 16) {
                            if isLoading {
                                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                            }
                            Text("Done").foregroundColor(Color.theme.azure).font(.system(size: 17, weight: .regular))
                        }
                    }.buttonStyle(PlainButtonStyle())
                        .disabled(isLoading)
                }
                .padding()
                .background(.white)
                
                Rectangle().fill(.black.opacity(0.3)).frame(height: 1)
            }
            
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("Event Type")
                        
                        Picker("", selection: $selectedEvent) {
                            ForEach(EventDataDropDown.allCases, id: \.self) {
                                Text($0.rawValue).tag($0.rawValue)
                            }
                        }.pickerStyle(MenuPickerStyle())
                    }
                    
                    TextField("Enter Flight Number", text: $tfEventName)
                        .font(.system(size: 15)).frame(maxWidth: .infinity)
                        .frame(height: 44)
                    
                    Grid(alignment: .topLeading) {
                        GridRow {
                            Text("Dep").foregroundColor(Color.black).font(.system(size: 15, weight: .semibold))
                            Text("Dest").foregroundColor(Color.black).font(.system(size: 15, weight: .semibold))
                        }.frame(maxWidth: .infinity, alignment: .leading).frame(height: 44)
                        
                        Divider().padding(.horizontal, -16)
                        
                        GridRow {
                            TextField("Input Dep", text: $tfDep)
                                .font(.system(size: 15)).frame(maxWidth: .infinity)
                            TextField("Input Dest", text: $tfDest)
                                .font(.system(size: 15)).frame(maxWidth: .infinity)
                        }.frame(maxWidth: .infinity, alignment: .leading).frame(height: 44)
                        
                        GridRow {
                            Text("STD").foregroundColor(Color.black).font(.system(size: 15, weight: .semibold))
                            Text("STA").foregroundColor(Color.black).font(.system(size: 15, weight: .semibold))
                        }.frame(maxWidth: .infinity, alignment: .leading).frame(height: 44)
                        
                        Divider().padding(.horizontal, -16)
                        
                        GridRow {
                            HStack {
                                DatePicker("", selection: $selectedStartDate, in: Date()..., displayedComponents: .date).fixedSize()
                                DatePicker("", selection: $selectedStartTime, in: startTime..., displayedComponents: .hourAndMinute)
                                    .environment(\.locale, Locale(identifier: "en_GB"))
                                    .fixedSize()
                            }.padding(.leading, -8)
                            
                            HStack {
                                DatePicker("", selection: $selectedEndDate, in: Date()..., displayedComponents: .date).fixedSize()
                                DatePicker("", selection: $selectedEndTime, in: endTime..., displayedComponents: .hourAndMinute)
                                    .environment(\.locale, Locale(identifier: "en_GB"))
                                    .fixedSize()
                            }.padding(.leading, -4)
                        }.frame(maxWidth: .infinity, alignment: .leading)
                            .frame(height: 44).padding(.top, 8).padding(.bottom)
                        
                    }.frame(maxWidth: .infinity)
                    
                    //                    VStack(alignment: .leading, spacing: 0) {
                    //                        HStack {
                    //                            Text("People").foregroundColor(Color.black).font(.system(size: 15, weight: .semibold))
                    //
                    //                            Spacer()
                    //
                    //                            Button(action: {
                    //
                    //                            }, label: {
                    //                                Text("Invite")
                    //                            }).buttonStyle(PlainButtonStyle())
                    //
                    //                        }.frame(maxWidth: .infinity, alignment: .leading)
                    //                            .padding(.bottom, 8)
                    //
                    //                        Divider().padding(.horizontal, -16)
                    //
                    //                        TextField("Add other Atlas users to this flight", text: $tfEventName)
                    //                            .font(.system(size: 15)).frame(maxWidth: .infinity)
                    //                            .padding(.vertical)
                    //                    }
                    //
                    //                    VStack(alignment: .leading, spacing: 0) {
                    //                        HStack {
                    //                            Text("Reminders").foregroundColor(Color.black).font(.system(size: 15, weight: .semibold))
                    //                        }.frame(maxWidth: .infinity, alignment: .leading)
                    //                            .padding(.bottom, 8)
                    //
                    //                        Divider().padding(.horizontal, -16)
                    //
                    //                        Picker("", selection: $selectedReminder) {
                    //                            ForEach(ReminderDataDropDown.allCases, id: \.self) {
                    //                                Text($0.rawValue).tag($0.rawValue)
                    //                            }
                    //                        }.pickerStyle(MenuPickerStyle())
                    //                    }
                    
                }// End VStack
                .padding()
                
            }// End VStack
            .background(RoundedRectangle(cornerRadius: 8, style: .continuous).fill(.white))
            .cornerRadius(8)
            .padding()
            
            Spacer()
        }
        .background(Color.theme.antiFlashWhite)
        .onAppear {
            if isEdit {
                dateFormatter.dateFormat = "yyyy-MM-dd"
                timeFormatter.dateFormat = "HHmm"
                
                tfEventName = calendarModel.selectedEvent?.unwrappedName ?? ""
                tfDep = calendarModel.selectedEvent?.unwrappedDep ?? ""
                tfDest = calendarModel.selectedEvent?.unwrappedDest ?? ""
                
                if let startDate = calendarModel.selectedEvent?.unwrappedStartDate, let startDateFormat = dateFormatter.date(from: startDate) {
                    selectedStartDate = startDateFormat
                }
                
                if let startTime = calendarModel.selectedEvent?.unwrappedStartDate, let startTimeFormat = timeFormatter.date(from: startTime) {
                    selectedStartTime = startTimeFormat
                }
                
                if let endDate = calendarModel.selectedEvent?.unwrappedEndDate, let endDateFormat = dateFormatter.date(from: endDate) {
                    selectedEndDate = endDateFormat
                }
                
                if let endTime = calendarModel.selectedEvent?.unwrappedEndDate, let endTimeFormat = timeFormatter.date(from: endTime) {
                    selectedEndTime = endTimeFormat
                }
            }
        }
        .onChange(of: selectedStartDate) {newValue in
            if Date() < newValue {
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                
                guard let inputDate = formatter.date(from: "00:01") else { return }
                let inputComps = Calendar.current.dateComponents([.hour, .minute], from: inputDate)
                if let temp = Calendar.current.date(from: inputComps) {
                    startTime = temp
                }
            } else {
                startTime = newValue
            }
            
        }
        .onChange(of: selectedEndDate) {newValue in
            if Date() < newValue {
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                
                guard let inputDate = formatter.date(from: "00:01") else { return }
                let inputComps = Calendar.current.dateComponents([.hour, .minute], from: inputDate)
                if let temp = Calendar.current.date(from: inputComps) {
                    endTime = temp
                }
            } else {
                endTime = newValue
            }
            
        }
    }
    
    private func addEvent() {
        Task {
            dateFormatterTime.dateFormat = "yyyy-MM-dd HHmm"
            dateFormatter.dateFormat = "yyyy-MM-dd"
            timeFormatter.dateFormat = "HHmm"
            timeFormatterToSave.dateFormat = "HH:mm"
            
            let startDateFm = dateFormatter.string(from: selectedStartDate)
            let startTimeFm = timeFormatter.string(from: selectedStartTime)
            let startTimeFmSave = timeFormatterToSave.string(from: selectedStartTime)
            
            let endDateFm = dateFormatter.string(from: selectedEndDate)
            let endTimeFm = timeFormatter.string(from: selectedEndTime)
            let endTimeFmSave = timeFormatterToSave.string(from: selectedEndTime)
            
            let startDate = dateFormatterTime.date(from: "\(startDateFm) \(startTimeFm)")
            let endDate = dateFormatterTime.date(from: "\(endDateFm) \(endTimeFm)")
            
            if tfEventName != "" && startDate != nil && endDate != nil && startDate! <= endDate! {
                isLoading = true
                
                let payload = [
                    "dep": tfDep,
                    "arr": tfDest,
                    "std": "\(startDateFm) \(startTimeFmSave)",
                    "sta": "\(endDateFm) \(endTimeFmSave)"
                ]
                let response = await remoteService.getSectorData(payload)
                
                do {
                    let eventSector = EventSectorList(context: persistenceController.container.viewContext)
                    eventSector.id = UUID()
                    eventSector.depLat = response?.depLat
                    eventSector.depLong = response?.depLong
                    eventSector.depTimeDiff = response?.dep_time_diff
                    eventSector.depSunriseTime = response?.dep_sunrise_time
                    eventSector.depSunsetTime = response?.dep_sunset_time
                    eventSector.depNextSunriseTime = response?.dep_next_sunrise_time
                    eventSector.arrLat = response?.arrLat
                    eventSector.arrLong = response?.arrLong
                    eventSector.arrTimeDiff = response?.arr_time_diff
                    eventSector.arrSunriseTime = response?.arr_sunrise_time
                    eventSector.arrSunsetTime = response?.arr_sunset_time
                    eventSector.arrNextSunriseTime = response?.arr_next_sunrise_time
                    try persistenceController.container.viewContext.save()
                    
                    let event = EventList(context: persistenceController.container.viewContext)
                    event.id = UUID()
                    event.type = selectedEvent.rawValue
                    event.name = tfEventName
                    event.dep = tfDep
                    event.dest = tfDest
                    event.startDate = "\(startDateFm) \(startTimeFmSave)"
                    event.endDate = "\(endDateFm) \(endTimeFmSave)"
                    event.status = 5
                    event.flightStatus = FlightStatusEnum.UPCOMING.rawValue
                    
                    // Create Date Range
                    let newDateRange = EventDateRangeList(context: persistenceController.container.viewContext)
                    newDateRange.id = UUID()
                    newDateRange.startDate = "\(startDateFm) \(startTimeFmSave)"
                    newDateRange.endDate = "\(endDateFm) \(endTimeFmSave)"
                    
                    // Create Flight Overview
                    let newObj = FlightOverviewList(context: persistenceController.container.viewContext)
                    newObj.id = UUID()
                    newObj.callsign = tfEventName
                    newObj.dep = tfDep
                    newObj.dest = tfDest
                    newObj.std = "\(startDateFm) \(startTimeFmSave)"
                    newObj.sta = "\(endDateFm) \(endTimeFmSave)"
                    
                    newObj.caName = ""
                    newObj.caPicker = ""
                    newObj.eta = ""
                    newObj.f0Name = ""
                    newObj.f0Picker = ""
                    newObj.aircraft = ""
                    newObj.blockTime = ""
                    newObj.blockTimeFlightTime = ""
                    newObj.chockOff = ""
                    newObj.chockOn = ""
                    newObj.day = ""
                    newObj.flightTime = ""
                    newObj.model = ""
                    newObj.night = ""
                    newObj.password = ""
                    newObj.pob = ""
                    newObj.timeDiffArr = ""
                    newObj.timeDiffDep = ""
                    newObj.totalTime = ""
                    
                    // add relationship with overview
                    event.eventDateRangeList = NSSet(array: [newDateRange])
                    event.flightOverviewList = NSSet(array: [newObj])
                    event.noteAabbaPostList = NSSet(array: [])
                    event.noteList = NSSet(array: [])
                    event.notamsDataList = NSSet(array: [])
                    event.metarTafList = NSSet(array: [])
                    event.mapRouteList = NSSet(array: [])
                    event.airportMapColorList = NSSet(array: [])
                    event.eventSector = eventSector
                    
                    try persistenceController.container.viewContext.save()
                    
                    coreDataModel.dataEvents = coreDataModel.readEvents()
                    coreDataModel.dataEventCompleted = coreDataModel.readEventsByStatus(status: "2")
                    coreDataModel.dataEventUpcoming = coreDataModel.readEventsByStatus(status: "5")
                    
                    isLoading = false
                    self.showModal.toggle()
                } catch {
                    self.showModal.toggle()
                    // Something went wrong 😭
                    print("Failed to save: \(error)")
                    // Rollback any changes in the managed object context
                    persistenceController.container.viewContext.rollback()
                    
                }
            }
        }
    }
}
