//
//  ClipboardAISearchResult.swift
//  ATLAS
//
//  Created by phuong phan on 13/07/2023.
//

import SwiftUI
import Foundation

struct ClipboardAISearchResult: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    
    var body: some View {
        if coreDataModel.selectedEvent?.flightStatus == FlightStatusEnum.COMPLETED.rawValue {
            ClipboardAISearchCompletedResult()
        } else {
            ClipboardAISearchIncomingResult()
        }
    }
}
