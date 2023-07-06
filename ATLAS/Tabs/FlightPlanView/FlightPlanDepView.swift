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
                        }
                    ) {
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
                                            
                                            if coreDataModel.existDataDepartureAts {
                                                coreDataModel.dataDepartureAts.code = code
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
                                            if coreDataModel.existDataDepartureAts {
                                                coreDataModel.dataDepartureAts.time = time
                                            } else {
                                                let item = DepartureATISList(context: persistenceController.container.viewContext)
                                                item.time = time
                                            }

                                            coreDataModel.save()
                                            
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
                                            if coreDataModel.existDataDepartureAts {
                                                coreDataModel.dataDepartureAts.rwy = rwy
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
                                            if coreDataModel.existDataDepartureAts {
                                                coreDataModel.dataDepartureAts.translvl = transLvl
                                            } else {
                                                let item = DepartureATISList(context: persistenceController.container.viewContext)
                                                item.translvl = transLvl
                                            }

                                            coreDataModel.save()
                                            
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
                                            if coreDataModel.existDataDepartureAts {
                                                coreDataModel.dataDepartureAts.wind = wind
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
                                            if coreDataModel.existDataDepartureAts {
                                                coreDataModel.dataDepartureAts.vis = vis
                                            } else {
                                                let item = DepartureATISList(context: persistenceController.container.viewContext)
                                                item.vis = vis
                                            }

                                            coreDataModel.save()
                                            
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
                                            if coreDataModel.existDataDepartureAts {
                                                coreDataModel.dataDepartureAts.wx = text
                                            } else {
                                                let item = DepartureATISList(context: persistenceController.container.viewContext)
                                                item.wx = text
                                            }

                                            coreDataModel.save()
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
                                            if coreDataModel.existDataDepartureAts {
                                                coreDataModel.dataDepartureAts.cloud = text
                                            } else {
                                                let item = DepartureATISList(context: persistenceController.container.viewContext)
                                                item.cloud = text
                                            }

                                            coreDataModel.save()
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
                                            if coreDataModel.existDataDepartureAts {
                                                coreDataModel.dataDepartureAts.temp = temp
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
                                            if coreDataModel.existDataDepartureAts {
                                                coreDataModel.dataDepartureAts.dp = dp
                                            } else {
                                                let item = DepartureATISList(context: persistenceController.container.viewContext)
                                                item.dp = dp
                                            }

                                            coreDataModel.save()
                                            
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
                                            if coreDataModel.existDataDepartureAts {
                                                coreDataModel.dataDepartureAts.qnh = qnh
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
                    }.onChange(of: coreDataModel.dataDepartureAts) { _ in
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
                                    Text("SQ")
                                        .foregroundStyle(Color.blue)
                                        .frame(width: calculateWidth(proxy.size.width, 6), alignment: .leading)
                                }
                            }.padding(.top, 5)
                                .padding(.bottom, 5)

                            Divider()

                            HStack(alignment: .center) {
                                Text("\(flightInfoData.dest)").frame(width: calculateWidth(proxy.size.width, 6), alignment: .leading)
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
                                }
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
                                        .onReceive(Just(isEditingAtcRte)) { focused in
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
                                }
                                TextField("SQ", text: $atcSQ)
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

                        }.padding(.horizontal, 25)
                        .frame(maxWidth: proxy.size.width - 50)

                    }.onChange(of: coreDataModel.dataDepartureAtc) { _ in
                        coreDataModel.readDepartureAtc()
                    }
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
                                }
                            }
                            .padding(.top, 5)
                            .padding(.bottom, 5)

                            Divider()

                            HStack(alignment: .center) {
                                Group {
                                    TextField("Chocks Off", text: $entOff)
                                        .focused($isTextFieldEntOffFocused)
                                        .onReceive(Just(isTextFieldEntOffFocused)) { focused in
                                            if focused {
                                                isTextFieldEntOffFocused = false
                                                setFocusToFalse()
                                                isEditingEntOff = true
                                            }
                                        }
                                        .overlay(isEditingEntOff ? Rectangle().stroke(Color.red, lineWidth:1) : nil)
                                        .onChange(of: entOff) { newValue in
                                            if newValue.count > 3 {
                                                entOff = String(newValue.prefix(4))
                                                cursorPositionEntOff = 4
                                                if coreDataModel.existDataDepartureEntries {
                                                    coreDataModel.dataDepartureEntries.entOff = entOff
                                                } else {
                                                    let item = DepartureEntriesList(context: persistenceController.container.viewContext)
                                                    item.entOff = entOff
                                                    coreDataModel.existDataDepartureEntries = true
                                                }

                                                coreDataModel.save()

                                                isEditingEntOff = false
                                                isTextFieldEntFuelInTanksFocused = true
                                            }
                                        }
                                        .frame(width: calculateWidth(proxy.size.width, 4))

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
                                            if newValue.count > 4 {
                                                entFuelInTanks = String(newValue.prefix(5))
                                                cursorPositionEntFuelInTanks = 5
                                                if coreDataModel.existDataDepartureEntries {
                                                    coreDataModel.dataDepartureEntries.entFuelInTanks = entFuelInTanks
                                                } else {
                                                    let item = DepartureEntriesList(context: persistenceController.container.viewContext)
                                                    item.entFuelInTanks = entFuelInTanks
                                                    coreDataModel.existDataDepartureEntries = true
                                                }

                                                coreDataModel.save()

                                                isEditingEntFuelInTanks = false
                                                isTextFieldEntTaxiFocused = true
                                            }
                                        }
                                        .frame(width: calculateWidth(proxy.size.width, 4))
                                }
                                Group {
                                    TextField("Taxi", text: $entTaxi)
                                    .focused($isTextFieldEntTaxiFocused)
                                    .onReceive(Just(isTextFieldEntTaxiFocused)) { focused in
                                        if focused {
                                            isTextFieldEntTaxiFocused = false
                                            setFocusToFalse()
                                            isEditingEntTaxi = true
                                        }
                                    }
                                    .overlay(isEditingEntTaxi ? Rectangle().stroke(Color.red, lineWidth:1) : nil)
                                    .onChange(of: entTaxi) { newValue in
                                        if newValue.count > 3 {
                                            entTaxi = String(newValue.prefix(4))
                                            cursorPositionEntTaxi = 4
                                            if coreDataModel.existDataDepartureEntries {
                                                coreDataModel.dataDepartureEntries.entTaxi = entTaxi
                                            } else {
                                                let item = DepartureEntriesList(context: persistenceController.container.viewContext)
                                                item.entTaxi = entTaxi
                                                coreDataModel.existDataDepartureEntries = true
                                            }

                                            coreDataModel.save()

                                            isEditingEntTaxi = false
                                            isTextFieldEntTakeoffFocused = true
                                        }
                                    }
                                    .frame(width: calculateWidth(proxy.size.width, 4))

                                    TextField( "Takeoff", text: $entTakeoff)
                                    .focused($isTextFieldEntTakeoffFocused)
                                    .onReceive(Just(isTextFieldEntTakeoffFocused)) { focused in
                                        if focused {
                                            isTextFieldEntTakeoffFocused = false
                                            setFocusToFalse()
                                            isEditingEntTakeoff = true
                                        }
                                    }
                                    .overlay(isEditingEntTakeoff ? Rectangle().stroke(Color.red, lineWidth:1) : nil)
                                    .onChange(of: entTakeoff) { newValue in
                                        if newValue.count > 3 {
                                            entTakeoff = String(newValue.prefix(4))
                                            cursorPositionEntTakeoff = 4
                                            if coreDataModel.existDataDepartureEntries {
                                                coreDataModel.dataDepartureEntries.entTakeoff = entTakeoff
                                            } else {
                                                let item = DepartureEntriesList(context: persistenceController.container.viewContext)
                                                item.entTakeoff = entTakeoff
                                                coreDataModel.existDataDepartureEntries = true
                                            }

                                            coreDataModel.save()

                                            isEditingEntTakeoff = false
                                            isTextFieldEntOffFocused = true
                                        }
                                    }
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
                        CustomKeyboardView1(text: $entFuelInTanks, cursorPosition: $cursorPositionEntFuelInTanks, currentFocus: $isEditingEntFuelInTanks, nextFocus: $isEditingEntTaxi, prevFocus: $isEditingEntOff)
                    }
                    if isEditingEntTaxi {
                        CustomKeyboardView1(text: $entTaxi, cursorPosition: $cursorPositionEntTaxi, currentFocus: $isEditingEntTaxi, nextFocus: $isEditingEntTakeoff, prevFocus: $isEditingEntFuelInTanks)
                    }
                    if isEditingEntTakeoff {
                        CustomKeyboardView1(text: $entTakeoff, cursorPosition: $cursorPositionEntTakeoff, currentFocus: $isEditingEntTakeoff, nextFocus: $isEditingEntOff, prevFocus: $isEditingEntTaxi)
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
                //.hideKeyboardWhenTappedAround()
        }.onAppear {
            coreDataModel.readDepartures()
            //set data ats
            if coreDataModel.existDataDepartureAts {
                self.code = coreDataModel.dataDepartureAts.unwrappedCode
                self.cursorPositionCode = coreDataModel.dataDepartureAts.unwrappedCode.count
                self.time = coreDataModel.dataDepartureAts.unwrappedTime
                self.cursorPositionTime = coreDataModel.dataDepartureAts.unwrappedTime.count
                self.rwy = coreDataModel.dataDepartureAts.unwrappedRwy
                self.cursorPositionRwy = coreDataModel.dataDepartureAts.unwrappedRwy.count
                self.transLvl = coreDataModel.dataDepartureAts.unwrappedRranslvl
                self.cursorPositionTransLvl = coreDataModel.dataDepartureAts.unwrappedRranslvl.count
                self.wind = coreDataModel.dataDepartureAts.unwrappedWind
                self.cursorPositionWind = coreDataModel.dataDepartureAts.unwrappedWind.count
                self.vis = coreDataModel.dataDepartureAts.unwrappedVis
                self.cursorPositionVis = coreDataModel.dataDepartureAts.unwrappedVis.count
                self.wx = coreDataModel.dataDepartureAts.unwrappedWx
                self.cursorPositionWx = coreDataModel.dataDepartureAts.unwrappedWx.count
                self.cloud = coreDataModel.dataDepartureAts.unwrappedCloud
                self.cursorPositionCloud = coreDataModel.dataDepartureAts.unwrappedCloud.count
                self.temp = coreDataModel.dataDepartureAts.unwrappedTemp
                self.cursorPositionTemp = coreDataModel.dataDepartureAts.unwrappedTemp.count
                self.dp = coreDataModel.dataDepartureAts.unwrappedDp
                self.cursorPositionDP = coreDataModel.dataDepartureAts.unwrappedDp.count
                self.qnh = coreDataModel.dataDepartureAts.unwrappedQnh
                self.cursorPositionQNH = coreDataModel.dataDepartureAts.unwrappedQnh.count
                self.remarks = coreDataModel.dataDepartureAts.unwrappedRemarks
                self.cursorPositionRemarks = coreDataModel.dataDepartureAts.unwrappedRemarks.count
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
                self.entOff = coreDataModel.dataDepartureEntries.unwrappedEntOff
                self.cursorPositionEntOff = coreDataModel.dataDepartureEntries.unwrappedEntOff.count
                self.entFuelInTanks = coreDataModel.dataDepartureEntries.unwrappedEntFuelInTanks
                self.cursorPositionEntFuelInTanks = coreDataModel.dataDepartureEntries.unwrappedEntFuelInTanks.count
                self.entTaxi = coreDataModel.dataDepartureEntries.unwrappedEntTaxi
                self.cursorPositionEntTaxi = coreDataModel.dataDepartureEntries.unwrappedEntTaxi.count
                self.entTakeoff = coreDataModel.dataDepartureEntries.unwrappedEntTakeoff
                self.cursorPositionEntTakeoff = coreDataModel.dataDepartureEntries.unwrappedEntTakeoff.count
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
}

struct FlightPlanDepView_Previews: PreviewProvider {
    static var previews: some View {
        FlightPlanDepView()
    }
}
