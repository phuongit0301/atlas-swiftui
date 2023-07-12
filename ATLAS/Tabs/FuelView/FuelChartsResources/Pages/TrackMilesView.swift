//
//  TrackMilesView.swift
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

struct TrackMilesView: View {
#if os(iOS)
    @Environment(\.horizontalSizeClass) private var sizeClass
#endif
    // fuel page swift data initialise
    @Environment(\.modelContext) private var context
    @Query var fuelPageData: [FuelPageData]
    
    var body: some View {
        // fetch SwiftData model
        let trackMilesResponse = fuelPageData.first!.trackMiles
        
        WidthThresholdReader(widthThreshold: 520) { proxy in
            ScrollView(.vertical) {
                VStack(spacing: 16) {
                    Text("Track Miles Difference") // TODO adjust font and size and add fuel selector sync with flight plan fuel table
                        .containerShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .fixedSize(horizontal: false, vertical: true)
                        .padding([.horizontal, .top], 12)
                        .frame(maxWidth: .infinity)
                    
                    Grid(horizontalSpacing: 12, verticalSpacing: 12) {
                        if proxy.isCompact {
                            trackMilesView(convertedJSON: trackMilesResponse)

                        } else {
                            GridRow {
                                trackMilesView(convertedJSON: trackMilesResponse)
                            }
                            .containerShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .fixedSize(horizontal: false, vertical: true)
                            .padding([.horizontal, .bottom], 16)
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
            }.padding(.vertical, 32)
        }
#if os(iOS)
        .background(Color(uiColor: .systemGroupedBackground))
#else
        .background(.quaternary.opacity(0.5))
#endif
        .background()
        .navigationTitle("Track Miles Difference")
    }
}
