//
//  StatisticsView.swift
//  ATLAS
//
//  Created by Muhammad Adil on 2/10/23.
//

//
//  FuelView.swift
//  ATLAS
//
//  Created by phuong phan on 20/05/2023.
//

import Foundation
import SwiftUI

struct StatisticsView: View {
    // statistics page swift data initialise
#if os(iOS)
    @Environment(\.horizontalSizeClass) private var sizeClass
    @EnvironmentObject var coreDataModel: CoreDataModelState
#endif
   
    var body: some View {
        VStack(spacing: 0) {
            if coreDataModel.loadingInitFuel {
                HStack(alignment: .center) {
                    ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.black)).controlSize(.large)
                }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .background(Color.black.opacity(0.3))
            } else {
                WidthThresholdReader(widthThreshold: 800) { proxy in
                    VStack {
                        HStack {
                            HStack {
                                Text("Statistics").font(.system(size: 20, weight: .semibold)).foregroundColor(.black).frame(maxWidth: .infinity, alignment: .leading)
                                Spacer()
                            }.padding()
                            .background(.white)
                            .cornerRadius(8)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 1))
                        }.padding()
                        
                        ScrollView(.vertical) {
                            VStack(spacing: 16) {
                                Grid(horizontalSpacing: 12, verticalSpacing: 12) {
                                    if proxy.isCompact {
                                        projArrivalDelaysViewBasic(dataProjDelays: $coreDataModel.dataProjDelays)
                                        historicalDelaysViewBasic(dataHistoricalDelays: $coreDataModel.dataHistoricalDelays)
                                    } else {
                                        GridRow {
                                            projArrivalDelaysViewBasic(dataProjDelays: $coreDataModel.dataProjDelays)
                                            historicalDelaysViewBasic(dataHistoricalDelays: $coreDataModel.dataHistoricalDelays)
                                        }
                                        .containerShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                        .padding([.horizontal, .bottom], 16)
                                        .frame(maxWidth: .infinity)
                                        GridRow {
                                            taxiViewBasic(dataProjTaxi: $coreDataModel.dataProjTaxi)
                                            flightLevelViewBasic(dataFlightLevel: $coreDataModel.dataFlightLevel)
                                        }
                                        .containerShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                        .fixedSize(horizontal: false, vertical: true)
                                        .padding([.horizontal, .bottom], 16)
                                        .frame(maxWidth: .infinity)
                                        GridRow {
                                            MapViewModalTrackFlown()
                                        }
                                        .containerShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                        .fixedSize(horizontal: false, vertical: true)
                                        .padding([.horizontal, .bottom], 16)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 500)
                                    }
                                }
                            }
                        }.padding(.vertical)
                    }
                }
            }
        }
//        .task {
//            await waitForResponse()
//        }
#if os(iOS)
        .background(Color(uiColor: .systemGroupedBackground))
#else
        .background(.quaternary.opacity(0.5))
#endif
        .background()
    }
    
    func waitForResponse() async {
        while coreDataModel.dataProjDelays == nil {
            do {
                try await Task.sleep(nanoseconds: 500000000) // Sleep for 0.5 seconds
            }
            catch {
                print("Error: \(error)")
            }
        }
    }
}







