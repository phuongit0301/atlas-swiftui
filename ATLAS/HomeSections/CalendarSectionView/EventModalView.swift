//
//  EventModalView.swift
//  ATLAS
//
//  Created by phuong phan on 07/09/2023.
//

import SwiftUI

struct EventModalView: View {
    @EnvironmentObject var calendarModel: CalendarModel
    
    @Binding var showModal: Bool
    @Binding var isEdit: Bool
    @State private var selectedEvent = EventDataDropDown.flight
    
    var body: some View {
        GeometryReader { proxy in
            if selectedEvent == EventDataDropDown.cop {
                COPForm(selectedEvent: $selectedEvent, showModal: $showModal, isEdit: $isEdit, width: proxy.size.width)
            } else if selectedEvent == EventDataDropDown.otherEvent {
                OtherEventForm(selectedEvent: $selectedEvent, showModal: $showModal, isEdit: $isEdit, width: proxy.size.width)
            } else {
                FlightForm(selectedEvent: $selectedEvent, showModal: $showModal, isEdit: $isEdit, width: proxy.size.width)
            }
        }.onAppear {
            if let type = calendarModel.selectedEvent?.unwrappedType {
                selectedEvent = EventDataDropDown(rawValue: type) ?? EventDataDropDown.flight
            }
        }
    }
}
