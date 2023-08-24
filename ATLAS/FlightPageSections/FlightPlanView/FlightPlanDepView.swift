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
    
    @State private var autofillOptionsCloud: [String] = ["FEW", "SCT", "BKN", "OVC", "AC", "AS", "CB", "CC", "CU", "SC", "ST", "SC"]
    @State private var autofillOptionsWX: [String] = ["AC", "AD", "AMD", "AS", "ASR", "AUTO", "BASE", "BCFG", "BECMG", "BL", "BLW", "BR", "BTN", "CAVOK", "CB", "CC", "CI", "CIT", "CLD", "COR", "COT", "CS", "CU", "DEG", "DP", "DR", "DS", "DU", "DUC", "DZ", "ENE", "ESE", "EMBD", "FC", "FCST", "FG", "FL", "FPM", "FRQ", "FT", "FU", "FZ", "GR", "GS", "HPA", "HVY", "HZ", "IC", "ICE", "INS", "INTSF", "IRVR", "ISOL", "JTST", "KM", "KMH", "KT", "LAN", "LCA", "LSQ", "LV", "LYR", "MB", "METAR", "MI", "MNM", "MOD", "MON", "MPS", "MS", "MSL", "MTW", "NAT", "NC", "NCD", "NDV", "NE", "NIL", "NM", "NNE", "NNW", "NOSIG", "NOTAM", "NS", "NSC", "NSW", "NW", "OCNL", "PL", "PO", "PRFG", "PROB30", "PROB4", "PS", "PSYS", "QFE", "QNE", "QNH", "RA", "RMK", "RVR", "RWY", "SA", "SC", "SE", "SEA", "SEV", "SFC", "SG", "SIG", "SKC", "SN", "SPECI", "SQ", "SS", "SSE", "SSW", "ST", "STNR", "SW", "TAF", "TCU", "TEMPO", "TL", "TOP", "TROP", "TS", "TSRA", "TURB", "UP", "UTC", "VA", "VAL", "VIS", "VRB", "VSP", "WDSPR", "WNW", "WRNG", "WS", "WSPD", "WSW", "WX"]
    @State private var autofillText = ""
    @State private var isShowingCustomKeyboard = false
    
    // For datetime picker
    @State var isShowModalChockOff = false
    @State var isShowModalTaxi = false
    @State var isShowModalTakeOff = false
    
    @State private var currentDateChockOff = Date()
    @State private var currentDateChockOffTemp = Date()
    @State private var currentDateTaxi = Date()
    @State private var currentDateTaxiTemp = Date()
    @State private var currentDateTakeOff = Date()
    @State private var currentDateTakeOffTemp = Date()
    
    var dateClosedRange: ClosedRange<Date> {
        let min = Calendar.current.date(byAdding: .day, value: 0, to: Date())!
        let max = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        return min...max
    }
    
    var body: some View {
        let route = coreDataModel.dataSummaryRoute.unwrappedRoute
        let routeList: [String] = route.components(separatedBy: " ")
        
        ScrollViewReader { scrollView in
            GeometryReader { proxy in
                VStack(alignment: .leading) {
                    HStack(alignment: .center) {
                        HStack {
                            Text("Flight Plan: \(coreDataModel.dataSummaryInfo.unwrappedPlanNo)").font(.system(size: 15, weight: .semibold))
                            Spacer()
                            Text("Last Update: 10 mins ago").font(.system(size: 15, weight: .regular))
                        }.padding()
                        .background(Color.theme.lightGray1)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal, 16)
                    
                    HStack(alignment: .center) {
                        Text("Departure")
                            .font(.system(size: 20, weight: .semibold))
                            .padding(.leading, 30)
                    }.padding(.vertical)

                    //scrollable outer list section
                    List {
                        // ATIS section
                        Section(header:
                                    HStack {
                            Text("ATIS \(coreDataModel.dataSummaryInfo.unwrappedDep)").font(.system(size: 15, weight: .semibold)).foregroundStyle(Color.black)
                        }
                        ) {
                            // grouped row using hstack
                            VStack(alignment: .leading) {
                                HStack(alignment: .center) {
                                    Group {
                                        Text("Code")
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundStyle(Color.blue)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Text("Time")
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundStyle(Color.blue)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Text("Rwy")
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundStyle(Color.black)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Text("Trans Lvl")
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundStyle(Color.black)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Text("Wind")
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundStyle(Color.black)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Text("Vis")
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundStyle(Color.black)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Text("Wx")
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundStyle(Color.black)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Text("Cloud")
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundStyle(Color.black)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Text("Temp")
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundStyle(Color.black)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Text("DP")
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundStyle(Color.black)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    Text("QNH")
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundStyle(Color.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text("Remarks")
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundStyle(Color.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }.padding(.top, 5)
                                    .padding(.bottom, 5)
                                
                                Divider()
                                
                                HStack(alignment: .center) {
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
                                                    
                                                    if coreDataModel.existDataDepartureAtis {
                                                        coreDataModel.dataDepartureAtis.code = code
                                                    } else {
                                                        let item = DepartureATISList(context: persistenceController.container.viewContext)
                                                        item.code = code
                                                    }
                                                    
                                                    coreDataModel.save()
                                                    
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
                                                    if coreDataModel.existDataDepartureAtis {
                                                        coreDataModel.dataDepartureAtis.time = time
                                                    } else {
                                                        let item = DepartureATISList(context: persistenceController.container.viewContext)
                                                        item.time = time
                                                    }
                                                    
                                                    coreDataModel.save()
                                                    
                                                    isEditingTime = false
                                                    isTextFieldRwyFocused = true
                                                }
                                            }
                                    }.font(.system(size: 17, weight: .regular))
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
                                                    if coreDataModel.existDataDepartureAtis {
                                                        coreDataModel.dataDepartureAtis.rwy = rwy
                                                    } else {
                                                        let item = DepartureATISList(context: persistenceController.container.viewContext)
                                                        item.rwy = rwy
                                                    }
                                                    
                                                    coreDataModel.save()
                                                    
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
                                                    if coreDataModel.existDataDepartureAtis {
                                                        coreDataModel.dataDepartureAtis.translvl = transLvl
                                                    } else {
                                                        let item = DepartureATISList(context: persistenceController.container.viewContext)
                                                        item.translvl = transLvl
                                                    }
                                                    
                                                    coreDataModel.save()
                                                    
                                                    isEditingTransLvl = false
                                                    isTextFieldWindFocused = true
                                                }
                                            }
                                    }.font(.system(size: 17, weight: .regular))
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
                                                    if coreDataModel.existDataDepartureAtis {
                                                        coreDataModel.dataDepartureAtis.wind = wind
                                                    } else {
                                                        let item = DepartureATISList(context: persistenceController.container.viewContext)
                                                        item.wind = wind
                                                    }
                                                    
                                                    coreDataModel.save()
                                                    
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
                                                    if coreDataModel.existDataDepartureAtis {
                                                        coreDataModel.dataDepartureAtis.vis = vis
                                                    } else {
                                                        let item = DepartureATISList(context: persistenceController.container.viewContext)
                                                        item.vis = vis
                                                    }
                                                    
                                                    coreDataModel.save()
                                                    
                                                    isEditingVis = false
                                                    isTextFieldWxFocused = true
                                                }
                                            }
                                    }.font(.system(size: 17, weight: .regular))
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
                                            .onChange(of: wx) { text in
                                                let components = text.components(separatedBy: " ")
                                                if let lastComponent = components.last, lastComponent.hasPrefix(".") && lastComponent.count > 1 {
                                                    let searchTerm = String(lastComponent.dropFirst())
                                                    autofillText = searchTerm
                                                    isShowingAutofillOptionsWx = true
                                                } else {
                                                    if coreDataModel.existDataDepartureAtis {
                                                        coreDataModel.dataDepartureAtis.wx = text
                                                    } else {
                                                        let item = DepartureATISList(context: persistenceController.container.viewContext)
                                                        item.wx = text
                                                    }

                                                    coreDataModel.save()
                                                    isShowingAutofillOptionsWx = false
                                                }
                                            }
                                            .onChange(of: isEditingWx) { focused in
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
                                            .onChange(of: cloud) { text in
                                                let components = text.components(separatedBy: " ")
                                                if let lastComponent = components.last, lastComponent.hasPrefix(".") && lastComponent.count > 1 {
                                                    let searchTerm = String(lastComponent.dropFirst())
                                                    autofillText = searchTerm
                                                    isShowingAutofillOptionsCloud = true
                                                } else {
                                                    if coreDataModel.existDataDepartureAtis {
                                                        coreDataModel.dataDepartureAtis.cloud = text
                                                    } else {
                                                        let item = DepartureATISList(context: persistenceController.container.viewContext)
                                                        item.cloud = text
                                                    }

                                                    coreDataModel.save()
                                                    isShowingAutofillOptionsCloud = false
                                                }
                                            }
                                            .onChange(of: isEditingCloud) { focused in
                                                if !focused {
                                                    isShowingAutofillOptionsCloud = false
                                                }
                                            }
                                    }.font(.system(size: 17, weight: .regular))
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
                                                    if coreDataModel.existDataDepartureAtis {
                                                        coreDataModel.dataDepartureAtis.temp = temp
                                                    } else {
                                                        let item = DepartureATISList(context: persistenceController.container.viewContext)
                                                        item.temp = temp
                                                    }
                                                    
                                                    coreDataModel.save()
                                                    
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
                                                    if coreDataModel.existDataDepartureAtis {
                                                        coreDataModel.dataDepartureAtis.dp = dp
                                                    } else {
                                                        let item = DepartureATISList(context: persistenceController.container.viewContext)
                                                        item.dp = dp
                                                    }
                                                    
                                                    coreDataModel.save()
                                                    
                                                    isEditingDP = false
                                                    isTextFieldQNHFocused = true
                                                }
                                            }
                                    }.font(.system(size: 17, weight: .regular))
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
                                                    if coreDataModel.existDataDepartureAtis {
                                                        coreDataModel.dataDepartureAtis.qnh = qnh
                                                    } else {
                                                        let item = DepartureATISList(context: persistenceController.container.viewContext)
                                                        item.qnh = qnh
                                                    }
                                                    
                                                    coreDataModel.save()
                                                    
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
                                            .onChange(of: remarks) { text in
                                                let components = text.components(separatedBy: " ")
                                                if let lastComponent = components.last, lastComponent.hasPrefix(".") && lastComponent.count > 1 {
                                                    let searchTerm = String(lastComponent.dropFirst())
                                                    autofillText = searchTerm
                                                    isShowingAutofillOptionsRemarks = true
                                                } else {
                                                    if coreDataModel.existDataDepartureAtis {
                                                        coreDataModel.dataDepartureAtis.remarks = text
                                                    } else {
                                                        let item = DepartureATISList(context: persistenceController.container.viewContext)
                                                        item.remarks = text
                                                    }

                                                    coreDataModel.save()
                                                    isShowingAutofillOptionsRemarks = false
                                                }
                                            }
                                            .onChange(of: isEditingRemarks) { focused in
                                                if !focused {
                                                    isShowingAutofillOptionsRemarks = false
                                                }
                                            }
                                    }.font(.system(size: 17, weight: .regular))
                                }
                                .padding(.top, 5)
                                .padding(.bottom, 5)
                            }.id("atis")
                        }.onChange(of: coreDataModel.dataDepartureAtis) { _ in
                            coreDataModel.readDepartureAtis()
                        }
                        
                        // ATC section
                        Section(header:
                                    HStack {
                            Text("ATC").font(.system(size: 15, weight: .semibold)).foregroundStyle(Color.black)
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
                                        Text("A")
                                            .foregroundStyle(Color.blue)
                                            .frame(width: calculateWidth(proxy.size.width, 6), alignment: .leading)
                                    }.font(.system(size: 15, weight: .medium))
                                }.padding(.top, 5)
                                    .padding(.bottom, 5)
                                
                                Divider()
                                
                                HStack(alignment: .center) {
                                    Text("\(coreDataModel.dataSummaryInfo.unwrappedDest)")
                                        .font(.system(size: 17, weight: .regular))
                                        .frame(width: calculateWidth(proxy.size.width, 6), alignment: .leading)
                                    Group {
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
                                                    if coreDataModel.existDataDepartureAtc {
                                                        coreDataModel.dataDepartureAtc.atcRwy = atcRwy
                                                    } else {
                                                        let item = DepartureATCList(context: persistenceController.container.viewContext)
                                                        item.atcRwy = atcRwy
                                                    }
                                                    
                                                    coreDataModel.save()
                                                    
                                                    isEditingAtcRwy = false
                                                    isTextFieldAtcDepFocused = true
                                                }
                                            }
                                            .frame(width: calculateWidth(proxy.size.width, 6), alignment: .leading)
                                        
                                        TextField("Dep", text: $atcDep)
                                            .frame(width: calculateWidth(proxy.size.width, 6))
                                            .focused($isTextFieldAtcDepFocused)
                                            .onReceive(Just(isTextFieldAtcDepFocused)) { focused in
                                                if focused {
                                                    isTextFieldAtcDepFocused = false
                                                    setFocusToFalse()
                                                    isEditingAtcDep = true
                                                }
                                            }
                                            .overlay(isEditingAtcDep ? Rectangle().stroke(Color.red, lineWidth:1) : nil)
                                            .onReceive(Just(atcDep)) { text in
                                                if coreDataModel.existDataDepartureAtc {
                                                    coreDataModel.dataDepartureAtc.atcDep = atcDep
                                                } else {
                                                    let item = DepartureATCList(context: persistenceController.container.viewContext)
                                                    item.atcDep = atcDep
                                                }
                                                
                                                coreDataModel.save()
                                            }
                                    }.font(.system(size: 17, weight: .regular))
                                    Group {
                                        TextField("Rte", text: $atcRte)
                                            .focused($isTextFieldAtcRteFocused)
                                            .onReceive(Just(isTextFieldAtcRteFocused)) { focused in
                                                if focused {
                                                    isTextFieldAtcRteFocused = false
                                                    setFocusToFalse()
                                                    isEditingAtcRte = true
                                                }
                                            }
                                            .overlay(isEditingAtcRte ? Rectangle().stroke(Color.red, lineWidth:1) : nil)
                                            .onChange(of: atcRte) { text in
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
                                            .onChange(of: isEditingAtcRte) { focused in
                                                if !focused {
                                                    isShowingAutofillOptionsAtcRte = false
                                                }
                                            }
                                            .frame(width: calculateWidth(proxy.size.width, 6))
                                        
                                        TextField( "FL", text: $atcFL)
                                            .focused($isTextFieldAtcFLFocused)
                                            .onReceive(Just(isTextFieldAtcFLFocused)) { focused in
                                                if focused {
                                                    isTextFieldAtcFLFocused = false
                                                    setFocusToFalse()
                                                    isEditingAtcFL = true
                                                }
                                            }
                                            .overlay(isEditingAtcFL ? Rectangle().stroke(Color.red, lineWidth:1) : nil)
                                            .onChange(of: atcFL) { newValue in
                                                if newValue.count > 2 {
                                                    atcFL = String(newValue.prefix(3))
                                                    cursorPositionAtcFL = 3
                                                    if coreDataModel.existDataDepartureAtc {
                                                        coreDataModel.dataDepartureAtc.atcFL = atcFL
                                                    } else {
                                                        let item = DepartureATCList(context: persistenceController.container.viewContext)
                                                        item.atcFL = atcFL
                                                    }
                                                    
                                                    coreDataModel.save()
                                                    
                                                    isEditingAtcFL = false
                                                    isTextFieldAtcSQFocused = true
                                                }
                                            }
                                            .frame(width: calculateWidth(proxy.size.width, 6))
                                    }.font(.system(size: 17, weight: .regular))
                                    TextField("A", text: $atcSQ)
                                        .font(.system(size: 17, weight: .regular))
                                        .focused($isTextFieldAtcSQFocused)
                                        .onReceive(Just(isTextFieldAtcSQFocused)) { focused in
                                            if focused {
                                                isTextFieldAtcSQFocused = false
                                                setFocusToFalse()
                                                isEditingAtcSQ = true
                                            }
                                        }
                                        .overlay(isEditingAtcSQ ? Rectangle().stroke(Color.red, lineWidth:1) : nil)
                                        .onChange(of: atcSQ) { newValue in
                                            if newValue.count > 3 {
                                                atcSQ = String(newValue.prefix(4))
                                                cursorPositionAtcSQ = 4
                                                
                                                if coreDataModel.existDataDepartureAtc {
                                                    coreDataModel.dataDepartureAtc.atcSQ = atcSQ
                                                } else {
                                                    let item = DepartureATCList(context: persistenceController.container.viewContext)
                                                    item.atcSQ = atcSQ
                                                }
                                                
                                                coreDataModel.save()
                                                
                                                isEditingAtcSQ = false
                                                isTextFieldAtcRwyFocused = true
                                            }
                                        }
                                        .frame(width: calculateWidth(proxy.size.width, 6))
                                }
                                .padding(.top, 5)
                                .padding(.bottom, 5)
                                
                            }.frame(maxWidth: proxy.size.width - 50)
                            
                        }.onChange(of: coreDataModel.dataDepartureAtc) { _ in
                            coreDataModel.readDepartureAtc()
                        }.id("atc")
                        // Entries section
                        Section(header:
                                    HStack {
                            Text("Entries").font(.system(size: 15, weight: .semibold)).foregroundStyle(Color.black)
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
                                    }.font(.system(size: 15, weight: .medium))
                                }
                                .padding(.top, 5)
                                .padding(.bottom, 5)
                                
                                Divider()
                                
                                HStack {
                                    Group {
                                        HStack {
                                            ButtonDateStepper(onToggle: onChockOff, value: $currentDateChockOff, suffix: "").fixedSize()
                                            Spacer()
                                        }.frame(width: calculateWidth(proxy.size.width, 4))
                                        
                                        TextField("Fuel in Tanks", text: $entFuelInTanks)
                                            .focused($isTextFieldEntFuelInTanksFocused)
                                            .onReceive(Just(isTextFieldEntFuelInTanksFocused)) { focused in
                                                if focused {
                                                    isTextFieldEntFuelInTanksFocused = false
                                                    setFocusToFalse()
                                                    isEditingEntFuelInTanks = true
                                                }
                                            }
                                            .overlay(isEditingEntFuelInTanks ? Rectangle().stroke(Color.red, lineWidth:1) : nil)
                                            .onChange(of: entFuelInTanks) { newValue in
//                                                if newValue.count > 4 {
                                                    entFuelInTanks = String(newValue.prefix(5))
//                                                    cursorPositionEntFuelInTanks = 5
                                                    if coreDataModel.existDataDepartureEntries {
                                                        coreDataModel.dataDepartureEntries.entFuelInTanks = entFuelInTanks
                                                    } else {
                                                        let item = DepartureEntriesList(context: persistenceController.container.viewContext)
                                                        item.entFuelInTanks = entFuelInTanks
                                                        coreDataModel.existDataDepartureEntries = true
                                                    }
                                                    
                                                    coreDataModel.save()
                                                    coreDataModel.readDepartureEntries()
                                                    
//                                                    isEditingEntFuelInTanks = false
//                                                    isTextFieldEntTaxiFocused = true
//                                                }
                                            }
                                            .frame(width: calculateWidth(proxy.size.width, 4))
                                    }.font(.system(size: 17, weight: .regular))
                                    Group {
                                        HStack {
                                            ButtonDateStepper(onToggle: onTaxi, value: $currentDateTaxi, suffix: "").fixedSize()
                                            Spacer()
                                        }.frame(width: calculateWidth(proxy.size.width, 4))
                                        
                                        HStack {
                                            ButtonDateStepper(onToggle: onTakeOff, value: $currentDateTakeOff, suffix: "").fixedSize()
                                            Spacer()
                                        }.frame(width: calculateWidth(proxy.size.width, 4))
                                    }.font(.system(size: 17, weight: .regular))
                                }
                                .padding(.top, 5)
                                .padding(.bottom, 5)
                            }.frame(maxWidth: proxy.size.width - 50)
                        }.onChange(of: coreDataModel.dataDepartureEntries) { _ in
                            coreDataModel.readDepartureEntries()
                        }.id("entries")
                    }
                    
                    ZStack {
                        VStack {
                            // custom keyboard view - todo set position properly - like normal ipad keyboard position
                            Group {
                                if isEditingCode {
                                    CustomKeyboardView1(text: $code, cursorPosition: $cursorPositionCode, currentFocus: $isEditingCode, nextFocus: $isEditingTime, prevFocus: $isEditingRemarks)
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
                                    CustomKeyboardView1(text: $remarks, cursorPosition: $cursorPositionRemarks, currentFocus: $isEditingRemarks, nextFocus: $isEditingCode, prevFocus: $isEditingQNH)
                                }
                            }
                            Group {
                                if isEditingAtcRwy {
                                    CustomKeyboardView1(text: $atcRwy, cursorPosition: $cursorPositionAtcRwy, currentFocus: $isEditingAtcRwy, nextFocus: $isEditingAtcDep, prevFocus: $isEditingAtcSQ)
                                }
                                if isEditingAtcDep {
                                    CustomKeyboardView1(text: $atcDep, cursorPosition: $cursorPositionAtcDep, currentFocus: $isEditingAtcDep, nextFocus: $isEditingAtcRte, prevFocus: $isEditingAtcRwy)
                                }
                                if isEditingAtcRte {
                                    CustomKeyboardView1(text: $atcRte, cursorPosition: $cursorPositionAtcRte, currentFocus: $isEditingAtcRte, nextFocus: $isEditingAtcFL, prevFocus: $isEditingAtcDep)
                                }
                                if isEditingAtcFL {
                                    CustomKeyboardView1(text: $atcFL, cursorPosition: $cursorPositionAtcFL, currentFocus: $isEditingAtcFL, nextFocus: $isEditingAtcSQ, prevFocus: $isEditingAtcRte)
                                }
                                if isEditingAtcSQ {
                                    CustomKeyboardView1(text: $atcSQ, cursorPosition: $cursorPositionAtcSQ, currentFocus: $isEditingAtcSQ, nextFocus: $isEditingAtcRwy, prevFocus: $isEditingAtcRte)
                                }
                            }
                            Group {
                                if isEditingEntOff {
                                    CustomKeyboardView1(text: $entOff, cursorPosition: $cursorPositionEntOff, currentFocus: $isEditingEntOff, nextFocus: $isEditingEntFuelInTanks, prevFocus: $isEditingEntTakeoff)
                                }
                                if isEditingEntFuelInTanks {
                                    CustomKeyboardView1(text: $entFuelInTanks, cursorPosition: $cursorPositionEntFuelInTanks, currentFocus: $isEditingEntFuelInTanks, nextFocus: .constant(false), prevFocus: $isEditingEntOff)
                                }
                                if isEditingEntTaxi {
                                    CustomKeyboardView1(text: $entTaxi, cursorPosition: $cursorPositionEntTaxi, currentFocus: $isEditingEntTaxi, nextFocus: $isEditingEntTakeoff, prevFocus: $isEditingEntFuelInTanks)
                                }
                                if isEditingEntTakeoff {
                                    CustomKeyboardView1(text: $entTakeoff, cursorPosition: $cursorPositionEntTakeoff, currentFocus: $isEditingEntTakeoff, nextFocus: $isEditingEntOff, prevFocus: $isEditingEntTaxi)
                                }
                            }
                        } // End VStack Custom keyboard
                        
                        ZStack {
                            Group {
                                if isShowingAutofillOptionsWx && autofillOptionsWX.filter({ $0.hasPrefix(autofillText) }).count > 0 {
                                    List(autofillOptionsWX.filter { $0.hasPrefix(autofillText) }, id: \.self) { option in
                                        Button(action: {
                                            let modifiedText = wx.components(separatedBy: " ").dropLast().joined(separator: " ")
                                            cursorPositionWx -= wx.count
                                            wx = modifiedText + " " + option + " "
                                            cursorPositionWx += wx.count
                                            isShowingAutofillOptionsWx = false
                                        }) {
                                            Text(option)
                                        }
                                    }.listStyle(.insetGrouped)
                                        .scrollIndicators(.hidden)
                                        .background(Color.clear)
                                }
                                if isShowingAutofillOptionsCloud && autofillOptionsCloud.filter({ $0.hasPrefix(autofillText) }).count > 0 {
                                    List(autofillOptionsCloud.filter { $0.hasPrefix(autofillText) }, id: \.self) { option in
                                        Button(action: {
                                            let modifiedText = cloud.components(separatedBy: " ").dropLast().joined(separator: " ")
                                            cursorPositionCloud -= cloud.count
                                            cloud = modifiedText + " " + option + " "
                                            cursorPositionCloud += cloud.count
                                            isShowingAutofillOptionsCloud = false
                                        }) {
                                            Text(option)
                                        }
                                    }.listStyle(.insetGrouped)
                                        .scrollIndicators(.hidden)
                                        .background(Color.clear)
                                }
                                if isShowingAutofillOptionsRemarks && (autofillOptionsWX.filter { $0.hasPrefix(autofillText) }).count > 0 {
                                    List(autofillOptionsWX.filter { $0.hasPrefix(autofillText) }, id: \.self) { option in
                                        Button(action: {
                                            let modifiedText = remarks.components(separatedBy: " ").dropLast().joined(separator: " ")
                                            cursorPositionRemarks -= remarks.count
                                            remarks = modifiedText + " " + option + " "
                                            cursorPositionRemarks += remarks.count
                                            isShowingAutofillOptionsRemarks = false
                                        }) {
                                            Text(option)
                                        }
                                    }.listStyle(.insetGrouped)
                                        .scrollIndicators(.hidden)
                                        .background(Color.clear)
                                }
                                if isShowingAutofillOptionsAtcRte && (routeList.filter { $0.hasPrefix(autofillText) }).count > 0 {
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
                                    }.listStyle(.insetGrouped)
                                        .scrollIndicators(.hidden)
                                        .background(Color.clear)
                                }
                            }.frame(width: 300)
                                .offset(x: 400, y: -16)
                                .padding()
                                .scrollContentBackground(.hidden)
                        }
                        
                    }.frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.theme.quickSilver)
                        .onChange(of: isEditingEntFuelInTanks) { _ in
                            scrollView.scrollTo("entries")
                        }
                        .onChange(of: isEditingAtcRwy) { _ in
                            scrollView.scrollTo("atc")
                        }
                        .onChange(of: isEditingAtcDep) { _ in
                            scrollView.scrollTo("atc")
                        }
                        .onChange(of: isEditingAtcRte) { _ in
                            scrollView.scrollTo("atc")
                        }
                        .onChange(of: isEditingAtcFL) { _ in
                            scrollView.scrollTo("atc")
                        }
                        .onChange(of: isEditingAtcSQ) { _ in
                            scrollView.scrollTo("atc")
                        }
                        .onChange(of: isEditingCode) { _ in
                            scrollView.scrollTo("atis")
                        }
                        .onChange(of: isEditingTime) { _ in
                            scrollView.scrollTo("atis")
                        }
                    
                }.navigationTitle("Departure")
                    .background(Color(.systemGroupedBackground))
                //.hideKeyboardWhenTappedAround()
            }
        }
        .onAppear {
            coreDataModel.readDepartures()
            //set data ats
            if coreDataModel.existDataDepartureAtis {
                self.code = coreDataModel.dataDepartureAtis.unwrappedCode
                self.cursorPositionCode = coreDataModel.dataDepartureAtis.unwrappedCode.count
                self.time = coreDataModel.dataDepartureAtis.unwrappedTime
                self.cursorPositionTime = coreDataModel.dataDepartureAtis.unwrappedTime.count
                self.rwy = coreDataModel.dataDepartureAtis.unwrappedRwy
                self.cursorPositionRwy = coreDataModel.dataDepartureAtis.unwrappedRwy.count
                self.transLvl = coreDataModel.dataDepartureAtis.unwrappedRranslvl
                self.cursorPositionTransLvl = coreDataModel.dataDepartureAtis.unwrappedRranslvl.count
                self.wind = coreDataModel.dataDepartureAtis.unwrappedWind
                self.cursorPositionWind = coreDataModel.dataDepartureAtis.unwrappedWind.count
                self.vis = coreDataModel.dataDepartureAtis.unwrappedVis
                self.cursorPositionVis = coreDataModel.dataDepartureAtis.unwrappedVis.count
                self.wx = coreDataModel.dataDepartureAtis.unwrappedWx
                self.cursorPositionWx = coreDataModel.dataDepartureAtis.unwrappedWx.count
                self.cloud = coreDataModel.dataDepartureAtis.unwrappedCloud
                self.cursorPositionCloud = coreDataModel.dataDepartureAtis.unwrappedCloud.count
                self.temp = coreDataModel.dataDepartureAtis.unwrappedTemp
                self.cursorPositionTemp = coreDataModel.dataDepartureAtis.unwrappedTemp.count
                self.dp = coreDataModel.dataDepartureAtis.unwrappedDp
                self.cursorPositionDP = coreDataModel.dataDepartureAtis.unwrappedDp.count
                self.qnh = coreDataModel.dataDepartureAtis.unwrappedQnh
                self.cursorPositionQNH = coreDataModel.dataDepartureAtis.unwrappedQnh.count
                self.remarks = coreDataModel.dataDepartureAtis.unwrappedRemarks
                self.cursorPositionRemarks = coreDataModel.dataDepartureAtis.unwrappedRemarks.count
            }
            
            //set data atc
            if coreDataModel.existDataDepartureAtc {
                self.atcRwy = coreDataModel.dataDepartureAtc.unwrappedAtcRwy
                self.cursorPositionAtcRwy = coreDataModel.dataDepartureAtc.unwrappedAtcRwy.count
                self.atcDep = coreDataModel.dataDepartureAtc.unwrappedAtcDep
                self.cursorPositionAtcDep = coreDataModel.dataDepartureAtc.unwrappedAtcDep.count
                self.atcRte = coreDataModel.dataDepartureAtc.unwrappedAtcRte
                self.cursorPositionAtcRte = coreDataModel.dataDepartureAtc.unwrappedAtcRte.count
                self.atcFL = coreDataModel.dataDepartureAtc.unwrappedAtcFL
                self.cursorPositionAtcFL = coreDataModel.dataDepartureAtc.unwrappedAtcFL.count
                self.atcSQ = coreDataModel.dataDepartureAtc.unwrappedAtcSQ
                self.cursorPositionAtcSQ = coreDataModel.dataDepartureAtc.unwrappedAtcSQ.count
            }
            
            //set data entries
            if coreDataModel.existDataDepartureEntries {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/M | HHmm"
                //dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                // func to add year to the date value
                func parseDate(from dateString: String, with formatter: DateFormatter) -> Date? {
                    // split date to array and join to new format
                    let arr = dateString.components(separatedBy: " | ")
                    if arr.count > 0 {
                        let dateMonth = arr[0].components(separatedBy: "/")
                        let currentYear = Calendar.current.component(.year, from: Date())
                        let formattedDateString = "\(currentYear)-\(dateMonth[1])-\(dateMonth[0]) \(arr[1])"
                        
                        return formatter.date(from: formattedDateString);
                    }
                    
                    let currentDate = formatter.string(from: Date())
                    
                    return formatter.date(from: currentDate)
                }
                
                if coreDataModel.dataDepartureEntries.unwrappedEntOff != "" {
                    // format the date by adding the year so that it can be used by datepicker
                    var formattedOffDate: Date {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-M-dd HHmm"
                        // read date value and add year
                        if let date = parseDate(from: coreDataModel.dataDepartureEntries.unwrappedEntOff, with: formatter) {
                            return date
                        } else {
                            return Date()
                        }
                    }
                    self.currentDateChockOff = formattedOffDate
                    self.currentDateChockOffTemp = formattedOffDate
//                    self.currentDateChockOff = dateFormatter.date(from: coreDataModel.dataDepartureEntries.unwrappedEntOff) ?? Date()
//                    self.currentDateChockOffTemp = dateFormatter.date(from: coreDataModel.dataDepartureEntries.unwrappedEntOff) ?? Date()
                }
                
                if coreDataModel.dataDepartureEntries.unwrappedEntTaxi != "" {
                    // format the date by adding the year so that it can be used by datepicker
                    var formattedTaxiDate: Date {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-M-dd HHmm"
                        // read date value and add year
                        if let date = parseDate(from: coreDataModel.dataDepartureEntries.unwrappedEntTaxi, with: formatter) {
                            return date
                        } else {
                            return Date()
                        }
                    }
                    self.currentDateTaxi = formattedTaxiDate
                    self.currentDateTaxiTemp = formattedTaxiDate
//                    self.currentDateTaxi = dateFormatter.date(from: coreDataModel.dataDepartureEntries.unwrappedEntTaxi) ?? Date()
//                    self.currentDateTaxiTemp = dateFormatter.date(from: coreDataModel.dataDepartureEntries.unwrappedEntTaxi) ?? Date()
                }
                
                if coreDataModel.dataDepartureEntries.unwrappedEntTakeoff != "" {
                    var formattedTakeoffDate: Date {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-M-dd HHmm"
                        // read date value and add year
                        if let date = parseDate(from: coreDataModel.dataDepartureEntries.unwrappedEntTakeoff, with: formatter) {
                            return date
                        } else {
                            return Date()
                        }
                    }
                    self.currentDateTakeOff = formattedTakeoffDate
                    self.currentDateTakeOffTemp = formattedTakeoffDate
//                    self.currentDateTakeOff = dateFormatter.date(from: coreDataModel.dataDepartureEntries.unwrappedEntTakeoff) ?? Date()
//                    self.currentDateTakeOffTemp = dateFormatter.date(from: coreDataModel.dataDepartureEntries.unwrappedEntTakeoff) ?? Date()
                }
                
                self.entFuelInTanks = coreDataModel.dataDepartureEntries.unwrappedEntFuelInTanks
                self.cursorPositionEntFuelInTanks = coreDataModel.dataDepartureEntries.unwrappedEntFuelInTanks.count
            }
        }
        .formSheet(isPresented: $isShowModalChockOff) {
            VStack {
                HStack(alignment: .center) {
                    Button(action: {
                        self.isShowModalChockOff.toggle()
                    }) {
                        Text("Cancel").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                    }
                    
                    Spacer()
                    
                    Text("Chocks Off").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.black)
                    
                    Spacer()
                    Button(action: {
                        // assign value from modal to entries form
                        self.currentDateChockOff = currentDateChockOffTemp
                        
                        // Save data
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd/M | HHmm"
                        //dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let str = dateFormatter.string(from: currentDateChockOffTemp)
                        
                        if coreDataModel.existDataDepartureEntries {
                            coreDataModel.dataDepartureEntries.entOff = str
                        } else {
                            let item = DepartureEntriesList(context: persistenceController.container.viewContext)
                            item.entOff = dateFormatter.string(from: currentDateChockOffTemp)
                        }
                        coreDataModel.save()
                        coreDataModel.readDepartureEntries()
                        
                        self.isShowModalChockOff.toggle()
                    }) {
                        Text("Done").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                    }
                }.padding()
                    .background(.white)
                    .roundedCorner(12, corners: [.topLeft, .topRight])
                
                Divider()
                VStack {
                    DatePicker("", selection: $currentDateChockOffTemp, in: dateClosedRange, displayedComponents: [.date, .hourAndMinute]).labelsHidden().datePickerStyle(WheelDatePickerStyle())
                        .environment(\.locale, Locale(identifier: "en_GB"))
                }
                Spacer()
            }
        }
        .formSheet(isPresented: $isShowModalTaxi) {
            VStack {
                HStack(alignment: .center) {
                    Button(action: {
                        self.isShowModalTaxi.toggle()
                    }) {
                        Text("Cancel").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                    }
                    
                    Spacer()
                    
                    Text("Taxi").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.black)
                    
                    Spacer()
                    Button(action: {
                        // assign value from modal to entries form
                        self.currentDateTaxi = currentDateTaxiTemp
                        
                        // Save data
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd/M | HHmm"
                        //dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let str = dateFormatter.string(from: currentDateTaxiTemp)
                        
                        if coreDataModel.existDataDepartureEntries {
                            coreDataModel.dataDepartureEntries.entTaxi = str
                        } else {
                            let item = DepartureEntriesList(context: persistenceController.container.viewContext)
                            item.entTaxi = dateFormatter.string(from: currentDateTaxiTemp)
                        }
                        coreDataModel.save()
                        coreDataModel.readDepartureEntries()
                        
                        self.isShowModalTaxi.toggle()
                    }) {
                        Text("Done").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                    }
                }.padding()
                    .background(.white)
                    .roundedCorner(12, corners: [.topLeft, .topRight])
                
                Divider()
                
                VStack {
                    DatePicker("", selection: $currentDateTaxiTemp, in: dateClosedRange, displayedComponents: [.date, .hourAndMinute]).labelsHidden().datePickerStyle(WheelDatePickerStyle())
                        .environment(\.locale, Locale(identifier: "en_GB"))
                }
                Spacer()
            }
        }
        .formSheet(isPresented: $isShowModalTakeOff) {
            VStack {
                HStack(alignment: .center) {
                    Button(action: {
                        self.isShowModalTakeOff.toggle()
                    }) {
                        Text("Cancel").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                    }
                    
                    Spacer()
                    
                    Text("Takeoff").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.black)
                    
                    Spacer()
                    
                    Button(action: {
                        // assign value from modal to entries form
                        self.currentDateTakeOff = currentDateTakeOffTemp
                        
                        // Save data
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd/M | HHmm"
                        //dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let str = dateFormatter.string(from: currentDateTakeOffTemp)
                        
                        if coreDataModel.existDataDepartureEntries {
                            coreDataModel.dataDepartureEntries.entTakeoff = str
                        } else {
                            let item = DepartureEntriesList(context: persistenceController.container.viewContext)
                            item.entTakeoff = dateFormatter.string(from: currentDateTakeOffTemp)
                        }
                        coreDataModel.save()
                        coreDataModel.readDepartureEntries()
                        
                        self.isShowModalTakeOff.toggle()
                    }) {
                        Text("Done").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                    }
                }.padding()
                    .background(.white)
                    .roundedCorner(12, corners: [.topLeft, .topRight])
                
                Divider()
                
                VStack {
                    DatePicker("", selection: $currentDateTakeOffTemp, in: dateClosedRange, displayedComponents: [.date, .hourAndMinute]).labelsHidden().datePickerStyle(WheelDatePickerStyle())
                        .environment(\.locale, Locale(identifier: "en_GB"))
                }
                Spacer()
            }
        }
    }
    func setFocusToFalse() {
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
        isEditingAtcDep = false
        isEditingAtcRte = false
        isEditingAtcFL = false
        isEditingAtcSQ = false
        
        isEditingEntOff = false
        isEditingEntFuelInTanks = false
        isEditingEntTaxi = false
        isEditingEntTakeoff = false
    }
    
    func strRecursive(_ arr: [String], _ str: String) -> [String] {
        if str == "" {
            return arr
        }
        
        let strToArr = str.map( { String($0) })
        var tempArr =  arr;
        for (j, word) in strToArr.enumerated() {
            tempArr = findWordInArray(j, word, tempArr)
        }
        return tempArr
    }
    
    func findWordInArray(_ index: Int, _ word: String, _ arr: [String]) -> [String] {
        if index == 0 {
            return arr.filter { $0.hasPrefix(word) }
        }
        return arr.filter { $0.contains(word) }
    }
    
    func onChockOff() {
        self.isShowModalChockOff.toggle()
    }
    
    func onTaxi() {
        self.isShowModalTaxi.toggle()
    }
    
    func onTakeOff() {
        self.isShowModalTakeOff.toggle()
    }

}

struct FlightPlanDepView_Previews: PreviewProvider {
    static var previews: some View {
        FlightPlanDepView()
    }
}
