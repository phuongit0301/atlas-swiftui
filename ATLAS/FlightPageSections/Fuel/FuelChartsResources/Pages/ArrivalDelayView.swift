//
//  ArrivalDelaysView.swift
//  ATLAS
//
//  Created by Muhammad Adil on 30/6/23.
//

import SwiftUI
import UIKit
import MobileCoreServices
import QuickLookThumbnailing
import Foundation

struct ArrivalDelayView: View {
#if os(iOS)
    @Environment(\.horizontalSizeClass) private var sizeClass
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var flightPlanDetailModel: FlightPlanDetailModel
#endif
    @State private var selection: Int = 0
    @State private var target: String = "ArrDelays"
    @State private var selectedValue: Int = 0
    @State private var isShowModal: Bool = false
    @State private var selectionOutput: Int = 0
    
    
    var body: some View {
        WidthThresholdReader(widthThreshold: 800) { proxy in
            VStack {
                HStack {
                    HStack {
                        Text("Arrival Delay").font(.system(size: 20, weight: .semibold)).foregroundColor(.black).frame(maxWidth: .infinity, alignment: .leading)
                        Spacer()
                        
                        HStack {
                            Text("Pilot Requirement").font(.system(size: 17, weight: .regular)).foregroundColor(.black)
                            ButtonStepper(onToggle: onToggle, value: $selectedValue, suffix: "mins")
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
                                if !flightPlanDetailModel.isModal {
                                    projArrivalDelaysView(dataProjDelays: $coreDataModel.dataProjDelays)
                                    historicalDelaysView(dataHistoricalDelays: $coreDataModel.dataHistoricalDelays)
                                } else {
                                    VStack(spacing: 20) {
                                        projArrivalDelaysView(dataProjDelays: $coreDataModel.dataProjDelays)
                                        historicalDelaysView(dataHistoricalDelays: $coreDataModel.dataHistoricalDelays)
                                    }.containerShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                        .padding([.horizontal, .bottom], 16)
                                        .frame(maxWidth: .infinity)
                                }
                            } else {
                                GridRow {
                                    projArrivalDelaysView(dataProjDelays: $coreDataModel.dataProjDelays)
                                    historicalDelaysView(dataHistoricalDelays: $coreDataModel.dataHistoricalDelays)
                                }
                                .containerShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
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
            coreDataModel.dataFuelExtra.selectedArrDelays = newValue
            coreDataModel.dataFuelExtra.includedArrDelays = true
            coreDataModel.save()
            coreDataModel.readFuelExtra()
        }.onAppear {
            self.selectedValue = coreDataModel.dataFuelExtra.selectedArrDelays
        }
#if os(iOS)
        .background(Color(uiColor: .systemGroupedBackground))
#else
        .background(.quaternary.opacity(0.5))
#endif
        .background()
    }
    
    func onToggle() {
        self.selection = self.selectedValue
        self.isShowModal.toggle()
    }
}
