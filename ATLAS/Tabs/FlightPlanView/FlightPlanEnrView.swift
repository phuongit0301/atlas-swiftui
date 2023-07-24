//
//  FlightPlanEnrView.swift
//  ATLAS
//
//  Created by Muhammad Adil on 22/6/23.
//

import Foundation
import SwiftUI
import Combine

// creating waypoints table structure
struct waypoints: Identifiable, Equatable {
    let posn: String
    let actm: String
    let ztm: String
    var eta: String
    var ata: String
    var afl: String
    var oat: String
    let adn: String
    var aWind: String
    let tas: String
    let vws: String
    let zfrq: String
    var afrm: String
    let Cord: String
    let Msa: String
    let Dis: String
    var Diff: String
    let Pfl: String
    let Imt: String
    let Pdn: String
    let fWind: String
    let Gsp: String
    let Drm: String
    let Pfrm: String
    var fDiff: String
    let id = UUID()
}

struct FlightPlanEnrView: View {
    // initialise state variables
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController
    
    @State var waypointsTableDefault: [EnrouteList] = []
    @State var waypointsTable: [EnrouteList] = []
    
    @State var eta = ""
    @State var ata = ""
    @State var afl = ""
    @State var oat = ""
    @State var awind = ""
    @State var afrm = ""
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    Text("Enroute")
                        .font(.system(size: 20, weight: .semibold))
                        .padding(.leading, 30)
                }.padding(.bottom, 10)
                
                Text("Plan \(coreDataModel.dataSummaryInfo.unwrappedPlanNo) | Last updated 0820LT")
                    .padding(.leading, 30)
                    .padding(.bottom, 10)
                    .font(.system(size: 15, weight: .semibold))
                //scrollable outer list section
                List {
                    // waypoints section
                    Section(header:Text("WAYPOINTS").font(.system(size: 15, weight: .semibold)).foregroundStyle(Color.black)) {
                        // table
                        HStack {
                            Group {
                                Text("POSN\n\nCOORD")
                                    .font(.system(size: 15, weight: .medium))
                                    .frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)
                                Text("ACTM\n\n")
                                    .font(.system(size: 15, weight: .medium))
                                    .frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)
                                Text("ZTM\n\nMSA")
                                    .font(.system(size: 15, weight: .medium))
                                    .frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)
                                Text("ETA\n\nDIS")
                                    .font(.system(size: 15, weight: .medium))
                                    .frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)
                                Text("ATA\n\nDIFF")
                                    .font(.system(size: 15, weight: .medium))
                                    .frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)
                                Text("AFL\n\nPFL")
                                    .font(.system(size: 15, weight: .medium))
                                    .frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)
                                Text("OAT\n\nIMT")
                                    .font(.system(size: 15, weight: .medium))
                                    .frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)
                                Text("ADN\n\nPDN")
                                    .font(.system(size: 15, weight: .medium))
                                    .frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)
                                Text("AWIND\n\nFWIND")
                                    .font(.system(size: 15, weight: .medium))
                                    .frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)
                                Text("TAS\n\nGSP")
                                    .font(.system(size: 15, weight: .medium))
                                    .frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)
                            }
                            .foregroundStyle(Color.blue)
                            Group {
                                Text("VWS\nDRM").frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)
                                Text("ZFRQ\nPFRM").frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)
                                Text("AFRM\nDIFF").frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)
                            }
                            .foregroundStyle(Color.blue)
                        }.listRowSeparator(.visible)
                        
                        ForEach(waypointsTable.indices, id: \.self) { index in
                            let row = waypointsTable[index]
                            VStack {
                                HStack {
                                    Group {
                                        Text(row.unwrappedPosn)
                                            .frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)
                                        Text(row.unwrappedActm).frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)
                                        Text(row.unwrappedZtm).frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)
                                        // entry here
//                                        TextField(
//                                            "\(row.unwrappedEta)",
//                                            text: $eta
//                                        ).onSubmit {
//                                            updateValues1(editedIndex: index)
//                                        }
                                        EnrouteCustomField(waypointsTableDefault: waypointsTableDefault, waypointsTable: $waypointsTable, name: "eta", field: row.unwrappedEta, index: index)
                                            .id(UUID())
                                        .textInputAutocapitalization(.never)
                                        .disableAutocorrection(true)
                                        .border(.secondary) // todo todo change design
                                        .frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)
                                        // entry here
                                        
