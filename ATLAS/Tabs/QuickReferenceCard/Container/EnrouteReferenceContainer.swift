//
//  EnrouteReferenceContainer.swift
//  ATLAS
//
//  Created by phuong phan on 23/05/2023.
//

import Foundation
import SwiftUI

struct EnrouteReferenceContainer: View {
    @EnvironmentObject var viewModel: FlightNoteModelState
    // Custom Back button
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var sideMenuState: SideMenuModelState
    
    @State var enrouteTags: [ITagStorage] = CommonTags().TagList
    
    @State private var currentIndex: Int = -1
    @State private var showSheet: Bool = false
    @State private var textNote: String = ""
    var header: String = "Enroute Status"
    
    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { proxy in
                ItemListReference(
                    header: header,
                    showSheet: $showSheet,
                    currentIndex: $currentIndex,
                    itemList: $viewModel.enrouteQRArray,
                    geoWidth: proxy.size.width,
                    update: update
                ).frame(maxHeight: .infinity)
                    .padding(.vertical, 32)
                    .padding(.horizontal, 16)
                    .background(Color.white)
                    .cornerRadius(8)
                    .sheet(isPresented: $showSheet) {
                        NoteReferenceForm(
                            textNote: $textNote,
                            tagList: $enrouteTags,
                            itemList: $viewModel.enrouteQRArray,
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
        viewModel.updateEnroute(item: viewModel.enrouteQRArray[index])
        viewModel.removeEnrouteQR(item: viewModel.enrouteQRArray[index])
    }
    
    private func resetData() {
        self.enrouteTags = CommonTags().TagList
        
        if self.currentIndex > -1 {
            self.currentIndex = -1
        }
    }
}

struct EnrouteReferenceContainer_Previews: PreviewProvider {
    static var previews: some View {
        EnrouteReferenceContainer().environmentObject(FlightNoteModelState())
            .environmentObject(SideMenuModelState())
    }
}
