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
        //todo remove and replace with coredata
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
            // todo implement coredata into code
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
                        HStack(alignment: .center) {
                            Group {
                                Text("Dest")
                                .foregroundStyle(Color.blue)
                                .frame(maxWidth: .infinity, alignment: .leading)
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
                            }
                            Text("DP")
                            .foregroundStyle(Color.blue)
                            .frame(maxWidth: .infinity, alignment: .leading)
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
                            TextField("Dest", text: $dest)
                            .focused($isTextFieldDestFocused)
                            .onReceive(Just(isTextFieldDestFocused)) { focused in
                                if focused {
                                    isTextFieldDestFocused = false
                                    setFocusToFalse()
                                    isEditingDest = true
                                }
                            }
                            .overlay(isEditingDest ? Rectangle().stroke(Color.red, lineWidth:1) : nil)
                            .onChange(of: dest) { newValue in
                                // Limit the text to a maximum of 1 characters
                                if newValue.count > 2 {
                                    code = String(newValue.prefix(3))
                                    cursorPositionDest = 3
                                    
                                    isEditingDest = false
                                    isTextFieldCodeFocused = true
                                }
                            }
                            Group {
                                TextField("Code", text: $code)
                                .focused($isTextFieldCodeFocused)
                                .onReceive(Just(isTextFieldCodeFocused)) { focused in
                                    if focused {
                                        isTextFieldCodeFocused = false
                                        setFocusToFalse()
                                        isEditingCode = true
                                    }
                                }
                                .overlay(isEditingCode ? Rectangle().stroke(Color.red, lineWidth:1) : nil)
                                .onChange(of: code) { newValue in
                                    // Limit the text to a maximum of 1 characters
                                    if newValue.count > 0 {
                                        code = String(newValue.prefix(1))
                                        cursorPositionCode = 1
                                        
                                        isEditingCode = false
                                        isTextFieldTimeFocused = true
                                    }
                                }

                                TextField("Time", text: $time)
                                .focused($isTextFieldTimeFocused)
                                .onReceive(Just(isTextFieldTimeFocused)) { focused in
                                    if focused {
                                        isTextFieldTimeFocused = false
                                        setFocusToFalse()
                                        isEditingTime = true
                                    }
                                }
                                .overlay(isEditingTime ? Rectangle().stroke(Color.red, lineWidth:1) : nil)
                                .onChange(of: time) { newValue in
                                    if newValue.count > 3 {
                                        time = String(newValue.prefix(4))
                                        cursorPositionTime = 4
                                        
                                        isEditingTime = false
                                        isTextFieldRwyFocused = true
                                    }
                                }
                            }
                            Group {
                                TextField("Rwy", text: $rwy)
                                .focused($isTextFieldRwyFocused)
                                .onReceive(Just(isTextFieldRwyFocused)) { focused in
                                    if focused {
                                        isTextFieldRwyFocused = false
                                        setFocusToFalse()
                                        isEditingRwy = true
                                    }
                                }
                                .overlay(isEditingRwy ? Rectangle().stroke(Color.red, lineWidth:1) : nil)
                                .onChange(of: rwy) { newValue in
                                    if newValue.count > 10 {
                                        rwy = String(newValue.prefix(11))
                                        cursorPositionRwy = 11
                                        
                                        isEditingRwy = false
                                        isTextFieldTransLvlFocused = true
                                    }
                                }

                                TextField( "Trans Lvl", text: $transLvl)
                                .focused($isTextFieldTransLvlFocused)
                                .onReceive(Just(isTextFieldTransLvlFocused)) { focused in
                                    if focused {
                                        isTextFieldTransLvlFocused = false
                                        setFocusToFalse()
                                        isEditingTransLvl = true
                                    }
                                }
                                .overlay(isEditingTransLvl ? Rectangle().stroke(Color.red, lineWidth:1) : nil)
                                .onChange(of: transLvl) { newValue in
                                    if newValue.count > 3 {
                                        transLvl = String(newValue.prefix(4))
                                        cursorPositionTransLvl = 4
                                        
                                        isEditingTransLvl = false
                                        isTextFieldWindFocused = true
                                    }
                                }
                            }
                            Group {
                                TextField( "Wind", text: $wind)
                                .focused($isTextFieldWindFocused)
                                .onReceive(Just(isTextFieldWindFocused)) { focused in
                                    if focused {
                                        isTextFieldWindFocused = false
                                        setFocusToFalse()
                                        isEditingWind = true
                                    }
                                }
                                .overlay(isEditingWind ? Rectangle().stroke(Color.red, lineWidth:1) : nil)
                                .onChange(of: wind) { newValue in
                                    if newValue.count > 5 {
                                        wind = String(newValue.prefix(6))
                                        cursorPositionWind = 6
                                        
                                        isEditingWind = false
                                        isTextFieldVisFocused = true
                                    }
                                }

                                TextField("Vis", text: $vis)
                                .focused($isTextFieldVisFocused)
                                .onReceive(Just(isTextFieldVisFocused)) { focused in
                                    if focused {
                                        isTextFieldVisFocused = false
                                        setFocusToFalse()
                                        isEditingVis = true
                                    }
                                }
                                .overlay(isEditingVis ? Rectangle().stroke(Color.red, lineWidth:1) : nil)
                                .onChange(of: vis) { newValue in
                                    if newValue.count > 3 {
                                        vis = String(newValue.prefix(4))
                                        cursorPositionVis = 4
                                        
                                        isEditingVis = false
                                        isTextFieldWxFocused = true
                                    }
                                }
                            }
                            Group {
                                TextField("Wx", text: $wx)
                                .focused($isTextFieldWxFocused)
                                .onReceive(Just(isTextFieldWxFocused)) { focused in
                                    if focused {
                                        isTextFieldWxFocused = false
                                        setFocusToFalse()
                                        isEditingWx = true
                                    }
                                }
                                .overlay(isEditingWx ? Rectangle().stroke(Color.red, lineWidth:1) : nil)
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
                                .onReceive(Just(isEditingWx)) { focused in
                                    if !focused {
                                        isShowingAutofillOptionsWx = false
                                    }
                                }
                                
                                TextField("Cloud", text: $cloud)
                                .focused($isTextFieldCloudFocused)
                                .onReceive(Just(isTextFieldCloudFocused)) { focused in
                                    if focused {
                                        isTextFieldCloudFocused = false
                                        setFocusToFalse()
                                        isEditingCloud = true
                                    }
                                }
                                .overlay(isEditingCloud ? Rectangle().stroke(Color.red, lineWidth:1) : nil)
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
                                .onReceive(Just(isEditingCloud)) { focused in
                                    if !focused {
                                        isShowingAutofillOptionsCloud = false
                                    }
                                }
                            }
                            Group {
                                TextField("Temp", text: $temp)
                                .focused($isTextFieldTempFocused)
                                .onReceive(Just(isTextFieldTempFocused)) { focused in
                                    if focused {
                                        isTextFieldTempFocused = false
                                        setFocusToFalse()
                                        isEditingTemp = true
                                    }
                                }
                                .overlay(isEditingTemp ? Rectangle().stroke(Color.red, lineWidth:1) : nil)
                                .onChange(of: temp) { newValue in
                                    if newValue.count > 1 {
                                        temp = String(newValue.prefix(2))
                                        cursorPositionTemp = 2
                                        
                                        isEditingTemp = false
                                        isTextFieldDPFocused = true
                                    }
                                }

                                TextField("DP", text: $dp)
                                .focused($isTextFieldDPFocused)
                                .onReceive(Just(isTextFieldDPFocused)) { focused in
                                    if focused {
                                        isTextFieldDPFocused = false
                                        setFocusToFalse()
                                        isEditingDP = true
                                    }
                                }
                                .overlay(isEditingDP ? Rectangle().stroke(Color.red, lineWidth:1) : nil)
                                .onChange(of: dp) { newValue in
                                    if newValue.count > 1 {
                                        dp = String(newValue.prefix(2))
                                        cursorPositionDP = 2
                                        
                                        isEditingDP = false
                                        isTextFieldQNHFocused = true
                                    }
                                }
                            }
                            Group {
                                TextField("QNH", text: $qnh)
                                .focused($isTextFieldQNHFocused)
                                .onReceive(Just(isTextFieldQNHFocused)) { focused in
                                    if focused {
                                        isTextFieldQNHFocused = false
                                        setFocusToFalse()
                                        isEditingQNH = true
                                    }
                                }
                                .overlay(isEditingQNH ? Rectangle().stroke(Color.red, lineWidth:1) : nil)
                                .onChange(of: qnh) { newValue in
                                    if newValue.count > 3 {
                                        qnh = String(newValue.prefix(4))
                                        cursorPositionQNH = 4
                                        
                                        isEditingQNH = false
                                        isTextFieldRemarksFocused = true
                                    }
                                }

                                TextField("Remarks", text: $remarks)
                                .focused($isTextFieldRemarksFocused)
                                .onReceive(Just(isTextFieldRemarksFocused)) { focused in
                                    if focused {
                                        isTextFieldRemarksFocused = false
                                        setFocusToFalse()
                                        isEditingRemarks = true
                                    }
                                }
                                .overlay(isEditingRemarks ? Rectangle().stroke(Color.red, lineWidth:1) : nil)
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
                                .onReceive(Just(isEditingRemarks)) { focused in
                                    if !focused {
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
                                TextField(" \(flightInfoData.dest)", text: $atcDest)
                                .focused($isTextFieldAtcDestFocused)
                                .onReceive(Just(isTextFieldAtcDestFocused)) { focused in
                                    if focused {
                                        isTextFieldAtcDestFocused = false
                                        setFocusToFalse()
                                        isEditingAtcDest = true
                                    }
                                }
                                .overlay(isEditingAtcDest ? Rectangle().stroke(Color.red, lineWidth:1) : nil)
                                .onChange(of: atcDest) { newValue in
                                    if newValue.count > 2 {
                                        atcDest = String(newValue.prefix(3))
                                        cursorPositionAtcDest = 3
                                        
                                        isEditingAtcDest = false
                                        isTextFieldAtcRwyFocused = true
                                    }
                                }
                                .focused($isTextFieldAtcDestFocused)
                                TextField("Rwy", text: $atcRwy)
                                .focused($isTextFieldAtcRwyFocused)
                                .onReceive(Just(isTextFieldAtcRwyFocused)) { focused in
                                    if focused {
                                        isTextFieldAtcRwyFocused = false
                                        setFocusToFalse()
                                        isEditingAtcRwy = true
                                    }
                                }
                                .overlay(isEditingAtcRwy ? Rectangle().stroke(Color.red, lineWidth:1) : nil)
                                .onChange(of: atcRwy) { newValue in
                                    if newValue.count > 2 {
                                        atcRwy = String(newValue.prefix(3))
                                        cursorPositionAtcRwy = 3
                                        
                                        isEditingAtcRwy = false
                                        isTextFieldAtcArrFocused = true
                                    }
                                }
                            }
                            Group {
                                TextField("Arr", text: $atcArr)
                                .focused($isTextFieldAtcArrFocused)
                                .onReceive(Just(isTextFieldAtcArrFocused)) { focused in
                                    if focused {
                                        isTextFieldAtcArrFocused = false
                                        setFocusToFalse()
                                        isEditingAtcArr = true
                                    }
                                }
                                .overlay(isEditingAtcArr ? Rectangle().stroke(Color.red, lineWidth:1) : nil)
                                
                                TextField("Trans Lvl", text: $atcTransLvl)
                                .focused($isTextFieldAtcTransLvlFocused)
                                .onReceive(Just(isTextFieldAtcTransLvlFocused)) { focused in
                                    if focused {
                                        isTextFieldAtcTransLvlFocused = false
                                        setFocusToFalse()
                                        isEditingAtcTransLvl = true
                                    }
                                }
                                .overlay(isEditingAtcTransLvl ? Rectangle().stroke(Color.red, lineWidth:1) : nil)
                                .onChange(of: atcTransLvl) { newValue in
                                    if newValue.count > 2 {
                                        atcTransLvl = String(newValue.prefix(3))
                                        cursorPositionAtcTransLvl = 3
                                        
                                        isEditingAtcTransLvl = false
                                        isTextFieldAtcDestFocused = true
                                    }
                                }
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
                                TextField("Landing", text: $entLdg)
                                .focused($isTextFieldEntLdgFocused)
                                .onReceive(Just(isTextFieldEntLdgFocused)) { focused in
                                    if focused {
                                        isTextFieldEntLdgFocused = false
                                        setFocusToFalse()
                                        isEditingEntLdg = true
                                    }
                                }
                                .overlay(isEditingEntLdg ? Rectangle().stroke(Color.red, lineWidth:1) : nil)
                                .onChange(of: entLdg) { newValue in
                                    if newValue.count > 3 {
                                        entLdg = String(newValue.prefix(4))
                                        cursorPositionEntLdg = 4
                                        
                                        isEditingEntLdg = false
                                        isTextFieldEntOnFocused = true
                                    }
                                }
                            }
                            Group {
                                TextField("Chocks On", text: $entOn)
                                .focused($isTextFieldEntOnFocused)
                                .onReceive(Just(isTextFieldEntOnFocused)) { focused in
                                    if focused {
                                        isTextFieldEntOnFocused = false
                                        setFocusToFalse()
                                        isEditingEntOn = true
                                    }
                                }
                                .overlay(isEditingEntOn ? Rectangle().stroke(Color.red, lineWidth:1) : nil)
                                .onChange(of: entOn) { newValue in
                                    if newValue.count > 3 {
                                        entOn = String(newValue.prefix(4))
                                        cursorPositionEntOn = 4
                                        
                                        isEditingEntOn = false
                                        isTextFieldEntFuelOnChocksFocused = true
                                    }
                                }
                            }
                            Group {
                                TextField("Fuel on Chocks", text: $entFuelOnChocks)
                                .focused($isTextFieldEntFuelOnChocksFocused)
                                .onReceive(Just(isTextFieldEntFuelOnChocksFocused)) { focused in
                                    if focused {
                                        isTextFieldEntFuelOnChocksFocused = false
                                        setFocusToFalse()
                                        isEditingEntFuelOnChocks = true
                                    }
                                }
                                .overlay(isEditingEntFuelOnChocks ? Rectangle().stroke(Color.red, lineWidth:1) : nil)
                                .onChange(of: entFuelOnChocks) { newValue in
                                    if newValue.count > 4 {
                                        entFuelOnChocks = String(newValue.prefix(5))
                                        cursorPositionEntFuelOnChocks = 5
                                        
                                        isEditingEntFuelOnChocks = false
                                        isTextFieldEntLdgFocused = true
                                    }
                                }
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
                    CustomKeyboardView1(text: $code, cursorPosition: $cursorPositionCode, currentFocus: $isEditingCode, nextFocus: $isEditingTime, prevFocus: $isEditingDest)
                }
                if isEditingTime {
                    CustomKeyboardView1(text: $time, cursorPosition: $cursorPositionTime, currentFocus: $isEditingTime, nextFocus: $isEditingRwy, prevFocus: $isEditingCode)
                }
                if isEditingRwy {
                    CustomKeyboardView1(text: $rwy, cursorPosition: $cursorPositionRwy, currentFocus: $isEditingRwy, nextFocus: $isEditingTransLvl, prevFocus: $isEditingTime)
                }
                if isEditingTransLvl {
                    CustomKeyboardView1(text: $transLvl, cursorPosition: $cursorPositionTransLvl, currentFocus: $isEditingTransLvl, nextFocus: $isEditingWind, prevFocus: $isEditingRwy)
                }
                if isEditingWind {
                    CustomKeyboardView1(text: $wind, cursorPosition: $cursorPositionWind, currentFocus: $isEditingWind, nextFocus: $isEditingVis, prevFocus: $isEditingTransLvl)
                }
                if isEditingVis {
                    CustomKeyboardView1(text: $vis, cursorPosition: $cursorPositionVis, currentFocus: $isEditingVis, nextFocus: $isEditingWx, prevFocus: $isEditingWind)
                }
                if isEditingWx {
                    CustomKeyboardView1(text: $wx, cursorPosition: $cursorPositionWx, currentFocus: $isEditingWx, nextFocus: $isEditingCloud, prevFocus: $isEditingVis)
                }
                if isEditingCloud {
                    CustomKeyboardView1(text: $cloud, cursorPosition: $cursorPositionCloud, currentFocus: $isEditingCloud, nextFocus: $isEditingTemp, prevFocus: $isEditingWx)
                }
                if isEditingTemp {
                    CustomKeyboardView1(text: $temp, cursorPosition: $cursorPositionTemp, currentFocus: $isEditingTemp, nextFocus: $isEditingDP, prevFocus: $isEditingCloud)
                }
                if isEditingDP {
                    CustomKeyboardView1(text: $dp, cursorPosition: $cursorPositionDP, currentFocus: $isEditingDP, nextFocus: $isEditingQNH, prevFocus: $isEditingTemp)
                }
            }
            Group {
                if isEditingQNH {
                    CustomKeyboardView1(text: $qnh, cursorPosition: $cursorPositionQNH, currentFocus: $isEditingQNH, nextFocus: $isEditingRemarks, prevFocus: $isEditingDP)
                }
                if isEditingRemarks {
                    CustomKeyboardView1(text: $remarks, cursorPosition: $cursorPositionRemarks, currentFocus: $isEditingRemarks, nextFocus: $isEditingDest, prevFocus: $isEditingQNH)
                }
                if isEditingDest {
                    CustomKeyboardView1(text: $dest, cursorPosition: $cursorPositionDest, currentFocus: $isEditingDest, nextFocus: $isEditingCode, prevFocus: $isEditingRemarks)
                }
            }
            Group {
                if isEditingAtcDest {
                    CustomKeyboardView1(text: $atcDest, cursorPosition: $cursorPositionAtcDest, currentFocus: $isEditingAtcDest, nextFocus: $isEditingAtcRwy, prevFocus: $isEditingAtcTransLvl)
                }
                if isEditingAtcRwy {
                    CustomKeyboardView1(text: $atcRwy, cursorPosition: $cursorPositionAtcRwy, currentFocus: $isEditingAtcRwy, nextFocus: $isEditingAtcArr, prevFocus: $isEditingAtcDest)
                }
                if isEditingAtcArr {
                    CustomKeyboardView1(text: $atcArr, cursorPosition: $cursorPositionAtcArr, currentFocus: $isEditingAtcArr, nextFocus: $isEditingAtcTransLvl, prevFocus: $isEditingAtcRwy)
                }
                if isEditingAtcTransLvl {
                    CustomKeyboardView1(text: $atcTransLvl, cursorPosition: $cursorPositionAtcTransLvl, currentFocus: $isEditingAtcTransLvl, nextFocus: $isEditingAtcRwy, prevFocus: $isEditingAtcArr)
                }
            }
            Group {
                if isEditingEntLdg {
                    CustomKeyboardView1(text: $entLdg, cursorPosition: $cursorPositionEntLdg, currentFocus: $isEditingEntLdg, nextFocus: $isEditingEntOn, prevFocus: $isEditingEntFuelOnChocks)
                }
                if isEditingEntOn {
                    CustomKeyboardView1(text: $entOn, cursorPosition: $cursorPositionEntOn, currentFocus: $isEditingEntOn, nextFocus: $isEditingEntFuelOnChocks, prevFocus: $isEditingEntLdg)
                }
                if isEditingEntFuelOnChocks {
                    CustomKeyboardView1(text: $entFuelOnChocks, cursorPosition: $cursorPositionEntFuelOnChocks, currentFocus: $isEditingEntFuelOnChocks, nextFocus: $isEditingEntLdg, prevFocus: $isEditingEntOn)
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
        // todo add onAppear CoreData init
    }
    func setFocusToFalse() {
        isEditingDest = false
        isEditingCode = false
        isEditingTime = false
        isEditingRwy = false
        isEditingTransLvl = false
        isEditingWind = false
        isEditingVis = false
        isEditingWx = false
        isEditingCloud = false
        isEditingTemp = false
        isEditingDP = false
        isEditingQNH = false
        isEditingRemarks = false
                
        isEditingAtcRwy = false
        isEditingAtcArr = false
        isEditingAtcDest = false
        isEditingAtcTransLvl = false

        isEditingEntLdg = false
        isEditingEntFuelOnChocks = false
        isEditingEntOn = false
    }
}