//                                        TextField(
//                                            "\(row.unwrappedAta)",
//                                            text: $ata
//                                        )
//                                        .onSubmit {
//                                            updateValues(editedIndex: index)
//                                        }
                                        EnrouteCustomField(waypointsTableDefault: waypointsTableDefault, waypointsTable: $waypointsTable, name: "ata", field: row.unwrappedAta, index: index)
                                            .id(UUID())
                                        .textInputAutocapitalization(.never)
                                        .disableAutocorrection(true)
                                        .border(.secondary) // todo todo change design
                                        .frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)
                                        // entry here
//                                        TextField(
//                                            row.unwrappedAfl,
//                                            text: $afl
//                                        )
//                                        .onSubmit {
//                                            updateValues(editedIndex: index)
//                                        }
                                        EnrouteCustomField(waypointsTableDefault: waypointsTableDefault, waypointsTable: $waypointsTable, name: "afl", field: row.unwrappedAfl, index: index)
                                            .id(UUID())
                                        .textInputAutocapitalization(.never)
                                        .disableAutocorrection(true)
                                        .border(.secondary) // todo todo change design
                                        .frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)
//
                                        // entry here
//                                        TextField(
//                                            row.unwrappedOat,
//                                            text: $oat
//                                        )
//                                        .onSubmit {
//                                            updateValues(editedIndex: index)
//                                        }
                                        EnrouteCustomField(waypointsTableDefault: waypointsTableDefault, waypointsTable: $waypointsTable, name: "oat", field: row.unwrappedOat, index: index)
                                            .id(UUID())
                                        .textInputAutocapitalization(.never)
                                        .disableAutocorrection(true)
                                        .border(.secondary) // todo todo change design
                                        .frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)
//
                                        Text(row.unwrappedAdn).frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)
                                        // entry here
//                                        TextField(
//                                            row.unwrappedAwind,
//                                            text: $awind
//                                        )
//                                        .onSubmit {
//                                            updateValues(editedIndex: index)
//                                        }
                                        EnrouteCustomField(waypointsTableDefault: waypointsTableDefault, waypointsTable: $waypointsTable, name: "awind", field: row.unwrappedAwind, index: index)
                                            .id(UUID())
                                        .textInputAutocapitalization(.never)
                                        .disableAutocorrection(true)
                                        .border(.secondary) // todo todo change design
                                        .frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)

                                        Text(row.unwrappedTas).frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)
                                    }.font(.system(size: 15, weight: .regular))
                                    Group {
                                        Text(row.unwrappedVws)
                                            .foregroundColor(textColorVws(for: row.unwrappedVws)).frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)

                                        Text(row.unwrappedZfrq).frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)
                                        // entry here
