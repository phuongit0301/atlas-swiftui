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
    @ObservedObject var enrouteSection = EnrouteSection()
    
    @State var waypointsTableDefault: [EnrouteList] = []
    @State var waypointsTable: [EnrouteList] = []
    @State private var currentIndex = 0 // change background when user tap gesture on row
    @State private var modalIndex = 0 // when user click on row to update number
    @State private var isEdit = false
    
    @State var eta = ""
    @State var ata = ""
    @State var afl = ""
    @State var oat = ""
    @State var awind = ""
    @State var afrm = ""
    
    // For modal
    @State var isShowEta = false
    @State private var selectionOutputEta = Date()
    
    @State var isShowAta = false
    @State private var selectionOutputAta = Date()
    
    @State var isShowAfl = false
    @State private var selectionOutputAfl = ""
    
    @State var isShowOat = false
    @State private var selectionOutputOat = ""
    
    @State var isShowAwind = false
    @State private var selectionOutputAwind = ""
    
    @State var isShowAfrm = false
    @State private var selectionOutputAfrm = ""
    
    @State var isCollapse = false
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .center) {
                    HStack {
                        Text("Flight Plan: \(coreDataModel.dataSummaryInfo.unwrappedPlanNo)").font(.system(size: 15, weight: .semibold))
                        Spacer()
                        Text("Last Update: 10 mins ago").font(.system(size: 15, weight: .regular))
                    }.padding(.horizontal)
                        .padding(.vertical, 8)
                    .background(Color.theme.lightGray1)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 16)
                
                HStack {
                    Text("Enroute").font(.system(size: 20, weight: .semibold))
                    Spacer()
                    
                    if waypointsTable.count > 0 {
                        HStack {
                            HStack {
                                Text("Current Waypoint: \(waypointsTable[currentIndex].unwrappedPosn)").font(.system(size: 17, weight: .semibold))
                            }.padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(Color.white)
                                .cornerRadius(4)
                                .border(Color.theme.azure, width: 2, cornerRadius: 4)
                            
                            HStack {
                                Text("Fuel Diff: \(waypointsTable[currentIndex].unwrappedFdiff)").font(.system(size: 17, weight: .semibold))
                            }.padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(Color.white)
                                .cornerRadius(4)
                            
                            HStack {
                                Text("Time Diff: \(waypointsTable[currentIndex].unwrappedDiff)").font(.system(size: 17, weight: .semibold))
                            }.padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(Color.white)
                                .cornerRadius(4)
                        }
                    }
                    
                }.padding(.leading, 30)
                    .padding(.trailing, 22)
                
                //fixed section as a list - todo @phuong adjust height of list
                VStack(alignment: .leading, spacing: 0) {
                    VStack {
                        HStack {
                            HStack(alignment: .center) {
                                Text("WAYPOINTS").font(.system(size: 15, weight: .semibold)).foregroundStyle(Color.black)
                                
                                Button(action: {
                                    self.isCollapse.toggle()
                                }, label: {
                                    if isCollapse {
                                        Image(systemName: "chevron.up")
                                            .foregroundColor(Color.blue)
                                            .scaledToFit()
                                            .aspectRatio(contentMode: .fit)
                                    } else {
                                        Image(systemName: "chevron.down")
                                            .foregroundColor(Color.blue)
                                            .scaledToFit()
                                            .aspectRatio(contentMode: .fit)
                                    }
                                    
                                }).buttonStyle(PlainButtonStyle())
                            }
                            Spacer()
                            Button(action: {
                                self.isEdit.toggle()
                            }, label: {
                                Text(isEdit ? "Done" : "Direct").font(.system(size: 17, weight: .medium)).textCase(nil)
                            }).padding(.leading, 5)
                        }.padding(.horizontal, 32)
                            .padding(.vertical)
                        
                        if !isCollapse {
                            VStack(spacing: 0) {
                                HStack {
                                    if isEdit {
                                        Text("").frame(width: 30)
                                    }
                                    
                                    Group {
                                        VStack(spacing: 16) {
                                            Text("POSN")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundStyle(Color.blue)
                                                .frame(width: calculate(proxy.size.width), alignment: .leading)
                                            Text("COORD")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundStyle(Color.black)
                                                .frame(width: calculate(proxy.size.width), alignment: .leading)
                                        }
                                        VStack(spacing: 16) {
                                            Text("ACTM")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundStyle(Color.black)
                                                .frame(width: calculate(proxy.size.width), alignment: .leading)
                                            Text("")
                                        }
                                        
                                        VStack(spacing: 16) {
                                            Text("ZTM")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundStyle(Color.black)
                                                .frame(width: calculate(proxy.size.width), alignment: .leading)
                                            Text("MSA")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundStyle(Color.black)
                                                .frame(width: calculate(proxy.size.width), alignment: .leading)
                                        }
                                        
                                        VStack(spacing: 16) {
                                            Text("ETA")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundStyle(Color.blue)
                                                .frame(width: calculate(proxy.size.width), alignment: .leading)
                                            Text("DIS")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundStyle(Color.black)
                                                .frame(width: calculate(proxy.size.width), alignment: .leading)
                                        }
                                        VStack(spacing: 16) {
                                            Text("ATA")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundStyle(Color.blue)
                                                .frame(width: calculate(proxy.size.width), alignment: .leading)
                                            Text("DIFF")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundStyle(Color.black)
                                                .frame(width: calculate(proxy.size.width), alignment: .leading)
                                        }
                                        VStack(spacing: 16) {
                                            Text("AFL")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundStyle(Color.blue)
                                                .frame(width: calculate(proxy.size.width), alignment: .leading)
                                            Text("PFL")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundStyle(Color.black)
                                                .frame(width: calculate(proxy.size.width), alignment: .leading)
                                        }
                                        VStack(spacing: 16) {
                                            Text("OAT")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundStyle(Color.blue)
                                                .frame(width: 65, alignment: .leading)
                                            Text("IMT")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundStyle(Color.black)
                                                .frame(width: 65, alignment: .leading)
                                        }
                                        
                                        VStack(spacing: 16) {
                                            Text("ADN")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundStyle(Color.black)
                                                .frame(width: 65, alignment: .leading)
                                            Text("PDN")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundStyle(Color.black)
                                                .frame(width: 65, alignment: .leading)
                                        }
                                        
                                        VStack(spacing: 16) {
                                            Text("AWIND")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundStyle(Color.blue)
                                                .frame(width: calculate(proxy.size.width), alignment: .leading)
                                            Text("FWIND")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundStyle(Color.black)
                                                .frame(width: calculate(proxy.size.width), alignment: .leading)
                                        }
                                        VStack(spacing: 16) {
                                            Text("TAS")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundStyle(Color.black)
                                                .frame(width: 65, alignment: .leading)
                                                .padding(.leading, 12)
                                            Text("GSP")
                                                .font(.system(size: 12, weight: .medium))
                                                .foregroundStyle(Color.black)
                                                .frame(width: 65, alignment: .leading)
                                                .padding(.leading, 8)
                                        }
                                        
                                    }
                                    Group {
                                        VStack(spacing: 16) {
                                            Text("VWS")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundStyle(Color.black)
                                                .frame(width: calculate(proxy.size.width), alignment: .leading)
                                            Text("DRM")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundStyle(Color.black)
                                                .frame(width: calculate(proxy.size.width), alignment: .leading)
                                        }
                                        VStack(spacing: 16) {
                                            Text("ZFRQ")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundStyle(Color.black)
                                                .frame(width: calculate(proxy.size.width), alignment: .leading)
                                            Text("PFRM")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundStyle(Color.black)
                                                .frame(width: calculate(proxy.size.width), alignment: .leading)
                                        }
                                        VStack(spacing: 16) {
                                            Text("AFRM")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundStyle(Color.blue)
                                                .frame(width: calculate(proxy.size.width), alignment: .leading)
                                            Text("DIFF")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundStyle(Color.black)
                                                .frame(width: calculate(proxy.size.width), alignment: .leading)
                                        }
                                    }
                                    .foregroundStyle(Color.blue)
                                }.padding()
                                    .frame(width: proxy.size.width - 32)
                            }
                        }
                        
                    }.background(Color.white)
                    .roundedCorner(12, corners: [.topLeft, .topRight])
                    
                    Rectangle().fill(Color.theme.arsenic.opacity(0.36)).frame(height: 0.5).frame(maxWidth: .infinity).padding(.leading, -50).padding(.trailing, -50)
                        .listRowInsets(EdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                }.zIndex(10)
                    .padding(.horizontal)
                
                //scrollable waypoints section as a list
                if !isCollapse {
                    List {
                        // table
                        // first row - todo scroll starts here only
                        ForEach(waypointsTable.indices, id: \.self) { index in
                            let row = waypointsTable[index]
                            
                            VStack(spacing: 0) {
                                HStack {
                                    if isEdit {
                                        Group {
                                            HStack {
                                                Button(action: { onUpdate(index) }, label: {
                                                    if row.isSkipped {
                                                        Image(systemName: "plus.circle")
                                                            .foregroundColor(Color.theme.azure)
                                                            .frame(width: 24, height: 24)
                                                            .scaledToFit()
                                                            .aspectRatio(contentMode: .fit)
                                                    } else {
                                                        Image(systemName: "minus.circle")
                                                            .foregroundColor(Color.theme.azure)
                                                            .frame(width: 24, height: 24)
                                                            .scaledToFit()
                                                            .aspectRatio(contentMode: .fit)
                                                    }
                                                }).buttonStyle(PlainButtonStyle())
                                            }.frame(width: 30)
                                        }
                                    }
                                    
                                    VStack(spacing: 0) {
                                        if row.isSkipped {
                                            VStack(spacing: 0) {
                                                HStack {
                                                    Group {
                                                        Text(row.unwrappedPosn)
                                                            .frame(width: calculate(proxy.size.width), alignment: .leading)
                                                        Text("Waypoint skipped. Tap \(isEdit ? "+" : "\"Direct\"") to reinstate")
                                                            .frame(width: calculateWidth(proxy.size.width, 2), alignment: .leading)
                                                            .font(.system(size: 17, weight: .regular))
                                                            .italic()
                                                    }
                                                    Spacer()
                                                }
                                            }.padding(.leading, isEdit ? 0 : 30).frame(height: 44)
                                        } else {
                                            VStack(spacing: 0) {
                                                HStack {
                                                    Group {
                                                        Text(row.unwrappedPosn)
                                                            .frame(width: calculate(proxy.size.width), alignment: .leading)
                                                        
                                                        Text(row.unwrappedActm).frame(width: calculate(proxy.size.width), alignment: .leading)
                                                        
                                                        Text(row.unwrappedZtm).frame(width: calculate(proxy.size.width), alignment: .leading)
                                                        
                                                        HStack {
                                                            EnrouteButtonTimeStepper(onToggle: onEta, value: row.unwrappedEta, index: index).fixedSize().id(UUID())
                                                        }.frame(width: calculate(proxy.size.width), alignment: .leading)
                                                        
                                                        HStack {
                                                            EnrouteButtonTimeStepper(onToggle: onAta, value: row.unwrappedAta, index: index).fixedSize().id(UUID())
                                                        }.frame(width: calculate(proxy.size.width), alignment: .leading)
                                                        HStack {
                                                            if index >= getTocIndex() {
                                                                EnrouteButtonTimeStepper(onToggle: onAfl, value: row.unwrappedAfl, index: index).fixedSize().id(UUID())
                                                            } else {
                                                                Text(row.unwrappedAfl).font(.system(size: 15, weight: .regular)).foregroundStyle(Color.blue)
                                                            }
                                                        }.frame(width: calculate(proxy.size.width), alignment: .leading)
                                                        
                                                        HStack {
                                                            if index >= getTocIndex() {
                                                                EnrouteButtonTimeStepper(onToggle: onOat, value: row.unwrappedOat, index: index).fixedSize().id(UUID())
                                                            } else {
                                                                Text(row.unwrappedOat).font(.system(size: 15, weight: .regular)).foregroundStyle(Color.blue)
                                                            }
                                                        }.frame(width: 65, alignment: .leading)
                                                        
                                                        Text(row.unwrappedAdn).frame(width: 65, alignment: .leading)
                                                        
                                                        HStack {
                                                            if index >= getTocIndex() {
                                                                EnrouteButtonTimeStepper(onToggle: onAwind, value: row.unwrappedAwind, index: index).fixedSize().id(UUID())
                                                            } else {
                                                                Text(row.unwrappedAwind).font(.system(size: 15, weight: .regular)).foregroundStyle(Color.blue)
                                                            }
                                                        }.frame(width: calculate(proxy.size.width), alignment: .leading)
                                                        
                                                        Text(row.unwrappedTas).frame(width: 65, alignment: .leading).padding(.leading, 12)
                                                    }.font(.system(size: 15))
                                                        .fontWeight(.regular)
                                                    Group {
                                                        Text(row.unwrappedVws)
                                                            .foregroundColor(textColorVws(for: row.unwrappedVws)).frame(width: calculate(proxy.size.width), alignment: .leading)
                                                        
                                                        Text(row.unwrappedZfrq).frame(width: calculate(proxy.size.width), alignment: .leading)
                                                        
                                                        HStack {
                                                            EnrouteButtonTimeStepper(onToggle: onAfrm, value: row.unwrappedAfrm, index: index).fixedSize().id(UUID())
                                                        }.frame(width: calculate(proxy.size.width), alignment: .leading)
                                                        
                                                    }.font(.system(size: 15))
                                                        .fontWeight(.regular)
                                                }
                                                HStack {
                                                    Group {
                                                        Text("\(row.unwrappedCord)").frame(width: calculate(proxy.size.width) * 2, alignment: .leading)
                                                        Text("\(row.unwrappedMsa)").foregroundColor(textColorMsa(for: row.unwrappedMsa)).frame(width: calculate(proxy.size.width), alignment: .leading).padding(.leading, 5)
                                                        Text("\(row.unwrappedDis)").frame(width: calculate(proxy.size.width), alignment: .leading)
                                                        Text("\(row.unwrappedDiff)").frame(width: calculate(proxy.size.width), alignment: .leading)
                                                        Text("\(row.unwrappedPfl)").frame(width: calculate(proxy.size.width), alignment: .leading)
                                                        Text("\(row.unwrappedImt)").frame(width: 65, alignment: .leading)
                                                        Text("\(row.unwrappedPdn)").frame(width: 65, alignment: .leading)
                                                        Text("\(row.unwrappedFwind)").frame(width: calculate(proxy.size.width), alignment: .leading)
                                                        Text("\(row.unwrappedGsp)").frame(width: 65, alignment: .leading).padding(.leading, 12)
                                                    }.font(.system(size: 15))
                                                        .fontWeight(.regular)
                                                    
                                                    Group {
                                                        Text("\(row.unwrappedDrm)").frame(width: calculate(proxy.size.width), alignment: .leading)
                                                        Text("\(row.unwrappedPfrm)").frame(width: calculate(proxy.size.width), alignment: .leading)
                                                        Text("\(row.unwrappedFdiff)").frame(width: calculate(proxy.size.width), alignment: .leading)
                                                    }.font(.system(size: 15))
                                                        .fontWeight(.regular)
                                                }
                                            }.frame(height: index == 0 ? 104 : 88)
                                        }// end else condition
                                    }
                                }.padding(.leading, (isEdit && row.isSkipped) ? 20 : 0)
                                    .padding(.top, index == 0 ? 8 : 0)
                                // end HStack
                                
                                Rectangle().fill(Color.theme.arsenic.opacity(0.36)).frame(height: 0.5).frame(maxWidth: .infinity).padding(.leading, -50).padding(.trailing, -50)
                                    .listRowInsets(EdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                            }.listRowBackground((currentIndex == index) ? Color.theme.pictonBlue.opacity(0.1) : Color(.white))
                                .listRowInsets(EdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                                .onTapGesture {
                                    if !row.isSkipped {
                                        currentIndex = index
                                    }
                                }
                        }
                    }
                    .frame(width: proxy.size.width)
                    .listRowSeparator(.hidden)
                    .padding(.top, -56)
                }//end if
                
            }
            .navigationTitle("Enroute")
            .onAppear {
                self.waypointsTableDefault = setDefaultValues(waypointsTableDefault: coreDataModel.dataFPEnroute)
                self.waypointsTable = waypointsTableDefault
            }
            .formSheet(isPresented: $isShowEta) {
                EnrouteModalWheelTime(isShowing: $isShowEta, selectionOutput: $selectionOutputEta)
            }
            .onChange(of: selectionOutputEta) { value in
                let formatter = DateFormatter()
                formatter.dateFormat = "HHmm"
                waypointsTable[modalIndex].eta = formatter.string(from: value)
                updateValues(editedIndex: modalIndex)
            }
            .formSheet(isPresented: $isShowAta) {
                EnrouteModalWheelTime(isShowing: $isShowEta, selectionOutput: $selectionOutputAta)
            }
            .onChange(of: selectionOutputAta) { value in
                let formatter = DateFormatter()
                formatter.dateFormat = "HHmm"
                waypointsTable[modalIndex].ata = formatter.string(from: value)
                updateValues(editedIndex: modalIndex)
                
            }
            .formSheet(isPresented: $isShowAfl) {
                EnrouteModalWheelAfl(isShowing: $isShowAfl, selectionInOut: $selectionOutputAfl, defaultValue: waypointsTableDefault[modalIndex].unwrappedAfl)
            }
            .onChange(of: selectionOutputAfl) { value in
                waypointsTable[modalIndex].afl = value
                updateValues(editedIndex: modalIndex)
            }
            .formSheet(isPresented: $isShowOat) {
                EnrouteModalWheelOat(isShowing: $isShowOat, selectionInOut: $selectionOutputOat)
            }
            .onChange(of: selectionOutputOat) { value in
                waypointsTable[modalIndex].oat = value
                updateValues(editedIndex: modalIndex)
            }
            .formSheet(isPresented: $isShowAwind) {
                EnrouteModalWheelAWind(isShowing: $isShowAwind, selectionInOut: $selectionOutputAwind, defaultValue: waypointsTableDefault[modalIndex].unwrappedAwind)
            }
            .onChange(of: selectionOutputAwind) { value in
                waypointsTable[modalIndex].awind = value
                updateValues(editedIndex: modalIndex)
            }
            .formSheet(isPresented: $isShowAfrm) {
                EnrouteModalWheelAfrm(isShowing: $isShowAfrm, selectionInOut: $selectionOutputAfrm)
            }
            .onChange(of: selectionOutputAfrm) { value in
                waypointsTable[modalIndex].afrm = value
                updateValues(editedIndex: modalIndex)
            }
        }
    }
    
    func onEta(_ index: Int) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HHmm"
        
        self.modalIndex = index
        self.selectionOutputEta = formatter.date(from: waypointsTable[modalIndex].unwrappedEta)!
        self.isShowEta.toggle()
    }
    
    func onAta(_ index: Int) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HHmm"
        
        self.modalIndex = index
        self.selectionOutputAta = formatter.date(from: waypointsTable[modalIndex].unwrappedAta)!
        self.isShowAta.toggle()
    }
    
    func onAfl(_ index: Int) {
        self.modalIndex = index
        self.selectionOutputAfl = waypointsTable[modalIndex].unwrappedAfl
        self.isShowAfl.toggle()
    }
    
    func onOat(_ index: Int) {
        self.modalIndex = index
        self.selectionOutputOat = waypointsTable[modalIndex].unwrappedOat
        self.isShowOat.toggle()
    }
    
    func onAwind(_ index: Int) {
        self.modalIndex = index
        self.selectionOutputAwind = waypointsTable[modalIndex].unwrappedAwind
        self.isShowAwind.toggle()
    }
    
    func onAfrm(_ index: Int) {
        self.modalIndex = index
        self.selectionOutputAfrm = waypointsTable[modalIndex].unwrappedAfrm
        self.isShowAfrm.toggle()
    }
    
    func calculate(_ width: CGFloat) -> CGFloat {
        return calculateWidth(CGFloat(isEdit ? width - 80 : width - 50), 13)
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
    
    func getTocIndex() -> Int {
        for (index, row) in waypointsTableDefault.enumerated() {
            if row.unwrappedPosn == "T_O_C" {
                return index
            }
        }
        return 0
    }

    func onUpdate(_ index: Int) {
        waypointsTable[index].isSkipped.toggle()
        coreDataModel.dataFPEnroute = waypointsTable
        coreDataModel.save()
        coreDataModel.dataFPEnroute = coreDataModel.readEnrouteList()
    }
    func setDefaultValues(waypointsTableDefault: [EnrouteList]) -> [EnrouteList] {
        // define the starting waypoint afrm based on user selections in departure page
        var afrmOff: Double {
            if let unit = coreDataModel.dataFuelDataList.unwrappedTaxi["unit"] {
                let unitChecked = unit != "" ? (unit as NSString).integerValue : 0
                let taxiFuel = coreDataModel.dataFuelDataList.unwrappedTaxi["fuel"]
                let taxiFuelChecked = taxiFuel != "" ? (taxiFuel! as NSString).integerValue : 0
                let calculatedTaxi: Double = Double((coreDataModel.dataFuelExtra.selectedTaxi * unitChecked) / 1000) + (Double(taxiFuelChecked) / 1000)
                let afrm = (Double(coreDataModel.dataDepartureEntries.unwrappedEntFuelInTanks) ?? 0 / 1000) - calculatedTaxi
                
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
            // afl, oat, adn, awind rows less than toc
            if index < tocIndex {
                row.afl = "CLB"
                coreDataModel.dataFPEnroute[index].afl = "CLB"
                row.awind = "N.A"
                coreDataModel.dataFPEnroute[index].awind = "N.A"
                row.oat = "N.A"
                coreDataModel.dataFPEnroute[index].oat = "N.A"
                row.adn = "N.A"
                coreDataModel.dataFPEnroute[index].adn = "N.A"
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
    func updateValues(editedIndex: Int) {
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
                    let adn = Int(oatDefaultValue) ?? 0 - isa
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
    
}

//struct EnrouteCustomField: View {
//    @EnvironmentObject var coreDataModel: CoreDataModelState
//    @EnvironmentObject var persistenceController: PersistenceController
//
//    let waypointsTableDefault: [EnrouteList]
//    @Binding var waypointsTable: [EnrouteList]
//
//    var name: String
//    @State var field: String
//    var index: Int
//
//    var body: some View {
//        TextField("\(name)", text: $field).onSubmit {
//            switch name {
//                case "eta":
//                    // take only last 4 characters of string dd/M | HHmm
//                    waypointsTable[index].eta = String(field.suffix(4))
//                case "ata":
//                    // take only last 4 characters of string dd/M | HHmm
//                    waypointsTable[index].ata = String(field.suffix(4))
//                    if index == 0 {
//                        // date time format
//                        let dateFormatterTime = DateFormatter()
//                        dateFormatterTime.dateFormat = "dd/M | HHmm"
//                        // get takeoff date
//                        let takeoffDate = String(coreDataModel.dataDepartureEntries.unwrappedEntTakeoff.prefix(4))
//                        // convert field into date time format
//                        let newTime = "\(takeoffDate) | \(field)"
//                        // update off time in dep page
//                        coreDataModel.dataDepartureEntries.entTakeoff = newTime
//                        coreDataModel.save()
//                        coreDataModel.dataFPEnroute = coreDataModel.readEnrouteList()
//                    }
//                case "afl":
//                    waypointsTable[index].afl = field
//                case "oat":
//                    waypointsTable[index].oat = field
//                case "awind":
//                    waypointsTable[index].awind = field
//                case "afrm":
//                    waypointsTable[index].afrm = field
//                default:
//                    break
//            }
//            // update the rest of the rows in waypointsTable
//            updateValues(editedIndex: index)
//        }
//    }
//
//    private func updateValues(editedIndex: Int) {
//        let dateFormatterTime = DateFormatter()
//        dateFormatterTime.dateFormat = "HHmm"
//
//        // define the T_O_C index
//        var tocIndex: Int {
//            for (index, row) in waypointsTableDefault.enumerated() {
//                if row.unwrappedPosn == "T_O_C" {
//                    return index
//                }
//            }
//            return 0
//        }
//
//        let startIndex = editedIndex + 1
//        for index in startIndex..<waypointsTable.count {
//            //eta
//            let etaDefaultValue = dateFormatterTime.date(from: waypointsTableDefault[index].unwrappedEta)!
//            if dateFormatterTime.date(from: waypointsTable[index].eta!) != nil {
//                // Update the value based on the previous row's value in column
//                if dateFormatterTime.date(from: waypointsTable[index-1].unwrappedEta) != nil {
//                    let etaPreviousRowValue = dateFormatterTime.date(from: waypointsTable[index-1].unwrappedEta)!
//                    let ztmString = waypointsTable[index].ztm
//                    let components = ztmString!.components(separatedBy: ":")
//                    let ztm = (Int(components[0])! * 3600) + (Int(components[1])! * 60)
//                    let NewValue = etaPreviousRowValue.addingTimeInterval(TimeInterval(ztm))
//                    waypointsTable[index].eta = dateFormatterTime.string(from: NewValue)
//                }
//            }
//            else {
//                // Set the default value if it exists and currentValue is nil
//                waypointsTable[index].eta = dateFormatterTime.string(from: etaDefaultValue)
//            }
//
//            //ata
//            let ataDefaultValue = dateFormatterTime.date(from: waypointsTableDefault[index].unwrappedAta)!
//            if dateFormatterTime.date(from: waypointsTable[index].unwrappedAta) != nil {
//                // Update the value based on the previous row's value in column
//                var ataPreviousRowValue: Date
//
//                if waypointsTable[index-1].unwrappedAta != "" {
//                    ataPreviousRowValue = dateFormatterTime.date(from: waypointsTable[index-1].unwrappedAta)!
//                    let ztmString = waypointsTable[index].unwrappedZtm
//                    let components = ztmString.components(separatedBy: ":")
//                    let ztm = (Int(components[0])! * 3600) + (Int(components[1])! * 60)
//                    let NewValue = ataPreviousRowValue.addingTimeInterval(TimeInterval(ztm))
//                    waypointsTable[index].ata = dateFormatterTime.string(from: NewValue)
//                } else {
//                    waypointsTable[index].ata = dateFormatterTime.string(from: ataDefaultValue)
//                }
//            }
//            else {
//                // Set the default value if it exists and currentValue is nil
//                waypointsTable[index].ata = dateFormatterTime.string(from: ataDefaultValue)
//            }
//
//            //afl
//            let aflDefaultValue = waypointsTableDefault[index].unwrappedAfl
//            if index <= tocIndex {
//                // Set the default value if waypoint is before TOC
//                waypointsTable[index].afl = aflDefaultValue
//            }
//            else {
//                // Update the value based on the previous row's value in column
//                let aflPreviousRowValue = waypointsTable[index-1].unwrappedAfl
//                let NewValue = aflPreviousRowValue
//                waypointsTable[index].afl = NewValue
//            }
//
//            //oat
//            let oatDefaultValue = waypointsTableDefault[index].unwrappedOat
//            if index <= tocIndex {
//                // Set the default value if waypoint is before TOC
//                waypointsTable[index].oat = oatDefaultValue
//            }
//            else {
//                // Update the value based on the previous row's value in column
//                let oatPreviousRowValue = waypointsTable[index-1].unwrappedOat
//                let NewValue = oatPreviousRowValue
//                waypointsTable[index].oat = NewValue
//            }
//
//            //awind
//            let aWindDefaultValue = waypointsTableDefault[index].unwrappedAwind
//            if index <= tocIndex {
//                // Set the default value if waypoint is before TOC
//                waypointsTable[index].awind = aWindDefaultValue
//            }
//            else {
//                // Update the value based on the previous row's value in column
//                let aWindPreviousRowValue = waypointsTable[index-1].unwrappedAwind
//                let NewValue = aWindPreviousRowValue
//                waypointsTable[index].awind = NewValue
//            }
//
//            //afrm
//            let afrmDefaultValue = Double(waypointsTableDefault[index].unwrappedAfrm)
//            if Double(waypointsTable[index].unwrappedAfrm) != nil {
//                // Update the value based on the previous row's value in column
//                let afrmPreviousRowValue = Double(waypointsTable[index-1].unwrappedAfrm)
//                let zfrq = Double(waypointsTable[index].unwrappedZfrq) ?? 0
//                var NewValue = zfrq
//
//                if afrmPreviousRowValue != nil {
//                    NewValue = afrmPreviousRowValue! - zfrq
//                }
//                waypointsTable[index].afrm = formatFuelNumberDouble(NewValue)
//            }
//            else {
//                // Set the default value if it exists and currentValue is nil
//                waypointsTable[index].afrm = formatFuelNumberDouble(afrmDefaultValue ?? 0)
//            }
//        }
//
//        for index in editedIndex..<waypointsTable.count {
//            //diff
//            let diffDefaultValue = waypointsTableDefault[index].unwrappedDiff
//            if dateFormatterTime.date(from: waypointsTable[index].unwrappedEta) != nil &&  dateFormatterTime.date(from: waypointsTable[index].unwrappedEta) != nil {
//                var eta = 0
//                if waypointsTable[index].unwrappedEta != "" {
//                    let etaMins = waypointsTable[index].unwrappedEta.suffix(2)
//                    let etaHrs = waypointsTable[index].unwrappedEta.prefix(2)
//                    eta = Int(etaHrs)! * 60 + Int(etaMins)!
//                }
//                // Update the value based on the eta and ata
//                let ataMins = waypointsTable[index].unwrappedAta.suffix(2)
//                let ataHrs = waypointsTable[index].unwrappedAta.prefix(2)
//                var ata = ataMins != "" ? Int(ataMins)! : 0
//
//                if ataHrs != "" {
//                    ata = Int(ataHrs)! * 60 + ata
//                }
//
//                var NewValue = ata - eta
//                if NewValue < 0 {
//                    NewValue = NewValue * -1
//                    let NewValueString = formatTime(NewValue)
//                    waypointsTable[index].diff = "-"+NewValueString
//                } else {
//                    let NewValueString = formatTime(NewValue)
//                    waypointsTable[index].diff = "+"+NewValueString
//                }
//            }
//            else {
//                // Set the default value if it exists and currentValue is nil
//                waypointsTable[index].diff = diffDefaultValue
//            }
//
//            // adn
//            let oatDefaultValue = waypointsTableDefault[index].unwrappedOat
//            let aflDefaultValue = waypointsTableDefault[index].unwrappedAfl
//            if index < tocIndex {
//                // Set the default value if waypoint is before TOC
//                waypointsTable[index].adn = "N.A"
//            } else { // set value for the rest
//                // get ISA = 15 + -2deg per 1000ft
//                if aflDefaultValue != "" {
//                    let aflFormatted = Int(aflDefaultValue)! * 100
//                    let isa = 15 + (aflFormatted / 1000) * -2
//                    // get adn = oat - ISA
//                    let adn = Int(oatDefaultValue)! - isa
//                    // update value
//                    if adn < 0 {
//                        waypointsTable[index].adn = "\(adn)"
//                    } else {
//                        waypointsTable[index].adn = "+\(adn)"
//                    }
//                } else {
//                    waypointsTable[index].adn = "N.A"
//                }
//            }
//
//            //fDiff
//            let fDiffDefaultValue = Double(waypointsTableDefault[index].unwrappedFdiff)
//            if Double(waypointsTable[index].unwrappedFdiff) != nil {
//                let afrm = Double(waypointsTable[index].unwrappedAfrm) ?? 0
//                let pfrm = Double(waypointsTable[index].unwrappedPfrm) ?? 0
//                var NewValue = afrm - pfrm
//                if NewValue < 0 {
//                    NewValue = NewValue * -1
//                    waypointsTable[index].fdiff = "-"+formatFuelNumberDouble(NewValue)
//                } else {
//                    waypointsTable[index].fdiff = "+"+formatFuelNumberDouble(NewValue)
//                }
//            }
//            else {
//                // Set the default value if it exists and currentValue is nil
//                waypointsTable[index].fdiff = formatFuelNumberDouble(fDiffDefaultValue ?? 0)
//            }
//        }
//
//        for index in editedIndex..<waypointsTable.count {
//            //fDiff
//            let fDiffDefaultValue = Double(waypointsTableDefault[index].unwrappedFdiff)
//            if Double(waypointsTable[index].unwrappedFdiff) != nil {
//                let afrm = Double(waypointsTable[index].unwrappedAfrm) ?? 0
//                let pfrm = Double(waypointsTable[index].unwrappedPfrm) ?? 0
//                var NewValue = afrm - pfrm
//                if NewValue < 0 {
//                    NewValue = NewValue * -1
//                    waypointsTable[index].fdiff = "-"+formatFuelNumberDouble(NewValue)
//                } else {
//                    waypointsTable[index].fdiff = "+"+formatFuelNumberDouble(NewValue)
//                }
//            }
//            else {
//                // Set the default value if it exists and currentValue is nil
//                waypointsTable[index].fdiff = formatFuelNumberDouble(fDiffDefaultValue ?? 0)
//            }
//        }
//        // sync up with coreData, save and reload
//        coreDataModel.dataFPEnroute = waypointsTable
//        coreDataModel.save()
//        coreDataModel.dataFPEnroute = coreDataModel.readEnrouteList()
//    }
//
//    func formatFuelNumberDouble(_ number: Double) -> String {
//        let formattedString = String(format: "%05.1f", number)
//        return formattedString
//    }
//    func formatTime(_ minutes: Int) -> String {
//        let hours = minutes / 60
//        let mins = minutes % 60
//
//        let formatter = DateFormatter()
//        formatter.dateFormat = "HH:mm"
//
//        let date = Calendar.current.date(bySettingHour: hours, minute: mins, second: 0, of: Date()) ?? Date()
//
//        return formatter.string(from: date)
//    }
//}
       

struct FlightPlanEnrView_Previews: PreviewProvider {
    static var previews: some View {
        FlightPlanEnrView()
    }
}
