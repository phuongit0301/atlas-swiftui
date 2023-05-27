//
//  QuickReferenceCard.swift
//  ATLAS
//
//  Created by phuong phan on 22/05/2023.
//

import Foundation
import SwiftUI

struct QuickReferenceCard: View {
    var geoWidth: Double = 0
    // Mock Data tabs
    @State var itemDepature = DepartureFlightInfoModel().ListItem
    @State var itemArrival = ArrivalFlightInfoModel().ListItem
    @State var itemEnroute = EnrouteFlightInfoModel().ListItem
    
    @State private var currentTab: Int = 0
    @State var animatedContentHeight: CGFloat = 98
    
    @State private var tabs: [Tab] = [
        .init(title: "Aircraft Status"),
        .init(title: "Departure"),
        .init(title: "Enroute"),
        .init(title: "Arrival"),
    ]
    
    @State private var selectedSegment = 0
    
    @State private var collapsed: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(
                action: { self.collapsed.toggle() },
                label: {
                    HStack(alignment: .center) {
                        Text("Quick Reference")
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
                                                
                                                if index == 0 {
                                                    animatedContentHeight = 98
                                                } else if index == 1 {
                                                    animatedContentHeight = CGFloat(98 + (64 * itemDepature.count))
                                                } else if index == 2 {
                                                    animatedContentHeight = CGFloat(98 + (64 * itemArrival.count))
                                                } else {
                                                    animatedContentHeight = CGFloat(98 + (64 * itemArrival.count))
                                                }
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
                            }
                            Rectangle().fill(Color.theme.eerieBlack).frame(height: 1)
                        }
                        
                        switch selectedSegment {
                        case 0:
                            AircraftStatusContainer().tag(selectedSegment).ignoresSafeArea()
                        case 1:
                            DepatureCardContainer(itemList: self.$itemDepature).tag(selectedSegment).ignoresSafeArea()
                        case 2:
                            EnrouteCardContainer(itemList: self.$itemEnroute).tag(selectedSegment).ignoresSafeArea()
                        case 3:
                            ArrivalCardContainer(itemList: self.$itemArrival).tag(selectedSegment).ignoresSafeArea()
                        default:
                            AircraftStatusContainer().tag(selectedSegment).ignoresSafeArea()
                        }
                    }.frame(height: animatedContentHeight).padding(.bottom, 16)
                    
                }.frame(minWidth: 0, maxWidth: .infinity)
                    .padding(.horizontal, 16)
            }
        }.background(Color.theme.honeydew)
        .cornerRadius(8)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}
