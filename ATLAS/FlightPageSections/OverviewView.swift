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
            if refState.isActive, let currentItem = refState.selectedItem {
                if currentItem.screenName == NavigationEnumeration.ClipboardFlightOverviewScreen {
                    ClipboardFlightOverviewView().padding(.top, -8)
                } else if currentItem.screenName == NavigationEnumeration.ClipboardPreflight {
                    ClipboardPreflight().padding(.top, -8)
                } else if currentItem.screenName == NavigationEnumeration.ClipboardDepature {
                    ClipboardDepature().padding(.top, -8)
                }
            } else {
                HStack(spacing: 0) {
                    Text("Clipboard").foregroundColor(Color.black).font(.system(size: 17, weight: .semibold))
                    Spacer()
                }.frame(height: 52)
                    .padding(.top, -8)
                    .padding(.horizontal, 32)
                
                ScrollView {
                    VStack(spacing: 0) {
                        VStack(spacing: 0) {
                            ForEach(viewInformationModel.ListItem, id: \.self) { item in
                                HStack {
                                    Text(item.name)
                                        .foregroundColor(Color.theme.eerieBlack)
                                        .font(.system(size: 17, weight: .regular))
                                        .frame(height: 44)
                                    Spacer()
                                }.contentShape(Rectangle())
                                    .onTapGesture {
                                        refState.isActive = true
                                        refState.selectedItem = item
                                    }
                                
                                Divider().padding(.horizontal, -16)
                            }
                        }.padding(.horizontal)
                        .background(Color.white)
                            .cornerRadius(8)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 0))
                    }.padding(.horizontal)
                }
            }
        }
    }
}
