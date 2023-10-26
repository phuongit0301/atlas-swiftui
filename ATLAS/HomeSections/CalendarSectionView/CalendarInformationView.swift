//
//  CalendarInformationView.swift
//  ATLAS
//
//  Created by phuong phan on 08/09/2023.
//

import SwiftUI

struct CalendarInformationView: View {
    @EnvironmentObject var calendarModel: CalendarModel
    @Binding var showModal: Bool
    @Binding var isEdit: Bool
    @State var isBtnDisabled = false
    
    let dateFormatter = DateFormatter()
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                if calendarModel.selectedEvent != nil {
                    if calendarModel.selectedEvent?.type == "Flight" {
                        FlightDetail(event: $calendarModel.selectedEvent, showModal: $showModal, isEdit: $isEdit, isBtnDisabled: $isBtnDisabled)
                    } else if calendarModel.selectedEvent?.type == "COP" {
                        COPDetail(event: $calendarModel.selectedEvent, showModal: $showModal, isEdit: $isEdit, isBtnDisabled: $isBtnDisabled)
                    } else {
                        OtherEventDetail(event: $calendarModel.selectedEvent, showModal: $showModal, isEdit: $isEdit, isBtnDisabled: $isBtnDisabled)
                    }
                } else {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("No Event Selected").font(.system(size: 15, weight: .semibold)).foregroundStyle(Color.black)
                            
                            Spacer()
                            
                            Button(action: {
                                // Todo
                            }, label: {
                                Text("Action(s)").font(.system(size: 15, weight: .regular)).foregroundStyle(Color.theme.azure)
                            }).buttonStyle(PlainButtonStyle())
                        }.frame(height: 44).padding(.vertical, 8).padding(.horizontal)
                        
                        Divider()
                        
                        Text("Click on a day or event to view details").font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black).frame(height: 44).padding(.vertical, 8).padding(.horizontal)
                    }.background(Color.white)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.theme.gainsboro, lineWidth: 0.5))
                }
            }.padding(.top, 8)
                .padding(.trailing)
                .onChange(of: calendarModel.selectedEvent?.startDate) {newValue in
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                    let dateNow = dateFormatter.string(from: Date())
                    
                    if let eventDate = newValue, let startDate = dateFormatter.date(from: eventDate), let now = dateFormatter.date(from: dateNow) {
                        if startDate < now {
                            isBtnDisabled = true
                        }
                    }
                }
        }
    }
}
