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
let DataCountryDropdown = ["+93", "+358", "+355", "+213", "+376", "+244", "+54", "+297", "+247", "+43", "+994", "+973", "+880", "+375", "+32", "+501", "+229", "+975", "+591", "+387", "+267", "+55", "+673", "+359", "+226", "+257", "+855", "+237", "+238", "+236", "+235", "+86", "+61", "+57", "+269", "+242", "+243", "+682", "+506", "+385", "+53", "+357", "+420", "+45", "+246", "+253", "+670", "+56", "+593", "+20", "+503", "+240", "+291", "+372", "+251", "+268", "+298", "+691", "+679", "+358", "+33", "+594", "+689", "+241", "+220", "+49", "+233", "+350", "+30", "+299", "+502", "+224", "+245", "+592", "+509", "+504", "+852", "+36", "+354", "+91", "+62", "+98", "+964", "+353", "+972", "+225", "+81", "+962", "+254", "+686", "+383", "+965", "+996", "+856", "+371", "+961", "+266", "+231", "+218", "+423", "+370", "+352", "+853", "+261", "+265", "+60", "+960", "+223", "+356", "+692", "+596", "+222", "+230", "+52", "+373", "+377", "+976", "+382", "+258", "+95", "+374", "+264", "+674", "+977", "+31", "+687", "+505", "+227", "+234", "+683", "+672", "+850", "+389", "+968", "+92", "+680", "+970", "+972", "+507", "+675", "+595", "+51", "+63", "+64", "+48", "+351", "+974", "+262", "+40", "+7", "+250", "+590", "+508", "+685", "+378", "+239", "+966", "+221", "+381", "+248", "+232", "+65", "+599", "+421", "+386", "+677", "+252", "+27", "+500", "+82", "+995", "+211", "+34", "+94", "+249", "+597", "+47", "+46", "+41", "+963", "+886", "+992", "+255", "+66", "+228", "+690", "+676", "+290", "+216", "+90", "+993", "+688", "+256", "+380", "+971", "+598", "+998", "+678", "+39", "+58", "+84", "+1", "+44", "+681", "+212", "+967", "+260", "+263"]
let DataModelDropdown = ["A318", "A319", "A320", "A321", "A220", "A330", "A340", "A350", "A380", "B737", "B747", "B757", "B767", "B777", "B787", "E190", "E175", "C919", "C929", "AT4", "AT5", "ATR", "AT7"]
let DataLimitationDropdown = ["Maximum Flight Hours", "Maximum Duty Hours"]
let DataRecencyDropdown = ["Landing", "LVO"]
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

struct Mobile: Hashable {
    var country: String
    var number: String
}

struct IProfile: Identifiable, Hashable {
    var id = UUID()
    var user_id: String
    var userName: String
    var firstName: String
    var lastName: String
    var airline: String
    var mobile: Mobile
    var email: String
    var subscribe: String
}

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
    var limitationFlight: String
    var limitation: String
    var duration: String
    var startDate: String
    var endDate: String
    var completed: String
}

struct IProvideRecency: Identifiable, Hashable {
    var id = UUID()
    var type: String
    var modelName: String
    var requirement: String
    var frequency: String
    var periodStart: String
    var completed: String
}

struct IProvideExpiry: Identifiable, Hashable {
    var id = UUID()
    var expiredDate: String
    var requirement: String
    var documentType: String
}

class OnboardingModel: ObservableObject {
    @Published var dataYourProfile: IProfile = IProfile(user_id: "", userName: "", firstName: "", lastName: "", airline: "", mobile: Mobile(country: "", number: ""), email: "", subscribe: "")
    @Published var dataModelExperience = [IProvideExperience]()
    @Published var dataModelLimitation = [IProvideLimitation]()
    @Published var dataModelRecency = [IProvideRecency]()
    @Published var dataModelExpiry = [IProvideExpiry]()
}

class SignUpModel: ObservableObject {
    @Published var step = 1
}
