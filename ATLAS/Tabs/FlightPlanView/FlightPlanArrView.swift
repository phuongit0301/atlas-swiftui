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

    @State private var autofillOptions: [String] = ["APPLE", "BANANA", "CHERRY", "BLUEBERRY"] // Replace with your own autofill options
    @State private var autofillText = ""
    
    var body: some View {
        
        VStack(alignment: .leading) {
            // fixed header section, todo clean up design
            HStack(alignment: .center) {
                Text("Arrival")
                    .font(.title)
                    .padding(.leading, 30)
            }
            .padding(.bottom, 10)
            Text("Plan \(coreDataModel.dataSummaryInfo.unwrappedPlanNo)) | Last updated 0820LT")
            .padding(.leading, 30)
            .padding(.bottom, 10)
            //scrollable outer list section
            List {
                // ATIS section
                Section(header:
                    HStack {
                        Text("ATIS").foregroundStyle(Color.black)
                        TextField(" \(coreDataModel.dataSummaryInfo.unwrappedDest)", text: $dest, onEditingChanged: { editing in
                            isEditingDest = editing
                        })
                        .focused($isTextFieldDestFocused)
                    }) {
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
                                TextField("Code", text: $code, onEditingChanged: { editing in
                                    isEditingCode = editing
                                })
                                .onChange(of: code) { newValue in
                                    // Limit the text to a maximum of 1 characters
                                    if newValue.count > 0 {
                                        code = String(newValue.prefix(1))
                                        
                                        if coreDataModel.existDataArrivalAtis {
                                            coreDataModel.dataArrivalAtis.code = code
                                        } else {
                                            let item = ArrivalATISList(context: persistenceController.container.viewContext)
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
                                        
                                        if coreDataModel.existDataArrivalAtis {
                                            coreDataModel.dataArrivalAtis.time = time
                                        } else {
                                            let item = ArrivalATISList(context: persistenceController.container.viewContext)
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
                                        
                                        if coreDataModel.existDataArrivalAtis {
                                            coreDataModel.dataArrivalAtis.rwy = rwy
                                        } else {
                                            let item = ArrivalATISList(context: persistenceController.container.viewContext)
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
                                        
                                        if coreDataModel.existDataArrivalAtis {
                                            coreDataModel.dataArrivalAtis.transLvl = transLvl
                                        } else {
                                            let item = ArrivalATISList(context: persistenceController.container.viewContext)
                                            item.transLvl = transLvl
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
                                        
                                        if coreDataModel.existDataArrivalAtis {
                                            coreDataModel.dataArrivalAtis.wind = wind
                                        } else {
                                            let item = ArrivalATISList(context: persistenceController.container.viewContext)
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
                                        
                                        if coreDataModel.existDataArrivalAtis {
                                            coreDataModel.dataArrivalAtis.vis = vis
                                        } else {
                                            let item = ArrivalATISList(context: persistenceController.container.viewContext)
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
                                        if coreDataModel.existDataArrivalAtis {
                                            coreDataModel.dataArrivalAtis.wx = text
                                        } else {
                                            let item = ArrivalATISList(context: persistenceController.container.viewContext)
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
                                        if coreDataModel.existDataArrivalAtis {
                                            coreDataModel.dataArrivalAtis.cloud = text
                                        } else {
                                            let item = ArrivalATISList(context: persistenceController.container.viewContext)
                                            item.cloud = text
                                        }

                                        coreDataModel.save()
                                        
                                        isShowingAutofillOptionsCloud = false
                                    }
                                } // todo hide autofilloptions when submit or when focus on another textfield
                            }
                            Group {
                                TextField("Temp", text: $temp, onEditingChanged: { editing in
                                        isEditingTemp = editing
                                    })
                                .onChange(of: temp) { newValue in
                                    if newValue.count > 1 {
                                        temp = String(newValue.prefix(2))
                                        
                                        if coreDataModel.existDataArrivalAtis {
                                            coreDataModel.dataArrivalAtis.temp = temp
                                        } else {
                                            let item = ArrivalATISList(context: persistenceController.container.viewContext)
                                            item.temp = temp
                                        }

                                        coreDataModel.save()
                                        
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
                                        
                                        if coreDataModel.existDataArrivalAtis {
                                            coreDataModel.dataArrivalAtis.dp = dp
                                        } else {
                                            let item = ArrivalATISList(context: persistenceController.container.viewContext)
                                            item.dp = dp
                                        }

                                        coreDataModel.save()
                                        
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
                                        
                                        if coreDataModel.existDataArrivalAtis {
                                            coreDataModel.dataArrivalAtis.qnh = qnh
                                        } else {
                                            let item = ArrivalATISList(context: persistenceController.container.viewContext)
                                            item.qnh = qnh
                                        }

                                        coreDataModel.save()
                                        
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
                                        if coreDataModel.existDataArrivalAtis {
                                            coreDataModel.dataArrivalAtis.remarks = text ?? ""
                                        } else {
                                            let item = ArrivalATISList(context: persistenceController.container.viewContext)
                                            item.remarks = text
                                        }

                                        coreDataModel.save()
                                        
                                        isShowingAutofillOptionsRemarks = false
                                    }
                                } // todo hide autofilloptions when submit or when focus on another textfield
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
                                TextField(" \(coreDataModel.dataSummaryInfo.unwrappedDest)", text: $atcDest, onEditingChanged: { editing in
                                    isEditingAtcDest = editing
                                })
                                .onChange(of: atcDest) { newValue in
                                    if newValue.count > 2 {
                                        atcDest = String(newValue.prefix(3))
                                        
                                        if coreDataModel.existDataArrivalAtc {
                                            coreDataModel.dataArrivalAtc.atcDest = atcDest
                                        } else {
                                            let item = ArrivalATCList(context: persistenceController.container.viewContext)
                                            item.atcDest = atcDest
                                        }

                                        coreDataModel.save()
                                        
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
                                        
                                        if coreDataModel.existDataArrivalAtc {
                                            coreDataModel.dataArrivalAtc.atcRwy = atcRwy
                                        } else {
                                            let item = ArrivalATCList(context: persistenceController.container.viewContext)
                                            item.atcRwy = atcRwy
                                        }

                                        coreDataModel.save()
                                        
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
                                .onChange(of: atcArr) { newValue in
                                    if coreDataModel.existDataArrivalAtc {
                                        coreDataModel.dataArrivalAtc.atcArr = newValue
                                    } else {
                                        let item = ArrivalATCList(context: persistenceController.container.viewContext)
                                        item.atcArr = newValue
                                    }
                                    
                                    coreDataModel.save()
                                }
                                
                                TextField("Trans Lvl", text: $atcTransLvl, onEditingChanged: { editing in
                                        isEditingAtcTransLvl = editing
                                    })
                                .onChange(of: atcTransLvl) { newValue in
                                    if newValue.count > 3 {
                                        atcTransLvl = String(newValue.prefix(4))
                                        
                                        if coreDataModel.existDataArrivalAtc {
                                            coreDataModel.dataArrivalAtc.atcTransLvl = atcTransLvl
                                        } else {
                                            let item = ArrivalATCList(context: persistenceController.container.viewContext)
                                            item.atcTransLvl = atcTransLvl
                                        }
                                        
                                        coreDataModel.save()
                                        
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
                                        
                                        if coreDataModel.existDataArrivalEntries {
                                            coreDataModel.dataArrivalEntries.entLdg = entLdg
                                        } else {
                                            let item = ArrivalEntriesList(context: persistenceController.container.viewContext)
                                            item.entLdg = entLdg
                                        }
                                        
                                        coreDataModel.save()
                                        
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
                                        
                                        if coreDataModel.existDataArrivalEntries {
                                            coreDataModel.dataArrivalEntries.entOn = entOn
                                        } else {
                                            let item = ArrivalEntriesList(context: persistenceController.container.viewContext)
                                            item.entOn = entOn
                                        }
                                        
                                        coreDataModel.save()
                                        
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
                                        
                                        if coreDataModel.existDataArrivalEntries {
                                            coreDataModel.dataArrivalEntries.entFuelOnChocks = entFuelOnChocks
                                        } else {
                                            let item = ArrivalEntriesList(context: persistenceController.container.viewContext)
                                            item.entFuelOnChocks = entFuelOnChocks
                                        }
                                        
                                        coreDataModel.save()
                                        
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
        }.navigationTitle("Arrival")
        .background(Color(.systemGroupedBackground))
        .onAppear {
            //set data ats
            if coreDataModel.existDataArrivalAtis {
                self.code = coreDataModel.dataArrivalAtis.unwrappedCode
                self.time = coreDataModel.dataArrivalAtis.unwrappedTime
                self.rwy = coreDataModel.dataArrivalAtis.unwrappedRwy
                self.transLvl = coreDataModel.dataArrivalAtis.unwrappedTransLvl
                self.wind = coreDataModel.dataArrivalAtis.unwrappedWind
                self.vis = coreDataModel.dataArrivalAtis.unwrappedVis
                self.wx = coreDataModel.dataArrivalAtis.unwrappedWx
                self.cloud = coreDataModel.dataArrivalAtis.unwrappedCloud
                self.temp = coreDataModel.dataArrivalAtis.unwrappedTemp
                self.dp = coreDataModel.dataArrivalAtis.unwrappedDp
                self.qnh = coreDataModel.dataArrivalAtis.unwrappedQnh
                self.remarks = coreDataModel.dataArrivalAtis.unwrappedRemarks
            }
            
            if coreDataModel.existDataArrivalAtc {
                self.atcDest = coreDataModel.dataArrivalAtc.unwrappedAtcDest
                self.atcRwy = coreDataModel.dataArrivalAtc.unwrappedAtcRwy
                self.atcArr = coreDataModel.dataArrivalAtc.unwrappedAtcArr
                self.atcTransLvl = coreDataModel.dataArrivalAtc.unwrappedAtcTransLvl
            }
            
            if coreDataModel.existDataArrivalEntries {
                self.entLdg = coreDataModel.dataArrivalEntries.unwrappedEntLdg
                self.entFuelOnChocks = coreDataModel.dataArrivalEntries.unwrappedEntFuelOnChocks
                self.entOn = coreDataModel.dataArrivalEntries.unwrappedEntOn
            }
        }
    }
}

