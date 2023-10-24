//
//  ClipboardNoteView.swift
//  ATLAS
//
//  Created by phuong phan on 25/09/2023.
//

import SwiftUI

struct ClipboardNoteView: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    
    let width: CGFloat
    
    var body: some View {
        if coreDataModel.selectedEvent?.flightStatus == FlightStatusEnum.COMPLETED.rawValue {
            ClipboardNoteCompletedView(width: width)
        } else {
            ClipboardNoteIncomingView(width: width)
        }
    }
}
