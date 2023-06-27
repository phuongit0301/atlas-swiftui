//
//  FlightPlanEnrView.swift
//  ATLAS
//
//  Created by Muhammad Adil on 22/6/23.
//

import Foundation
import SwiftUI

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

// replace with fetch from coredata
let flightPlanData: [String : Any] = fetchFlightPlanData()
let waypointsTableDefault: [waypoints] = flightPlanData["waypointsData"] as! [waypoints]

struct FlightPlanEnrView: View {
    // initialise state variables
    @State var waypointsTable: [waypoints] = waypointsTableDefault
    
    var body: some View {
        let flightInfoData: InfoData = flightPlanData["infoData"] as! InfoData
        return VStack(alignment: .leading) {
            // fixed header section, todo clean up design
            HStack(alignment: .center) {
                Text("Enroute")
                    .font(.title)
                    .padding(.leading, 30)
            }
            .padding(.bottom, 10)
            Text("Plan \(flightInfoData.planNo) | Last updated 0820LT")
                .padding(.leading, 30)
                .padding(.bottom, 10)
            //scrollable outer list section
            List {
                // waypoints section
                Section(header: Text("WAYPOINTS").foregroundStyle(Color.black)) {
                    // table
                    HStack {
                        Group {
                            Text("POSN\nCOORD")
                            Text("ACTM\n")
                            Text("ZTM\nMSA")
                            Text("ETA\nDIS")
                            Text("ATA\nDIFF")
                            Text("AFL\nPFL")
                            Text("OAT\nIMT")
                            Text("ADN\nPDN")
                            Text("AWIND\nFWIND")
                            Text("TAS\nGSP")
                        }
                        .foregroundStyle(Color.blue)
                        Group {
                            Text("VWS\nDRM")
                            Text("ZFRQ\nPFRM")
                            Text("AFRM\nDIFF")
                        }
                        .foregroundStyle(Color.blue)
                    }
                    .listRowSeparator(.visible)
                    ForEach(waypointsTable.indices, id: \.self) { index in
                        let row = waypointsTable[index]
                        VStack {
                            HStack {
                                Group {
                                    Text("\(row.posn)")
                                    Text("\(row.actm)")
                                    Text("\(row.ztm)")
                                    // entry here
                                    TextField(
                                        "\(row.eta)",
                                        text: $waypointsTable[index].eta
                                    )
                                    .onSubmit {
                                        updateValues(editedIndex: index)
                                    }
                                    .textInputAutocapitalization(.never)
                                    .disableAutocorrection(true)
                                    .border(.secondary) // todo todo change design
                                    // entry here
                                    TextField(
                                        "\(row.ata)",
                                        text: $waypointsTable[index].ata
                                    )
                                    .onSubmit {
                                        updateValues(editedIndex: index)
                                    }
                                    .textInputAutocapitalization(.never)
                                    .disableAutocorrection(true)
                                    .border(.secondary) // todo todo change design
                                    // entry here
                                    TextField(
                                        "\(row.afl)",
                                        text: $waypointsTable[index].afl
                                    )
                                    .onSubmit {
                                        updateValues(editedIndex: index)
                                    }
                                    .textInputAutocapitalization(.never)
                                    .disableAutocorrection(true)
                                    .border(.secondary) // todo todo change design
                                    // entry here
                                    TextField(
                                        "\(row.oat)",
                                        text: $waypointsTable[index].oat
                                    )
                                    .onSubmit {
                                        updateValues(editedIndex: index)
                                    }
                                    .textInputAutocapitalization(.never)
                                    .disableAutocorrection(true)
                                    .border(.secondary) // todo todo change design
                                    Text("\(row.adn)")
                                    // entry here
                                    TextField(
                                        "\(row.aWind)",
                                        text: $waypointsTable[index].aWind
                                    )
                                    .onSubmit {
                                        updateValues(editedIndex: index)
                                    }
                                    .textInputAutocapitalization(.never)
                                    .disableAutocorrection(true)
                                    .border(.secondary) // todo todo change design
                                    Text("\(row.tas)")
                                }
                                Group {
                                    Text("\(row.vws)")
                                    Text("\(row.zfrq)")
                                    // entry here
                                    TextField(
                                        "\(row.afrm)",
                                        text: $waypointsTable[index].afrm
                                    )
                                    .onSubmit {
                                        updateValues(editedIndex: index)
                                    }
                                    .textInputAutocapitalization(.never)
                                    .disableAutocorrection(true)
                                    .border(.secondary) // todo todo change design
                                }
                            }
                            HStack {
                                Group {
                                    Text("\(row.Cord)")
                                    Text("\(row.Msa)")
                                    Text("\(row.Dis)")
                                    Text("\(row.Diff)")
                                    Text("\(row.Pfl)")
                                    Text("\(row.Imt)")
                                    Text("\(row.Pdn)")
                                    Text("\(row.fWind)")
                                    Text("\(row.Gsp)")
                                }
                                Group {
                                    Text("\(row.Drm)")
                                    Text("\(row.Pfrm)")
                                    Text("\(row.fDiff)")
                                }
                            }
                        }
                    }
                    .listRowSeparator(.hidden)
                    // todo every two rows different color, fix spacing for each row
                }
                // winds section
                
            }
        }
        .navigationTitle("Enroute")
        .background(Color(.systemGroupedBackground))
    }
    
