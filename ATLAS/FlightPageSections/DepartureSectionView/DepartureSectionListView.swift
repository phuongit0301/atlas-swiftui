//
//  DepartureSectionListView.swift
//  ATLAS
//
//  Created by phuong phan on 25/09/2023.
//

import SwiftUI

struct DepartureSectionListView: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    
    var body: some View {
        if coreDataModel.isAabbaNoteLoading {
            HStack(alignment: .center) {
                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.black)).controlSize(.large)
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .background(Color.black.opacity(0.3))
        } else {
            if coreDataModel.selectedEvent?.flightStatus == FlightStatusEnum.COMPLETED.rawValue {
                DepartureCompletedSectionListView()
            } else {
                DepartureIncomingSectionListView()
            }
        }
    }
}
