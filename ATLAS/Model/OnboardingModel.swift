//
//  OnboardingModel.swift
//  ATLAS
//
//  Created by phuong phan on 01/10/2023.
//

import Foundation

struct ICheckList {
    var id = UUID()
    var name: String
    var isCompleted: Bool
}

let DataCheckList = [
    ICheckList(name: "Complete your profile", isCompleted: false),
    ICheckList(name: "Provide your flying experience", isCompleted: false),
    ICheckList(name: "Provide your limitations", isCompleted: false),
    ICheckList(name: "Provide your recencies", isCompleted: false),
    ICheckList(name: "Provide your expiry information", isCompleted: false),
]

let DataAirlineDropdown = ["Accumulus Airlines", "Accumulus Airlines 1", "Accumulus Airlines 2"]
let DataCountryDropdown = ["65", "68", "84"]
let DataModelDropdown = ["B777-300ER/SF", "B222-300ER/SF", "B444-300ER/SF"]

struct IProvideExperience: Identifiable, Hashable {
    var id = UUID()
    var modelName: String
    var pic: String
    var picUs: String
    var p1: String
    var p2: String
    var instr: String
    var exam: String
    var totalTime: String
}
