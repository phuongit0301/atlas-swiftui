//
//  CalendarSectionView.swift
//  ATLAS
//
//  Created by phuong phan on 06/09/2023.
//

import SwiftUI
import iCalendarParser

struct CalendarSectionView: View {
    @State var showModal = false
    @EnvironmentObject var calendarModel: CalendarModel
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("Calendar").font(.system(size: 17, weight: .semibold))
                    
                    Spacer()
                    
                    Button(action: {
//                        self.showModal.toggle()
                        Task {
                            if let filepath = Bundle.main.path(forResource: "example", ofType: "ics") {
                                do {
                                    let contents = try String(contentsOfFile: filepath)
                                    let parser = ICParser()
                                    let calendar: ICalendar? = parser.calendar(from: contents)
                                    
                                    if calendar != nil {
                                        var temp = [IEvent]()
                                        let dateFormatter = DateFormatter()
                                        dateFormatter.dateFormat = "yyyy-MM-dd"
                                        dateFormatter.timeZone = TimeZone.current
                                        dateFormatter.locale = Locale.current
                                        dateFormatter.calendar = Calendar(identifier: .gregorian)
                                        
                                        for event in calendar!.events {
                                            let startDate = dateFormatter.string(from: event.dtStart!.date)
//                                            let dtEndDate = Calendar.current.date(byAdding: .day, value: -1, to: event.dtEnd!.date)
                                            let dtEndDate = dateFormatter.string(from: event.dtEnd!.date)
                                            
                                            if startDate < dtEndDate {
                                                let endDate = dateFormatter.string(for: Calendar.current.date(byAdding: .day, value: -1, to: event.dtEnd!.date))
                                                temp.append(IEvent(id: UUID(), name: event.summary!, startDate: startDate, endDate: endDate!))
                                            } else {
                                                temp.append(IEvent(id: UUID(), name: event.summary!, startDate: startDate, endDate: dtEndDate))
                                            }
                                            
                                        }

                                        calendarModel.listEvent = temp
                                    }
                                } catch {
                                    // contents could not be loaded
                                }
                            } else {
                                print("Error read file ics")
                            }

                        }
                        
                    }, label: {
                        Text("Add Event").font(.system(size: 17, weight: .regular)).foregroundColor(Color.white)
                    }).padding(.vertical, 11)
                        .padding(.horizontal)
                        .background(Color.theme.azure)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(.white, lineWidth: 1))
                        .cornerRadius(8)
                        .buttonStyle(PlainButtonStyle())
                }.padding(.horizontal)
                
                HStack(spacing: 0) {
                    CalendarView(calendar: Calendar(identifier: .gregorian)).frame(width: (proxy.size.width * 2 / 3))
                    
                    CalendarInformationView()
                }
            }// end VStack
            .background(Color.theme.antiFlashWhite)
            .sheet(isPresented: $showModal) {
                EventModalView(showModal: $showModal)
            }
        }
    }
}
