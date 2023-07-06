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
//let waypointsTableDefault: [waypoints] = flightPlanData["waypointsData"] as! [waypoints]

struct FlightPlanEnrView: View {
    // initialise state variables
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController
    
//    @State var waypointsTableDefault: [waypoints] = waypointsTableDefault
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
                // fixed header section, todo clean up design
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
                                Text("POSN\nCOORD")
                                    .font(.system(size: 15, weight: .medium))
                                    .frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)
                                Text("ACTM\n")
                                    .font(.system(size: 15, weight: .medium))
                                    .frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)
                                Text("ZTM\nMSA")
                                    .font(.system(size: 15, weight: .medium))
                                    .frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)
                                Text("ETA\nDIS")
                                    .font(.system(size: 15, weight: .medium))
                                    .frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)
                                Text("ATA\nDIFF")
                                    .font(.system(size: 15, weight: .medium))
                                    .frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)
                                Text("AFL\nPFL")
                                    .font(.system(size: 15, weight: .medium))
                                    .frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)
                                Text("OAT\nIMT")
                                    .font(.system(size: 15, weight: .medium))
                                    .frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)
                                Text("ADN\nPDN")
                                    .font(.system(size: 15, weight: .medium))
                                    .frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)
                                Text("AWIND\nFWIND")
                                    .font(.system(size: 15, weight: .medium))
                                    .frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)
                                Text("TAS\nGSP")
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
//                                        )
                                        EnrouteCustomField(waypointsTableDefault: $waypointsTableDefault, waypointsTable: $waypointsTable, field: row.unwrappedEta, index: index)
//                                        .onSubmit {
//                                            updateValues(editedIndex: index)
//                                        }
                                        .textInputAutocapitalization(.never)
                                        .disableAutocorrection(true)
                                        .border(.secondary) // todo todo change design
                                        .frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)
                                        // entry here

                                        TextField(
                                            "\(row.unwrappedAta)",
                                            text: $ata
                                        )
//                                        .onSubmit {
//                                            updateValues(editedIndex: index)
//                                        }
                                        .textInputAutocapitalization(.never)
                                        .disableAutocorrection(true)
                                        .border(.secondary) // todo todo change design
                                        .frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)
                                        // entry here
                                        TextField(
                                            row.unwrappedAfl,
                                            text: $afl
                                        )
//                                        .onSubmit {
//                                            updateValues(editedIndex: index)
//                                        }
                                        .textInputAutocapitalization(.never)
                                        .disableAutocorrection(true)
                                        .border(.secondary) // todo todo change design
                                        .frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)
//
                                        // entry here
                                        TextField(
                                            row.unwrappedOat,
                                            text: $oat
                                        )
//                                        .onSubmit {
//                                            updateValues(editedIndex: index)
//                                        }
                                        .textInputAutocapitalization(.never)
                                        .disableAutocorrection(true)
                                        .border(.secondary) // todo todo change design
                                        .frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)
//
                                        Text(row.unwrappedAdn).frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)
                                        // entry here
                                        TextField(
                                            row.unwrappedAwind,
                                            text: $awind
                                        )
//                                        .onSubmit {
//                                            updateValues(editedIndex: index)
//                                        }
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
                                        TextField(
                                            row.unwrappedAfrm,
                                            text: $afrm
                                        )
//                                        .onSubmit {
//                                            updateValues(editedIndex: index)
//                                        }
                                        .textInputAutocapitalization(.never)
                                        .disableAutocorrection(true)
                                        .border(.secondary) // todo todo change design
                                        .frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)
                                    }.font(.system(size: 15, weight: .regular))
                                }
                                HStack {
                                    Group {
                                        Text("\(row.unwrappedCord)").frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)
                                        Text("-").foregroundColor(textColorMsa(for: row.unwrappedMsa)).frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)
                                        Text("\(row.unwrappedMsa)").foregroundColor(textColorMsa(for: row.unwrappedMsa)).frame(width: calculateWidth(proxy.size.width - 50, 13), alignment: .leading)
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
                    
                }
            }
            .navigationTitle("Enroute")
            .background(Color(.systemGroupedBackground))
            .onAppear {
                self.waypointsTableDefault = coreDataModel.dataFPEnroute
                self.waypointsTable = coreDataModel.dataFPEnroute
                
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
}

struct EnrouteCustomField: View {
    // Read the view model, to store the value of the text field
//    @EnvironmentObject var viewModel: ViewModelSummary
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController
    
    @Binding var waypointsTableDefault: [EnrouteList]
    @Binding var waypointsTable: [EnrouteList]
    
