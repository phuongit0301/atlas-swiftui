//
//  AircraftReferenceContainer.swift
//  ATLAS
//
//  Created by phuong phan on 23/05/2023.
//

import Foundation
import SwiftUI

struct AircraftReferenceContainer: View {
    @EnvironmentObject var viewModel: FlightNoteModelState
    // Custom Back button
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var sideMenuState: SideMenuModelState
    
    @State var aircraftTags: [ITagStorage] = []
    
    @State private var currentIndex: Int = -1
    @State private var showSheet: Bool = false
    @State private var textNote: String = ""
    var header: String = "Aircraft Status"
    
    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { proxy in
                ItemListReference(
                    header: header,
                    showSheet: $showSheet,
                    currentIndex: $currentIndex,
                    itemList: $viewModel.aircraftQRArray,
                    geoWidth: proxy.size.width,
                    update: update
                ).frame(maxHeight: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .sheet(isPresented: $showSheet) {
                        NoteReferenceForm(
                            textNote: $textNote,
                            tagList: $aircraftTags,
                            itemList: $viewModel.aircraftQRArray,
                            currentIndex: $currentIndex,
                            showSheet: $showSheet,
                            resetData: self.resetData
                        ).keyboardAdaptive()
                            .interactiveDismissDisabled(true)
                    }
            }
        }.hasToolbar()
            .padding()
            .background(Color.theme.antiFlashWhite)
    }
    
    private func update(_ index: Int) {
        viewModel.updateAircraft(item: viewModel.aircraftQRArray[index])
        viewModel.removeAircraftQR(item: viewModel.aircraftQRArray[index])
    }
    
    private func resetData() {
        self.aircraftTags = []
        
        if self.currentIndex > -1 {
            self.currentIndex = -1
        }
    }
}

struct AircraftReferenceContainer_Previews: PreviewProvider {
    static var previews: some View {
        AircraftReferenceContainer().environmentObject(FlightNoteModelState())
            .environmentObject(SideMenuModelState())
    }
}
