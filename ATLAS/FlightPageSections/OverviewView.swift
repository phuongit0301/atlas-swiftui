//
//  OverviewView.swift
//  ATLAS
//
//  Created by phuong phan on 20/05/2023.
//

import Foundation
import SwiftUI

struct OverviewView: View {
    var viewInformationModel = ListReferenceModel()
    var viewUtilitiesModel = ListUtilitiesModel()
    @EnvironmentObject var refState: ScreenReferenceModel
    
    var body: some View {
        // flight informations
        VStack (spacing: 0) {
            if refState.isActive {
                getDestination(refState.selectedItem!)
            } else {
                HStack {
                    Text("Clipboard").foregroundColor(Color.black).font(.system(size: 17, weight: .semibold))
                }.frame(height: 44)
                .padding(.horizontal)
                
                List {
                    ForEach(viewInformationModel.ListItem, id: \.self) { item in
                        HStack {
                            Text(item.name).foregroundColor(Color.theme.eerieBlack).font(.system(size: 17, weight: .regular))
                            Spacer()
                        }.contentShape(Rectangle())
                            .onTapGesture {
                                refState.isActive = true
                                refState.selectedItem = item
                            }
                    }
                    
                }.scrollContentBackground(.hidden)
                    .ignoresSafeArea()
            }
            
        }
    }
}
