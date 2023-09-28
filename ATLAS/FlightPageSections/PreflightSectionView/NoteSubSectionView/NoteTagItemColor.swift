//
//  NoteTagItemColor.swift
//  ATLAS
//
//  Created by phuong phan on 26/06/2023.
//

import Foundation
import SwiftUI

struct NoteTagItemColor: View {
    let name: String
    
    var body: some View {
        HStack(alignment: .center) {
            Text(name).font(.system(size: 11, weight: .regular))
        }.padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background(handleBgColor(name))
            .foregroundColor(Color.white)
            .cornerRadius(16)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(handleBgColor(name), lineWidth: 1))
    }
    
    func handleBgColor(_ name: String) -> Color {
        if name.lowercased() == "weather" {
            return Color.theme.seaSerpent
        } else if name.lowercased() == "turbulence" {
            return Color.theme.radicalRed
        } else if name.lowercased() == "wind" {
            return Color.theme.mayaBlue
        } else if name.lowercased() == "runway" {
            return Color.theme.vividGamboge
        } else if name.lowercased() == "congestion" {
            return Color.theme.cafeAuLait
        } else if name.lowercased() == "hazard" {
            return Color.theme.coralRed1
        } else if name.lowercased() == "general" {
            return Color.theme.iris
        } else if name.lowercased() == "Ask AABBA" {
            return Color.theme.mediumOrchid
        }
        return Color.theme.azure
    }
}