//                                        TextField(
//                                            row.unwrappedAfrm,
//                                            text: $afrm
//                                        )
//                                        .onSubmit {
//                                            updateValues(editedIndex: index)
//                                        }
                                        EnrouteCustomField(waypointsTableDefault: waypointsTableDefault, waypointsTable: $waypointsTable, name: "afrm", field: row.unwrappedAfrm, index: index)
                                            .id(UUID())
                                        .textInputAutocapitalization(.never)
                                        .disableAutocorrection(true)
                                        .border(.secondary) // todo todo change design
                                        .frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)
                                    }.font(.system(size: 15, weight: .regular))
                                }
                                HStack {
                                    Group {
                                        Text("\(row.unwrappedCord) \(row.unwrappedMsa)").frame(width: calculateWidth(proxy.size.width - 50, 13) * 2, alignment: .leading)
                                        Text("-").foregroundColor(textColorMsa(for: row.unwrappedMsa)).frame(width: calculateWidth(proxy.size.width - 40, 13), alignment: .leading).padding(.leading, 5)
//                                        Text("\(row.unwrappedMsa)").foregroundColor(textColorMsa(for: row.unwrappedMsa)).frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)
                                        Text("\(row.unwrappedDis)").frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)
                                        Text("\(row.unwrappedDiff)").frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)
                                        Text("\(row.unwrappedPfl)").frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)
                                        Text("\(row.unwrappedImt)").frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)
                                        Text("\(row.unwrappedPdn)").frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)
                                        Text("\(row.unwrappedFwind)").frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)
                                        Text("\(row.unwrappedGsp)").frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)
                                    }.font(.system(size: 15, weight: .regular))
                                    Group {
                                        Text("\(row.unwrappedDrm)").frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)
                                        Text("\(row.unwrappedPfrm)").frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)
                                        Text("\(row.unwrappedFdiff)").frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)
                                    }.font(.system(size: 15, weight: .regular))
                                }
                            }
                                .listRowBackground((index  % 2 == 0) ? Color.theme.sonicSilver.opacity(0.12) : Color(.white))
                        }
                        .listRowSeparator(.hidden)
                    }.padding()
                    .frame(width: proxy.size.width - 50)
                    // winds section
                    
                }.keyboardAvoidView()
            }
            .navigationTitle("Enroute")
            .background(Color(.systemGroupedBackground))
            .onAppear {
                self.waypointsTableDefault = setDefaultValues(waypointsTableDefault: coreDataModel.dataFPEnroute)
                self.waypointsTable = waypointsTableDefault
            }
        }
    }
    
    func textColorMsa(for value: String) -> Color {
        if let value1: Int = Int(value) {
            if value1 > 80 {
                    return .red
            } else {
                return .black
            }
        } else {
            if value.contains("*") {
                return .red
            } else {
                return .black
            }
        }
    }
    func textColorVws(for value: String) -> Color {
        if let value1: Int = Int(value) {
            if value1 > 4 {
                    return .red
            } else {
                return .black
            }
        } else {
            return .black
        }
    }
    func formatFuelNumberDouble(_ number: Double) -> String {
        let formattedString = String(format: "%05.1f", number)
        return formattedString
    }
    func setDefaultValues(waypointsTableDefault: [EnrouteList]) -> [EnrouteList] {
        // define the starting waypoint afrm based on user selections in departure page
        var afrmOff: Double {
            if let unit = coreDataModel.dataFuelDataList.unwrappedTaxi["unit"] {
                let unitChecked = unit != "" ? (unit as NSString).integerValue : 0
                let taxiFuel = coreDataModel.dataFuelDataList.unwrappedTaxi["fuel"]
                let taxiFuelChecked = taxiFuel != "" ? (taxiFuel! as NSString).integerValue : 0
                let calculatedTaxi: Double = Double((coreDataModel.dataFuelExtra.selectedTaxi * unitChecked) / 1000) + (Double(taxiFuelChecked) / 1000)
                let afrm = (Double(coreDataModel.dataDepartureEntries.unwrappedEntFuelInTanks)! / 1000) - calculatedTaxi
                return afrm
            }
            
            return 0
        }
        let formattedAfrmOff: String = formatFuelNumberDouble(afrmOff)
        
        // define the T_O_C index
        var tocIndex: Int {
            for (index, row) in waypointsTableDefault.enumerated() {
                if row.unwrappedPosn == "T_O_C" {
                    return index
                }
            }
            return 0
        }
        
        // set default values
        for (index, row) in waypointsTableDefault.enumerated() {
            // eta, ata, afrm first row
            if index == 0 {
                // extract last 4 characters from date time string for eta and ata
                row.eta = String(coreDataModel.dataDepartureEntries.unwrappedEntTakeoff.suffix(4))
                coreDataModel.dataFPEnroute[index].eta = String(coreDataModel.dataDepartureEntries.unwrappedEntTakeoff.suffix(4))
                row.ata = String(coreDataModel.dataDepartureEntries.unwrappedEntTakeoff.suffix(4))
                coreDataModel.dataFPEnroute[index].eta = String(coreDataModel.dataDepartureEntries.unwrappedEntTakeoff.suffix(4))
                row.afrm = formattedAfrmOff
                coreDataModel.dataFPEnroute[index].afrm = formattedAfrmOff
            }
            // afl, oat, awind rows less than toc
            if index < tocIndex {
                row.afl = "CLB"
                coreDataModel.dataFPEnroute[index].afl = "CLB"
                row.awind = "N.A"
                coreDataModel.dataFPEnroute[index].awind = "N.A"
                row.oat = "N.A"
                coreDataModel.dataFPEnroute[index].oat = "N.A"
            }
            
            //other rows
            if index > 0 {
                // eta
                let dateFormatterTime = DateFormatter()
                dateFormatterTime.dateFormat = "HHmm"
                let etaDefaultValue = dateFormatterTime.date(from: row.unwrappedEta)!
                if dateFormatterTime.date(from: row.eta!) != nil {
                    // Update the value based on the previous row's value in column
                    if dateFormatterTime.date(from: waypointsTableDefault[index-1].unwrappedEta) != nil {
                        let etaPreviousRowValue = dateFormatterTime.date(from: waypointsTableDefault[index-1].unwrappedEta)!
                        let ztmString = row.ztm
                        let components = ztmString!.components(separatedBy: ":")
                        let ztm = (Int(components[0])! * 3600) + (Int(components[1])! * 60)
                        let NewValue = etaPreviousRowValue.addingTimeInterval(TimeInterval(ztm))
                        row.eta = dateFormatterTime.string(from: NewValue)
                    }
                }
                else {
                    // Set the default value if it exists and currentValue is nil
                    row.eta = dateFormatterTime.string(from: etaDefaultValue)
                }
                
                //ata
                let ataDefaultValue = dateFormatterTime.date(from: row.unwrappedAta)!
                if dateFormatterTime.date(from: row.unwrappedAta) != nil {
                    // Update the value based on the previous row's value in column
                    var ataPreviousRowValue: Date
                    
                    if waypointsTableDefault[index-1].unwrappedAta != "" {
                        ataPreviousRowValue = dateFormatterTime.date(from: waypointsTableDefault[index-1].unwrappedAta)!
                        let ztmString = row.unwrappedZtm
                        let components = ztmString.components(separatedBy: ":")
                        let ztm = (Int(components[0])! * 3600) + (Int(components[1])! * 60)
                        let NewValue = ataPreviousRowValue.addingTimeInterval(TimeInterval(ztm))
                        row.ata = dateFormatterTime.string(from: NewValue)
                    } else {
                        row.ata = dateFormatterTime.string(from: ataDefaultValue)
                    }
                }
                else {
                    // Set the default value if it exists and currentValue is nil
                    row.ata = dateFormatterTime.string(from: ataDefaultValue)
                }
                
                //afrm
                let afrmDefaultValue = Double(row.unwrappedAfrm)
                if Double(row.unwrappedAfrm) != nil {
                    // Update the value based on the previous row's value in column
                    let afrmPreviousRowValue = Double(waypointsTableDefault[index-1].unwrappedAfrm)
                    let zfrq = Double(row.unwrappedZfrq) ?? 0
                    var NewValue = zfrq
                    
                    if afrmPreviousRowValue != nil {
                        NewValue = afrmPreviousRowValue! - zfrq
                    }
                    row.afrm = formatFuelNumberDouble(NewValue)
                }
                else {
                    // Set the default value if it exists and currentValue is nil
                    row.afrm = formatFuelNumberDouble(afrmDefaultValue ?? 0)
                }
                
                //diff
                let diffDefaultValue = row.unwrappedDiff
                if dateFormatterTime.date(from: row.unwrappedEta) != nil &&  dateFormatterTime.date(from: row.unwrappedEta) != nil {
                    var eta = 0
                    if row.unwrappedEta != "" {
                        let etaMins = row.unwrappedEta.suffix(2)
                        let etaHrs = row.unwrappedEta.prefix(2)
                        eta = Int(etaHrs)! * 60 + Int(etaMins)!
                    }
                    // Update the value based on the eta and ata
                    let ataMins = row.unwrappedAta.suffix(2)
                    let ataHrs = row.unwrappedAta.prefix(2)
                    var ata = ataMins != "" ? Int(ataMins)! : 0
                    
                    if ataHrs != "" {
                        ata = Int(ataHrs)! * 60 + ata
                    }
                    
                    var NewValue = ata - eta
                    if NewValue < 0 {
                        NewValue = NewValue * -1
                        let NewValueString = formatTime(NewValue)
                        row.diff = "-"+NewValueString
                    } else {
                        let NewValueString = formatTime(NewValue)
                        row.diff = "+"+NewValueString
                    }
                }
                else {
                    // Set the default value if it exists and currentValue is nil
                    row.diff = diffDefaultValue
                }
                
                //fDiff
                let afrm = Double(row.unwrappedAfrm) ?? 0
                let pfrm = Double(row.unwrappedPfrm) ?? 0
                var NewValue = afrm - pfrm
                if NewValue < 0 {
                    NewValue = NewValue * -1
                    row.fdiff = "-"+formatFuelNumberDouble(NewValue)
                    coreDataModel.dataFPEnroute[index].fdiff = "-"+formatFuelNumberDouble(NewValue)
                } else {
                    row.fdiff = "+"+formatFuelNumberDouble(NewValue)
                    coreDataModel.dataFPEnroute[index].fdiff = "+"+formatFuelNumberDouble(NewValue)
                }
            }
        }
        return waypointsTableDefault
    }
    
    func formatTime(_ minutes: Int) -> String {
        let hours = minutes / 60
        let mins = minutes % 60
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        let date = Calendar.current.date(bySettingHour: hours, minute: mins, second: 0, of: Date()) ?? Date()
        
        return formatter.string(from: date)
    }
}

