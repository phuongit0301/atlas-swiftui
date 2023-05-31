//
//  FlightNoteCard.swift
//  ATLAS
//
//  Created by phuong phan on 21/05/2023.
//

import Foundation
import SwiftUI

struct FlightNoteCard: View {
    var geoWidth: Double = 0
    @Binding var collapsed: Bool
    // Mock Data tabs
    @State var itemAircraft: [IFlightInfoModel] = []
    @State var itemDepature = DepartureFlightInfoModel().ListItem
    @State var itemArrival = ArrivalFlightInfoModel().ListItem
    @State var itemEnroute = EnrouteFlightInfoModel().ListItem
    
    @State private var currentTab: Int = 0
    @State var animatedContentHeight: CGFloat = 150
    
    @State private var tabs: [Tab] = [
        .init(title: "Aircraft Status"),
        .init(title: "Departure"),
        .init(title: "Enroute"),
        .init(title: "Arrival"),
    ]
    
    @State private var selectedSegment = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(
                action: { self.collapsed.toggle() },
                label: {
                    HStack(alignment: .center) {
                        Text("Flight Notes")
                            .font(.custom("Inter-SemiBold", size: 20))
                            .foregroundColor(.black)
                        Spacer()
                        Image(self.collapsed ? "icon_arrow_up" : "icon_arrow_down")
                    }
                }
            )
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            
            if collapsed {
                VStack(spacing: 0) {
                    // Tabs
                    VStack(alignment: .leading, spacing: 0) {
                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                ForEach(0..<tabs.count, id: \.self) { index in
                                    VStack(alignment: .center, spacing: 0) {
                                        Button(action: {
                                            withAnimation(.interactiveSpring()) {
                                                selectedSegment = index
                                                
                                                self.calculateHeight()
                                            }
                                        }) {
                                            if selectedSegment == index {
                                                Text(tabs[index].title)
                                                    .font(.custom("Inter-SemiBold", size: 13))
                                                    .fontWeight(.semibold)
                                                    .padding(.horizontal, 12)
                                                    .padding(.vertical, 8)
                                                    .foregroundColor(Color.theme.eerieBlack)
                                            } else {
                                                Text(tabs[index].title)
                                                    .font(.custom("Inter-Regular", size: 13))
                                                    .padding(.horizontal, 12)
                                                    .padding(.vertical, 8)
                                                    .foregroundColor(Color.theme.eerieBlack)
                                            }
                                        }
                                        
                                        Rectangle().fill(Color.theme.eerieBlack).frame(height: selectedSegment == index ? 3 : 0)
                                    }
                                    
                                }
                            }.frame(maxWidth: .infinity)
                            
                            Rectangle().fill(Color.theme.eerieBlack).frame(height: 1)
                        }.frame(width: .infinity, height: 40)
                        
                        switch selectedSegment {
                        case 0:
                            AircraftStatusContainer(itemList: self.$itemAircraft, calculateHeight: self.calculateHeight, geoWidth: geoWidth).tag(selectedSegment).ignoresSafeArea()
                        case 1:
                            DepatureCardContainer(itemList: self.$itemDepature, calculateHeight: self.calculateHeight, geoWidth: geoWidth).tag(selectedSegment).ignoresSafeArea()
                        case 2:
                            EnrouteCardContainer(itemList: self.$itemEnroute, calculateHeight: self.calculateHeight, geoWidth: geoWidth).tag(selectedSegment).ignoresSafeArea()
                        case 3:
                            ArrivalCardContainer(itemList: self.$itemArrival, calculateHeight: self.calculateHeight, geoWidth: geoWidth).tag(selectedSegment).ignoresSafeArea()
                        default:
                            AircraftStatusContainer(itemList: self.$itemAircraft, calculateHeight: self.calculateHeight, geoWidth: geoWidth).tag(selectedSegment).ignoresSafeArea()
                        }
                    }.padding(.bottom, 16)
                    //                    .frame(height: animatedContentHeight).padding(.bottom, 16)
                }.frame(minWidth: 0, maxWidth: .infinity)
                    .padding(.horizontal, 16)
            }
        }.background(Color.theme.honeydew)
            .cornerRadius(8)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        
    }
    
    private func calculateHeight() {
        if self.selectedSegment == 1 {
            animatedContentHeight = CGFloat(98 + (60 * itemDepature.count))
        } else if self.selectedSegment == 2 {
            animatedContentHeight = CGFloat(98 + (60 * itemEnroute.count))
        } else if self.selectedSegment == 3 {
            animatedContentHeight = CGFloat(98 + (60 * itemArrival.count))
        } else {
            animatedContentHeight = itemAircraft.count > 0 ? CGFloat(98 + (60 * itemAircraft.count)) : 150
        }
    }
}
