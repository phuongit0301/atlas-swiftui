//
//  FlightPlanDepView.swift
//  ATLAS
//
//  Created by Muhammad Adil on 22/6/23.
//

import Foundation
import SwiftUI

struct FlightPlanDepView: View {
    // initialise state variables
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
    
    @State private var isEditing = false
    @State private var cursorPosition = 0
    
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
    
    var body: some View {
        let flightPlanData: [String : Any] = fetchFlightPlanData()
        let flightInfoData: InfoData = flightPlanData["infoData"] as! InfoData
        
        VStack(alignment: .leading) {
            // fixed header section, todo clean up design
            HStack(alignment: .center) {
                Text("Departure")
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
                Section(header: Text("ATIS \(flightInfoData.dep)").foregroundStyle(Color.black)) {
                    // grouped row using hstack
                    VStack(alignment: .leading) {
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
                                TextField(
                                    "Code",
                                    text: $code
                                )
                                .onChange(of: code) { newValue in
                                    // Limit the text to a maximum of 1 characters
                                    if newValue.count > 0 {
                                        code = String(newValue.prefix(1))
                                        isTextFieldCodeFocused = false
                                        isTextFieldTimeFocused = true
                                    }
                                }
                                .textInputAutocapitalization(.words)
                                .disableAutocorrection(true)
                                .focused($isTextFieldCodeFocused)
                                TextField(
                                    "Time",
                                    text: $time
                                )
                                .onChange(of: time) { newValue in
                                    if newValue.count > 3 {
                                        time = String(newValue.prefix(4))
                                        isTextFieldTimeFocused = false
                                        isTextFieldRwyFocused = true
                                    }
                                }
                                .textInputAutocapitalization(.words)
                                .disableAutocorrection(true)
                                .focused($isTextFieldTimeFocused)
                                TextField(
                                    "Rwy",
                                    text: $rwy
                                )
                                .onChange(of: rwy) { newValue in
                                    if newValue.count > 10 {
                                        rwy = String(newValue.prefix(11))
                                        isTextFieldRwyFocused = false
                                        isTextFieldTransLvlFocused = true
                                    }
                                }
                                .textInputAutocapitalization(.words)
                                .disableAutocorrection(true)
                                .focused($isTextFieldRwyFocused)
                                TextField(
                                    "Trans Lvl",
                                    text: $transLvl
                                )
                                .onChange(of: transLvl) { newValue in
                                    if newValue.count > 3 {
                                        transLvl = String(newValue.prefix(4))
                                        isTextFieldTransLvlFocused = false
                                        isTextFieldWindFocused = true
                                    }
                                }
                                .textInputAutocapitalization(.words)
                                .disableAutocorrection(true)
                                .focused($isTextFieldTransLvlFocused)
                                TextField(
                                    "Wind",
                                    text: $wind
                                )
                                .onChange(of: wind) { newValue in
                                    if newValue.count > 5 {
                                        wind = String(newValue.prefix(6))
                                        isTextFieldWindFocused = false
                                        isTextFieldVisFocused = true
                                    }
                                }
                                .textInputAutocapitalization(.words)
                                .disableAutocorrection(true)
                                .focused($isTextFieldWindFocused)
                                TextField(
                                    "Vis",
                                    text: $vis
                                )
                                .onChange(of: vis) { newValue in
                                    if newValue.count > 3 {
                                        vis = String(newValue.prefix(4))
                                        isTextFieldVisFocused = false
                                        isTextFieldWxFocused = true
                                    }
                                }
                                .textInputAutocapitalization(.words)
                                .disableAutocorrection(true)
                                .focused($isTextFieldVisFocused)
                                TextField(
                                    "Wx",
                                    text: $wx
                                )
//                                .onChange(of: wx) { newValue in
//                                    if newValue.count > 5 {
//                                        wx = String(newValue.prefix(6))
//                                        isTextFieldWxFocused = false
//                                        isTextFieldCloudFocused = true
//                                    }
//                                }
                                .textInputAutocapitalization(.words)
                                .disableAutocorrection(true)
                                .focused($isTextFieldWxFocused)
                                TextField(
                                    "Cloud",
                                    text: $cloud
                                )
//                                .onChange(of: cloud) { newValue in
//                                    if newValue.count > 5 {
//                                        cloud = String(newValue.prefix(6))
//                                        isTextFieldCloudFocused = false
//                                        isTextFieldTempFocused = true
//                                    }
//                                }
                                .textInputAutocapitalization(.words)
                                .disableAutocorrection(true)
                                .focused($isTextFieldCloudFocused)
                                TextField(
                                    "Temp",
                                    text: $temp
                                )
                                .onChange(of: temp) { newValue in
                                    if newValue.count > 1 {
                                        temp = String(newValue.prefix(2))
                                        isTextFieldTempFocused = false
                                        isTextFieldDPFocused = true
                                    }
                                }
                                .textInputAutocapitalization(.words)
                                .disableAutocorrection(true)
                                .focused($isTextFieldTempFocused)
                                TextField(
                                    "DP",
                                    text: $dp
                                )
                                .onChange(of: dp) { newValue in
                                    if newValue.count > 1 {
                                        dp = String(newValue.prefix(2))
                                        isTextFieldDPFocused = false
                                        isTextFieldQNHFocused = true
                                    }
                                }
                                .textInputAutocapitalization(.words)
                                .disableAutocorrection(true)
                                .focused($isTextFieldDPFocused)
                            }
                            TextField(
                                "QNH",
                                text: $qnh
                            )
                            .onChange(of: qnh) { newValue in
                                if newValue.count > 3 {
                                    qnh = String(newValue.prefix(4))
                                    isTextFieldQNHFocused = false
                                    isTextFieldRemarksFocused = true
                                }
                            }
                            .textInputAutocapitalization(.words)
                            .disableAutocorrection(true)
                            .focused($isTextFieldQNHFocused)
                            TextField(
                                "Remarks",
                                text: $remarks
                            )
//                            .onChange(of: remarks) { newValue in
//                                if newValue.count > 1 {
//                                    remarks = String(newValue.prefix(2))
//                                    isTextFieldRemarksFocused = false
//                                }
//                            }
                            .textInputAutocapitalization(.words)
                            .disableAutocorrection(true)
                            .focused($isTextFieldRemarksFocused)
                        }
                        .padding(.top, 5)
                        .padding(.bottom, 5)
                        .padding(.leading, 25)
                    }
                }
                
                // ATC section
                
                // Entries section
            }
        }
        .navigationTitle("Departure")
        .background(Color(.systemGroupedBackground))
    }
}