struct EnrouteCustomField: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController
    
    let waypointsTableDefault: [EnrouteList]
    @Binding var waypointsTable: [EnrouteList]
        
    var name: String
    @State var field: String
    var index: Int
    
    var body: some View {
        TextField("\(name)", text: $field).onSubmit {
            switch name {
                case "eta":
                    // take only last 4 characters of string dd/M | HHmm
                    waypointsTable[index].eta = String(field.suffix(4))
                case "ata":
                    // take only last 4 characters of string dd/M | HHmm
                    waypointsTable[index].ata = String(field.suffix(4))
                    if index == 0 {
                        // date time format
                        let dateFormatterTime = DateFormatter()
                        dateFormatterTime.dateFormat = "dd/M | HHmm"
                        // get takeoff date
                        let takeoffDate = String(coreDataModel.dataDepartureEntries.unwrappedEntTakeoff.prefix(4))
                        // convert field into date time format
                        let newTime = "\(takeoffDate) | \(field)"
                        // update off time in dep page
                        coreDataModel.dataDepartureEntries.entTakeoff = newTime
                        coreDataModel.save()
                        coreDataModel.dataFPEnroute = coreDataModel.readEnrouteList()
                    }
                case "afl":
                    waypointsTable[index].afl = field
                case "oat":
                    waypointsTable[index].oat = field
                case "awind":
                    waypointsTable[index].awind = field
                case "afrm":
                    waypointsTable[index].afrm = field
                default:
                    break
            }
            // update the rest of the rows in waypointsTable
            updateValues(editedIndex: index)
        }
    }
        
    private func updateValues(editedIndex: Int) {
        let dateFormatterTime = DateFormatter()
        dateFormatterTime.dateFormat = "HHmm"
        
        // define the T_O_C index
        var tocIndex: Int {
            for (index, row) in waypointsTableDefault.enumerated() {
                if row.unwrappedPosn == "T_O_C" {
                    return index
                }
            }
            return 0
        }
        
        let startIndex = editedIndex + 1
        for index in startIndex..<waypointsTable.count {
            //eta
            let etaDefaultValue = dateFormatterTime.date(from: waypointsTableDefault[index].unwrappedEta)!
            if dateFormatterTime.date(from: waypointsTable[index].eta!) != nil {
                // Update the value based on the previous row's value in column
                if dateFormatterTime.date(from: waypointsTable[index-1].unwrappedEta) != nil {
                    let etaPreviousRowValue = dateFormatterTime.date(from: waypointsTable[index-1].unwrappedEta)!
                    let ztmString = waypointsTable[index].ztm
                    let components = ztmString!.components(separatedBy: ":")
                    let ztm = (Int(components[0])! * 3600) + (Int(components[1])! * 60)
                    let NewValue = etaPreviousRowValue.addingTimeInterval(TimeInterval(ztm))
                    waypointsTable[index].eta = dateFormatterTime.string(from: NewValue)
                }
            }
            else {
                // Set the default value if it exists and currentValue is nil
                waypointsTable[index].eta = dateFormatterTime.string(from: etaDefaultValue)
            }
            
            //ata
            let ataDefaultValue = dateFormatterTime.date(from: waypointsTableDefault[index].unwrappedAta)!
            if dateFormatterTime.date(from: waypointsTable[index].unwrappedAta) != nil {
                // Update the value based on the previous row's value in column
                var ataPreviousRowValue: Date
                
                if waypointsTable[index-1].unwrappedAta != "" {
                    ataPreviousRowValue = dateFormatterTime.date(from: waypointsTable[index-1].unwrappedAta)!
                    let ztmString = waypointsTable[index].unwrappedZtm
                    let components = ztmString.components(separatedBy: ":")
                    let ztm = (Int(components[0])! * 3600) + (Int(components[1])! * 60)
                    let NewValue = ataPreviousRowValue.addingTimeInterval(TimeInterval(ztm))
                    waypointsTable[index].ata = dateFormatterTime.string(from: NewValue)
                } else {
                    waypointsTable[index].ata = dateFormatterTime.string(from: ataDefaultValue)
                }
            }
            else {
                // Set the default value if it exists and currentValue is nil
                waypointsTable[index].ata = dateFormatterTime.string(from: ataDefaultValue)
            }
            
            //afl
            let aflDefaultValue = waypointsTableDefault[index].unwrappedAfl
            if index <= tocIndex {
                // Set the default value if waypoint is before TOC
                waypointsTable[index].afl = aflDefaultValue
            }
            else {
                // Update the value based on the previous row's value in column
                let aflPreviousRowValue = waypointsTable[index-1].unwrappedAfl
                let NewValue = aflPreviousRowValue
                waypointsTable[index].afl = NewValue
            }
            
            //oat
            let oatDefaultValue = waypointsTableDefault[index].unwrappedOat
            if index <= tocIndex {
                // Set the default value if waypoint is before TOC
                waypointsTable[index].oat = oatDefaultValue
            }
            else {
                // Update the value based on the previous row's value in column
                let oatPreviousRowValue = waypointsTable[index-1].unwrappedOat
                let NewValue = oatPreviousRowValue
                waypointsTable[index].oat = NewValue
            }
            
            //awind
            let aWindDefaultValue = waypointsTableDefault[index].unwrappedAwind
            if index <= tocIndex {
                // Set the default value if waypoint is before TOC
                waypointsTable[index].awind = aWindDefaultValue
            }
            else {
                // Update the value based on the previous row's value in column
                let aWindPreviousRowValue = waypointsTable[index-1].unwrappedAwind
                let NewValue = aWindPreviousRowValue
                waypointsTable[index].awind = NewValue
            }
            
            //afrm
            let afrmDefaultValue = Double(waypointsTableDefault[index].unwrappedAfrm)
            if Double(waypointsTable[index].unwrappedAfrm) != nil {
                // Update the value based on the previous row's value in column
                let afrmPreviousRowValue = Double(waypointsTable[index-1].unwrappedAfrm)
                let zfrq = Double(waypointsTable[index].unwrappedZfrq) ?? 0
                var NewValue = zfrq
                
                if afrmPreviousRowValue != nil {
                    NewValue = afrmPreviousRowValue! - zfrq
                }
                waypointsTable[index].afrm = formatFuelNumberDouble(NewValue)
            }
            else {
                // Set the default value if it exists and currentValue is nil
                waypointsTable[index].afrm = formatFuelNumberDouble(afrmDefaultValue ?? 0)
            }
        }
        
        for index in editedIndex..<waypointsTable.count {
            //diff
            let diffDefaultValue = waypointsTableDefault[index].unwrappedDiff
            if dateFormatterTime.date(from: waypointsTable[index].unwrappedEta) != nil &&  dateFormatterTime.date(from: waypointsTable[index].unwrappedEta) != nil {
                var eta = 0
                if waypointsTable[index].unwrappedEta != "" {
                    let etaMins = waypointsTable[index].unwrappedEta.suffix(2)
                    let etaHrs = waypointsTable[index].unwrappedEta.prefix(2)
                    eta = Int(etaHrs)! * 60 + Int(etaMins)!
                }
                // Update the value based on the eta and ata
                let ataMins = waypointsTable[index].unwrappedAta.suffix(2)
                let ataHrs = waypointsTable[index].unwrappedAta.prefix(2)
                var ata = ataMins != "" ? Int(ataMins)! : 0
                
                if ataHrs != "" {
                    ata = Int(ataHrs)! * 60 + ata
                }
                
                var NewValue = ata - eta
                if NewValue < 0 {
                    NewValue = NewValue * -1
                    let NewValueString = formatTime(NewValue)
                    waypointsTable[index].diff = "-"+NewValueString
                } else {
                    let NewValueString = formatTime(NewValue)
                    waypointsTable[index].diff = "+"+NewValueString
                }
            }
            else {
                // Set the default value if it exists and currentValue is nil
                waypointsTable[index].diff = diffDefaultValue
            }
            
            // adn
            let oatDefaultValue = waypointsTableDefault[index].unwrappedOat
            let aflDefaultValue = waypointsTableDefault[index].unwrappedAfl
            if index < tocIndex {
                // Set the default value if waypoint is before TOC
                waypointsTable[index].adn = "N.A"
            } else { // set value for the rest
                // get ISA = 15 + -2deg per 1000ft
                if aflDefaultValue != "" {
                    let aflFormatted = Int(aflDefaultValue)! * 100
                    let isa = 15 + (aflFormatted / 1000) * -2
                    // get adn = oat - ISA
                    let adn = Int(oatDefaultValue)! - isa
                    // update value
                    if adn < 0 {
                        waypointsTable[index].adn = "\(adn)"
                    } else {
                        waypointsTable[index].adn = "+\(adn)"
                    }
                } else {
                    waypointsTable[index].adn = "N.A"
                }
            }
            
            //fDiff
            let fDiffDefaultValue = Double(waypointsTableDefault[index].unwrappedFdiff)
            if Double(waypointsTable[index].unwrappedFdiff) != nil {
                let afrm = Double(waypointsTable[index].unwrappedAfrm) ?? 0
                let pfrm = Double(waypointsTable[index].unwrappedPfrm) ?? 0
                var NewValue = afrm - pfrm
                if NewValue < 0 {
                    NewValue = NewValue * -1
                    waypointsTable[index].fdiff = "-"+formatFuelNumberDouble(NewValue)
                } else {
                    waypointsTable[index].fdiff = "+"+formatFuelNumberDouble(NewValue)
                }
            }
            else {
                // Set the default value if it exists and currentValue is nil
                waypointsTable[index].fdiff = formatFuelNumberDouble(fDiffDefaultValue ?? 0)
            }
        }
        
        for index in editedIndex..<waypointsTable.count {
            //fDiff
            let fDiffDefaultValue = Double(waypointsTableDefault[index].unwrappedFdiff)
            if Double(waypointsTable[index].unwrappedFdiff) != nil {
                let afrm = Double(waypointsTable[index].unwrappedAfrm) ?? 0
                let pfrm = Double(waypointsTable[index].unwrappedPfrm) ?? 0
                var NewValue = afrm - pfrm
                if NewValue < 0 {
                    NewValue = NewValue * -1
                    waypointsTable[index].fdiff = "-"+formatFuelNumberDouble(NewValue)
                } else {
                    waypointsTable[index].fdiff = "+"+formatFuelNumberDouble(NewValue)
                }
            }
            else {
                // Set the default value if it exists and currentValue is nil
                waypointsTable[index].fdiff = formatFuelNumberDouble(fDiffDefaultValue ?? 0)
            }
        }
        // sync up with coreData, save and reload
        coreDataModel.dataFPEnroute = waypointsTable
        coreDataModel.save()
        coreDataModel.dataFPEnroute = coreDataModel.readEnrouteList()
    }
    
    func formatFuelNumberDouble(_ number: Double) -> String {
        let formattedString = String(format: "%05.1f", number)
        return formattedString
    }
    func formatTime(_ minutes: Int) -> String {
        let hours = minutes / 60
        let mins = minutes % 60
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        let date = Calendar.current.date(bySettingHour: hours, minute: mins, second: 0, of: Date()) ?? Date()
        
        return formatter.string(from: date)
    }
}
       

struct FlightPlanEnrView_Previews: PreviewProvider {
    static var previews: some View {
        FlightPlanEnrView()
    }
}