    // Dedicated state var for each field
//    @State var item: PerfWeightList = PerfWeightList()
    @State var field = ""
    @State var index: Int = 0
    
    var body: some View {
        TextField("Enter", text: $field).onSubmit {
            
            updateValues(editedIndex: index)
        }
    }
    
    private func updateValues(editedIndex: Int) {
        let dateFormatterTime = DateFormatter()
        dateFormatterTime.dateFormat = "HHmm"
        
        let startIndex = editedIndex + 1
        for index in startIndex..<coreDataModel.dataFPEnroute.count {
            //            //eta
            let etaDefaultValue = dateFormatterTime.date(from: waypointsTableDefault[index].unwrappedEta)!
            if dateFormatterTime.date(from: coreDataModel.dataFPEnroute[index].unwrappedEta) != nil {
                // Update the value based on the previous row's value in column
                let etaPreviousRowValue = dateFormatterTime.date(from: coreDataModel.dataFPEnroute[index-1].unwrappedEta)!
                let ztmString = coreDataModel.dataFPEnroute[index].unwrappedZtm
                let components = ztmString.components(separatedBy: ":")
                let ztm = (Int(components[0])! * 3600) + (Int(components[1])! * 60)
                let NewValue = etaPreviousRowValue.addingTimeInterval(TimeInterval(ztm))
                coreDataModel.dataFPEnroute[index].eta = dateFormatterTime.string(from: NewValue)
            }
            else {
                // Set the default value if it exists and currentValue is nil
                coreDataModel.dataFPEnroute[index].eta = dateFormatterTime.string(from: etaDefaultValue)
            }
            
            //ata
            let ataDefaultValue = dateFormatterTime.date(from: waypointsTableDefault[index].unwrappedAta)!
            if dateFormatterTime.date(from: coreDataModel.dataFPEnroute[index].unwrappedAta) != nil {
                // Update the value based on the previous row's value in column
                let ataPreviousRowValue = dateFormatterTime.date(from: coreDataModel.dataFPEnroute[index-1].unwrappedAta)!
                let ztmString = coreDataModel.dataFPEnroute[index].unwrappedZtm
                let components = ztmString.components(separatedBy: ":")
                let ztm = (Int(components[0])! * 3600) + (Int(components[1])! * 60)
                let NewValue = ataPreviousRowValue.addingTimeInterval(TimeInterval(ztm))
                coreDataModel.dataFPEnroute[index].ata = dateFormatterTime.string(from: NewValue)
            }
            else {
                // Set the default value if it exists and currentValue is nil
                coreDataModel.dataFPEnroute[index].ata = dateFormatterTime.string(from: ataDefaultValue)
            }
            
            //afl
            let aflDefaultValue = waypointsTableDefault[index].unwrappedAfl
            if coreDataModel.dataFPEnroute[index].unwrappedAfl != "" {
                // Update the value based on the previous row's value in column
                let aflPreviousRowValue = coreDataModel.dataFPEnroute[index-1].unwrappedAfl
                let NewValue = aflPreviousRowValue
                coreDataModel.dataFPEnroute[index].afl = NewValue
            }
            else {
                // Set the default value if it exists and currentValue is nil
                coreDataModel.dataFPEnroute[index].afl = aflDefaultValue
            }
            
            //oat
            let oatDefaultValue = waypointsTableDefault[index].unwrappedOat
            if coreDataModel.dataFPEnroute[index].unwrappedOat != "" {
                // Update the value based on the previous row's value in column
                let oatPreviousRowValue = coreDataModel.dataFPEnroute[index-1].unwrappedOat
                let NewValue = oatPreviousRowValue
                coreDataModel.dataFPEnroute[index].oat = NewValue
            }
            else {
                // Set the default value if it exists and currentValue is nil
                coreDataModel.dataFPEnroute[index].oat = oatDefaultValue
            }
            
            //awind
            let aWindDefaultValue = waypointsTableDefault[index].unwrappedAwind
            if coreDataModel.dataFPEnroute[index].unwrappedAwind != "" {
                // Update the value based on the previous row's value in column
                let aWindPreviousRowValue = coreDataModel.dataFPEnroute[index-1].unwrappedAwind
                let NewValue = aWindPreviousRowValue
                coreDataModel.dataFPEnroute[index].awind = NewValue
            }
            else {
                // Set the default value if it exists and currentValue is nil
                coreDataModel.dataFPEnroute[index].awind = aWindDefaultValue
            }
            
            //afrm
            let afrmDefaultValue = Double(waypointsTableDefault[index].unwrappedAfrm)
            if Double(coreDataModel.dataFPEnroute[index].unwrappedAfrm) != nil {
                // Update the value based on the previous row's value in column
                let afrmPreviousRowValue = Double(coreDataModel.dataFPEnroute[index-1].unwrappedAfrm)
                let zfrq = Double(coreDataModel.dataFPEnroute[index].unwrappedZfrq) ?? 0
                let NewValue = afrmPreviousRowValue! - zfrq
                coreDataModel.dataFPEnroute[index].afrm = formatFuelNumberDouble(NewValue)
            }
            else {
                // Set the default value if it exists and currentValue is nil
                coreDataModel.dataFPEnroute[index].afrm = formatFuelNumberDouble(afrmDefaultValue ?? 0)
            }
            coreDataModel.save()
        }
        
        for index in editedIndex..<coreDataModel.dataFPEnroute.count {
            //diff
            let diffDefaultValue = waypointsTableDefault[index].unwrappedDiff
            if dateFormatterTime.date(from: coreDataModel.dataFPEnroute[index].unwrappedEta) != nil &&  dateFormatterTime.date(from: coreDataModel.dataFPEnroute[index].unwrappedEta) != nil {
                // Update the value based on the eta and ata
                let etaMins = coreDataModel.dataFPEnroute[index].unwrappedEta.suffix(2)
                let etaHrs = coreDataModel.dataFPEnroute[index].unwrappedEta.prefix(2)
                let eta = Int(etaHrs)! * 60 + Int(etaMins)!
                let ataMins = coreDataModel.dataFPEnroute[index].unwrappedAta.suffix(2)
                let ataHrs = coreDataModel.dataFPEnroute[index].unwrappedAta.prefix(2)
                let ata = Int(ataHrs)! * 60 + Int(ataMins)!
                var NewValue = ata - eta
                if NewValue < 0 {
                    NewValue = NewValue * -1
                    let NewValueString = formatTime(NewValue)
                    coreDataModel.dataFPEnroute[index].diff = "-"+NewValueString
                } else {
                    let NewValueString = formatTime(NewValue)
                    coreDataModel.dataFPEnroute[index].diff = "+"+NewValueString
                }
            }
            else {
                // Set the default value if it exists and currentValue is nil
                coreDataModel.dataFPEnroute[index].diff = diffDefaultValue
            }
            
            //fDiff
            let fDiffDefaultValue = Double(waypointsTableDefault[index].unwrappedFdiff)
            if Double(coreDataModel.dataFPEnroute[index].unwrappedFdiff) != nil {
                // Update the value based on the previous row's value in column
                let afrm = Double(coreDataModel.dataFPEnroute[index].unwrappedAfrm) ?? 0
                let pfrm = Double(coreDataModel.dataFPEnroute[index].unwrappedPfrm) ?? 0
                var NewValue = afrm - pfrm
                if NewValue < 0 {
                    NewValue = NewValue * -1
                    coreDataModel.dataFPEnroute[index].fdiff = "-"+formatFuelNumberDouble(NewValue)
                } else {
                    coreDataModel.dataFPEnroute[index].fdiff = "+"+formatFuelNumberDouble(NewValue)
                }
            }
            else {
                // Set the default value if it exists and currentValue is nil
                coreDataModel.dataFPEnroute[index].fdiff = formatFuelNumberDouble(fDiffDefaultValue ?? 0)
            }
            coreDataModel.save()
        }
        
        for index in editedIndex..<coreDataModel.dataFPEnroute.count {
            //fDiff
            let fDiffDefaultValue = Double(waypointsTableDefault[index].unwrappedFdiff)
            if Double(coreDataModel.dataFPEnroute[index].unwrappedFdiff) != nil {
                // Update the value based on the previous row's value in column
                let afrm = Double(coreDataModel.dataFPEnroute[index].unwrappedAfrm) ?? 0
                let pfrm = Double(coreDataModel.dataFPEnroute[index].unwrappedPfrm) ?? 0
                var NewValue = afrm - pfrm
                if NewValue < 0 {
                    NewValue = NewValue * -1
                    coreDataModel.dataFPEnroute[index].fdiff = "-"+formatFuelNumberDouble(NewValue)
                } else {
                    coreDataModel.dataFPEnroute[index].fdiff = "+"+formatFuelNumberDouble(NewValue)
                }
            }
            else {
                // Set the default value if it exists and currentValue is nil
                coreDataModel.dataFPEnroute[index].fdiff = formatFuelNumberDouble(fDiffDefaultValue ?? 0)
            }
            coreDataModel.save()
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
       

struct FlightPlanEnrView_Previews: PreviewProvider {
    static var previews: some View {
        FlightPlanEnrView()
    }
}
