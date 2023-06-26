//
//  FlightPlanArrView.swift
//  ATLAS
//
//  Created by Muhammad Adil on 25/6/23.
//

import Foundation
import SwiftUI
import Combine

struct FlightPlanArrView: View {
    // initialise state variables
    // ATIS variables
    @State var dest: String = ""
    @State var code: String = ""
    @State var time: String = ""
    @State var rwy: String = ""
    @State var transLvl: String = ""
    @State var wind: String = ""
    @State var vis: String = ""
    @State var wx: String = ""
    @State var cloud: String = ""
    @State var temp: String = ""
    @State var dp: String = ""
    @State var qnh: String = ""
    @State var remarks: String = ""
    
    @State private var isEditingDest = false
    @State private var isEditingCode = false
    @State private var isEditingTime = false
    @State private var isEditingRwy = false
    @State private var isEditingTransLvl = false
    @State private var isEditingWind = false
    @State private var isEditingVis = false
    @State private var isEditingWx = false
    @State private var isEditingCloud = false
    @State private var isEditingTemp = false
    @State private var isEditingDP = false
    @State private var isEditingQNH = false
    @State private var isEditingRemarks = false
    
    @State private var cursorPositionDest = 0
    @State private var cursorPositionCode = 0
    @State private var cursorPositionTime = 0
    @State private var cursorPositionRwy = 0
    @State private var cursorPositionTransLvl = 0
    @State private var cursorPositionWind = 0
    @State private var cursorPositionVis = 0
    @State private var cursorPositionWx = 0
    @State private var cursorPositionCloud = 0
    @State private var cursorPositionTemp = 0
    @State private var cursorPositionDP = 0
    @State private var cursorPositionQNH = 0
    @State private var cursorPositionRemarks = 0
    
    @FocusState private var isTextFieldDestFocused: Bool
    @FocusState private var isTextFieldCodeFocused: Bool
    @FocusState private var isTextFieldTimeFocused: Bool
    @FocusState private var isTextFieldRwyFocused: Bool
    @FocusState private var isTextFieldTransLvlFocused: Bool
    @FocusState private var isTextFieldWindFocused: Bool
    @FocusState private var isTextFieldVisFocused: Bool
    @FocusState private var isTextFieldWxFocused: Bool
    @FocusState private var isTextFieldCloudFocused: Bool
    @FocusState private var isTextFieldTempFocused: Bool
    @FocusState private var isTextFieldDPFocused: Bool
    @FocusState private var isTextFieldQNHFocused: Bool
    @FocusState private var isTextFieldRemarksFocused: Bool
    
    // ATC variables
    @State var atcDest: String = ""
    @State var atcRwy: String = ""
    @State var atcArr: String = ""
    @State var atcTransLvl: String = ""
    
    @State private var isEditingAtcRwy = false
    @State private var isEditingAtcArr = false
    @State private var isEditingAtcDest = false
    @State private var isEditingAtcTransLvl = false
    
    @State private var cursorPositionAtcRwy = 0
    @State private var cursorPositionAtcArr = 0
    @State private var cursorPositionAtcDest = 0
    @State private var cursorPositionAtcTransLvl = 0
    
    @FocusState private var isTextFieldAtcRwyFocused: Bool
    @FocusState private var isTextFieldAtcArrFocused: Bool
    @FocusState private var isTextFieldAtcDestFocused: Bool
    @FocusState private var isTextFieldAtcTransLvlFocused: Bool
    
    // Entries variables
    @State var entLdg: String = ""
    @State var entFuelOnChocks: String = ""
    @State var entOn: String = ""
    
    @State private var isEditingEntLdg = false
    @State private var isEditingEntFuelOnChocks = false
    @State private var isEditingEntOn = false
    
    @State private var cursorPositionEntLdg = 0
    @State private var cursorPositionEntFuelOnChocks = 0
    @State private var cursorPositionEntOn = 0
    
    @FocusState private var isTextFieldEntLdgFocused: Bool
    @FocusState private var isTextFieldEntFuelOnChocksFocused: Bool
    @FocusState private var isTextFieldEntOnFocused: Bool
    
    // autofill variables
    @State private var isShowingAutofillOptionsWx = false
    @State private var isShowingAutofillOptionsCloud = false
    @State private var isShowingAutofillOptionsRemarks = false
    @State private var isShowingAutofillOptionsAtcRte = false

    @State private var autofillOptions: [String] = ["APPLE", "BANANA", "CHERRY", "BLUEBERRY"] // Replace with your own autofill options
    @State private var autofillText = ""
    
