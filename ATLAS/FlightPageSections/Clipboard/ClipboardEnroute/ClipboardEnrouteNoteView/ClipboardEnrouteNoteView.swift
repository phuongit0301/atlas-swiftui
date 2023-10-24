//
//  ClipboardEnrouteNoteView.swift
//  ATLAS
//
//  Created by phuong phan on 29/09/2023.
//

import SwiftUI

struct ClipboardEnrouteNoteView: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    
    let width: CGFloat
    
    var body: some View {
        if coreDataModel.selectedEvent?.flightStatus == FlightStatusEnum.COMPLETED.rawValue {
            ClipboardEnrouteCompletedNoteView(width: width)
        } else {
            ClipboardEnrouteIncomingNoteView(width: width)
        }
    }
}

