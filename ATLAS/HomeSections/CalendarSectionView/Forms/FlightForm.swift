//
//  FlightForm.swift
//  ATLAS
//
//  Created by phuong phan on 11/09/2023.
//

import SwiftUI

struct FlightForm: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController
    @Binding var selectedEvent: EventDataDropDown
    @Binding var showModal: Bool
    var width: CGFloat = 0
    
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
                                DatePicker("", selection: $selectedStartDate, displayedComponents: .date).fixedSize()
                                DatePicker("", selection: $selectedStartTime, displayedComponents: .hourAndMinute)
                                    .environment(\.locale, Locale(identifier: "en_GB"))
                                    .fixedSize()
                            }.padding(.leading, -8)
                            
                            HStack {
                                DatePicker("", selection: $selectedEndDate, displayedComponents: .date).fixedSize()
                                DatePicker("", selection: $selectedEndTime, displayedComponents: .hourAndMinute)
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
            event.type = selectedEvent.rawValue
            event.name = tfEventName
            event.dep = tfDep
            event.dest = tfDest
            event.startDate = "\(startDateFm) \(startTimeFmSave)"
            event.endDate = "\(endDateFm) \(endTimeFmSave)"
            event.status = 5
            coreDataModel.save()
            
            coreDataModel.dataEvents = coreDataModel.readEvents()
            coreDataModel.dataEventCompleted = coreDataModel.readEventsByStatus(status: "2")
            coreDataModel.dataEventUpcoming = coreDataModel.readEventsByStatus(status: "5")
            
            self.showModal.toggle()
        }
    }
}

struct FlightForm_Previews: PreviewProvider {
    static var previews: some View {
        FlightForm(selectedEvent: .constant(EventDataDropDown.flight), showModal: .constant(true), width: 200)
    }
}
