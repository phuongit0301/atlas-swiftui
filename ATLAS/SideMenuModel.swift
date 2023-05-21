//
//  ViewModel.swift
//  ATLAS
//
//  Created by phuong phan on 17/05/2023.
//

import Foundation

struct MenuItem: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var image: String?
    var subMenuItems: [SubMenuItem]
}

struct SubMenuItem: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var date: String?
    var flight: String?
    var isExternal: Bool?
}

struct SideMenuModel {
    let SideMenu = {
        let UpcomingMenuItems = [
            SubMenuItem(name: "SQ123", date: "31 May 2023", flight: "SIN-LHR"),
            SubMenuItem(name: "SQ124", date: "1 Jun 2023", flight: "SIN-LHR"),
            SubMenuItem(name: "SQ300", date: "4 Jun 2023", flight: "SIN-LHR"),
            SubMenuItem(name: "SQ301", date: "5 Jun 2023", flight: "SIN-LHR"),
            SubMenuItem(name: "SQ1235", date: "7 Jun 2023", flight: "SIN-LHR"),
        ]
        
        let CompletedMenuItems = [
            SubMenuItem(name: "SQ123", date: "24 May 2023", flight: "SIN-LHR"),
            SubMenuItem(name: "SQ124", date: "25 Jun 2023", flight: "SIN-LHR"),
            SubMenuItem(name: "SQ300", date: "27 Jun 2023", flight: "SIN-LHR"),
            SubMenuItem(name: "SQ301", date: "28 Jun 2023", flight: "SIN-LHR"),
        ]
        
        let AppMenuItems = [
            SubMenuItem(name: "Flight Plans", isExternal: false),
            SubMenuItem(name: "Weather", isExternal: true),
            SubMenuItem(name: "Charts", isExternal: true),
            SubMenuItem(name: "Flight Notes", isExternal: false),
            SubMenuItem(name: "Fuel Calculator", isExternal: false),
            SubMenuItem(name: "Flight Reports", isExternal: false),
            SubMenuItem(name: "Documents", isExternal: false),
        
        
        ]
        
        let MainMenu = [
            MenuItem(name: "Upcoming Flights", image: "linea-mini", subMenuItems: UpcomingMenuItems),
            MenuItem(name: "Completed Flights", image: "swift-mini", subMenuItems: CompletedMenuItems),
            MenuItem(name: "Apps", image: "espresso-ep", subMenuItems: AppMenuItems)
        ]
        
        return MainMenu
    }()
}
