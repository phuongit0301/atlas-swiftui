//
//  EventModalView.swift
//  ATLAS
//
//  Created by phuong phan on 07/09/2023.
//

import SwiftUI

struct EventModalView: View {
    @Binding var showModal: Bool
    @State private var selectedEvent = EventDataDropDown.flight
    
    var body: some View {
        GeometryReader { proxy in
            if selectedEvent == EventDataDropDown.cop {
                COPForm(selectedEvent: $selectedEvent, showModal: $showModal, width: proxy.size.width)
            } else if selectedEvent == EventDataDropDown.otherEvent {
                OtherEventForm(selectedEvent: $selectedEvent, showModal: $showModal, width: proxy.size.width)
            } else {
                FlightForm(selectedEvent: $selectedEvent, showModal: $showModal, width: proxy.size.width)
            }
        }
    }
}

struct EventModalView_Previews: PreviewProvider {
    static var previews: some View {
        EventModalView(showModal: .constant(true))
    }
}
