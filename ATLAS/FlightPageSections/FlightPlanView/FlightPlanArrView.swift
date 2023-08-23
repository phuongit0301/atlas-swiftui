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
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController
    
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

    @State private var autofillOptionsCloud: [String] = ["FEW", "SCT", "BKN", "OVC", "AC", "AS", "CB", "CC", "CU", "SC", "ST", "SC"]
    @State private var autofillOptionsWX: [String] = ["AC", "AD", "AMD", "AS", "ASR", "AUTO", "BASE", "BCFG", "BECMG", "BL", "BLW", "BR", "BTN", "CAVOK", "CB", "CC", "CI", "CIT", "CLD", "COR", "COT", "CS", "CU", "DEG", "DP", "DR", "DS", "DU", "DUC", "DZ", "ENE", "ESE", "EMBD", "FC", "FCST", "FG", "FL", "FPM", "FRQ", "FT", "FU", "FZ", "GR", "GS", "HPA", "HVY", "HZ", "IC", "ICE", "INS", "INTSF", "IRVR", "ISOL", "JTST", "KM", "KMH", "KT", "LAN", "LCA", "LSQ", "LV", "LYR", "MB", "METAR", "MI", "MNM", "MOD", "MON", "MPS", "MS", "MSL", "MTW", "NAT", "NC", "NCD", "NDV", "NE", "NIL", "NM", "NNE", "NNW", "NOSIG", "NOTAM", "NS", "NSC", "NSW", "NW", "OCNL", "PL", "PO", "PRFG", "PROB30", "PROB4", "PS", "PSYS", "QFE", "QNE", "QNH", "RA", "RMK", "RVR", "RWY", "SA", "SC", "SE", "SEA", "SEV", "SFC", "SG", "SIG", "SKC", "SN", "SPECI", "SQ", "SS", "SSE", "SSW", "ST", "STNR", "SW", "TAF", "TCU", "TEMPO", "TL", "TOP", "TROP", "TS", "TSRA", "TURB", "UP", "UTC", "VA", "VAL", "VIS", "VRB", "VSP", "WDSPR", "WNW", "WRNG", "WS", "WSPD", "WSW", "WX"]
    @State private var autofillText = ""

    // For datetime picker
    @State var isShowModalLanding = false
    @State var isShowModalChockOn = false
    
    @State private var currentDateLanding = Date()
    @State private var currentDateLandingTemp = Date()
    @State private var currentDateChockOn = Date()
    @State private var currentDateChockOnTemp = Date()
    
    var dateClosedRange: ClosedRange<Date> {
        let min = Calendar.current.date(byAdding: .day, value: 0, to: Date())!
        let max = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        return min...max
    }
    
    var body: some View {
        ScrollViewReader { scrollView in
            GeometryReader { proxy in
                VStack(alignment: .leading) {
                    // fixed header section, todo clean up design
                    HStack(alignment: .center) {
                        Text("Arrival")
                            .font(.system(size: 20, weight: .semibold))
                            .padding(.leading, 30)
                    }
                    .padding(.bottom, 10)
                    Text("Plan \(coreDataModel.dataSummaryInfo.unwrappedPlanNo) | Last updated 0820LT")
                        .padding(.leading, 30)
                        .padding(.bottom, 10)
                        .font(.system(size: 15, weight: .semibold))
                    //scrollable outer list section
                    // todo implement coredata into code
                    List {
                        // ATIS section
                        Section(header:
                                    HStack {
                            Text("ATIS").foregroundStyle(Color.black)
                                .font(.system(size: 15, weight: .semibold)).foregroundStyle(Color.black)
                            TextField(" \(coreDataModel.dataSummaryInfo.unwrappedDest)", text: $dest, onEditingChanged: { editing in
                                isEditingDest = editing
                            })
                            .focused($isTextFieldDestFocused)
                            .font(.system(size: 15, weight: .semibold))
                        }) {
                            // grouped row using hstack
                            VStack(alignment: .leading) {
                                HStack(alignment: .center) {
                                    Group {
                                        Text("Dest")
                                            .foregroundStyle(Color.black)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Text("Code")
                                            .foregroundStyle(Color.blue)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Text("Time")
                                            .foregroundStyle(Color.blue)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Text("Rwy")
                                            .foregroundStyle(Color.black)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Text("Trans Lvl")
                                            .foregroundStyle(Color.black)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Text("Wind")
                                            .foregroundStyle(Color.black)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Text("Vis")
                                            .foregroundStyle(Color.black)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Text("Wx")
                                            .foregroundStyle(Color.black)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Text("Cloud")
                                            .foregroundStyle(Color.black)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Text("Temp")
                                            .foregroundStyle(Color.black)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }.font(.system(size: 15, weight: .medium))
                                    Text("DP")
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundStyle(Color.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text("QNH")
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundStyle(Color.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text("Remarks")
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundStyle(Color.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                } // todo correct design and spacing
                                .padding(.top, 5)
                                .padding(.bottom, 5)
                                
                                Divider()
                                
                                HStack(alignment: .center) {
                                    TextField("Dest", text: $dest)
                                        .font(.system(size: 17, weight: .regular))
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
                                            // Limit the text to a maximum of 3 characters
                                            if newValue.count > 2 {
                                                code = String(newValue.prefix(3))
                                                cursorPositionDest = 3
                                                
                                                if coreDataModel.existDataArrivalAtis {
                                                    coreDataModel.dataArrivalAtis.dest = dest
                                                } else {
                                                    let item = ArrivalATISList(context: persistenceController.container.viewContext)
                                                    item.dest = dest
                                                }
                                                
                                                coreDataModel.save()
                                                
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
                                                    
                                                    if coreDataModel.existDataArrivalAtis {
                                                        coreDataModel.dataArrivalAtis.code = code
                                                    } else {
                                                        let item = ArrivalATISList(context: persistenceController.container.viewContext)
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
                                                    
                                                    if coreDataModel.existDataArrivalAtis {
                                                        coreDataModel.dataArrivalAtis.time = time
                                                    } else {
                                                        let item = ArrivalATISList(context: persistenceController.container.viewContext)
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
                                                    
                                                    if coreDataModel.existDataArrivalAtis {
                                                        coreDataModel.dataArrivalAtis.rwy = rwy
                                                    } else {
                                                        let item = ArrivalATISList(context: persistenceController.container.viewContext)
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
                                                    
                                                    if coreDataModel.existDataArrivalAtis {
                                                        coreDataModel.dataArrivalAtis.transLvl = transLvl
                                                    } else {
                                                        let item = ArrivalATISList(context: persistenceController.container.viewContext)
                                                        item.transLvl = transLvl
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
                                                    
                                                    if coreDataModel.existDataArrivalAtis {
                                                        coreDataModel.dataArrivalAtis.wind = wind
                                                    } else {
                                                        let item = ArrivalATISList(context: persistenceController.container.viewContext)
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
                                                    
                                                    if coreDataModel.existDataArrivalAtis {
                                                        coreDataModel.dataArrivalAtis.vis = vis
                                                    } else {
                                                        let item = ArrivalATISList(context: persistenceController.container.viewContext)
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
                                                    if coreDataModel.existDataArrivalAtis {
                                                        coreDataModel.dataArrivalAtis.wx = text
                                                    } else {
                                                        let item = ArrivalATISList(context: persistenceController.container.viewContext)
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
                                                    if coreDataModel.existDataArrivalAtis {
                                                        coreDataModel.dataArrivalAtis.cloud = text
                                                    } else {
                                                        let item = ArrivalATISList(context: persistenceController.container.viewContext)
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
                                                    
                                                    if coreDataModel.existDataArrivalAtis {
                                                        coreDataModel.dataArrivalAtis.temp = temp
                                                    } else {
                                                        let item = ArrivalATISList(context: persistenceController.container.viewContext)
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
                                                    
                                                    if coreDataModel.existDataArrivalAtis {
                                                        coreDataModel.dataArrivalAtis.dp = dp
                                                    } else {
                                                        let item = ArrivalATISList(context: persistenceController.container.viewContext)
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
                                                    
                                                    if coreDataModel.existDataArrivalAtis {
                                                        coreDataModel.dataArrivalAtis.qnh = qnh
                                                    } else {
                                                        let item = ArrivalATISList(context: persistenceController.container.viewContext)
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
                                                    if coreDataModel.existDataArrivalAtis {
                                                        coreDataModel.dataArrivalAtis.remarks = text
                                                    } else {
                                                        let item = ArrivalATISList(context: persistenceController.container.viewContext)
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
                            }.id("arrAtis")
                        }
                        
                        // ATC section
                        Section(header: Text("ATC").font(.system(size: 15, weight: .semibold)).foregroundStyle(Color.black)) {
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
                                    }.font(.system(size: 15, weight: .medium))
                                } // todo correct design and spacing
                                .padding(.top, 5)
                                .padding(.bottom, 5)
                                
                                Divider()
                                
                                HStack(alignment: .center) {
                                    Group {
                                        TextField(" \(coreDataModel.dataSummaryInfo.unwrappedDest)", text: $atcDest)
                                            .font(.system(size: 17, weight: .regular))
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
                                                    
                                                    if coreDataModel.existDataArrivalAtc {
                                                        coreDataModel.dataArrivalAtc.atcDest = atcDest
                                                    } else {
                                                        let item = ArrivalATCList(context: persistenceController.container.viewContext)
                                                        item.atcDest = atcDest
                                                    }
                                                    
                                                    coreDataModel.save()
                                                    
                                                    isEditingAtcDest = false
                                                    isTextFieldAtcRwyFocused = true
                                                }
                                            }
                                        
                                        TextField("Rwy", text: $atcRwy)
                                            .font(.system(size: 17, weight: .regular))
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
                                                    
                                                    if coreDataModel.existDataArrivalAtc {
                                                        coreDataModel.dataArrivalAtc.atcRwy = atcRwy
                                                    } else {
                                                        let item = ArrivalATCList(context: persistenceController.container.viewContext)
                                                        item.atcRwy = atcRwy
                                                    }
                                                    
                                                    coreDataModel.save()
                                                    
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
                                            .onChange(of: atcArr) { newValue in
                                                if coreDataModel.existDataArrivalAtc {
                                                    coreDataModel.dataArrivalAtc.atcArr = newValue
                                                } else {
                                                    let item = ArrivalATCList(context: persistenceController.container.viewContext)
                                                    item.atcArr = newValue
                                                }
                                                
                                                coreDataModel.save()
                                            }
                                        
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
                                                    
                                                    if coreDataModel.existDataArrivalAtc {
                                                        coreDataModel.dataArrivalAtc.atcTransLvl = atcTransLvl
                                                    } else {
                                                        let item = ArrivalATCList(context: persistenceController.container.viewContext)
                                                        item.atcTransLvl = atcTransLvl
                                                    }
                                                    
                                                    coreDataModel.save()
                                                    
                                                    isEditingAtcTransLvl = false
                                                    isTextFieldAtcDestFocused = true
                                                }
                                            }
                                    }.font(.system(size: 17, weight: .regular))
                                }
                                .padding(.top, 5)
                                .padding(.bottom, 5)
                            }.id("arrAtc")
                        }
                        // Entries section
                        Section(header: Text("Entries").font(.system(size: 15, weight: .semibold)).foregroundStyle(Color.black)) {
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
                                    }.font(.system(size: 15, weight: .medium))
                                } // todo correct design and spacing
                                .padding(.top, 5)
                                .padding(.bottom, 5)

                                Divider()

                                HStack(alignment: .center) {
                                    Group {
                                        HStack {
                                            ButtonDateStepper(onToggle: onLanding, value: $currentDateLanding, suffix: "").fixedSize()
                                            Spacer()
                                        }
                                    }
                                    Group {
                                        HStack {
                                            ButtonDateStepper(onToggle: onChockOn, value: $currentDateChockOn, suffix: "").fixedSize()
                                            Spacer()
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
//                                                if newValue.count > 4 {
                                                    entFuelOnChocks = String(newValue.prefix(5))
//                                                    cursorPositionEntFuelOnChocks = 5
                                                    if coreDataModel.existDataArrivalEntries {
                                                        coreDataModel.dataArrivalEntries.entFuelOnChocks = entFuelOnChocks
                                                    } else {
                                                        let item = ArrivalEntriesList(context: persistenceController.container.viewContext)
                                                        item.entFuelOnChocks = entFuelOnChocks
                                                    }
                                                    
                                                    coreDataModel.save()
                                                    
//                                                    isEditingEntFuelOnChocks = false
//                                                    isTextFieldEntLdgFocused = true
//                                                }
                                            }
                                    }.font(.system(size: 17, weight: .regular))
                                }
                                .padding(.top, 5)
                                .padding(.bottom, 5)
                            }.id("arrEntries")
                        }
                    }
                    
                    ZStack {
                        VStack {
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
                                    CustomKeyboardView1(text: $entFuelOnChocks, cursorPosition: $cursorPositionEntFuelOnChocks, currentFocus: $isEditingEntFuelOnChocks, nextFocus: .constant(false), prevFocus: $isEditingEntOn)
                                }
                            }
                        } // End VStack Custom keyboard
                        ZStack {
                            Group {
                                if isShowingAutofillOptionsWx && (autofillOptionsWX.filter { $0.hasPrefix(autofillText) }).count > 0 {
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
                                if isShowingAutofillOptionsCloud && (autofillOptionsCloud.filter { $0.hasPrefix(autofillText) }).count > 0 {
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
                            }.frame(width: 300)
                                .offset(x: 400, y: -16)
                                .padding()
                                .scrollContentBackground(.hidden)
                        }
                    }.frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.theme.quickSilver)
                        .onChange(of: isEditingEntFuelOnChocks) { _ in
                            scrollView.scrollTo("arrEntries")
                        }
                        .onChange(of: isEditingAtcDest) { _ in
                            scrollView.scrollTo("arrAtc")
                        }
                        .onChange(of: isEditingAtcRwy) { _ in
                            scrollView.scrollTo("arrAtc")
                        }
                        .onChange(of: isEditingAtcArr) { _ in
                            scrollView.scrollTo("arrAtc")
                        }
                        .onChange(of: isEditingAtcTransLvl) { _ in
                            scrollView.scrollTo("arrAtc")
                        }
                        .onChange(of: isEditingDest) { _ in
                            scrollView.scrollTo("arrAtis")
                        }
                        .onChange(of: isEditingCode) { _ in
                            scrollView.scrollTo("arrAtis")
                        }
                        .onChange(of: isEditingTime) { _ in
                            scrollView.scrollTo("arrAtis")
                        }
                        .onChange(of: isEditingRwy) { _ in
                            scrollView.scrollTo("arrAtis")
                        }
                        .onChange(of: isEditingTransLvl) { _ in
                            scrollView.scrollTo("arrAtis")
                        }
                        .onChange(of: isEditingWind) { _ in
                            scrollView.scrollTo("arrAtis")
                        }
                        .onChange(of: isEditingVis) { _ in
                            scrollView.scrollTo("arrAtis")
                        }
                        .onChange(of: isEditingWx) { _ in
                            scrollView.scrollTo("arrAtis")
                        }
                        .onChange(of: isEditingCloud) { _ in
                            scrollView.scrollTo("arrAtis")
                        }
                        .onChange(of: isEditingTemp) { _ in
                            scrollView.scrollTo("arrAtis")
                        }
                        .onChange(of: isEditingDP) { _ in
                            scrollView.scrollTo("arrAtis")
                        }
                        .onChange(of: isEditingQNH) { _ in
                            scrollView.scrollTo("arrAtis")
                        }
                        .onChange(of: isEditingRemarks) { _ in
                            scrollView.scrollTo("arrAtis")
                        }
                }.navigationTitle("Arrival")
                    .background(Color(.systemGroupedBackground))
            }
        }
        .onAppear {
            //set data ats
            if coreDataModel.existDataArrivalAtis {
                self.dest = coreDataModel.dataArrivalAtis.unwrappedDest
//                self.cursorPositionDest = coreDataModel.dataArrivalAtis!.unwrappedDest.count
                self.code = coreDataModel.dataArrivalAtis!.unwrappedCode
                self.cursorPositionCode = coreDataModel.dataArrivalAtis.unwrappedCode.count
                self.time = coreDataModel.dataArrivalAtis.unwrappedTime
                self.cursorPositionTime = coreDataModel.dataArrivalAtis.unwrappedTime.count
                self.rwy = coreDataModel.dataArrivalAtis.unwrappedRwy
                self.cursorPositionRwy = coreDataModel.dataArrivalAtis.unwrappedRwy.count
                self.transLvl = coreDataModel.dataArrivalAtis.unwrappedTransLvl
                self.cursorPositionTransLvl = coreDataModel.dataArrivalAtis.unwrappedTransLvl.count
                self.wind = coreDataModel.dataArrivalAtis.unwrappedWind
                self.cursorPositionWind = coreDataModel.dataArrivalAtis.unwrappedWind.count
                self.vis = coreDataModel.dataArrivalAtis.unwrappedVis
                self.cursorPositionVis = coreDataModel.dataArrivalAtis.unwrappedVis.count
                self.wx = coreDataModel.dataArrivalAtis.unwrappedWx
                self.cursorPositionWx = coreDataModel.dataArrivalAtis.unwrappedWx.count
                self.cloud = coreDataModel.dataArrivalAtis.unwrappedCloud
                self.cursorPositionCloud = coreDataModel.dataArrivalAtis.unwrappedCloud.count
                self.temp = coreDataModel.dataArrivalAtis.unwrappedTemp
                self.cursorPositionTemp = coreDataModel.dataArrivalAtis.unwrappedTemp.count
                self.dp = coreDataModel.dataArrivalAtis.unwrappedDp
                self.cursorPositionDP = coreDataModel.dataArrivalAtis.unwrappedDp.count
                self.qnh = coreDataModel.dataArrivalAtis.unwrappedQnh
                self.cursorPositionQNH = coreDataModel.dataArrivalAtis.unwrappedQnh.count
                self.remarks = coreDataModel.dataArrivalAtis.unwrappedRemarks
                self.cursorPositionRemarks = coreDataModel.dataArrivalAtis.unwrappedRemarks.count
            }
            
            if coreDataModel.existDataArrivalAtc {
                self.atcDest = coreDataModel.dataArrivalAtc.unwrappedAtcDest
                self.cursorPositionAtcDest = coreDataModel.dataArrivalAtc.unwrappedAtcDest.count
                self.atcRwy = coreDataModel.dataArrivalAtc.unwrappedAtcRwy
                self.cursorPositionAtcRwy = coreDataModel.dataArrivalAtc.unwrappedAtcRwy.count
                self.atcArr = coreDataModel.dataArrivalAtc.unwrappedAtcArr
                self.cursorPositionAtcArr = coreDataModel.dataArrivalAtc.unwrappedAtcArr.count
                self.atcTransLvl = coreDataModel.dataArrivalAtc.unwrappedAtcTransLvl
                self.cursorPositionAtcTransLvl = coreDataModel.dataArrivalAtc.unwrappedAtcTransLvl.count
            }
            
            if coreDataModel.existDataArrivalEntries {
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
                
                if coreDataModel.dataArrivalEntries.unwrappedEntLdg != "" {
                    // format the date by adding the year so that it can be used by datepicker
                    var formattedLandingDate: Date {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-M-dd HHmm"
                        // read date value and add year
                        if let date = parseDate(from: coreDataModel.dataArrivalEntries.unwrappedEntLdg, with: formatter) {
                            return date
                        } else {
                            return Date()
                        }
                    }
                    self.currentDateLanding = formattedLandingDate
                    self.currentDateLandingTemp = formattedLandingDate
//                    self.currentDateLanding = dateFormatter.date(from: coreDataModel.dataArrivalEntries.unwrappedEntLdg) ?? Date()
//                    self.currentDateLandingTemp = dateFormatter.date(from: coreDataModel.dataArrivalEntries.unwrappedEntLdg) ?? Date()
                }
                
                if coreDataModel.dataArrivalEntries.unwrappedEntOn != "" {
                    // format the date by adding the year so that it can be used by datepicker
                    var formattedOnDate: Date {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-M-dd HHmm"
                        // read date value and add year
                        if let date = parseDate(from: coreDataModel.dataArrivalEntries.unwrappedEntOn, with: formatter) {
                            return date
                        } else {
                            return Date()
                        }
                    }
                    self.currentDateChockOn = formattedOnDate
                    self.currentDateChockOnTemp = formattedOnDate
//                    self.currentDateChockOn = dateFormatter.date(from: coreDataModel.dataArrivalEntries.unwrappedEntFuelOnChocks) ?? Date()
//                    self.currentDateChockOnTemp = dateFormatter.date(from: coreDataModel.dataArrivalEntries.unwrappedEntFuelOnChocks) ?? Date()
                }
                
                self.entFuelOnChocks = coreDataModel.dataArrivalEntries.unwrappedEntFuelOnChocks
            }
        }.formSheet(isPresented: $isShowModalLanding) {
            VStack {
                HStack(alignment: .center) {
                    Button(action: {
                        self.isShowModalLanding.toggle()
                    }) {
                        Text("Cancel").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                    }
                    
                    Spacer()
                    
                    Text("Landing").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.black)
                    
                    Spacer()
                    Button(action: {
                        // assign value from modal to entries form
                        self.currentDateLanding = currentDateLandingTemp
                        
                        // Save data
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd/M | HHmm"
                        //dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let str = dateFormatter.string(from: currentDateLandingTemp)
                        
                        if coreDataModel.existDataArrivalEntries {
                            coreDataModel.dataArrivalEntries.entLdg = str
                        } else {
                            let item = ArrivalEntriesList(context: persistenceController.container.viewContext)
                            item.entLdg = dateFormatter.string(from: currentDateLandingTemp)
                        }
                        coreDataModel.save()
                        coreDataModel.readArrivalEntries()
                        
                        self.isShowModalLanding.toggle()
                    }) {
                        Text("Done").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                    }
                }.padding()
                    .background(.white)
                    .roundedCorner(12, corners: [.topLeft, .topRight])
                
                Divider()
                
                VStack {
                    DatePicker("", selection: $currentDateLandingTemp, in: dateClosedRange, displayedComponents: [.date, .hourAndMinute]).labelsHidden().datePickerStyle(WheelDatePickerStyle())
                        .environment(\.locale, Locale(identifier: "en_GB"))
                }
                Spacer()
            }
        }
        .formSheet(isPresented: $isShowModalChockOn) {
            VStack {
                HStack(alignment: .center) {
                    Button(action: {
                        self.isShowModalChockOn.toggle()
                    }) {
                        Text("Cancel").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                    }
                    
                    Spacer()
                    
                    Text("Chocks On").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.black)
                    
                    Spacer()
                    Button(action: {
                        // assign value from modal to entries form
                        self.currentDateChockOn = currentDateChockOnTemp
                        
                        // Save data
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd/M | HHmm"
                        //dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let str = dateFormatter.string(from: currentDateChockOnTemp)
                        
                        if coreDataModel.existDataArrivalEntries {
                            coreDataModel.dataArrivalEntries.entOn = str
                        } else {
                            let item = ArrivalEntriesList(context: persistenceController.container.viewContext)
                            item.entOn = dateFormatter.string(from: currentDateChockOnTemp)
                        }
                        coreDataModel.save()
                        coreDataModel.readDepartureEntries()
                        
                        self.isShowModalChockOn.toggle()
                    }) {
                        Text("Done").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                    }
                }.padding()
                    .background(.white)
                    .roundedCorner(12, corners: [.topLeft, .topRight])
                
                Divider()
                
                VStack {
                    DatePicker("", selection: $currentDateChockOnTemp, in: dateClosedRange, displayedComponents: [.date, .hourAndMinute]).labelsHidden().datePickerStyle(WheelDatePickerStyle())
                        .environment(\.locale, Locale(identifier: "en_GB"))
                }
                Spacer()
            }
        }
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
    
    func onLanding() {
        self.isShowModalLanding.toggle()
    }
    
    func onChockOn() {
        self.isShowModalChockOn.toggle()
    }
}

