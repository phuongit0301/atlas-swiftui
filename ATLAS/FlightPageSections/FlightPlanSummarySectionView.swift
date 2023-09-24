//
//  FlightOverviewView.swift
//  ATLAS
//
//  Created by phuong phan on 22/08/2023.
//

import SwiftUI
import Combine

struct FlightPlanSummarySectionView: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController
    @State var isReference = false
    @State private var selectedCA = SummaryDataDropDown.pic
    @State private var selectedFO = SummaryDataDropDown.pic
    @State private var selectAltn = ""
    @State private var tfPob: String = ""
    @State private var tfRoute: String = ""
    @State private var tfVis: String = ""
    @State private var tfMinima: String = ""
    @State private var tfEta: String = ""
    @State private var showUTC = true
    
    @State private var isCollapseFlightInfo = true
    @State private var isCollapsePlanTime = true
    @State private var isCollapseRoute = true
    @State private var isCollapseCrew = true
    @State private var selectedAircraftPicker = ""
    var ALTN_DROP_DOWN: [String] = ["ALTN 1", "ALTN 1", "ALTN 1"]
    
    var body: some View {
        
        GeometryReader { proxy in
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    Text("Summary").font(.system(size: 20, weight: .semibold))
                }.padding(.leading, 30)
                    .padding(.trailing, 16)
                // End header
                List {
                    Section {
                        VStack(spacing: 16) {
                            HStack {
                                Button(action: {
                                    self.isCollapseFlightInfo.toggle()
                                }, label: {
                                    HStack {
                                        Text("Flight Information").font(.system(size: 17, weight: .semibold)).foregroundStyle(Color.black)
                                        
                                        if isCollapseFlightInfo {
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
                                    }.frame(alignment: .leading)
                                }).buttonStyle(PlainButtonStyle())
                                
                                Spacer()
                            }
                            
                            if isCollapseFlightInfo {
                                VStack(spacing: 16) {
                                    VStack {
                                        HStack {
                                            Group {
                                                Text("Callsign").frame(width: calculateWidthSummary(proxy.size.width - 40, 3), alignment: .leading)
                                                Text("Aircraft Model").frame(width: calculateWidthSummary(proxy.size.width - 40, 3), alignment: .leading)
                                                Text("Aircraft").frame(width: calculateWidthSummary(proxy.size.width - 40, 3), alignment: .leading)
                                            }.foregroundStyle(Color.black)
                                                .font(.system(size: 15, weight: .medium))
                                                .frame(alignment: .leading)
                                        }
                                        
                                        Divider().padding(.horizontal, -16)
                                        
                                        HStack {
                                            Text("XXXXXXXX").frame(width: calculateWidthSummary(proxy.size.width - 40, 3), alignment: .leading)
                                            Text("XXXXXXXX").frame(width: calculateWidthSummary(proxy.size.width - 40, 3), alignment: .leading)
                                            Text("XXXXXXXX").frame(width: calculateWidthSummary(proxy.size.width - 40, 3), alignment: .leading)
                                        }
                                    }
                                    
                                    VStack {
                                        HStack {
                                            Group {
                                                Text("Dep").frame(width: calculateWidthSummary(proxy.size.width - 40, 3), alignment: .leading)
                                                Text("Dest").frame(width: calculateWidthSummary(proxy.size.width - 40, 3), alignment: .leading)
                                                Text("POB").frame(width: calculateWidthSummary(proxy.size.width - 40, 3), alignment: .leading)
                                            }.foregroundStyle(Color.black)
                                                .font(.system(size: 15, weight: .medium))
                                                .frame(alignment: .leading)
                                        }
                                        
                                        Divider().padding(.horizontal, -16)
                                        
                                        HStack {
                                            Text("XXXXXXXX").frame(width: calculateWidthSummary(proxy.size.width - 40, 3), alignment: .leading)
                                            Text("XXXXXXXX").frame(width: calculateWidthSummary(proxy.size.width - 40, 3), alignment: .leading)
                                            Text("XXXXXXXX").frame(width: calculateWidthSummary(proxy.size.width - 40, 3), alignment: .leading)
                                        }
                                    }
                                } //end VStack
                            }// end if
                        }
                    }// end section Flight Info
                    
                    
                    Section {
                        VStack(spacing: 16) {
                            HStack {
                                Button(action: {
                                    self.isCollapsePlanTime.toggle()
                                }, label: {
                                    HStack {
                                        Text("Planned times").font(.system(size: 17, weight: .semibold)).foregroundStyle(Color.black)
                                        if isCollapsePlanTime {
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
                                    }.frame(alignment: .leading)
                                }).buttonStyle(PlainButtonStyle())
                                
                                Spacer()
                            }
                            
                            if isCollapsePlanTime {
                                VStack(spacing: 16) {
                                    VStack {
                                        HStack {
                                            Group {
                                                Text("STD").frame(width: calculateWidthSummary(proxy.size.width - 40, 3), alignment: .leading)
                                                Text("STA").frame(width: calculateWidthSummary(proxy.size.width - 40, 3), alignment: .leading)
                                                Text("").frame(width: calculateWidthSummary(proxy.size.width - 40, 3), alignment: .leading)
                                            }
                                            .foregroundStyle(Color.black)
                                            .font(.system(size: 15, weight: .medium))
                                        }
                                        
                                        Divider().padding(.horizontal, -16)
                                        
                                        HStack {
                                            Group {
                                                Text(showUTC ? coreDataModel.dataSummaryInfo.unwrappedStdUTC : coreDataModel.dataSummaryInfo.unwrappedStdLocal).frame(width: calculateWidthSummary(proxy.size.width - 40, 3), alignment: .leading)
                                                Text(showUTC ? coreDataModel.dataSummaryInfo.unwrappedStaUTC : coreDataModel.dataSummaryInfo.unwrappedStaLocal).frame(width: calculateWidthSummary(proxy.size.width - 40, 3), alignment: .leading)
                                                Text("").frame(width: calculateWidthSummary(proxy.size.width - 40, 3), alignment: .leading)
                                            }.font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                        }
                                    }
                                    
                                    VStack {
                                        HStack {
                                            Group {
                                                Text("Block Time").frame(width: calculateWidthSummary(proxy.size.width - 40, 3), alignment: .leading)
                                                Text("Flight Time").frame(width: calculateWidthSummary(proxy.size.width - 40, 3), alignment: .leading)
                                                Text("Block Time - Flight Time").frame(width: calculateWidthSummary(proxy.size.width - 40, 3), alignment: .leading)
                                            }.foregroundStyle(Color.black)
                                                .font(.system(size: 15, weight: .medium))
                                        }
                                        
                                        Divider().padding(.horizontal, -16)
                                        
                                        HStack {
                                            Group {
                                                Text(coreDataModel.dataSummaryInfo.unwrappedBlkTime).frame(width: calculateWidthSummary(proxy.size.width - 40, 3), alignment: .leading)
                                                
                                                Text("XXXXXXXX").frame(width: calculateWidthSummary(proxy.size.width - 40, 3), alignment: .leading)
                                                
                                                Text(calculateTime(coreDataModel.dataSummaryInfo.unwrappedFltTime, coreDataModel.dataSummaryInfo.unwrappedBlkTime)).frame(width: calculateWidthSummary(proxy.size.width - 40, 3), alignment: .leading)
                                            }.font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                        }
                                    }
                                    
                                }// End VStack
                            }// end If
                        }
                    }// end section ETA
                    
                    Section {
                        VStack(spacing: 16) {
                            HStack {
                                Button(action: {
                                    self.isCollapseRoute.toggle()
                                }, label: {
                                    HStack {
                                        Text("Route").font(.system(size: 17, weight: .semibold)).foregroundStyle(Color.black)
                                        if isCollapseRoute {
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
                                    }.frame(alignment: .leading)
                                }).buttonStyle(PlainButtonStyle())
                                
                                Spacer()
                            }
                            
                            if isCollapseRoute {
                                VStack(spacing: 16) {
                                    VStack {
                                        HStack {
                                            Group {
                                                Text("Route").frame(width: proxy.size.width - 56, alignment: .leading)
                                            }
                                            .foregroundStyle(Color.black)
                                            .font(.system(size: 15, weight: .medium))
                                        }
                                        
                                        Divider().padding(.horizontal, -16)
                                        
                                        HStack {
                                            Group {
                                                TextField("Enter Waypoints",text: $tfRoute)
                                                    .frame(width: proxy.size.width - 56, alignment: .leading)
                                                    .onSubmit {
                                                        //Todo
                                                    }
                                            }.font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                        }
                                    }
                                    
                                    VStack {
                                        HStack {
                                            Group {
                                                HStack {
                                                    Text("Enroute Alternates").foregroundColor(Color.black).font(.system(size: 15, weight: .medium))
                                                    Spacer()
                                                    Button(action: {
                                                        //Todo
                                                    }, label: {
                                                        Text("Add").foregroundColor(Color.theme.azure).font(.system(size: 15, weight: .medium))
                                                    }).padding(.trailing)
                                                    
                                                }.frame(width: calculateWidthSummary(proxy.size.width - 56, 4), alignment: .leading)
                                                
                                                Text("VIS").frame(width: calculateWidthSummary(proxy.size.width - 56, 4), alignment: .leading)
                                                Text("Minima").frame(width: calculateWidthSummary(proxy.size.width - 56, 4), alignment: .leading)
                                                Text("ETA").frame(width: calculateWidthSummary(proxy.size.width - 56, 4), alignment: .leading)
                                            }
                                            .foregroundStyle(Color.black)
                                            .font(.system(size: 15, weight: .medium))
                                        }
                                        
                                        Divider().padding(.horizontal, -16)
                                        
                                        HStack {
                                            Group {
                                                HStack {
                                                    Picker("", selection: $selectAltn) {
                                                        Text("Select ALTN").tag("")
                                                        ForEach(ALTN_DROP_DOWN, id: \.self) {
                                                            Text($0).tag($0)
                                                        }
                                                    }.pickerStyle(MenuPickerStyle()).fixedSize()
                                                }.fixedSize()
                                                    .frame(width: calculateWidthSummary(proxy.size.width - 56, 4), alignment: .leading)
                                                    .padding(.leading, -32)
                                                
                                                TextField("Enter VIS",text: $tfVis)
                                                    .frame(width: calculateWidthSummary(proxy.size.width - 56, 4), alignment: .leading)
                                                    .onSubmit {
                                                        //Todo
                                                    }
                                                
                                                TextField("Enter Minima",text: $tfMinima)
                                                    .frame(width: calculateWidthSummary(proxy.size.width - 56, 4), alignment: .leading)
                                                    .onSubmit {
                                                        //Todo
                                                    }
                                                
                                                TextField("Enter ETA",text: $tfEta)
                                                    .frame(width: calculateWidthSummary(proxy.size.width - 56, 4), alignment: .leading)
                                                    .onSubmit {
                                                        //Todo
                                                    }
                                            }.font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                        }
                                    }
                                    
                                }// End VStack
                            }// End if
                        }
                    }
                }.scrollContentBackground(.hidden)
                    .padding(.top, -8)
                // end List
            }
        }//end geometry
    }
}
