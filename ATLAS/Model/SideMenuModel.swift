//
//  ViewModel.swift
//  ATLAS
//
//  Created by phuong phan on 17/05/2023.
//

import Foundation

enum EMenuStatus {
    case working // double circle
    case none // circle
    case done // green circle
    case notDone // yellow circle
}

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
    var status: EMenuStatus?
}

let UpcomingMenuItems = [
    SubMenuItem(name: "SQ123", date: "31 May 2023", flight: "SIN-LHR", status: EMenuStatus.working),
    SubMenuItem(name: "SQ124", date: "1 Jun 2023", flight: "SIN-LHR", status: EMenuStatus.working),
    SubMenuItem(name: "SQ300", date: "4 Jun 2023", flight: "SIN-LHR", status: EMenuStatus.none),
    SubMenuItem(name: "SQ301", date: "5 Jun 2023", flight: "SIN-LHR", status: EMenuStatus.none),
    SubMenuItem(name: "SQ1235", date: "7 Jun 2023", flight: "SIN-LHR", status: EMenuStatus.none),
]

let CompletedMenuItems = [
    SubMenuItem(name: "SQ123", date: "24 May 2023", flight: "SIN-LHR", status: EMenuStatus.done),
    SubMenuItem(name: "SQ124", date: "25 Jun 2023", flight: "SIN-LHR", status: EMenuStatus.notDone),
    SubMenuItem(name: "SQ300", date: "27 Jun 2023", flight: "SIN-LHR", status: EMenuStatus.done),
    SubMenuItem(name: "SQ301", date: "28 Jun 2023", flight: "SIN-LHR", status: EMenuStatus.notDone),
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

class SideMenuModelState: ObservableObject {
    @Published var mainMenu: [MenuItem]
    @Published var selectedMenu: SubMenuItem?
        
    init() {
        self.mainMenu = [
            MenuItem(name: "Upcoming Flights", image: "linea-mini", subMenuItems: UpcomingMenuItems),
            MenuItem(name: "Completed Flights", image: "swift-mini", subMenuItems: CompletedMenuItems),
//            MenuItem(name: "Logbook", image: "swift-mini", subMenuItems: []),
//            MenuItem(name: "Sector Info", image: "swift-mini", subMenuItems: []),
//            MenuItem(name: "Flight Radar", image: "swift-mini", subMenuItems: []),
//            MenuItem(name: "Apps", image: "espresso-ep", subMenuItems: AppMenuItems)
        ]
        
        self.selectedMenu = UpcomingMenuItems.first
    }

}


struct BottomMenuItem: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var isExternal = false
}

struct BottomMenuModel {
    let BottomMenu = {
        let MainMenu = [
            BottomMenuItem(name: "list.bullet.clipboard"),
            BottomMenuItem(name: "fuelpump"),
            BottomMenuItem(name: "doc.plaintext"),
            BottomMenuItem(name: "map", isExternal: true),
            BottomMenuItem(name: "sun.max", isExternal: true),
            BottomMenuItem(name: "globe"),
            BottomMenuItem(name: "rectangle.stack"),
        ]
        
        return MainMenu
    }()
}
