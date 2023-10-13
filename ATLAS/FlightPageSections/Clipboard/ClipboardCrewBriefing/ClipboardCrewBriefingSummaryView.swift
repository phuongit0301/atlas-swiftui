//
//  ClipboardCrewBriefingSummaryView.swift
//  ATLAS
//
//  Created by phuong phan on 22/08/2023.
//

import SwiftUI
import Combine
import UIKit

struct ClipboardCrewBriefingSummaryView: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    let width: CGFloat
    @State private var isCollapseFlightInfo = true
    @State private var dataFlightOverview: FlightOverviewList?
    
    var body: some View {
        VStack(spacing: 8) {
            VStack(spacing: 0) {
                HStack(alignment: .center, spacing: 0) {
                    Button(action: {
                        self.isCollapseFlightInfo.toggle()
                    }, label: {
                        HStack(alignment: .center, spacing: 8) {
                            Text("Flight Information").font(.system(size: 17, weight: .semibold)).foregroundStyle(Color.black)
                            
                            if isCollapseFlightInfo {
                                Image(systemName: "chevron.down")
                                    .foregroundColor(Color.blue)
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fit)
                            } else {
                                Image(systemName: "chevron.up")
                                    .foregroundColor(Color.blue)
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fit)
                            }
                        }.frame(alignment: .leading)
                    }).buttonStyle(PlainButtonStyle())
                    
                    Spacer()
                }.frame(height: 52)
                
                if isCollapseFlightInfo {
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            Text("Flight Time")
                                .foregroundStyle(Color.black)
                                .font(.system(size: 15, weight: .semibold))
                                .frame(width: calculateWidthSummary(width - 32, 2), alignment: .leading)
                            Text("Password")
                                .foregroundStyle(Color.black)
                                .font(.system(size: 15, weight: .semibold))
                                .frame(width: calculateWidthSummary(width - 32, 2), alignment: .leading)
                        }.frame(height: 44)
                        
                        Divider().padding(.horizontal, -16)
                        
                        HStack(spacing: 0) {
                            Text(dataFlightOverview?.flightTime ?? "")
                                .foregroundStyle(Color.black)
                                .font(.system(size: 15, weight: .regular))
                                .frame(width: calculateWidthSummary(width - 32, 2), alignment: .leading)
                            Text(dataFlightOverview?.unwrappedPassword ?? "")
                                .foregroundStyle(Color.black)
                                .font(.system(size: 15, weight: .regular))
                                .frame(width: calculateWidthSummary(width - 32, 2), alignment: .leading)
                        }.frame(height: 44)
                    } //end VStack
                }// end if
            }.padding(.horizontal)
                .background(Color.white)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 0))
        }// end VStack
        .onAppear {
            if let overviewList = coreDataModel.selectedEvent?.flightOverviewList?.allObjects as? [FlightOverviewList] {
                dataFlightOverview = overviewList.first
            }
        }
    }
}
