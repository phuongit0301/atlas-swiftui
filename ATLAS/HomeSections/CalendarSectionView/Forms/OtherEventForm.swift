//
//  OtherEventForm.swift
//  ATLAS
//
//  Created by phuong phan on 11/09/2023.
//

import SwiftUI

struct OtherEventForm: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController
    @Binding var selectedEvent: EventDataDropDown
    @Binding var showModal: Bool
    var width: CGFloat = 0
    
    @State private var selectedReminder = ReminderDataDropDown.before
    @State var tfEventName: String = ""
    @State private var selectedStartDate = Date()
    @State private var selectedStartTime = Date()
    @State private var selectedEndDate = Date()
    @State private var selectedEndTime = Date()
    @State var tfLocation: String = ""
    @State private var isAllDay = false
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
                    }
                    
                    Spacer()
                    
                    Text("Add Event").foregroundColor(.black).font(.system(size: 17, weight: .semibold))
                    
                    Spacer()
                    
                    Button(action: {
                        addEvent()
                    }) {
                        Text("Done").foregroundColor(Color.theme.azure).font(.system(size: 17, weight: .regular))
                    }
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
                    
                    TextField("Enter Name of Event", text: $tfEventName)
                        .font(.system(size: 15)).frame(maxWidth: .infinity)
                        .frame(height: 44)
                    
                    VStack(spacing: 0) {
                        HStack {
                            Text("Start").foregroundColor(Color.black).font(.system(size: 15, weight: .semibold)).frame(width: (width / 2) - 100, alignment: .leading)
                            Text("End").foregroundColor(Color.black).font(.system(size: 15, weight: .semibold)).frame(width: (width / 2) - 100, alignment: .leading)
                            Text("All Day").foregroundColor(Color.black).font(.system(size: 15, weight: .semibold)).frame(width: 100, alignment: .leading)
                        }.frame(maxWidth: .infinity, alignment: .leading).frame(height: 44)
                        
                        Divider().frame(maxWidth: .infinity).padding(.horizontal, -16)
                        
                        HStack(alignment: .center) {
                            HStack {
                                DatePicker("", selection: $selectedStartDate, displayedComponents: .date).fixedSize()
                                DatePicker("", selection: $selectedStartTime, displayedComponents: .hourAndMinute)
                                    .environment(\.locale, Locale(identifier: "en_GB"))
                                    .fixedSize()
                            }.frame(width: (width / 2) - 100, alignment: .leading).padding(.leading, -8)
                            
                            HStack {
                                DatePicker("", selection: $selectedEndDate, displayedComponents: .date).fixedSize()
                                DatePicker("", selection: $selectedEndTime, displayedComponents: .hourAndMinute)
                                    .environment(\.locale, Locale(identifier: "en_GB"))
                                    .fixedSize()
                            }.frame(width: (width / 2) - 100, alignment: .leading).padding(.leading, -4)
                            Toggle("", isOn: $isAllDay).fixedSize().frame(width: 100, alignment: .leading)
                        }.frame(maxWidth: .infinity, alignment: .leading).frame(height: 44).padding(.top, 8).padding(.bottom)
                    }
                    
                    Grid(alignment: .topLeading) {
                        GridRow {
                            Text("Location").foregroundColor(Color.black).font(.system(size: 15, weight: .semibold))
                        }.frame(maxWidth: .infinity, alignment: .leading)
                        
                        Divider().padding(.horizontal, -16)
                        
                        GridRow {
                            TextField("Add location", text: $tfLocation)
                                .font(.system(size: 15)).frame(maxWidth: .infinity)
                                .padding(.vertical)
                        }.frame(maxWidth: .infinity, alignment: .leading).padding(.bottom)
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
            .onChange(of: isAllDay) { newValue in
                if newValue {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "HHmm"
                    selectedStartTime = dateFormatter.date(from: "0000")!
                    selectedEndTime = dateFormatter.date(from: "2359")!
                }
                
            }
            Spacer()
        }
        .background(Color.theme.antiFlashWhite)
    }
    
    private func addEvent() {
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
            let event = EventList(context: persistenceController.container.viewContext)
            event.id = UUID()
            event.name = tfEventName
            event.type = selectedEvent.rawValue
            event.location = tfLocation
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
            newObj.dep = ""
            newObj.dest = ""
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
            
            coreDataModel.save()
            
            coreDataModel.dataEvents = coreDataModel.readEvents()
            coreDataModel.dataEventCompleted = coreDataModel.readEventsByStatus(status: "2")
            coreDataModel.dataEventUpcoming = coreDataModel.readEventsByStatus(status: "5")
            
            self.showModal.toggle()
        }
    }
}

struct OtherEventForm_Previews: PreviewProvider {
    static var previews: some View {
        OtherEventForm(selectedEvent: .constant(EventDataDropDown.otherEvent), showModal: .constant(true), width: 200)
    }
}
