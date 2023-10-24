//
//  AISearchView.swift
//  ATLAS
//
//  Created by phuong phan on 20/05/2023.
//

import Foundation
import SwiftUI

struct AISearchView: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    
    var body: some View {
        if coreDataModel.selectedEvent?.flightStatus == FlightStatusEnum.COMPLETED.rawValue {
            AISearchCompletedView()
        } else {
            AISearchIncomingView()
        }
    }
}
