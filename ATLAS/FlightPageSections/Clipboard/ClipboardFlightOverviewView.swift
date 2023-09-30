//
//  ClipboardFlightOverviewView.swift
//  ATLAS
//
//  Created by phuong phan on 22/08/2023.
//

import SwiftUI
import Combine

struct ClipboardFlightOverviewView: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var refState: ScreenReferenceModel
    
    @State private var selectedCA = SummaryDataDropDown.pic
    @State private var selectedFO = SummaryDataDropDown.pic
    
    @State private var showUTC = true
    
    @State private var isCollapseFlightInfo = true
    @State private var isCollapsePlanTime = true
    @State private var isCollapseActualTime = true
    @State private var isCollapseCrew = true
    
    //For switch crew
    @State private var isSync = false
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .center) {
                    HStack(alignment: .center, spacing: 8) {
                        Button {
                            refState.isActive = false
                        } label: {
                            HStack {
                                Text("Clipboard").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.theme.azure)
                            }
                        }
                        
                        Image(systemName: "chevron.forward").font(.system(size: 17, weight: .regular))
                        
                        if let currentItem = refState.selectedItem, let screenName = currentItem.screenName {
                            Text("\(convertScreenNameToString(screenName))").font(.system(size: 17, weight: .semibold)).foregroundColor(.black)
                        }
                        
                        Spacer()
                    }.padding(.leading)
                    
                    HStack {
                        Toggle(isOn: $showUTC) {
                            Text("Local").font(.system(size: 15, weight: .regular))
                                .foregroundStyle(Color.black)
                        }
                        Text("UTC").font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(Color.black)

                    }.fixedSize(horizontal: true, vertical: false)
                    
                }.frame(height: 52)
                // End header
                
                ScrollView {
                    VStack(spacing: 0) {
                        HStack(alignment: .center, spacing: 0) {
                            Button(action: {
                                self.isCollapseFlightInfo.toggle()
                            }, label: {
                                HStack(alignment: .center, spacing: 8) {
                                    Text("Flight Information").font(.system(size: 17, weight: .semibold)).foregroundStyle(Color.black)
                                    
                                    if isCollapseFlightInfo {
                                        Image(systemName: "chevron.down")
                                            .foregroundColor(Color.blue)
                                            .scaledToFit()
                                            .aspectRatio(contentMode: .fit)
                                        
                                    } else {
                                        Image(systemName: "chevron.up")
                                            .foregroundColor(Color.blue)
                                            .scaledToFit()
                                            .aspectRatio(contentMode: .fit)
                                    }
                                }.frame(alignment: .leading)
                            }).buttonStyle(PlainButtonStyle())
                            
                            Spacer()
                        }.frame(height: 52)
                        
                        if isCollapseFlightInfo {
                            VStack(spacing: 0) {
                                HStack(spacing: 0) {
                                    Text("Callsign")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    Text("Model")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    Text("Aircraft")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                }.frame(height: 44)
                                
                                Divider().padding(.horizontal, -16)
                                
                                HStack(spacing: 0) {
                                    Text(coreDataModel.dataSummaryInfo.unwrappedFltNo)
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .regular))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    
                                    HStack {
                                        Text("Model XXX")
                                            .foregroundStyle(Color.black)
                                            .font(.system(size: 15, weight: .regular))
                                    }.frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    
                                    HStack {
                                        Text("Aircraft XXX")
                                            .foregroundStyle(Color.black)
                                            .font(.system(size: 15, weight: .regular))
                                    }.frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    
                                }.frame(height: 44)
                                
                                HStack(spacing: 0) {
                                    Text("Dep")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    Text("Dest")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    Text("POB")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                }.frame(height: 44)
                                
                                Divider().padding(.horizontal, -16)
                                
                                HStack(spacing: 0) {
                                    Text(coreDataModel.dataSummaryInfo.unwrappedDep)
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .regular))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    Text(coreDataModel.dataSummaryInfo.unwrappedDest)
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .regular))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    
                                    Text("POB XXX")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .regular))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                }.frame(height: 44)
                            } //end VStack
                        }// end if
                    }.padding(.horizontal)
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 0))
                    
                    VStack(spacing: 0) {
                        HStack(alignment: .center, spacing: 0) {
                            Button(action: {
                                self.isCollapsePlanTime.toggle()
                            }, label: {
                                HStack(alignment: .center, spacing: 8) {
                                    Text("Planned times").font(.system(size: 17, weight: .semibold)).foregroundStyle(Color.black)
                                    if isCollapsePlanTime {
                                        Image(systemName: "chevron.down")
                                            .foregroundColor(Color.blue)
                                            .scaledToFit()
                                            .aspectRatio(contentMode: .fit)
                                    } else {
                                        Image(systemName: "chevron.up")
                                            .foregroundColor(Color.blue)
                                            .scaledToFit()
                                            .aspectRatio(contentMode: .fit)
                                    }
                                }.frame(alignment: .leading)
                            }).buttonStyle(PlainButtonStyle())
                            
                            Spacer()
                        }.frame(height: 52)
                        
                        if isCollapsePlanTime {
                            VStack(spacing: 0) {
                                HStack(spacing: 0) {
                                    Text("STD")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    Text("STA")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    Text("")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                }.frame(height: 44)
                                
                                Divider().padding(.horizontal, -16)
                                
                                HStack(spacing: 0) {
                                    Text(showUTC ? coreDataModel.dataSummaryInfo.unwrappedStdUTC : coreDataModel.dataSummaryInfo.unwrappedStdLocal)
                                        .font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black)
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    Text(showUTC ? coreDataModel.dataSummaryInfo.unwrappedStaUTC : coreDataModel.dataSummaryInfo.unwrappedStaLocal)
                                        .font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black)
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    Text("").frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                }.frame(height: 44)
                                
                                HStack(spacing: 0) {
                                    Text("Block Time")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    Text("Flight Time")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    Text("Block Time - Flight Time")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                }.frame(height: 44)
                                
                                Divider().padding(.horizontal, -16)
                                
                                HStack(spacing: 0) {
                                    Text(coreDataModel.dataSummaryInfo.unwrappedBlkTime)
                                        .font(.system(size: 15, weight: .regular))
                                        .foregroundStyle(Color.black)
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    
                                    Text("XXXX")
                                        .font(.system(size: 15, weight: .regular))
                                        .foregroundStyle(Color.black)
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    
                                    Text(calculateTime(coreDataModel.dataSummaryInfo.unwrappedFltTime, coreDataModel.dataSummaryInfo.unwrappedBlkTime))
                                        .font(.system(size: 15, weight: .regular))
                                        .foregroundStyle(Color.black)
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                }.frame(height: 44)
                            }// End VStack
                        }// end If
                    }.padding(.horizontal)
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 0))
                    
                    VStack(spacing: 0) {
                        HStack(alignment: .center, spacing: 0) {
                            Button(action: {
                                self.isCollapseActualTime.toggle()
                            }, label: {
                                HStack(alignment: .center, spacing: 8) {
                                    Text("Actual Times").font(.system(size: 17, weight: .semibold)).foregroundStyle(Color.black)
                                    if isCollapseActualTime {
                                        Image(systemName: "chevron.down")
                                            .foregroundColor(Color.blue)
                                            .scaledToFit()
                                            .aspectRatio(contentMode: .fit)
                                    } else {
                                        Image(systemName: "chevron.up")
                                            .foregroundColor(Color.blue)
                                            .scaledToFit()
                                            .aspectRatio(contentMode: .fit)
                                    }
                                }.frame(alignment: .leading)
                            }).buttonStyle(PlainButtonStyle())
                            
                            Spacer()
                        }.frame(height: 52)
                        
                        if isCollapseActualTime {
                            VStack(spacing: 0) {
                                HStack(spacing: 0) {
                                    Text("Chocks Off")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    Text("ETA")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    Text("Chocks On")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                }.frame(height: 44)
                                
                                Divider().padding(.horizontal, -16)
                                
                                HStack(spacing: 0) {
                                    Text("XXX")
                                        .font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black)
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    
                                    Text("XXX")
                                        .font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black)
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    
                                    Text("XXX")
                                        .font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black)
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    
                                }.frame(height: 44)
                                
                                
                                HStack(spacing: 0) {
                                    Text("Day")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    Text("Night")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    Text("Total Time")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                }.frame(height: 44)
                                
                                Divider().padding(.horizontal, -16)
                                
                                HStack(spacing: 0) {
                                    Text("TODO")
                                        .font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    Text("TODO")
                                        .font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    Text("XXX")
                                        .font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                }.frame(height: 44)
                            }// End VStack
                        }// End if
                    }.padding(.horizontal)
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 0))
                    
                    VStack(spacing: 0) {
                        HStack(alignment: .center, spacing: 0) {
                            Button(action: {
                                self.isCollapseCrew.toggle()
                            }, label: {
                                HStack(alignment: .center, spacing: 8) {
                                    Text("Crew").font(.system(size: 17, weight: .semibold)).foregroundStyle(Color.black)
                                    if isCollapseCrew {
                                        Image(systemName: "chevron.down")
                                            .foregroundColor(Color.blue)
                                            .scaledToFit()
                                            .aspectRatio(contentMode: .fit)
                                    } else {
                                        Image(systemName: "chevron.up")
                                            .foregroundColor(Color.blue)
                                            .scaledToFit()
                                            .aspectRatio(contentMode: .fit)
                                    }
                                }
                            }).buttonStyle(PlainButtonStyle())
                            
                            Spacer()
                        }.frame(height: 52)
                        
                        if isCollapseCrew {
                            VStack(spacing: 0) {
                                HStack(spacing: 0) {
                                    Text("Password").font(.system(size: 17, weight: .semibold)).foregroundStyle(Color.black).frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    
                                    HStack(spacing: 0) {
                                        Text("CA").foregroundStyle(Color.black).font(.system(size: 15, weight: .semibold))

                                        Spacer()
                                        
                                    }.frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)

                                    Text("FO").font(.system(size: 17, weight: .semibold)).foregroundStyle(Color.black).frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)

                                }.frame(height: 44, alignment: .leading)

                                Divider().padding(.horizontal, -16)

                                HStack(alignment: .top, spacing: 0) {
                                    VStack(alignment: .leading) {
                                        HStack(alignment: .center) {
                                            Text("Password")
                                                .font(.system(size: 15, weight: .regular))
                                                .foregroundStyle(Color.black)
                                        }.frame(height: 44)
                                        
                                        Spacer()
                                    }.frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    
                                    HStack(alignment: .center) {
                                        HStack(alignment: .center) {
                                            Circle().strokeBorder(Color.black, lineWidth: 1)
                                                .background(Circle().fill(Color.theme.mountainMeadow))
                                                .frame(width: 48, height: 48)
                                        }

                                        VStack(alignment: .leading) {
                                            HStack {
                                                Text("Muhammad Adil").font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black)
                                                
                                                Text("Picker").font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black)
                                            }.frame(height: 44)

                                            Spacer()
                                        }
                                    }.frame(width: calculateWidthSummary(proxy.size.width - 32, 3), height: 88, alignment: .leading)

                                    HStack(alignment: .center) {
                                        HStack(alignment: .center) {
                                            Circle().strokeBorder(Color.black, lineWidth: 1)
                                                .background(Circle().fill(Color.theme.mountainMeadow))
                                                .frame(width: 48, height: 48)
                                        }

                                        VStack(alignment: .leading, spacing: 0) {
                                            HStack {
                                                Text("Other Pilot's Full name").font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black)

                                                Text("Picker").font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black)
                                            }.frame(height: 44)
                                            
                                            Spacer()
                                        }
                                    }.frame(width: calculateWidthSummary(proxy.size.width - 32, 3), height: 88, alignment: .leading)
                                }.frame(height: 88)

                            }
                        }
                    }.padding(.horizontal)
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 0))
                }// end ScrollView
            }.padding(.horizontal, 16)
                .background(Color.theme.antiFlashWhite)
            // end VStack
            .onAppear {
                selectedCA = SummaryDataDropDown(rawValue: coreDataModel.dataSummaryInfo.unwrappedCrewCA) ?? SummaryDataDropDown.pic
                selectedFO = SummaryDataDropDown(rawValue: coreDataModel.dataSummaryInfo.unwrappedCrewFO) ?? SummaryDataDropDown.pic
            }
            .onChange(of: selectedCA) { value in
                if coreDataModel.existDataSummaryInfo {
                    coreDataModel.dataSummaryInfo.crewCA = value.rawValue
                    coreDataModel.save()
                }
            }
            .onChange(of: selectedFO) { value in
                if coreDataModel.existDataSummaryInfo {
                    coreDataModel.dataSummaryInfo.crewFO = value.rawValue
                    coreDataModel.save()
                }
            }
        }//end geometry
    }
}
