//
//  NoteDestinationSplit.swift
//  ATLAS
//
//  Created by phuong phan on 22/07/2023.
//

import SwiftUI

struct NoteDestinationSplit: View {
    @State var item: ListFlightInformationItem?
    var viewInformationModel = ListReferenceModel()
    
    var body: some View {
        if let index = viewInformationModel.ListItem.firstIndex(where: {$0.screenName == item?.screenName}) {
            if item?.nextScreen == NavigationEnumeration.DepartureScreen {
                DepartureSplit(item: viewInformationModel.ListItem[3])
            } else if item?.nextScreen == NavigationEnumeration.EnrouteScreen {
                EnrouteSplit(item: viewInformationModel.ListItem[index + 1])
            } else if item?.nextScreen == NavigationEnumeration.ArrivalScreen {
                ArrivalSplit(item: viewInformationModel.ListItem[index + 1])
            }
        }
    }
}

#Preview {
    NoteDestinationSplit()
}
