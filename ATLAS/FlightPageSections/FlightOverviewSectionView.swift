//
//  FlightOverviewSectionView.swift
//  ATLAS
//
//  Created by phuong phan on 22/08/2023.
//

import SwiftUI
import Combine

struct FlightOverviewSectionView: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController
    @EnvironmentObject var remoteService: RemoteService
    
    @State var isReference = false
    @State private var selectedCA = SummaryDataDropDown.pic
    @State private var selectedFO = SummaryDataDropDown.pic
    @State private var tfAircraft: String = ""
    @State private var tfPob: String = ""
    @State private var tfPassword: String = ""
    
    //For Modal Flight Time
    @State private var currentDateFlightTime: String = "00:00"
    @State private var currentDateFlightTimeTemp = Date()
    @State private var isShowFlightTimeModal = false
    
    //For Modal Chock Off
    @State private var currentDateChockOff = Date()
    @State private var currentDateChockOffTemp = Date()
    @State private var isShowChockOffModal = false
    
    //For Modal Chock On
    @State private var currentDateChockOn = Date()
    @State private var currentDateChockOnTemp = Date()
    @State private var isShowChockOnModal = false
    
    @State private var showUTC = true
    
    @State private var isCollapseFlightInfo = true
    @State private var isCollapsePlanTime = true
    @State private var isCollapseActualTime = true
    @State private var isCollapseCrew = true
    @State private var selectedModelPicker = ""
    
    // For signature
    @State private var isSignatureViewModalPresented = false
    @State private var isSignatureModalPresented = false
    @State private var signatureImage: UIImage?
    @State private var signatureTfLicense: String = ""
    @State private var signatureTfComment: String = ""

    @State private var dataFlightOverview: FlightOverviewList?
    
    //For switch crew
    @State private var isSync = false
    
    var body: some View {
        
        var std: String {
            if showUTC {
                return dataFlightOverview?.unwrappedStd ?? ""
            } else {
                return convertUTCToLocalTime(timeString: dataFlightOverview?.unwrappedStd ?? "", timeDiff: dataFlightOverview?.unwrappedTimeDiffDep ?? "")
            }
        }
        
        var sta: String {
            if showUTC {
                return dataFlightOverview?.unwrappedSta ?? ""
            } else {
                return convertUTCToLocalTime(timeString: dataFlightOverview?.unwrappedSta ?? "", timeDiff: dataFlightOverview?.unwrappedTimeDiffArr ?? "")
            }
        }
        
        var eta: String {
            if showUTC {
                return dataFlightOverview?.unwrappedEta ?? ""
            } else {
                return convertUTCToLocalTime(timeString: dataFlightOverview?.unwrappedEta ?? "", timeDiff: dataFlightOverview?.unwrappedTimeDiffArr ?? "")
            }
        }
        
        GeometryReader { proxy in
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .center) {
                    Text("Flight Overview")
                        .font(.system(size: 17, weight: .semibold))
                        .padding(.leading, 16)
                    
                    Spacer().frame(maxWidth: .infinity)
                    
                    HStack {
                        Toggle(isOn: $showUTC) {
                            Text("Local").font(.system(size: 15, weight: .regular))
                                .foregroundStyle(Color.black)
                        }
                        Text("UTC").font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(Color.black)
                        
                        Button(action: {
                            if checkBtnValid() {
                                isSignatureModalPresented.toggle()
                            }
                        }, label: {
                            Text("Close Flight").font(.system(size: 17, weight: .regular)).foregroundColor(Color.white)
                        }).padding(.vertical, 11)
                            .padding(.horizontal)
                            .background(checkBtnValid() ? Color.theme.azure : Color.theme.philippineGray3)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.white, lineWidth: 0)
                            )
                    }.fixedSize(horizontal: true, vertical: false)
                    
                }.frame(height: 52)
                    .padding(.bottom, 8)
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
                                    Text(dataFlightOverview?.unwrappedCallsign ?? "")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .regular))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    
                                    HStack {
                                        Picker("", selection: $selectedModelPicker) {
                                            Text("Select Aircraft Model").tag("")
                                            ForEach(DataModelDropdown, id: \.self) {
                                                Text($0).tag($0)
                                            }
                                        }.pickerStyle(MenuPickerStyle())
                                            .fixedSize()
                                            .padding(.leading, -16)
                                        Spacer()
                                    }.frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    
                                    TextField(
                                        "Enter Aircraft",
                                        text: $tfAircraft
                                    ).frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                        .onSubmit {
                                            if dataFlightOverview != nil, let item = dataFlightOverview {
                                                item.aircraft = tfAircraft
                                            } else {
                                                let item = FlightOverviewList(context: persistenceController.container.viewContext)
                                                item.aircraft = tfAircraft
                                            }
                                            coreDataModel.save()
                                            dataFlightOverview = coreDataModel.readFlightOverview()
                                        }
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
                                    Text(dataFlightOverview?.unwrappedDep ?? "")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .regular))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    
                                    Text(dataFlightOverview?.unwrappedDest ?? "")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .regular))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                    
                                    TextField(
                                        "Enter POB",
                                        text: $tfPob
                                    ).frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)
                                        .keyboardType(.numberPad)
                                        .onReceive(Just(tfPob)) { output in
                                            let newOutput = output.filter { "0123456789".contains($0) }
                                            tfPob = String(newOutput.prefix(3))
                                        }
                                        .onSubmit {
                                            if dataFlightOverview != nil, let item = dataFlightOverview {
                                                item.pob = tfPob
                                            } else {
                                                let item = FlightOverviewList(context: persistenceController.container.viewContext)
                                                item.pob = tfPob
                                            }
                                            coreDataModel.save()
                                            dataFlightOverview = coreDataModel.readFlightOverview()
                                        }

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
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                    Text("STA")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                }.frame(height: 44)
                                
                                Divider().padding(.horizontal, -16)
                                
                                HStack(spacing: 0) {
                                    Text(std)
                                        .font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black)
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                    Text(sta)
                                        .font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black)
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                }.frame(height: 44)
                                
                                HStack(spacing: 0) {
                                    Text("Block Time")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                    Text("Flight Time")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                }.frame(height: 44)
                                
                                Divider().padding(.horizontal, -16)
                                
                                HStack(spacing: 0) {
                                    Text(dataFlightOverview?.unwrappedBlockTime ?? "")
                                        .font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black)
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                    
                                    FlightTimeButtonTimeStepper(onToggle: onFlightTime, value: currentDateFlightTime)
                                        .fixedSize()
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                }.frame(height: 44)
                                
                                HStack(spacing: 0) {
                                    Text("Block Time - Flight Time")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 1), alignment: .leading)
                                }.frame(height: 44)
                                
                                Divider().padding(.horizontal, -16)
                                
                                HStack(spacing: 0) {
                                    Text(dataFlightOverview?.unwrappedBlockTimeFlightTime ?? "")
                                        .font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black)
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 1), alignment: .leading)
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
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                    Text("Chocks On")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                }.frame(height: 44)
                                
                                Divider().padding(.horizontal, -16)
                                
                                HStack(spacing: 0) {
                                    ButtonDateStepper(onToggle: onChockOff, value: $currentDateChockOff, suffix: "")
                                        .fixedSize()
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                    
                                    ButtonDateStepper(onToggle: onChockOn, value: $currentDateChockOn, suffix: "")
                                        .fixedSize()
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                    
                                }.frame(height: 44)
                                
                                
                                HStack(spacing: 0) {
                                    Text("Day")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                    Text("Night")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                }.frame(height: 44)
                                
                                Divider().padding(.horizontal, -16)
                                
                                HStack(spacing: 0) {
                                    Text(dataFlightOverview?.unwrappedDay ?? "")
                                        .font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black)
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                    Text(dataFlightOverview?.unwrappedNight ?? "")
                                        .font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black)
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                }.frame(height: 44)
                                
                                HStack(spacing: 0) {
                                    Text("ETA")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                    Text("Total Time")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                }.frame(height: 44)
                                
                                Divider().padding(.horizontal, -16)
                                
                                HStack {
                                    Text(eta)
                                        .font(.system(size: 17, weight: .regular)).foregroundStyle(Color.black)
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                    
                                    Text(dataFlightOverview?.totalTime ?? "")
                                        .font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black)
                                        .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
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
                                        
                                        Button(action: {
                                            self.isSync.toggle()
                                        }, label: {
                                            Image("icon_sync")
                                                .scaledToFit()
                                                .aspectRatio(contentMode: .fit)
                                        }).padding(.trailing)
                                            .buttonStyle(PlainButtonStyle())
                                        
                                    }.frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)

                                    Text("FO").font(.system(size: 17, weight: .semibold)).foregroundStyle(Color.black).frame(width: calculateWidthSummary(proxy.size.width - 32, 3), alignment: .leading)

                                }.frame(height: 44, alignment: .leading)

                                Divider().padding(.horizontal, -16)

                                HStack(alignment: .top, spacing: 0) {
                                    VStack(alignment: .leading) {
                                        HStack(alignment: .center) {
                                            SecureField("Enter Password",text: $tfPassword)
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
                                                if isSync {
                                                    Text(dataFlightOverview?.unwrappedF0Name ?? "").font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black)
                                                } else {
                                                    Text(dataFlightOverview?.unwrappedCaName ?? "").font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black)
                                                }
                                                HStack {
                                                    Picker("", selection: $selectedFO) {
                                                        ForEach(SummaryDataDropDown.allCases, id: \.self) {
                                                            Text($0.rawValue).tag($0.rawValue)
                                                        }
                                                    }.pickerStyle(MenuPickerStyle()).fixedSize()
                                                }.fixedSize()
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
                                                if isSync {
                                                    Text(dataFlightOverview?.unwrappedCaName ?? "").font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black)
                                                } else {
                                                    Text(dataFlightOverview?.unwrappedF0Name ?? "").font(.system(size: 15, weight: .regular)).foregroundStyle(Color.black)
                                                }

                                                HStack {
                                                    Picker("", selection: $selectedCA) {
                                                        ForEach(SummaryDataDropDown.allCases, id: \.self) {
                                                            Text($0.rawValue).tag($0.rawValue)
                                                        }
                                                    }.pickerStyle(MenuPickerStyle()).fixedSize()
                                                }.fixedSize()
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
                .padding(.bottom, 32)
            }.padding(.horizontal, 16)
                .background(Color.theme.antiFlashWhite)
                .keyboardAvoidView()
            // end VStack
            .onAppear {
                if let overviewList = coreDataModel.selectedEvent?.flightOverviewList?.allObjects as? [FlightOverviewList] {
                    dataFlightOverview = overviewList.first

                    if let ca = dataFlightOverview?.unwrappedCaPicker {
                        selectedCA = SummaryDataDropDown(rawValue: ca) ?? SummaryDataDropDown.pic
                    }
                    
                    if let f0 = dataFlightOverview?.unwrappedF0Picker {
                        selectedFO = SummaryDataDropDown(rawValue: f0) ?? SummaryDataDropDown.pic
                    }
                    
                    if let model = dataFlightOverview?.model {
                        selectedModelPicker = model
                    }
                    
                    currentDateFlightTime = dataFlightOverview?.unwrappedFlightTime ?? ""
                    tfPob = dataFlightOverview?.unwrappedPob ?? ""
                    tfAircraft = dataFlightOverview?.unwrappedAircraft ?? ""
                }
            }
            .onChange(of: selectedCA) { value in
                if dataFlightOverview != nil, let item = dataFlightOverview {
                    item.caPicker = value.rawValue
                    coreDataModel.save()
                    dataFlightOverview = coreDataModel.readFlightOverview()
                }
            }
            .onChange(of: selectedFO) { value in
                if dataFlightOverview != nil, let item = dataFlightOverview {
                    item.f0Picker = value.rawValue
                    coreDataModel.save()
                    dataFlightOverview = coreDataModel.readFlightOverview()
                }
            }
            .onChange(of: selectedModelPicker) { value in
                if dataFlightOverview != nil, let item = dataFlightOverview {
                    item.model = value
                    coreDataModel.save()
                    dataFlightOverview = coreDataModel.readFlightOverview()
                }
            }
            .onChange(of: currentDateFlightTime) { value in
                if dataFlightOverview != nil, let item = dataFlightOverview {
                    item.flightTime = value
                    coreDataModel.save()
                    dataFlightOverview = coreDataModel.readFlightOverview()
                }
            }
            .onChange(of: signatureImage) { _ in
                if let signatureImage = signatureImage {
                    let str = convertImageToBase64(image: signatureImage)
                    let newObj = SignatureList(context: persistenceController.container.viewContext)
                    newObj.id = UUID()
                    newObj.imageString = str
                    newObj.licenseNumber = signatureTfLicense
                    newObj.comment = signatureTfComment
                    
                    coreDataModel.save()
                    
                    Task {
                        coreDataModel.dataEvents = coreDataModel.readEvents()
                        coreDataModel.dataEventDateRange = coreDataModel.readEventDateRange()
                        coreDataModel.dataLogbookEntries = coreDataModel.readDataLogbookEntries()
                        coreDataModel.dataLogbookLimitation = coreDataModel.readDataLogbookLimitation()
                        coreDataModel.dataRecency = coreDataModel.readDataRecency()
                        coreDataModel.dataRecencyExpiry = coreDataModel.readDataRecencyExpiry()
                        // For Flight Overview
                        // NoteList
                        coreDataModel.dataNoteList = coreDataModel.readNoteList()
                        
                        coreDataModel.dataAirportColorMap = coreDataModel.readDataAirportMapColorList()
                        
                        coreDataModel.dataRouteMap = coreDataModel.readDataRouteMapList()
                        
                        coreDataModel.dataNotams = coreDataModel.readDataNotamsList()
                        
                        coreDataModel.dataMetarTaf = coreDataModel.readDataMetarTafList()
                        
                        coreDataModel.dataNoteAabba = coreDataModel.readDataNoteAabbaPostList("")
                        coreDataModel.dataNoteAabbaPreflight = coreDataModel.readDataNoteAabbaPostList("preflight")
                        coreDataModel.dataNoteAabbaDeparture = coreDataModel.readDataNoteAabbaPostList("departure")
                        coreDataModel.dataNoteAabbaEnroute = coreDataModel.readDataNoteAabbaPostList("enroute")
                        coreDataModel.dataNoteAabbaArrival = coreDataModel.readDataNoteAabbaPostList("arrival")
                        dataFlightOverview = coreDataModel.readFlightOverview()
                        
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        
                        var picDay = "00:00"
                        var picNight = "00:00"
                        var p1Day = "00:00"
                        var p1Night = "00:00"
                        var picUsDay = "00:00"
                        var picUsNight = "00:00"
                        var p2Day = "00:00"
                        var p2Night = "00:00"
                        
                        if isSync {
                            if let dataOverview = dataFlightOverview {
                                if selectedFO == SummaryDataDropDown.pic {
                                    picDay = dataFlightOverview?.day ?? "00:00"
                                    picNight = dataFlightOverview?.night ?? "00:00"
                                } else if selectedFO == SummaryDataDropDown.p1 || selectedFO == SummaryDataDropDown.p1us {
                                    p1Day = dataFlightOverview?.day ?? "00:00"
                                    p1Night = dataFlightOverview?.night ?? "00:00"
                                } else if selectedFO == SummaryDataDropDown.picus {
                                    picUsDay = dataFlightOverview?.day ?? "00:00"
                                    picUsNight = dataFlightOverview?.night ?? "00:00"
                                } else if selectedFO == SummaryDataDropDown.p2 {
                                    p2Day = dataFlightOverview?.day ?? "00:00"
                                    p2Night = dataFlightOverview?.night ?? "00:00"
                                }
                            }
                        } else {
                            if selectedCA == SummaryDataDropDown.pic {
                                picDay = dataFlightOverview?.day ?? "00:00"
                                picNight = dataFlightOverview?.night ?? "00:00"
                            } else if selectedCA == SummaryDataDropDown.p1 || selectedCA == SummaryDataDropDown.p1us {
                                p1Day = dataFlightOverview?.day ?? "00:00"
                                p1Night = dataFlightOverview?.night ?? "00:00"
                            } else if selectedCA == SummaryDataDropDown.picus {
                                picUsDay = dataFlightOverview?.day ?? "00:00"
                                picUsNight = dataFlightOverview?.night ?? "00:00"
                            } else if selectedCA == SummaryDataDropDown.p2 {
                                p2Day = dataFlightOverview?.day ?? "00:00"
                                p2Night = dataFlightOverview?.night ?? "00:00"
                            }
                        }
                        
                        let payload = ILogbookEntriesData(log_id: UUID().uuidString, date: dateFormatter.string(from: Date()), aircraft_category: "", aircraft_type: selectedModelPicker, aircraft: dataFlightOverview?.unwrappedAircraft ?? "", departure: dataFlightOverview?.unwrappedDep ?? "", destination: dataFlightOverview?.unwrappedDest ?? "", pic_day: picDay, pic_u_us_day: picUsDay, p1_day: p1Day, p2_day: p2Day, pic_night: picNight, pic_u_us_night: picUsNight, p1_night: p1Night, p2_night: p2Night, instr: "", exam: "", comments: coreDataModel.dataSignature?.unwrappedComment ?? "", sign_file_name: "", sign_file_url: coreDataModel.dataSignature?.unwrappedImageString ?? "", licence_number: coreDataModel.dataSignature?.unwrappedLicenseNumber ?? "")
                        
                        coreDataModel.initDataLogbookEntries([payload])
                        
                        coreDataModel.dataLogbookEntries = coreDataModel.readDataLogbookEntries()
                        
                        async let serviceLogbook = coreDataModel.postLogbookEntries(coreDataModel.dataLogbookEntries)
                        
                        async let serviceEvent = coreDataModel.postEvent(coreDataModel.dataEvents)
                        
                        async let serviceFlightPlan = coreDataModel.postFlightPlan()
                        
                        await [serviceLogbook, serviceEvent, serviceFlightPlan]
                    }
                }
            }
            .sheet(isPresented: $isSignatureModalPresented) {
                SignatureModalView(signatureImage: $signatureImage, signatureTfLicense: $signatureTfLicense, signatureTfComment: $signatureTfComment, isSignatureModalPresented: $isSignatureModalPresented)
            }
            .formSheet(isPresented: $isShowFlightTimeModal) {
                VStack {
                    HStack(alignment: .center) {
                        Button(action: {
                            self.isShowFlightTimeModal.toggle()
                        }) {
                            Text("Cancel").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                        }
                        
                        Spacer()
                        
                        Text("Flight Time").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.black)
                        
                        Spacer()
                        Button(action: {
                            // assign value from modal to entries form
                            dateFormatter.dateFormat = "HH:mm"
                            self.currentDateFlightTime = dateFormatter.string(from: currentDateFlightTimeTemp)
                            
                            self.isShowFlightTimeModal.toggle()
                        }) {
                            Text("Done").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                        }
                    }.padding()
                        .background(.white)
                        .roundedCorner(12, corners: [.topLeft, .topRight])
                    
                    Divider()
                    
                    VStack {
                        DatePicker("", selection: $currentDateFlightTimeTemp, displayedComponents: [ .hourAndMinute]).labelsHidden().datePickerStyle(WheelDatePickerStyle())
                            .environment(\.locale, Locale(identifier: "en_GB"))
                    }
                    Spacer()
                }
            }
            .formSheet(isPresented: $isShowChockOffModal) {
                VStack {
                    HStack(alignment: .center) {
                        Button(action: {
                            self.isShowChockOffModal.toggle()
                        }) {
                            Text("Cancel").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                        }
                        
                        Spacer()
                        
                        Text("Chocks Off").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.black)
                        
                        Spacer()
                        Button(action: {
                            // assign value from modal to entries form
                            self.currentDateChockOff = currentDateChockOffTemp
                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            
                            self.isShowChockOffModal.toggle()
                        }) {
                            Text("Done").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                        }
                    }.padding()
                        .background(.white)
                        .roundedCorner(12, corners: [.topLeft, .topRight])
                    
                    Divider()
                    
                    VStack {
                        DatePicker("", selection: $currentDateChockOffTemp, displayedComponents: [.date, .hourAndMinute]).labelsHidden().datePickerStyle(WheelDatePickerStyle())
                            .environment(\.locale, Locale(identifier: "en_GB"))
                    }
                    Spacer()
                }
            }
            .formSheet(isPresented: $isShowChockOnModal) {
                VStack {
                    HStack(alignment: .center) {
                        Button(action: {
                            self.isShowChockOnModal.toggle()
                        }) {
                            Text("Cancel").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                        }
                        
                        Spacer()
                        
                        Text("Chocks On").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.black)
                        
                        Spacer()
                        Button(action: {
                            // assign value from modal to entries form
                            self.currentDateChockOn = currentDateChockOnTemp
                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            
                            self.isShowChockOnModal.toggle()
                        }) {
                            Text("Done").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                        }
                    }.padding()
                        .background(.white)
                        .roundedCorner(12, corners: [.topLeft, .topRight])
                    
                    Divider()
                    
                    VStack {
                        DatePicker("", selection: $currentDateChockOnTemp, displayedComponents: [.date, .hourAndMinute]).labelsHidden().datePickerStyle(WheelDatePickerStyle())
                            .environment(\.locale, Locale(identifier: "en_GB"))
                    }
                    Spacer()
                }
            }
        }//end geometry
    }
    
    func onFlightTime() {
        self.isShowFlightTimeModal.toggle()
    }
    
    func onChockOff() {
        self.isShowChockOffModal.toggle()
    }
    
    func onChockOn() {
        self.isShowChockOnModal.toggle()
    }
    
    func checkBtnValid() -> Bool {
        let overview = dataFlightOverview
        return selectedModelPicker != "" && overview?.unwrappedFlightTime != "" && overview?.unwrappedChockOff != "" && overview?.unwrappedChockOn != "" && selectedCA.rawValue != "" && selectedFO.rawValue != ""
    }
}
