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
    
    @State private var collapsed: Bool = false
    
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
                    Tabs(tabs: tabs, geoWidth: geoWidth - 100, selectedTab: $currentTab)
                    // Views
                    TabView(selection: $currentTab,
                        content: {
                        AircraftStatusForm().tag(0).ignoresSafeArea()
                        
                        DepatureCardForm(itemList: self.$itemDepature).tag(1).ignoresSafeArea()
                        
                        EnrouteCardForm(itemList: self.$itemEnroute).tag(2).ignoresSafeArea()
                        
                        ArrivalCardForm(itemList: self.$itemArrival).tag(3).ignoresSafeArea()
                            
                    })
                    .tabViewStyle(DefaultTabViewStyle())
                        .frame(height: animatedContentHeight)
                        .onChange(of: currentTab) { newValue in
                            if currentTab == 0 {
                                animatedContentHeight = 98
                            } else if currentTab == 1 {
                                animatedContentHeight = CGFloat(98 + (54 * itemDepature.count))
                            } else if currentTab == 2 {
                                animatedContentHeight = CGFloat(98 + (54 * itemArrival.count))
                            } else {
                                animatedContentHeight = CGFloat(98 + (54 * itemArrival.count))
                            }
                        }
                }.frame(minWidth: 0, maxWidth: .infinity)
                    .padding(.horizontal, 16)
                    .clipped()
            }
        }.background(Color.theme.honeydew)
        .cornerRadius(8)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}
