//
//  ArrivalReferenceContainer.swift
//  ATLAS
//
//  Created by phuong phan on 23/05/2023.
//

import Foundation
import SwiftUI

struct ArrivalReferenceContainer: View {    
    @EnvironmentObject var viewModel: FlightNoteModelState
    // Custom Back button
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var sideMenuState: SideMenuModelState
    
    @State var arrivalTags: [ITagStorage] = CommonTags().TagList
    
    @State private var currentIndex: Int = -1
    @State private var showSheet: Bool = false
    @State private var textNote: String = ""
    var header: String = "Arrival Status"
    
    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { proxy in
                ItemListReference(
                    header: header,
                    showSheet: $showSheet,
                    currentIndex: $currentIndex,
                    itemList: $viewModel.arrivalQRArray,
                    geoWidth: proxy.size.width,
                    update: update
                ).frame(maxHeight: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .sheet(isPresented: $showSheet) {
                        NoteReferenceForm(
                            textNote: $textNote,
                            tagList: $arrivalTags,
                            itemList: $viewModel.arrivalQRArray,
                            currentIndex: $currentIndex,
                            showSheet: $showSheet,
                            resetData: self.resetData
                        ).keyboardAdaptive()
                            .interactiveDismissDisabled(true)
                    }
            }
        }.padding()
            .background(Color.theme.antiFlashWhite)
    }
    
    private func update(_ index: Int) {
        viewModel.updateArrival(item: viewModel.arrivalQRArray[index])
        viewModel.removeArrivalQR(item: viewModel.arrivalQRArray[index])
    }
    
    private func resetData() {
        self.arrivalTags = CommonTags().TagList
        
        if self.currentIndex > -1 {
            self.currentIndex = -1
        }
    }
}

struct ArrivalReferenceContainer_Previews: PreviewProvider {
    static var previews: some View {
        ArrivalReferenceContainer().environmentObject(FlightNoteModelState())
            .environmentObject(SideMenuModelState())
    }
}
