//
//  ClipboardDepartureNoteView.swift
//  ATLAS
//
//  Created by phuong phan on 29/09/2023.
//

import SwiftUI

struct ClipboardDepartureNoteView: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    
    let width: CGFloat
    
    var body: some View {
        if coreDataModel.selectedEvent?.flightStatus == FlightStatusEnum.COMPLETED.rawValue {
            ClipboardDepartureCompletedNoteView(width: width)
        } else {
            ClipboardDepartureIncomingNoteView(width: width)
        }
    }
}

