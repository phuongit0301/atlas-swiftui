//
//  FlightLevelView.swift
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

struct FlightLevelView: View {
#if os(iOS)
    @Environment(\.horizontalSizeClass) private var sizeClass
    @EnvironmentObject var coreDataModel: CoreDataModelState
#endif
    // fuel page swift data initialise
    @Environment(\.modelContext) private var context
    @Query var fuelPageData: [FuelPageData]
    
    @State private var selectedFlightLevel000: Int = 0
    @State private var selectedFlightLevel00: Int = 0
    @State private var selectedFlightLevelPrint: String = "0ft"
    
    @State private var selection1: Int = 0
    @State private var selection2: Int = 0
    @State private var target: String = "FlightLevel"
    @State private var selectedValue: Int = 0
    @State private var isShowModal: Bool = false
    @State private var selectionOutput: Int = 0
    
    var body: some View {
        // fetch SwiftData model
        let flightLevelResponse = fuelPageData.first!.flightLevel
        
        WidthThresholdReader(widthThreshold: 520) { proxy in
            VStack {
                HStack {
                    HStack {
                        Text("Flight level deviation").font(.system(size: 20, weight: .semibold)).foregroundColor(.black).frame(maxWidth: .infinity, alignment: .leading)
                        Spacer()
                        
                        HStack {
                            Text("Pilot Requirement").font(.system(size: 17, weight: .regular)).foregroundColor(.black)
                            ButtonStepperMultiple(onToggle: onToggle, value: $selectedFlightLevelPrint, suffix: "")
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
                                flightLevelView(convertedJSON: flightLevelResponse)
                                
                            } else {
                                GridRow {
                                    flightLevelView(convertedJSON: flightLevelResponse)
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
            ModalPickerMultiple(isShowing: $isShowModal, target: $target, onSelectOutput: onSelectOutput, selection1: $selection1, selection2: $selection2)
                .presentationDetents([.medium])
                .interactiveDismissDisabled(true)
        }
        .onAppear {
            self.selectedFlightLevel000 = coreDataModel.dataFuelExtra.selectedFlightLevel000
            self.selectedFlightLevel00 = coreDataModel.dataFuelExtra.selectedFlightLevel00
            self.selectedFlightLevelPrint = "\((self.selectedFlightLevel000 * 10) + self.selectedFlightLevel00)00ft"
        }
#if os(iOS)
        .background(Color(uiColor: .systemGroupedBackground))
#else
        .background(.quaternary.opacity(0.5))
#endif
        .background()
    }
    
    func onToggle() {
        self.selection1 = self.selectedFlightLevel000
        self.selection2 = self.selectedFlightLevel00
        self.isShowModal.toggle()
    }
    
    func onSelectOutput(_ sel1: Int, _ sel2: Int) {
        self.selectedFlightLevel000 = sel1
        self.selectedFlightLevel00 = sel2
        self.selectedFlightLevelPrint = "\((sel1 * 10) + sel2)00ft"
        self.selection1 = sel1
        self.selection2 = sel2
        coreDataModel.dataFuelExtra.selectedFlightLevel000 = sel1
        coreDataModel.dataFuelExtra.selectedFlightLevel00 = sel2
        coreDataModel.dataFuelExtra.includedFlightLevel = true
        coreDataModel.save()
        coreDataModel.readFuelExtra()
    }
}

