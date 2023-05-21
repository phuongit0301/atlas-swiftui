//
//  DataEnum.swift
//  ATLAS
//
//  Created by phuong phan on 20/05/2023.
//

import Foundation

enum NavigationScreen {
    case home, flight
}

func getScreenName(name: NavigationScreen) -> String {
    switch name {
        case .flight:
            return "Flight"
        default:
            return "Home"
    }
}
