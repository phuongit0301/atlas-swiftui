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
let DataLimitationDropdown = ["Maximum flight hours", "Maximum flight hours 1", "Maximum flight hours 2"]
let DataRecencyDropdown = ["Landing 1", "Landing 2", "Landing 3"]
let DataExpiryDropdown = ["Instructor Rating 1", "Instructor Rating 2", "Instructor Rating 3"]

struct IRecencyModel: Identifiable, Hashable {
    var id = UUID()
    var name: String
}

let DataRecencyModelDropdown: [IRecencyModel] = [
    IRecencyModel(name: "B777"),
    IRecencyModel(name: "B222"),
    IRecencyModel(name: "B444")
]

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

struct IProvideLimitation: Identifiable, Hashable {
    var id = UUID()
    var limitation: Int
    var duration: Int
    var startDate: String
    var endDate: String
    var completed: Int
}

struct IProvideRecency: Identifiable, Hashable {
    var id = UUID()
    var modelName: String
    var requirement: Int
    var frequency: Int
    var periodStart: String
    var completed: Int
}

struct IProvideExpiry: Identifiable, Hashable {
    var id = UUID()
    var expiredDate: String
    var requirement: String
    var documentType: String
}
