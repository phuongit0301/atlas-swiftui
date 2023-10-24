//
//  NotamSubSectionView.swift
//  ATLAS
//
//  Created by phuong phan on 24/9/23.
//

import Foundation
import SwiftUI

struct NotamSubSectionView: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    
    var body: some View {
        if coreDataModel.isNotamLoading {
            HStack(alignment: .center) {
                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.black)).controlSize(.large)
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .background(Color.black.opacity(0.3))
        } else {
            if coreDataModel.selectedEvent?.flightStatus == FlightStatusEnum.COMPLETED.rawValue {
                NotamCompletedSubSectionView()
            } else {
                NotamIncomingSubSectionView()
            }
        }
    }
}