    var body: some View {
        let flightPlanData: [String : Any] = fetchFlightPlanData()
        let flightInfoData: InfoData = flightPlanData["infoData"] as! InfoData
        
        VStack(alignment: .leading) {
            // fixed header section, todo clean up design
            HStack(alignment: .center) {
                Text("Arrival")
                    .font(.title)
                    .padding(.leading, 30)
            }
            .padding(.bottom, 10)
            Text("Plan \(flightInfoData.planNo) | Last updated 0820LT")
            .padding(.leading, 30)
            .padding(.bottom, 10)
            //scrollable outer list section
            List {
                // ATIS section
                Section(header:
                    HStack {
                        Text("ATIS").foregroundStyle(Color.black)
                        TextField(" \(flightInfoData.dest)", text: $dest, onEditingChanged: { editing in
                            isEditingDest = editing
                        })
                        .focused($isTextFieldDestFocused)
                    }) {
                    // grouped row using hstack
                    VStack(alignment: .leading) {
//                        Group {
//                            HStack(alignment: .center) {
//                                Text("Code")
//                                .foregroundStyle(Color.blue)
//                                .frame(maxWidth: 144, alignment: .leading)
//                                TextField(
//                                    "Code",
//                                    text: $code
//                                )
//                                .onChange(of: code) { newValue in
//                                    // Limit the text to a maximum of 1 characters
//                                    if newValue.count > 0 {
//                                        code = String(newValue.prefix(1))
//                                        isTextFieldCodeFocused = false
//                                        isTextFieldTimeFocused = true
//                                    }
//                                }
//                                .textInputAutocapitalization(.words)
//                                .disableAutocorrection(true)
//                                .focused($isTextFieldCodeFocused)
//                                .frame(maxWidth: 860, alignment: .leading)
//                            }
//                            .padding(.top, 5)
//                            .padding(.bottom, 5)
//                            .padding(.leading, 25)
//                            Divider()
//                                .padding(.leading, 25)
//                            HStack(alignment: .center) {
//                                Text("Time")
//                                .foregroundStyle(Color.blue)
//                                .frame(maxWidth: 144, alignment: .leading)
//                                TextField(
//                                    "Time",
//                                    text: $time
//                                )
//                                .onChange(of: time) { newValue in
//                                    if newValue.count > 3 {
//                                        time = String(newValue.prefix(4))
//                                        isTextFieldTimeFocused = false
//                                        isTextFieldRwyFocused = true
//                                    }
//                                }
//                                .textInputAutocapitalization(.words)
//                                .disableAutocorrection(true)
//                                .focused($isTextFieldTimeFocused)
//                                .frame(maxWidth: 860, alignment: .leading)
//                            }
//                            .padding(.top, 5)
//                            .padding(.bottom, 5)
//                            .padding(.leading, 25)
//                            Divider()
//                                .padding(.leading, 25)
//                            HStack(alignment: .center) {
//                                Text("Rwy")
//                                .foregroundStyle(Color.blue)
//                                .frame(maxWidth: 144, alignment: .leading)
//                                TextField(
//                                    "Rwy",
//                                    text: $rwy
//                                )
//                                .onChange(of: rwy) { newValue in
//                                    if newValue.count > 10 {
//                                        rwy = String(newValue.prefix(11))
//                                        isTextFieldRwyFocused = false
//                                        isTextFieldTransLvlFocused = true
//                                    }
//                                }
//                                .textInputAutocapitalization(.words)
//                                .disableAutocorrection(true)
//                                .focused($isTextFieldRwyFocused)
//                                .frame(maxWidth: 860, alignment: .leading)
//                            }
//                            .padding(.top, 5)
//                            .padding(.bottom, 5)
//                            .padding(.leading, 25)
//                            Divider()
//                                .padding(.leading, 25)
//                            HStack(alignment: .center) {
//                                Text("Trans Lvl")
//                                .foregroundStyle(Color.blue)
//                                .frame(maxWidth: 144, alignment: .leading)
//                                TextField(
//                                    "Trans Lvl",
//                                    text: $transLvl
//                                )
//                                .onChange(of: transLvl) { newValue in
//                                    if newValue.count > 3 {
//                                        transLvl = String(newValue.prefix(4))
//                                        isTextFieldTransLvlFocused = false
//                                        isTextFieldWindFocused = true
//                                    }
//                                }
//                                .textInputAutocapitalization(.words)
//                                .disableAutocorrection(true)
//                                .focused($isTextFieldTransLvlFocused)
//                                .frame(maxWidth: 860, alignment: .leading)
//                            }
//                            .padding(.top, 5)
//                            .padding(.bottom, 5)
//                            .padding(.leading, 25)
//                            Divider()
//                                .padding(.leading, 25)
//                            HStack(alignment: .center) {
//                                Text("Wind")
//                                .foregroundStyle(Color.blue)
//                                .frame(maxWidth: 144, alignment: .leading)
//                                TextField(
//                                    "Wind",
//                                    text: $wind
//                                )
//                                .onChange(of: wind) { newValue in
//                                    if newValue.count > 5 {
//                                        wind = String(newValue.prefix(6))
//                                        isTextFieldWindFocused = false
//                                        isTextFieldVisFocused = true
//                                    }
//                                }
//                                .textInputAutocapitalization(.words)
//                                .disableAutocorrection(true)
//                                .focused($isTextFieldWindFocused)
//                                .frame(maxWidth: 860, alignment: .leading)
//                            }
//                            .padding(.top, 5)
//                            .padding(.bottom, 5)
//                            .padding(.leading, 25)
//                            Divider()
//                                .padding(.leading, 25)
//                        }
//                        Group {
//                            HStack(alignment: .center) {
//                                Text("Vis")
//                                .foregroundStyle(Color.blue)
//                                .frame(maxWidth: 144, alignment: .leading)
//                                TextField(
//                                    "Vis",
//                                    text: $vis
//                                )
//                                .onChange(of: vis) { newValue in
//                                    if newValue.count > 3 {
//                                        vis = String(newValue.prefix(4))
//                                        isTextFieldVisFocused = false
//                                        isTextFieldWxFocused = true
//                                    }
//                                }
//                                .textInputAutocapitalization(.words)
//                                .disableAutocorrection(true)
//                                .focused($isTextFieldVisFocused)
//                                .frame(maxWidth: 860, alignment: .leading)
//                            }
//                            .padding(.top, 5)
//                            .padding(.bottom, 5)
//                            .padding(.leading, 25)
//                            Divider()
//                                .padding(.leading, 25)
//                            HStack(alignment: .center) {
//                                Text("Wx")
//                                .foregroundStyle(Color.blue)
//                                .frame(maxWidth: 144, alignment: .leading)
//                                TextField(
//                                    "Wx",
//                                    text: $wx
//                                )
//    //                                .onChange(of: wx) { newValue in
//    //                                    if newValue.count > 5 {
//    //                                        wx = String(newValue.prefix(6))
//    //                                        isTextFieldWxFocused = false
//    //                                        isTextFieldCloudFocused = true
//    //                                    }
//    //                                }
//                                .textInputAutocapitalization(.words)
//                                .disableAutocorrection(true)
//                                .focused($isTextFieldWxFocused)
//                                .frame(maxWidth: 860, alignment: .leading)
//                            }
//                            .padding(.top, 5)
//                            .padding(.bottom, 5)
//                            .padding(.leading, 25)
//                            Divider()
//                                .padding(.leading, 25)
//                            HStack(alignment: .center) {
//                                Text("Cloud")
//                                .foregroundStyle(Color.blue)
//                                .frame(maxWidth: 144, alignment: .leading)
//                                TextField(
//                                    "Cloud",
//                                    text: $cloud
//                                )
//    //                                .onChange(of: cloud) { newValue in
//    //                                    if newValue.count > 5 {
//    //                                        cloud = String(newValue.prefix(6))
//    //                                        isTextFieldCloudFocused = false
//    //                                        isTextFieldTempFocused = true
//    //                                    }
//    //                                }
//                                .textInputAutocapitalization(.words)
//                                .disableAutocorrection(true)
//                                .focused($isTextFieldCloudFocused)
//                                .frame(maxWidth: 860, alignment: .leading)
//                            }
//                            .padding(.top, 5)
//                            .padding(.bottom, 5)
//                            .padding(.leading, 25)
//                            Divider()
//                                .padding(.leading, 25)
//                            HStack(alignment: .center) {
//                                Text("Temp")
//                                .foregroundStyle(Color.blue)
//                                .frame(maxWidth: 144, alignment: .leading)
//                                TextField(
//                                    "Temp",
//                                    text: $temp
//                                )
//                                .onChange(of: temp) { newValue in
//                                    if newValue.count > 1 {
//                                        temp = String(newValue.prefix(2))
//                                        isTextFieldTempFocused = false
//                                        isTextFieldDPFocused = true
//                                    }
//                                }
//                                .textInputAutocapitalization(.words)
//                                .disableAutocorrection(true)
//                                .focused($isTextFieldTempFocused)
//                                .frame(maxWidth: 860, alignment: .leading)
//                            }
//                            .padding(.top, 5)
//                            .padding(.bottom, 5)
//                            .padding(.leading, 25)
//                            Divider()
//                                .padding(.leading, 25)
//                            HStack(alignment: .center) {
//                                Text("DP")
//                                .foregroundStyle(Color.blue)
//                                .frame(maxWidth: 144, alignment: .leading)
//                                TextField(
//                                    "DP",
//                                    text: $dp
//                                )
//                                .onChange(of: dp) { newValue in
//                                    if newValue.count > 1 {
//                                        dp = String(newValue.prefix(2))
//                                        isTextFieldDPFocused = false
//                                        isTextFieldQNHFocused = true
//                                    }
//                                }
//                                .textInputAutocapitalization(.words)
//                                .disableAutocorrection(true)
//                                .focused($isTextFieldDPFocused)
//                                .frame(maxWidth: 860, alignment: .leading)
//                            }
//                            .padding(.top, 5)
//                            .padding(.bottom, 5)
//                            .padding(.leading, 25)
//                            Divider()
//                                .padding(.leading, 25)
//                        }
//                        Group {
//                            HStack(alignment: .center) {
//                                Text("QNH")
//                                .foregroundStyle(Color.blue)
//                                .frame(maxWidth: 144, alignment: .leading)
//                                TextField(
//                                    "QNH",
//                                    text: $qnh
//                                )
//                                .onChange(of: qnh) { newValue in
//                                    if newValue.count > 3 {
//                                        qnh = String(newValue.prefix(4))
//                                        isTextFieldQNHFocused = false
//                                        isTextFieldRemarksFocused = true
//                                    }
//                                }
//                                .textInputAutocapitalization(.words)
//                                .disableAutocorrection(true)
//                                .focused($isTextFieldQNHFocused)
//                                .frame(maxWidth: 860, alignment: .leading)
//                            }
//                            .padding(.top, 5)
//                            .padding(.bottom, 5)
//                            .padding(.leading, 25)
//                            Divider()
//                                .padding(.leading, 25)
//                            HStack(alignment: .center) {
//                                Text("Remarks")
//                                .foregroundStyle(Color.blue)
//                                .frame(maxWidth: 144, alignment: .leading)
//                                TextField(
//                                    "Remarks",
//                                    text: $remarks
//                                )
//    //                            .onChange(of: remarks) { newValue in
//    //                                if newValue.count > 1 {
//    //                                    remarks = String(newValue.prefix(2))
//    //                                    isTextFieldRemarksFocused = false
//    //                                }
//    //                            }
//                                .textInputAutocapitalization(.words)
//                                .disableAutocorrection(true)
//                                .focused($isTextFieldRemarksFocused)
//                                .frame(maxWidth: 860, alignment: .leading)
//                            }
//                            .padding(.top, 5)
//                            .padding(.bottom, 5)
//                            .padding(.leading, 25)
//                            Divider()
//                                .padding(.leading, 25)
//                        }
                        
                        HStack(alignment: .center) {
                            Group {
                                Text("Code")
                                .foregroundStyle(Color.blue)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Time")
                                .foregroundStyle(Color.blue)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Rwy")
                                .foregroundStyle(Color.blue)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Trans Lvl")
                                .foregroundStyle(Color.blue)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Wind")
                                .foregroundStyle(Color.blue)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Vis")
                                .foregroundStyle(Color.blue)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Wx")
                                .foregroundStyle(Color.blue)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Cloud")
                                .foregroundStyle(Color.blue)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Temp")
                                .foregroundStyle(Color.blue)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                Text("DP")
                                .foregroundStyle(Color.blue)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            Text("QNH")
                            .foregroundStyle(Color.blue)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Remarks")
                            .foregroundStyle(Color.blue)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        } // todo correct design and spacing
                        .padding(.top, 5)
                        .padding(.bottom, 5)
                        .padding(.leading, 25)
                        Divider()
                            .padding(.leading, 25)
                        HStack(alignment: .center) {
                            Group {
                                TextField("Code", text: $code, onEditingChanged: { editing in
                                    isEditingCode = editing
                                })
                                .onChange(of: code) { newValue in
                                    // Limit the text to a maximum of 1 characters
                                    if newValue.count > 0 {
                                        code = String(newValue.prefix(1))
                                        isTextFieldCodeFocused = false
                                        isTextFieldTimeFocused = true
                                    }
                                }
                                .focused($isTextFieldCodeFocused)
                                TextField("Time", text: $time, onEditingChanged: { editing in
                                    isEditingTime = editing
                                })
                                .onChange(of: time) { newValue in
                                    if newValue.count > 3 {
                                        time = String(newValue.prefix(4))
                                        isTextFieldTimeFocused = false
                                        isTextFieldRwyFocused = true
                                    }
                                }
                                .focused($isTextFieldTimeFocused)
                            }
                            Group {
                                TextField("Rwy", text: $rwy, onEditingChanged: { editing in
                                        isEditingRwy = editing
                                    })
                                .onChange(of: rwy) { newValue in
                                    if newValue.count > 10 {
                                        rwy = String(newValue.prefix(11))
                                        isTextFieldRwyFocused = false
                                        isTextFieldTransLvlFocused = true
                                    }
                                }
                                .focused($isTextFieldRwyFocused)
                                TextField( "Trans Lvl", text: $transLvl, onEditingChanged: { editing in
                                        isEditingTransLvl = editing
                                    })
                                .onChange(of: transLvl) { newValue in
                                    if newValue.count > 3 {
                                        transLvl = String(newValue.prefix(4))
                                        isTextFieldTransLvlFocused = false
                                        isTextFieldWindFocused = true
                                    }
                                }
                                .focused($isTextFieldTransLvlFocused)
                            }
                            Group {
                                TextField( "Wind", text: $wind, onEditingChanged: { editing in
                                        isEditingWind = editing
                                    })
                                .onChange(of: wind) { newValue in
                                    if newValue.count > 5 {
                                        wind = String(newValue.prefix(6))
                                        isTextFieldWindFocused = false
                                        isTextFieldVisFocused = true
                                    }
                                }
                                .focused($isTextFieldWindFocused)
                                TextField("Vis", text: $vis, onEditingChanged: { editing in
                                        isEditingVis = editing
                                    })
                                .onChange(of: vis) { newValue in
                                    if newValue.count > 3 {
                                        vis = String(newValue.prefix(4))
                                        isTextFieldVisFocused = false
                                        isTextFieldWxFocused = true
                                    }
                                }
                                .focused($isTextFieldVisFocused)
                            }
                            Group {
                                TextField("Wx", text: $wx, onEditingChanged: { editing in
                                        isEditingWx = editing
                                    })
                                .focused($isTextFieldWxFocused)
                                .onReceive(Just(wx)) { text in
                                    let components = text.components(separatedBy: " ")
                                    if let lastComponent = components.last, lastComponent.hasPrefix(".") && lastComponent.count > 1 {
                                        let searchTerm = String(lastComponent.dropFirst())
                                        autofillText = searchTerm
                                        isShowingAutofillOptionsWx = true
                                    } else {
                                        isShowingAutofillOptionsWx = false
                                    }
                                }
                                TextField("Cloud", text: $cloud, onEditingChanged: { editing in
                                        isEditingCloud = editing
                                    })
                                .focused($isTextFieldCloudFocused)
                                .onReceive(Just(cloud)) { text in
                                    let components = text.components(separatedBy: " ")
                                    if let lastComponent = components.last, lastComponent.hasPrefix(".") && lastComponent.count > 1 {
                                        let searchTerm = String(lastComponent.dropFirst())
                                        autofillText = searchTerm
                                        isShowingAutofillOptionsCloud = true
                                    } else {
                                        isShowingAutofillOptionsCloud = false
                                    }
                                }
                            }
                            Group {
                                TextField("Temp", text: $temp, onEditingChanged: { editing in
                                        isEditingTemp = editing
                                    })
                                .onChange(of: temp) { newValue in
                                    if newValue.count > 1 {
                                        temp = String(newValue.prefix(2))
                                        isTextFieldTempFocused = false
                                        isTextFieldDPFocused = true
                                    }
                                }
                                .focused($isTextFieldTempFocused)
                                TextField(
                                    "DP",
                                    text: $dp, onEditingChanged: { editing in
                                        isEditingDP = editing
                                    })
                                .onChange(of: dp) { newValue in
                                    if newValue.count > 1 {
                                        dp = String(newValue.prefix(2))
                                        isTextFieldDPFocused = false
                                        isTextFieldQNHFocused = true
                                    }
                                }
                                .focused($isTextFieldDPFocused)
                            }
                            Group {
                                TextField("QNH", text: $qnh, onEditingChanged: { editing in
                                        isEditingQNH = editing
                                    })
                                .onChange(of: qnh) { newValue in
                                    if newValue.count > 3 {
                                        qnh = String(newValue.prefix(4))
                                        isTextFieldQNHFocused = false
                                        isTextFieldRemarksFocused = true
                                    }
                                }
                                .focused($isTextFieldQNHFocused)
                                TextField("Remarks", text: $remarks, onEditingChanged: { editing in
                                        isEditingRemarks = editing
                                    })
                                .focused($isTextFieldRemarksFocused)
                                .onReceive(Just(remarks)) { text in
                                    let components = text.components(separatedBy: " ")
                                    if let lastComponent = components.last, lastComponent.hasPrefix(".") && lastComponent.count > 1 {
                                        let searchTerm = String(lastComponent.dropFirst())
                                        autofillText = searchTerm
                                        isShowingAutofillOptionsRemarks = true
                                    } else {
                                        isShowingAutofillOptionsRemarks = false
                                    }
                                }
                            }
                        }
                        .padding(.top, 5)
                        .padding(.bottom, 5)
                        .padding(.leading, 25)
                    }
                }
                
                // ATC section
                Section(header: Text("ATC").foregroundStyle(Color.black)) {
                    // grouped row using hstack
                    VStack(alignment: .leading) {
                        HStack(alignment: .center) {
                            Group {
                                Text("Dest")
                                .foregroundStyle(Color.blue)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Rwy")
                                .foregroundStyle(Color.blue)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Arr")
                                .foregroundStyle(Color.blue)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Trans Lvl")
                                .foregroundStyle(Color.blue)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        } // todo correct design and spacing
                        .padding(.top, 5)
                        .padding(.bottom, 5)
                        .padding(.leading, 25)
                        Divider()
                            .padding(.leading, 25)
                        HStack(alignment: .center) {
                            Group {
                                TextField(" \(flightInfoData.dest)", text: $atcDest, onEditingChanged: { editing in
                                    isEditingAtcDest = editing
                                })
                                .onChange(of: atcDest) { newValue in
                                    if newValue.count > 2 {
                                        atcDest = String(newValue.prefix(3))
                                        isTextFieldAtcDestFocused = false
                                        isTextFieldAtcRwyFocused = true
                                    }
                                }
                                .focused($isTextFieldAtcDestFocused)
                                TextField("Rwy", text: $atcRwy, onEditingChanged: { editing in
                                    isEditingAtcRwy = editing
                                })
                                .onChange(of: atcRwy) { newValue in
                                    if newValue.count > 2 {
                                        atcRwy = String(newValue.prefix(3))
                                        isTextFieldAtcRwyFocused = false
                                        isTextFieldAtcArrFocused = true
                                    }
                                }
                                .focused($isTextFieldAtcRwyFocused)
                            }
                            Group {
                                TextField("Arr", text: $atcArr, onEditingChanged: { editing in
                                        isEditingAtcArr = editing
                                    })
                                .focused($isTextFieldAtcArrFocused)
                                TextField("Trans Lvl", text: $atcTransLvl, onEditingChanged: { editing in
                                        isEditingAtcTransLvl = editing
                                    })
                                .onChange(of: atcTransLvl) { newValue in
                                    if newValue.count > 3 {
                                        atcRwy = String(newValue.prefix(4))
                                        isTextFieldAtcTransLvlFocused = false
                                        isTextFieldAtcDestFocused = true
                                    }
                                }
                                .focused($isTextFieldAtcTransLvlFocused)
                            }
                        }
                        .padding(.top, 5)
                        .padding(.bottom, 5)
                        .padding(.leading, 25)
                    }
                }
                // Entries section
                Section(header: Text("Entries").foregroundStyle(Color.black)) {
                    // grouped row using hstack
                    VStack(alignment: .leading) {
                        HStack(alignment: .center) {
                            Group {
                                Text("Landing")
                                .foregroundStyle(Color.blue)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Chocks On")
                                .foregroundStyle(Color.blue)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Fuel on Chocks")
                                .foregroundStyle(Color.blue)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        } // todo correct design and spacing
                        .padding(.top, 5)
                        .padding(.bottom, 5)
                        .padding(.leading, 25)
                        Divider()
                            .padding(.leading, 25)
                        HStack(alignment: .center) {
                            Group {
                                TextField("Landing", text: $entLdg, onEditingChanged: { editing in
                                    isEditingEntLdg = editing
                                })
                                .onChange(of: entLdg) { newValue in
                                    if newValue.count > 3 {
                                        entLdg = String(newValue.prefix(4))
                                        isTextFieldEntLdgFocused = false
                                        isTextFieldEntOnFocused = true
                                    }
                                }
                                .focused($isTextFieldEntLdgFocused)
                            }
                            Group {
                                TextField("Chocks On", text: $entOn, onEditingChanged: { editing in
                                        isEditingEntOn = editing
                                    })
                                .onChange(of: entOn) { newValue in
                                    if newValue.count > 3 {
                                        entOn = String(newValue.prefix(4))
                                        isTextFieldEntOnFocused = false
                                        isTextFieldEntFuelOnChocksFocused = true
                                    }
                                }
                                .focused($isTextFieldEntOnFocused)
                            }
                            Group {
                                TextField("Fuel on Chocks", text: $entFuelOnChocks, onEditingChanged: { editing in
                                        isEditingEntFuelOnChocks = editing
                                    })
                                .onChange(of: entFuelOnChocks) { newValue in
                                    if newValue.count > 4 {
                                        entFuelOnChocks = String(newValue.prefix(5))
                                        isTextFieldEntFuelOnChocksFocused = false
                                        isTextFieldEntLdgFocused = true
                                    }
                                }
                                .focused($isTextFieldEntFuelOnChocksFocused)
                            }
                        }
                        .padding(.top, 5)
                        .padding(.bottom, 5)
                        .padding(.leading, 25)
                    }
                }
            }
            // custom keyboard view - todo set position properly - like normal ipad keyboard position
            Group {
                if isEditingCode {
                    CustomKeyboardView(text: $code, cursorPosition: $cursorPositionCode, currentFocus: _isTextFieldCodeFocused, nextFocus: _isTextFieldTimeFocused, prevFocus: _isTextFieldRemarksFocused)
                }
                if isEditingTime {
                    CustomKeyboardView(text: $time, cursorPosition: $cursorPositionTime, currentFocus: _isTextFieldTimeFocused, nextFocus: _isTextFieldRwyFocused, prevFocus: _isTextFieldCodeFocused)
                }
                if isEditingRwy {
                    CustomKeyboardView(text: $rwy, cursorPosition: $cursorPositionRwy, currentFocus: _isTextFieldRwyFocused, nextFocus: _isTextFieldTransLvlFocused, prevFocus: _isTextFieldTimeFocused)
                }
                if isEditingTransLvl {
                    CustomKeyboardView(text: $transLvl, cursorPosition: $cursorPositionTransLvl, currentFocus: _isTextFieldTransLvlFocused, nextFocus: _isTextFieldWindFocused, prevFocus: _isTextFieldRwyFocused)
                }
                if isEditingWind {
                    CustomKeyboardView(text: $wind, cursorPosition: $cursorPositionWind, currentFocus: _isTextFieldWindFocused, nextFocus: _isTextFieldVisFocused, prevFocus: _isTextFieldTransLvlFocused)
                }
                if isEditingVis {
                    CustomKeyboardView(text: $vis, cursorPosition: $cursorPositionVis, currentFocus: _isTextFieldVisFocused, nextFocus: _isTextFieldWxFocused, prevFocus: _isTextFieldWindFocused)
                }
                if isEditingWx {
                    CustomKeyboardView(text: $wx, cursorPosition: $cursorPositionWx, currentFocus: _isTextFieldWxFocused, nextFocus: _isTextFieldCloudFocused, prevFocus: _isTextFieldVisFocused)
                }
                if isEditingCloud {
                    CustomKeyboardView(text: $cloud, cursorPosition: $cursorPositionCloud, currentFocus: _isTextFieldCloudFocused, nextFocus: _isTextFieldTempFocused, prevFocus: _isTextFieldWxFocused)
                }
                if isEditingTemp {
                    CustomKeyboardView(text: $temp, cursorPosition: $cursorPositionTemp, currentFocus: _isTextFieldTempFocused, nextFocus: _isTextFieldDPFocused, prevFocus: _isTextFieldCloudFocused)
                }
                if isEditingDP {
                    CustomKeyboardView(text: $dp, cursorPosition: $cursorPositionDP, currentFocus: _isTextFieldDPFocused, nextFocus: _isTextFieldQNHFocused, prevFocus: _isTextFieldTempFocused)
                }
            }
            Group {
                if isEditingQNH {
                    CustomKeyboardView(text: $qnh, cursorPosition: $cursorPositionQNH, currentFocus: _isTextFieldQNHFocused, nextFocus: _isTextFieldRemarksFocused, prevFocus: _isTextFieldDPFocused)
                }
                if isEditingRemarks {
                    CustomKeyboardView(text: $remarks, cursorPosition: $cursorPositionRemarks, currentFocus: _isTextFieldRemarksFocused, nextFocus: _isTextFieldCodeFocused, prevFocus: _isTextFieldQNHFocused)
                }
                if isEditingDest {
                    CustomKeyboardView(text: $dest, cursorPosition: $cursorPositionDest, currentFocus: _isTextFieldDestFocused, nextFocus: _isTextFieldDestFocused, prevFocus: _isTextFieldDestFocused)
                }
            }
            Group {
                if isEditingAtcDest {
                    CustomKeyboardView(text: $atcDest, cursorPosition: $cursorPositionAtcDest, currentFocus: _isTextFieldAtcDestFocused, nextFocus: _isTextFieldAtcRwyFocused, prevFocus: _isTextFieldAtcTransLvlFocused)
                }
                if isEditingAtcRwy {
                    CustomKeyboardView(text: $atcRwy, cursorPosition: $cursorPositionAtcRwy, currentFocus: _isTextFieldAtcRwyFocused, nextFocus: _isTextFieldAtcArrFocused, prevFocus: _isTextFieldAtcDestFocused)
                }
                if isEditingAtcArr {
                    CustomKeyboardView(text: $atcArr, cursorPosition: $cursorPositionAtcArr, currentFocus: _isTextFieldAtcArrFocused, nextFocus: _isTextFieldAtcTransLvlFocused, prevFocus: _isTextFieldAtcRwyFocused)
                }
                if isEditingAtcTransLvl {
                    CustomKeyboardView(text: $atcTransLvl, cursorPosition: $cursorPositionAtcTransLvl, currentFocus: _isTextFieldAtcTransLvlFocused, nextFocus: _isTextFieldAtcRwyFocused, prevFocus: _isTextFieldAtcArrFocused)
                }
            }
            Group {
                if isEditingEntLdg {
                    CustomKeyboardView(text: $entLdg, cursorPosition: $cursorPositionEntLdg, currentFocus: _isTextFieldEntLdgFocused, nextFocus: _isTextFieldEntOnFocused, prevFocus: _isTextFieldEntFuelOnChocksFocused)
                }
                if isEditingEntOn {
                    CustomKeyboardView(text: $entOn, cursorPosition: $cursorPositionEntOn, currentFocus: _isTextFieldEntOnFocused, nextFocus: _isTextFieldEntFuelOnChocksFocused, prevFocus: _isTextFieldEntLdgFocused)
                }
                if isEditingEntFuelOnChocks {
                    CustomKeyboardView(text: $entFuelOnChocks, cursorPosition: $cursorPositionEntFuelOnChocks, currentFocus: _isTextFieldEntFuelOnChocksFocused, nextFocus: _isTextFieldEntLdgFocused, prevFocus: _isTextFieldEntOnFocused)
                }
            }
            Group {
                if isShowingAutofillOptionsWx {
                    List(autofillOptions.filter { $0.hasPrefix(autofillText) }, id: \.self) { option in
                        Button(action: {
                            let modifiedText = wx.components(separatedBy: " ").dropLast().joined(separator: " ")
                            cursorPositionWx -= wx.count
                            wx = modifiedText + " " + option + " "
                            cursorPositionWx += wx.count
                            isShowingAutofillOptionsWx = false
                        }) {
                            Text(option)
                        }
                    }
                    .listStyle(GroupedListStyle())
                }
                if isShowingAutofillOptionsCloud {
                    List(autofillOptions.filter { $0.hasPrefix(autofillText) }, id: \.self) { option in
                        Button(action: {
                            let modifiedText = cloud.components(separatedBy: " ").dropLast().joined(separator: " ")
                            cursorPositionCloud -= cloud.count
                            cloud = modifiedText + " " + option + " "
                            cursorPositionCloud += cloud.count
                            isShowingAutofillOptionsCloud = false
                        }) {
                            Text(option)
                        }
                    }
                    .listStyle(GroupedListStyle())
                }
                if isShowingAutofillOptionsRemarks {
                    List(autofillOptions.filter { $0.hasPrefix(autofillText) }, id: \.self) { option in
                        Button(action: {
                            let modifiedText = remarks.components(separatedBy: " ").dropLast().joined(separator: " ")
                            cursorPositionRemarks -= remarks.count
                            remarks = modifiedText + " " + option + " "
                            cursorPositionRemarks += remarks.count
                            isShowingAutofillOptionsRemarks = false
                        }) {
                            Text(option)
                        }
                    }
                    .listStyle(GroupedListStyle())
                }
            }
        }
        .navigationTitle("Arrival")
        .background(Color(.systemGroupedBackground))
    }
}

