//
//  FlightInformationView.swift
//  ATLAS
//
//  Created by phuong phan on 06/07/2023.
//

import SwiftUI

struct FlightInformationDetailView: View {
    @State private var showUTC = true
    @EnvironmentObject var coreDataModel: CoreDataModelState
    
    var body: some View {
        
        var eta: String {
            let dateFormatterTime = DateFormatter()
            dateFormatterTime.dateFormat = "HHmm"
            
            if let takeoff = coreDataModel.dataDepartureEntries.entTakeoff {
                let entTakeoff =  dateFormatterTime.date(from: takeoff)
                
                if let flightTimeComponents = coreDataModel.dataSummaryInfo.fltTime {
                    let components = flightTimeComponents.components(separatedBy: ":")
                    if components.count > 1 {
                        let flightTime = (Int(components[0])! * 3600) + (Int(components[1])! * 60)
                        if let etaTime = entTakeoff?.addingTimeInterval(TimeInterval(flightTime)) {
                            return dateFormatterTime.string(from: etaTime)
                        }
                    }
                    
                }
            }
            
            return ""
        }
        
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center) {
                Text("FLIGHT INFORMATION")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Color.black)
                
                Spacer()
                
                HStack {
                    Toggle(isOn: $showUTC) {
                        Text("Local").font(.system(size: 17, weight: .regular))
                            .foregroundStyle(Color.black)
                    }
                    Text("UTC").font(.system(size: 17, weight: .regular))
                        .foregroundStyle(Color.black)
                }.fixedSize(horizontal: true, vertical: false)
            }
            
            List {
                Section {
                    // grouped row using hstack
                    VStack(alignment: .leading) {
                        HStack(alignment: .center) {
                            Group {
                                Text("Chocks Off")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundStyle(Color.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Chocks On")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundStyle(Color.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        Divider()
                        HStack(alignment: .center) {
                            Group {
                                Text(coreDataModel.dataDepartureEntries.unwrappedEntOff)
                                    .font(.system(size: 17, weight: .regular))
                                    .foregroundStyle(Color.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(coreDataModel.dataArrivalEntries.unwrappedEntOn)
                                    .font(.system(size: 17, weight: .regular))
                                    .foregroundStyle(Color.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                }.listRowBackground(Color.theme.antiFlashWhite)
                
                Section {
                    // grouped row using hstack
                    VStack(alignment: .leading) {
                        HStack(alignment: .center) {
                            Group {
                                Text("STD")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundStyle(Color.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("STA")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundStyle(Color.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("ETA")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundStyle(Color.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        Divider()
                        HStack(alignment: .center) {
                            Group {
                                //coreDataModel.dataDepartureEntries.stdUTC
                                Text(showUTC ? coreDataModel.dataSummaryInfo.unwrappedStdUTC : coreDataModel.dataSummaryInfo.unwrappedStdLocal)
                                    .font(.system(size: 17, weight: .regular))
                                    .foregroundStyle(Color.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(showUTC ? coreDataModel.dataSummaryInfo.unwrappedStaUTC : coreDataModel.dataSummaryInfo.unwrappedStaLocal)
                                    .font(.system(size: 17, weight: .regular))
                                    .foregroundStyle(Color.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(eta)
                                    .font(.system(size: 17, weight: .regular))
                                    .foregroundStyle(Color.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                }.listRowBackground(Color.theme.antiFlashWhite)
                
                Section {
                    // grouped row using hstack
                    VStack(alignment: .leading) {
                        HStack(alignment: .center) {
                            Group {
                                Text("Block Time")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundStyle(Color.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Flight Time")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundStyle(Color.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        Divider()
                        HStack(alignment: .center) {
                            Group {
                                Text(coreDataModel.dataSummaryInfo.unwrappedBlkTime)
                                    .font(.system(size: 17, weight: .regular))
                                    .foregroundStyle(Color.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(coreDataModel.dataSummaryInfo.unwrappedFltTime)
                                    .font(.system(size: 17, weight: .regular))
                                    .foregroundStyle(Color.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                }.listRowBackground(Color.theme.antiFlashWhite)
                
                Section {
                    // grouped row using hstack
                    VStack(alignment: .leading) {
                        HStack(alignment: .center) {
                            Group {
                                Text("POB")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundStyle(Color.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        Divider()
                        HStack(alignment: .center) {
                            Group {
                                Text(coreDataModel.dataSummaryInfo.unwrappedPob)
                                    .font(.system(size: 17, weight: .regular))
                                    .foregroundStyle(Color.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                }.listRowBackground(Color.theme.antiFlashWhite)
                
                Section {
                    // grouped row using hstack
                    VStack(alignment: .leading) {
                        HStack(alignment: .center) {
                            Group {
                                Text("Route")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundStyle(Color.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        Divider()
                        HStack(alignment: .center) {
                            Group {
                                Text(coreDataModel.dataSummaryRoute.unwrappedRoute)
                                    .font(.system(size: 17, weight: .regular))
                                    .foregroundStyle(Color.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                }.listRowBackground(Color.theme.antiFlashWhite)
            }.listStyle(.insetGrouped)
                .scrollContentBackground(.hidden)
                .padding(.leading, -16)
                .padding(.trailing, -16)
        }.padding(.top, 32)
    }
}

struct FlightInformationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FlightInformationDetailView()
    }
}