    private func updateValues(editedIndex: Int) {       
        let dateFormatterTime = DateFormatter()
        dateFormatterTime.dateFormat = "HHmm"
        
        let startIndex = editedIndex + 1
        for index in startIndex..<waypointsTable.count {
            //eta
            let etaDefaultValue = dateFormatterTime.date(from: waypointsTableDefault[index].eta)!
            if dateFormatterTime.date(from: waypointsTable[index].eta) != nil {
                // Update the value based on the previous row's value in column
                let etaPreviousRowValue = dateFormatterTime.date(from: waypointsTable[index-1].eta)!
                let ztmString = waypointsTable[index].ztm
                let components = ztmString.components(separatedBy: ":")
                let ztm = (Int(components[0])! * 3600) + (Int(components[1])! * 60)
                let NewValue = etaPreviousRowValue.addingTimeInterval(TimeInterval(ztm))
                waypointsTable[index].eta = dateFormatterTime.string(from: NewValue)
            }
            else {
                // Set the default value if it exists and currentValue is nil
                waypointsTable[index].eta = dateFormatterTime.string(from: etaDefaultValue)
            }
            
            //ata
            let ataDefaultValue = dateFormatterTime.date(from: waypointsTableDefault[index].ata)!
            if dateFormatterTime.date(from: waypointsTable[index].ata) != nil {
                // Update the value based on the previous row's value in column
                let ataPreviousRowValue = dateFormatterTime.date(from: waypointsTable[index-1].ata)!
                let ztmString = waypointsTable[index].ztm
                let components = ztmString.components(separatedBy: ":")
                let ztm = (Int(components[0])! * 3600) + (Int(components[1])! * 60)
                let NewValue = ataPreviousRowValue.addingTimeInterval(TimeInterval(ztm))
                waypointsTable[index].ata = dateFormatterTime.string(from: NewValue)
            }
            else {
                // Set the default value if it exists and currentValue is nil
                waypointsTable[index].ata = dateFormatterTime.string(from: ataDefaultValue)
            }

            //afl
            let aflDefaultValue = waypointsTableDefault[index].afl
            if waypointsTable[index].afl != nil {
                // Update the value based on the previous row's value in column
                let aflPreviousRowValue = waypointsTable[index-1].afl
                let NewValue = aflPreviousRowValue
                waypointsTable[index].afl = NewValue
            }
            else {
                // Set the default value if it exists and currentValue is nil
                waypointsTable[index].afl = aflDefaultValue
            }

            //oat
            let oatDefaultValue = waypointsTableDefault[index].oat
            if waypointsTable[index].oat != nil {
                // Update the value based on the previous row's value in column
                let oatPreviousRowValue = waypointsTable[index-1].oat
                let NewValue = oatPreviousRowValue
                waypointsTable[index].oat = NewValue
            }
            else {
                // Set the default value if it exists and currentValue is nil
                waypointsTable[index].oat = oatDefaultValue
            }
            
            //awind
            let aWindDefaultValue = waypointsTableDefault[index].aWind
            if waypointsTable[index].aWind != nil {
                // Update the value based on the previous row's value in column
                let aWindPreviousRowValue = waypointsTable[index-1].aWind
                let NewValue = aWindPreviousRowValue
                waypointsTable[index].aWind = NewValue
            }
            else {
                // Set the default value if it exists and currentValue is nil
                waypointsTable[index].aWind = aWindDefaultValue
            }
            
            //afrm
            let afrmDefaultValue = Double(waypointsTableDefault[index].afrm)
            if Double(waypointsTable[index].afrm) != nil {
                // Update the value based on the previous row's value in column
                let afrmPreviousRowValue = Double(waypointsTable[index-1].afrm)
                let zfrq = Double(waypointsTable[index].zfrq) ?? 0
                let NewValue = afrmPreviousRowValue! - zfrq
                waypointsTable[index].afrm = formatFuelNumberDouble(NewValue)
            }
            else {
                // Set the default value if it exists and currentValue is nil
                waypointsTable[index].afrm = formatFuelNumberDouble(afrmDefaultValue ?? 0)
            }
        }
        
        for index in editedIndex..<waypointsTable.count {
            //diff
            let diffDefaultValue = waypointsTableDefault[index].Diff
            if dateFormatterTime.date(from: waypointsTable[index].eta) != nil &&  dateFormatterTime.date(from: waypointsTable[index].ata) != nil {
                // Update the value based on the eta and ata
                let etaMins = waypointsTable[index].eta.suffix(2)
                let etaHrs = waypointsTable[index].eta.prefix(2)
                let eta = Int(etaHrs)! * 60 + Int(etaMins)!
                let ataMins = waypointsTable[index].ata.suffix(2)
                let ataHrs = waypointsTable[index].ata.prefix(2)
                let ata = Int(ataHrs)! * 60 + Int(ataMins)!
                var NewValue = ata - eta
                if NewValue < 0 {
                    NewValue = NewValue * -1
                    let NewValueString = formatTime(NewValue)
                    waypointsTable[index].Diff = "-"+NewValueString
                } else {
                    let NewValueString = formatTime(NewValue)
                    waypointsTable[index].Diff = NewValueString
                }
            }
            else {
                // Set the default value if it exists and currentValue is nil
                waypointsTable[index].Diff = diffDefaultValue
            }
            
            //fDiff
            let fDiffDefaultValue = Double(waypointsTableDefault[index].fDiff)
            if Double(waypointsTable[index].fDiff) != nil {
                // Update the value based on the previous row's value in column
                let afrm = Double(waypointsTable[index].afrm) ?? 0
                let pfrm = Double(waypointsTable[index].Pfrm) ?? 0
                let NewValue = afrm - pfrm
                waypointsTable[index].fDiff = formatFuelNumberDouble(NewValue)
            }
            else {
                // Set the default value if it exists and currentValue is nil
                waypointsTable[index].fDiff = formatFuelNumberDouble(fDiffDefaultValue ?? 0)
            }
        }
        
        for index in editedIndex..<waypointsTable.count {
            //fDiff
            let fDiffDefaultValue = Double(waypointsTableDefault[index].fDiff)
            if Double(waypointsTable[index].fDiff) != nil {
                // Update the value based on the previous row's value in column
                let afrm = Double(waypointsTable[index].afrm) ?? 0
                let pfrm = Double(waypointsTable[index].Pfrm) ?? 0
                let NewValue = afrm - pfrm
                waypointsTable[index].fDiff = formatFuelNumberDouble(NewValue)
            }
            else {
                // Set the default value if it exists and currentValue is nil
                waypointsTable[index].fDiff = formatFuelNumberDouble(fDiffDefaultValue ?? 0)
            }
        }
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
