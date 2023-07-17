//
//  EnrouteWeatherView.swift
//  ATLAS
//
//  Created by Muhammad Adil on 30/6/23.
//

import SwiftUI
import UIKit
import MobileCoreServices
import QuickLookThumbnailing
import Foundation
import SwiftData

struct EnrouteWeatherView: View {
#if os(iOS)
    @Environment(\.horizontalSizeClass) private var sizeClass
    @EnvironmentObject var coreDataModel: CoreDataModelState
#endif
    // fuel page swift data initialise
    @Environment(\.modelContext) private var context
    @Query var fuelPageData: [FuelPageData]
    
    @State private var selection: Int = 0
    @State private var target: String = "EnrouteWeather"
    @State private var selectedValue: Int = 0
    @State private var isShowModal: Bool = false
    @State private var selectionOutput: Int = 0
    
    var body: some View {
        // fetch SwiftData model
        let enrWXResponse = fuelPageData.first!.enrWX
        
        WidthThresholdReader(widthThreshold: 520) { proxy in
            VStack {
                HStack {
                    HStack {
                        Text("Enroute Weather Deviation").font(.system(size: 20, weight: .semibold)).foregroundColor(.black).frame(maxWidth: .infinity, alignment: .leading)
                        Spacer()
                        
                        HStack {
                            Text("Pilot Requirement").font(.system(size: 17, weight: .regular)).foregroundColor(.black)
                            ButtonStepper(onToggle: onToggle, value: $selectedValue, suffix: "mins").disabled(!coreDataModel.dataFuelExtra.includedEnrWx)
                        }.fixedSize()
                    }.padding()
                        .background(.white)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 1))
                }.padding()
                
                ScrollView(.vertical) {
                    VStack(spacing: 16) {
                        Grid(horizontalSpacing: 12, verticalSpacing: 12) {
                            if proxy.isCompact {
                                enrWXView(convertedJSON: enrWXResponse)
                            } else {
                                GridRow {
                                    enrWXView(convertedJSON: enrWXResponse)
                                }
                                .containerShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                .fixedSize(horizontal: false, vertical: true)
                                .padding([.horizontal, .bottom], 16)
                                .frame(maxWidth: .infinity)
                            }
                        }
                    }
                }.padding(.vertical)
            }
        }.formSheet(isPresented: $isShowModal) {
            ModalPicker(selectionOutput: $selectionOutput, isShowing: $isShowModal, selection: $selection, target: $target)
                .presentationDetents([.medium])
                .interactiveDismissDisabled(true)
        }
        .onChange(of: selectionOutput) { newValue in
            self.selectedValue = newValue
            coreDataModel.dataFuelExtra.selectedEnrWx = newValue
            coreDataModel.save()
            coreDataModel.readFuelExtra()
        }.onAppear {
            self.selectedValue = coreDataModel.dataFuelExtra.selectedEnrWx
        }
#if os(iOS)
        .background(Color(uiColor: .systemGroupedBackground))
#else
        .background(.quaternary.opacity(0.5))
#endif
        .background()
    }
    
    func onToggle() {
        if !coreDataModel.dataFuelExtra.includedEnrWx {
            return
        }
        self.selection = self.selectedValue
        self.isShowModal.toggle()
    }
}
