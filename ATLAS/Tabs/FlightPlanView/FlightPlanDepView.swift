//
//  FlightPlanDepView.swift
//  ATLAS
//
//  Created by Muhammad Adil on 22/6/23.
//

import Foundation
import SwiftUI
import Combine

struct FlightPlanDepView: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController
    
    // initialise state variables
    // ATIS variables
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
    @State var atcRwy: String = ""
    @State var atcDep: String = ""
    @State var atcRte: String = ""
    @State var atcFL: String = ""
    @State var atcSQ: String = ""
    
    @State private var isEditingAtcRwy = false
    @State private var isEditingAtcDep = false
    @State private var isEditingAtcRte = false
    @State private var isEditingAtcFL = false
    @State private var isEditingAtcSQ = false
    
    @State private var cursorPositionAtcRwy = 0
    @State private var cursorPositionAtcDep = 0
    @State private var cursorPositionAtcRte = 0
    @State private var cursorPositionAtcFL = 0
    @State private var cursorPositionAtcSQ = 0
    
    @FocusState private var isTextFieldAtcRwyFocused: Bool
    @FocusState private var isTextFieldAtcDepFocused: Bool
    @FocusState private var isTextFieldAtcRteFocused: Bool
    @FocusState private var isTextFieldAtcFLFocused: Bool
    @FocusState private var isTextFieldAtcSQFocused: Bool
    
    // Entries variables
    @State var entOff: String = ""
    @State var entFuelInTanks: String = ""
    @State var entTaxi: String = ""
    @State var entTakeoff: String = ""
    
    @State private var isEditingEntOff = false
    @State private var isEditingEntFuelInTanks = false
    @State private var isEditingEntTaxi = false
    @State private var isEditingEntTakeoff = false
    
    @State private var cursorPositionEntOff = 0
    @State private var cursorPositionEntFuelInTanks = 0
    @State private var cursorPositionEntTaxi = 0
    @State private var cursorPositionEntTakeoff = 0
    
    @FocusState private var isTextFieldEntOffFocused: Bool
    @FocusState private var isTextFieldEntFuelInTanksFocused: Bool
    @FocusState private var isTextFieldEntTaxiFocused: Bool
    @FocusState private var isTextFieldEntTakeoffFocused: Bool
    
    // autofill variables
    @State private var isShowingAutofillOptionsWx = false
    @State private var isShowingAutofillOptionsCloud = false
    @State private var isShowingAutofillOptionsRemarks = false
    @State private var isShowingAutofillOptionsAtcRte = false

    @State private var autofillOptionsATIS: [String] = ["APPLE", "BANANA", "CHERRY", "BLUEBERRY"] // Replace with your own autofill options
    @State private var autofillText = ""
    @State private var isShowingCustomKeyboard = false
    
    var body: some View {
        let flightPlanData: [String : Any] = fetchFlightPlanData()
        let flightInfoData: InfoData = flightPlanData["infoData"] as! InfoData
        let routeData: RouteData = flightPlanData["routeData"] as! RouteData
        let route = routeData.route
        let routeList: [String] = route.components(separatedBy: " ")
        
        GeometryReader { proxy in
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    Text("Departure")
                        .font(.system(size: 20, weight: .semibold))
                        .padding(.leading, 30)
                }
                .padding(.bottom, 10)
                
                Text("Plan \(coreDataModel.dataSummaryInfo.unwrappedPlanNo) | Last updated 0820LT").padding(.leading, 30).padding(.bottom, 10)
                    .font(.system(size: 15, weight: .semibold))
                //scrollable outer list section
                List {
                    // ATIS section
                    Section(header:
                        HStack {
                            Text("ATIS \(coreDataModel.dataSummaryInfo.unwrappedDep)").font(.system(size: 15, weight: .semibold)).foregroundStyle(Color.black)
                            
//                            Spacer()
//
//                            Button(action: {
//                                print("Edit")
//                            }) {
//                                Text("Edit").font(.system(size: 15, weight: .semibold)).foregroundColor(Color.theme.azure)
//                            }
                        }
                    ) {
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
                                            
                                            if coreDataModel.existDataDepartureAts {
                                                coreDataModel.dataDepartureAts.code = code
                                            } else {
                                                let item = DepartureATISList(context: persistenceController.container.viewContext)
                                                item.code = code
                                            }

                                            coreDataModel.save()
                                            
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
                                            if coreDataModel.existDataDepartureAts {
                                                coreDataModel.dataDepartureAts.time = time
                                            } else {
                                                let item = DepartureATISList(context: persistenceController.container.viewContext)
                                                item.time = time
                                            }

                                            coreDataModel.save()
                                            
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
                                            
                                            if coreDataModel.existDataDepartureAts {
                                                coreDataModel.dataDepartureAts.rwy = rwy
                                            } else {
                                                let item = DepartureATISList(context: persistenceController.container.viewContext)
                                                item.rwy = rwy
                                            }

                                            coreDataModel.save()
                                            
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
                                            
                                            if coreDataModel.existDataDepartureAts {
                                                coreDataModel.dataDepartureAts.translvl = transLvl
                                            } else {
                                                let item = DepartureATISList(context: persistenceController.container.viewContext)
                                                item.translvl = transLvl
                                            }

                                            coreDataModel.save()
                                            
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
                                            
                                            if coreDataModel.existDataDepartureAts {
                                                coreDataModel.dataDepartureAts.wind = wind
                                            } else {
                                                let item = DepartureATISList(context: persistenceController.container.viewContext)
                                                item.wind = wind
                                            }

                                            coreDataModel.save()
                                            
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
                                            
                                            if coreDataModel.existDataDepartureAts {
                                                coreDataModel.dataDepartureAts.vis = vis
                                            } else {
                                                let item = DepartureATISList(context: persistenceController.container.viewContext)
                                                item.vis = vis
                                            }

                                            coreDataModel.save()
                                            
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
                                            if coreDataModel.existDataDepartureAts {
                                                coreDataModel.dataDepartureAts.wx = text
                                            } else {
                                                let item = DepartureATISList(context: persistenceController.container.viewContext)
                                                item.wx = text
                                            }

                                            coreDataModel.save()
                                            
                                            isShowingAutofillOptionsWx = false
                                        }
                                    } // todo hide autofilloptions when submit or when focus on another textfield
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
                                            if coreDataModel.existDataDepartureAts {
                                                coreDataModel.dataDepartureAts.cloud = text
                                            } else {
                                                let item = DepartureATISList(context: persistenceController.container.viewContext)
                                                item.cloud = text
                                            }

                                            coreDataModel.save()
                                            
                                            isShowingAutofillOptionsCloud = false
                                        }
                                    }// todo hide autofilloptions when submit or when focus on another textfield
                                }
                                Group {
                                    TextField("Temp", text: $temp, onEditingChanged: { editing in
                                        isEditingTemp = editing
                                    })
                                    .onChange(of: temp) { newValue in
                                        if newValue.count > 1 {
                                            temp = String(newValue.prefix(2))
                                            
                                            if coreDataModel.existDataDepartureAts {
                                                coreDataModel.dataDepartureAts.temp = temp
                                            } else {
                                                let item = DepartureATISList(context: persistenceController.container.viewContext)
                                                item.temp = temp
                                            }

                                            coreDataModel.save()
                                            
                                            isTextFieldTempFocused = false
                                            isTextFieldDPFocused = true
                                        }
                                    }.focused($isTextFieldTempFocused)
                                    .autocorrectionDisabled(true)
                                    
                                    TextField(
                                        "DP",
                                        text: $dp, onEditingChanged: { editing in
                                            isEditingDP = editing
                                        })
                                    .onChange(of: dp) { newValue in
                                        if newValue.count > 1 {
                                            dp = String(newValue.prefix(2))
                                            
                                            if coreDataModel.existDataDepartureAts {
                                                coreDataModel.dataDepartureAts.dp = dp
                                            } else {
                                                let item = DepartureATISList(context: persistenceController.container.viewContext)
                                                item.dp = dp
                                            }

                                            coreDataModel.save()
                                            
                                            isTextFieldDPFocused = false
                                            isTextFieldQNHFocused = true
                                        }
                                    }.focused($isTextFieldDPFocused)
                                        .autocorrectionDisabled(true)
                                }
                                
                                Group {
                                    TextField("QNH", text: $qnh, onEditingChanged: { editing in
                                        isEditingQNH = editing
                                    }).onChange(of: qnh) { newValue in
                                        if newValue.count > 3 {
                                            qnh = String(newValue.prefix(4))
                                            
                                            if coreDataModel.existDataDepartureAts {
                                                coreDataModel.dataDepartureAts.qnh = qnh
                                            } else {
                                                let item = DepartureATISList(context: persistenceController.container.viewContext)
                                                item.qnh = qnh
                                            }

                                            coreDataModel.save()
                                            
                                            isTextFieldQNHFocused = false
                                            isTextFieldRemarksFocused = true
                                        }
                                    }.focused($isTextFieldQNHFocused)
                                        .autocorrectionDisabled(true)
                                    
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
                                            if coreDataModel.existDataDepartureAts {
                                                coreDataModel.dataDepartureAts.remarks = text
                                            } else {
                                                let item = DepartureATISList(context: persistenceController.container.viewContext)
                                                item.remarks = text
                                            }

                                            coreDataModel.save()
                                            
                                            isShowingAutofillOptionsRemarks = false
                                        }
                                    }.autocorrectionDisabled(true)
                                }
                            }
                            .padding(.top, 5)
                            .padding(.bottom, 5)
                            .padding(.leading, 25)
                        }
                    }.onChange(of: coreDataModel.dataDepartureAts) { _ in
                        coreDataModel.readDepartureAtis()
                    }
                    
                    // ATC section
                    Section(header:
                                HStack {
                        Text("ATC").font(.system(size: 15, weight: .semibold)).foregroundStyle(Color.black)
//
//                        Spacer()
//
//                        Button(action: {
//                            print("Edit")
//                        }) {
//                            Text("Edit").font(.system(size: 15, weight: .semibold)).foregroundColor(Color.theme.azure)
//                        }
                    }
                    ) {
                        // grouped row using hstack
                        VStack(alignment: .center) {
                            HStack(alignment: .center) {
                                Group {
                                    Text("Dest")
                                        .foregroundStyle(Color.blue)
                                        .frame(width: calculateWidth(proxy.size.width, 6), alignment: .leading)
                                    Text("Rwy")
                                        .foregroundStyle(Color.blue)
                                        .frame(width: calculateWidth(proxy.size.width, 6), alignment: .leading)
                                    Text("Dep")
                                        .foregroundStyle(Color.blue)
                                        .frame(width: calculateWidth(proxy.size.width, 6), alignment: .leading)
                                    Text("Rte")
                                        .foregroundStyle(Color.blue)
                                        .frame(width: calculateWidth(proxy.size.width, 6), alignment: .leading)
                                    Text("FL")
                                        .foregroundStyle(Color.blue)
                                        .frame(width: calculateWidth(proxy.size.width, 6), alignment: .leading)
                                    Text("SQ")
                                        .foregroundStyle(Color.blue)
                                        .frame(width: calculateWidth(proxy.size.width, 6), alignment: .leading)
                                }
                            }.padding(.top, 5)
                                .padding(.bottom, 5)
                            
                            Divider()
                            
                            HStack(alignment: .center) {
                                Group {
                                    Text("\(flightInfoData.dest)").frame(width: calculateWidth(proxy.size.width, 6), alignment: .leading)
                                    
                                    TextField("Rwy", text: $atcRwy, onEditingChanged: { editing in
                                        isEditingAtcRwy = editing
                                    })
                                    .onChange(of: atcRwy) { newValue in
                                        if newValue.count > 2 {
                                            atcRwy = String(newValue.prefix(3))
                                            
                                            if coreDataModel.existDataDepartureAtc {
                                                coreDataModel.dataDepartureAtc.atcRwy = atcRwy
                                            } else {
                                                let item = DepartureATCList(context: persistenceController.container.viewContext)
                                                item.atcRwy = atcRwy
                                            }

                                            coreDataModel.save()
                                            
                                            isTextFieldAtcRwyFocused = false
                                            isTextFieldAtcDepFocused = true
                                        }
                                    }
                                    .focused($isTextFieldAtcRwyFocused)
                                    .frame(width: calculateWidth(proxy.size.width, 6), alignment: .leading)
                                
                                    TextField("Dep", text: $atcDep, onEditingChanged: { editing in
                                        isEditingAtcDep = editing
                                    })
                                    .focused($isTextFieldAtcDepFocused)
                                    .frame(width: calculateWidth(proxy.size.width, 6))
                                    .onReceive(Just(atcDep)) { text in
                                        if coreDataModel.existDataDepartureAtc {
                                            coreDataModel.dataDepartureAtc.atcDep = atcDep
                                        } else {
                                            let item = DepartureATCList(context: persistenceController.container.viewContext)
                                            item.atcDep = atcDep
                                        }

                                        coreDataModel.save()
                                    }
                                    
                                    TextField("Rte", text: $atcRte, onEditingChanged: { editing in
                                        isEditingAtcRte = editing
                                    })
                                    .focused($isTextFieldAtcRteFocused)
                                    .onReceive(Just(atcRte)) { text in
                                        let components = text.components(separatedBy: " ")
                                        if let lastComponent = components.last, lastComponent.hasPrefix(".") && lastComponent.count > 1 {
                                            let searchTerm = String(lastComponent.dropFirst())
                                            autofillText = searchTerm
                                            isShowingAutofillOptionsAtcRte = true
                                        } else {
                                            if coreDataModel.existDataDepartureAtc {
                                                coreDataModel.dataDepartureAtc.atcRte = text
                                            } else {
                                                let item = DepartureATCList(context: persistenceController.container.viewContext)
                                                item.atcRte = text
                                            }

                                            coreDataModel.save()
                                            
                                            isShowingAutofillOptionsAtcRte = false
                                        }
                                    }
                                    .frame(width: calculateWidth(proxy.size.width, 6))
                                
                                    TextField( "FL", text: $atcFL, onEditingChanged: { editing in
                                        isEditingAtcFL = editing
                                    }).onChange(of: atcFL) { newValue in
                                        if newValue.count > 2 {
                                            atcFL = String(newValue.prefix(3))
                                            
                                            if coreDataModel.existDataDepartureAtc {
                                                coreDataModel.dataDepartureAtc.atcFL = atcFL
                                            } else {
                                                let item = DepartureATCList(context: persistenceController.container.viewContext)
                                                item.atcFL = atcFL
                                            }

                                            coreDataModel.save()
                                            
                                            isTextFieldAtcFLFocused = false
                                            isTextFieldAtcSQFocused = true
                                        }
                                    }.focused($isTextFieldAtcFLFocused)
                                        .frame(width: calculateWidth(proxy.size.width, 6))
                                    
                                    TextField("SQ", text: $atcSQ, onEditingChanged: { editing in
                                        isEditingAtcSQ = editing
                                    }).onChange(of: atcSQ) { newValue in
                                        if newValue.count > 3 {
                                            atcSQ = String(newValue.prefix(4))
                                            
                                            if coreDataModel.existDataDepartureAtc {
                                                coreDataModel.dataDepartureAtc.atcSQ = atcSQ
                                            } else {
                                                let item = DepartureATCList(context: persistenceController.container.viewContext)
                                                item.atcSQ = atcSQ
                                            }

                                            coreDataModel.save()
                                            
                                            isTextFieldAtcSQFocused = false
                                            isTextFieldAtcRwyFocused = true
                                        }
                                    }.focused($isTextFieldAtcSQFocused)
                                        .frame(width: calculateWidth(proxy.size.width, 6))
                                }
                            }
                            .padding(.top, 5)
                            .padding(.bottom, 5)
                            
                        }.padding(.horizontal, 25)
                        .frame(maxWidth: proxy.size.width - 50)
                        
                    }.onChange(of: coreDataModel.dataDepartureAtc) { _ in
                        coreDataModel.readDepartureAtc()
                    }
                    // Entries section
                    Section(header:
                                HStack {
                        Text("Entries").font(.system(size: 15, weight: .semibold)).foregroundStyle(Color.black)
                        
//                        Spacer()
//                        
//                        Button(action: {
//                            print("Edit")
//                        }) {
//                            Text("Edit").font(.system(size: 15, weight: .semibold)).foregroundColor(Color.theme.azure)
//                        }
                    }
                    ) {
                        // grouped row using hstack
                        VStack(alignment: .center) {
                            HStack(alignment: .center) {
                                Group {
                                    Text("Chocks Off")
                                        .foregroundStyle(Color.blue)
                                        .frame(width: calculateWidth(proxy.size.width, 4), alignment: .leading)
                                    Text("Fuel in Tanks")
                                        .foregroundStyle(Color.blue)
                                        .frame(width: calculateWidth(proxy.size.width, 4), alignment: .leading)
                                    Text("Taxi")
                                        .foregroundStyle(Color.blue)
                                        .frame(width: calculateWidth(proxy.size.width, 4), alignment: .leading)
                                    Text("Takeoff")
                                        .foregroundStyle(Color.blue)
                                        .frame(width: calculateWidth(proxy.size.width, 4), alignment: .leading)
                                }
                            }
                            .padding(.top, 5)
                            .padding(.bottom, 5)
                            
                            Divider()
                            
                            HStack(alignment: .center) {
                                Group {
                                    TextField("Chocks Off", text: $entOff, onEditingChanged: { editing in
                                        isEditingEntOff = editing
                                    })
                                    .onChange(of: entOff) { newValue in
                                        if newValue.count > 3 {
                                            entOff = String(newValue.prefix(4))
                                            
                                            if coreDataModel.existDataDepartureEntries {
                                                coreDataModel.dataDepartureEntries.entOff = entOff
                                            } else {
                                                let item = DepartureEntriesList(context: persistenceController.container.viewContext)
                                                item.entOff = entOff
                                                coreDataModel.existDataDepartureEntries = true
                                            }

                                            coreDataModel.save()
                                            
                                            isTextFieldEntOffFocused = false
                                            isTextFieldEntFuelInTanksFocused = true
                                        }
                                    }
                                    .focused($isTextFieldEntOffFocused)
                                    .frame(width: calculateWidth(proxy.size.width, 4))
                                           
                                    TextField("Fuel in Tanks", text: $entFuelInTanks, onEditingChanged: { editing in
                                        isEditingEntFuelInTanks = editing
                                    })
                                    .onChange(of: entFuelInTanks) { newValue in
                                        if newValue.count > 4 {
                                            entFuelInTanks = String(newValue.prefix(5))
                                            
                                            if coreDataModel.existDataDepartureEntries {
                                                coreDataModel.dataDepartureEntries.entFuelInTanks = entFuelInTanks
                                            } else {
                                                let item = DepartureEntriesList(context: persistenceController.container.viewContext)
                                                item.entFuelInTanks = entFuelInTanks
                                                coreDataModel.existDataDepartureEntries = true
                                            }

                                            coreDataModel.save()
                                            
                                            isTextFieldEntFuelInTanksFocused = false
                                            isTextFieldEntTaxiFocused = true
                                        }
                                    }.focused($isTextFieldEntFuelInTanksFocused)
                                    .frame(width: calculateWidth(proxy.size.width, 4))

                                    TextField("Taxi", text: $entTaxi, onEditingChanged: { editing in
                                        isEditingEntTaxi = editing
                                    })
                                    .onChange(of: entTaxi) { newValue in
                                        if newValue.count > 3 {
                                            entTaxi = String(newValue.prefix(4))
                                            
                                            if coreDataModel.existDataDepartureEntries {
                                                coreDataModel.dataDepartureEntries.entTaxi = entTaxi
                                            } else {
                                                let item = DepartureEntriesList(context: persistenceController.container.viewContext)
                                                item.entTaxi = entTaxi
                                                coreDataModel.existDataDepartureEntries = true
                                            }

                                            coreDataModel.save()
                                            
                                            isTextFieldEntTaxiFocused = false
                                            isTextFieldEntTakeoffFocused = true
                                        }
                                    }.focused($isTextFieldEntTaxiFocused)
                                        .frame(width: calculateWidth(proxy.size.width, 4))
                                    
                                    TextField( "Takeoff", text: $entTakeoff, onEditingChanged: { editing in
                                        isEditingEntTakeoff = editing
                                    })
                                    .onChange(of: entTakeoff) { newValue in
                                        if newValue.count > 3 {
                                            entTakeoff = String(newValue.prefix(4))
                                            
                                            if coreDataModel.existDataDepartureEntries {
                                                coreDataModel.dataDepartureEntries.entTakeoff = entTakeoff
                                            } else {
                                                let item = DepartureEntriesList(context: persistenceController.container.viewContext)
                                                item.entTakeoff = entTakeoff
                                                coreDataModel.existDataDepartureEntries = true
                                            }

                                            coreDataModel.save()
                                            
                                            isTextFieldEntTakeoffFocused = false
                                            isTextFieldEntOffFocused = true
                                        }
                                    }.focused($isTextFieldEntTakeoffFocused)
                                        .frame(width: calculateWidth(proxy.size.width, 4))
                                }
                            }
                            .padding(.top, 5)
                            .padding(.bottom, 5)
                        }.padding(.horizontal, 25)
                            .frame(maxWidth: proxy.size.width - 50)
                    }.onChange(of: coreDataModel.dataDepartureEntries) { _ in
                        coreDataModel.readDepartureEntries()
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
                }
                Group {
                    if isEditingAtcRwy {
                        CustomKeyboardView(text: $atcRwy, cursorPosition: $cursorPositionAtcRwy, currentFocus: _isTextFieldAtcRwyFocused, nextFocus: _isTextFieldAtcDepFocused, prevFocus: _isTextFieldAtcSQFocused)
                    }
                    if isEditingAtcDep {
                        CustomKeyboardView(text: $atcDep, cursorPosition: $cursorPositionAtcDep, currentFocus: _isTextFieldAtcDepFocused, nextFocus: _isTextFieldAtcRteFocused, prevFocus: _isTextFieldAtcRwyFocused)
                    }
                    if isEditingAtcRte {
                        CustomKeyboardView(text: $atcRte, cursorPosition: $cursorPositionAtcRte, currentFocus: _isTextFieldAtcRteFocused, nextFocus: _isTextFieldAtcFLFocused, prevFocus: _isTextFieldAtcDepFocused)
                    }
                    if isEditingAtcFL {
                        CustomKeyboardView(text: $atcFL, cursorPosition: $cursorPositionAtcFL, currentFocus: _isTextFieldAtcFLFocused, nextFocus: _isTextFieldAtcSQFocused, prevFocus: _isTextFieldAtcRteFocused)
                    }
                    if isEditingAtcSQ {
                        CustomKeyboardView(text: $atcSQ, cursorPosition: $cursorPositionAtcSQ, currentFocus: _isTextFieldAtcSQFocused, nextFocus: _isTextFieldAtcRwyFocused, prevFocus: _isTextFieldAtcFLFocused)
                    }
                }
                Group {
                    if isEditingEntOff {
                        CustomKeyboardView(text: $entOff, cursorPosition: $cursorPositionEntOff, currentFocus: _isTextFieldEntOffFocused, nextFocus: _isTextFieldEntFuelInTanksFocused, prevFocus: _isTextFieldEntTakeoffFocused)
                    }
                    if isEditingEntFuelInTanks {
                        CustomKeyboardView(text: $entFuelInTanks, cursorPosition: $cursorPositionEntFuelInTanks, currentFocus: _isTextFieldEntFuelInTanksFocused, nextFocus: _isTextFieldEntTaxiFocused, prevFocus: _isTextFieldEntOffFocused)
                    }
                    if isEditingEntTaxi {
                        CustomKeyboardView(text: $entTaxi, cursorPosition: $cursorPositionEntTaxi, currentFocus: _isTextFieldEntTaxiFocused, nextFocus: _isTextFieldEntTakeoffFocused, prevFocus: _isTextFieldEntFuelInTanksFocused)
                    }
                    if isEditingEntTakeoff {
                        CustomKeyboardView(text: $entTakeoff, cursorPosition: $cursorPositionEntTakeoff, currentFocus: _isTextFieldEntTakeoffFocused, nextFocus: _isTextFieldEntOffFocused, prevFocus: _isTextFieldEntTaxiFocused)
                    }
                }
                Group {
                    if isShowingAutofillOptionsWx {
                        List(autofillOptionsATIS.filter { $0.hasPrefix(autofillText) }, id: \.self) { option in
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
                        List(autofillOptionsATIS.filter { $0.hasPrefix(autofillText) }, id: \.self) { option in
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
                        List(autofillOptionsATIS.filter { $0.hasPrefix(autofillText) }, id: \.self) { option in
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
                    if isShowingAutofillOptionsAtcRte {
                        List(routeList.filter { $0.hasPrefix(autofillText) }, id: \.self) { option in
                            Button(action: {
                                let modifiedText = atcRte.components(separatedBy: " ").dropLast().joined(separator: " ")
                                cursorPositionAtcRte -= atcRte.count
                                atcRte = modifiedText + " " + option + " "
                                cursorPositionAtcRte += atcRte.count
                                isShowingAutofillOptionsAtcRte = false
                            }) {
                                Text(option)
                            }
                        }
                        .listStyle(GroupedListStyle())
                    }
                }
            }.navigationTitle("Departure")
                .background(Color(.systemGroupedBackground))
                .hideKeyboardWhenTappedAround()
        }.onAppear {
            coreDataModel.readDepartures()
            //set data ats
            if coreDataModel.existDataDepartureAts {
                self.code = coreDataModel.dataDepartureAts.unwrappedCode
                self.time = coreDataModel.dataDepartureAts.unwrappedTime
                self.rwy = coreDataModel.dataDepartureAts.unwrappedRwy
                self.transLvl = coreDataModel.dataDepartureAts.unwrappedRranslvl
                self.wind = coreDataModel.dataDepartureAts.unwrappedWind
                self.vis = coreDataModel.dataDepartureAts.unwrappedVis
                self.wx = coreDataModel.dataDepartureAts.unwrappedWx
                self.cloud = coreDataModel.dataDepartureAts.unwrappedCloud
                self.temp = coreDataModel.dataDepartureAts.unwrappedTemp
                self.dp = coreDataModel.dataDepartureAts.unwrappedDp
                self.qnh = coreDataModel.dataDepartureAts.unwrappedQnh
                self.remarks = coreDataModel.dataDepartureAts.unwrappedRemarks
            }
            
            //set data atc
            if coreDataModel.existDataDepartureAtc {
                self.atcRwy = coreDataModel.dataDepartureAtc.unwrappedAtcRwy
                self.atcDep = coreDataModel.dataDepartureAtc.unwrappedAtcDep
                self.atcRte = coreDataModel.dataDepartureAtc.unwrappedAtcRte
                self.atcFL = coreDataModel.dataDepartureAtc.unwrappedAtcFL
                self.atcSQ = coreDataModel.dataDepartureAtc.unwrappedAtcSQ
            }
            
            //set data entries
            if coreDataModel.existDataDepartureEntries {
                self.entOff = coreDataModel.dataDepartureEntries.unwrappedEntOff
                self.entFuelInTanks = coreDataModel.dataDepartureEntries.unwrappedEntFuelInTanks
                self.entTaxi = coreDataModel.dataDepartureEntries.unwrappedEntTaxi
                self.entTakeoff = coreDataModel.dataDepartureEntries.unwrappedEntTakeoff
            }
        }
    }
}

struct FlightPlanDepView_Previews: PreviewProvider {
    static var previews: some View {
        FlightPlanDepView()
    }
}
