//
//  MapView.swift
//  ATLAS
//
//  Created by phuong phan on 22/08/2023.
//

import SwiftUI
import CoreLocation
import MapKit

let mapView = MKMapView(frame: UIScreen.main.bounds)
let worldMap = WorldMap(filename: "WorldCoordinates")

struct SRoute {
    let name: String
    let latitude: String
    let longitude: String
}

struct MapViewModal: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @StateObject var locationViewModel = LocationViewModel()
    @EnvironmentObject var mapIconModel: MapIconModel
    @State private var mapType: MKMapType = .satelliteFlyover
    @State var tfRoute: String = ""
    
    @State private var showRoute = false
    @State private var showLayer = false
    @State private var showIcon = false
    
    @State var selectedTraffic = true
    @State var selectedWeather = true
    @State var selectedAddRoute = false
    @State var selectedAABBA = true
    @State var selectedWaypoint = true
    @State var selectedAirport = true
    
    @State private var showPopoverWeather = false
    @State private var showPopoverTurbulence = false
    
    @State private var showPopoverVisibility = false
    @State private var showPopoverWind = false
    @State private var showPopoverRunway = false
    @State private var showPopoverCongestion = false
    @State private var showPopoverHazard = false
    @State private var showPopoverGeneral = false
    @State private var showPopoverAskAABBA = false
    @State private var isLoading = true
    @State private var firstLoading = false
    @State var airportIds = [String]()
    //Variable for verify data exists in Route Direction or not
    @State var routeDatas = [SRoute]()
    @State var airportArr = [CustomAirportAnnotation]()
    @State var waypointArr = [CustomWaypointAnnotation]()
    
    @State private var mapOverlay: MapOverlay?
    @State private var mapPolylineOverlay: MKPolyline?
    @State private var mapAirportColor: [CustomAirportColorAnnotation] = []
    @State private var mapTraffic: [CustomTrafficAnnotation] = []
    @State private var mapAabba: [CustomAabbaAnnotation] = []
    
    // check zoom is less than 10 for waypoint and aiport
    @State private var hasShowAnnotation = false
    @State private var hasShowAnnotation2 = false
    
    var body: some View {
        VStack {
            if coreDataModel.isTrafficLoading || coreDataModel.isMapAabbaLoading || coreDataModel.isMapAirportLoading || coreDataModel.isMapAirportColorLoading {
                HStack(alignment: .center) {
                    ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.black)).controlSize(.large)
                }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .background(Color.black.opacity(0.3))
            } else {
                ZStack(alignment: .top) {
                    MapView(
                        region: coreDataModel.region,
                        lineCoordinates: coreDataModel.lineCoordinates,
                        dataWaypointMap: coreDataModel.dataWaypointMap,
                        dataAabbaMap: coreDataModel.dataAabbaMap,
                        currentLocation: locationViewModel.currentLocation,
                        mapType: mapType,
                        isLoading: isLoading,
                        routeDatas: routeDatas,
                        airportIds: airportIds,
                        selectedAirport: $selectedAirport,
                        selectedWaypoint: $selectedWaypoint,
                        selectedTraffic: $selectedTraffic,
                        selectedAABBA: $selectedAABBA,
                        airportArr: $airportArr,
                        waypointArr: $waypointArr,
                        mapTraffic: $mapTraffic,
                        mapAabba: $mapAabba
                    ).overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.theme.azure, lineWidth: 0))
                        .cornerRadius(8)
                    
                    VStack {
                        HStack(alignment: .top) {
                            Button(action: {
                                self.showRoute.toggle()
                                self.showLayer = false
                            }, label: {
                                HStack {
                                    if let dep = coreDataModel.selectedEvent?.dep, let dest = coreDataModel.selectedEvent?.dest {
                                        Text("\(dep)-\(dest)").font(.system(size: 17, weight: .semibold)).foregroundColor(showRoute ? Color.white : Color.black)
                                            .padding(.vertical, 8)
                                            .padding(.horizontal)
                                    }
                                }.contentShape(Rectangle())
                            }).frame(alignment: .center)
                                .background(showRoute ? Color.theme.azure : Color.white)
                                .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.theme.azure, lineWidth: 1))
                                .cornerRadius(24)
                                .buttonStyle(PlainButtonStyle())
                            
                            Button(action: {
                                self.showLayer.toggle()
                                self.showRoute = false
                            }, label: {
                                HStack {
                                    Image(systemName: "square.3.layers.3d")
                                        .foregroundColor(showLayer ? Color.white : Color.theme.azure)
                                        .scaledToFit()
                                        .aspectRatio(contentMode: .fit)
                                        .padding(11)
                                }.frame(width: 44, height: 44, alignment: .center)
                                    .contentShape(Rectangle())
                            }).frame(width: 44, height: 44, alignment: .center)
                                .background(showLayer ? Color.theme.azure : Color.white)
                                .overlay(RoundedRectangle(cornerRadius: 100).stroke(Color.theme.azure, lineWidth: 1))
                                .cornerRadius(100)
                                .buttonStyle(PlainButtonStyle())
                                
                            
                            Spacer()
                            
                            Button(action: {
                                self.showIcon.toggle()
                            }, label: {
                                HStack {
                                    Image(systemName: "plus")
                                        .foregroundColor(Color.white)
                                        .scaledToFit()
                                        .aspectRatio(contentMode: .fit)
                                        .rotationEffect(.degrees(showIcon ? 45 : 0))
                                }.frame(width: 44, height: 44, alignment: .center)
                                .contentShape(Rectangle())
                            }).frame(width: 44, height: 44, alignment: .center)
                                .background(Color.theme.azure)
                                .overlay(RoundedRectangle(cornerRadius: 100).stroke(Color.theme.azure, lineWidth: 1))
                                .cornerRadius(100)
                                .buttonStyle(PlainButtonStyle())
                        }
                        
                        HStack(alignment: .top) {
                            if showRoute && !showLayer {
                                HStack {
                                    HStack {
                                        HStack {
                                            VStack(alignment: .leading) {
                                                Text("Entered Route")
                                                    .font(.system(size: 15, weight: .semibold)).foregroundColor(Color.black)
                                                    .padding(.vertical, 8)
                                                    .disabled(coreDataModel.selectedEvent?.flightStatus == FlightStatusEnum.COMPLETED.rawValue)
                                                
                                                Divider().padding(.horizontal, -16)
                                                
                                                Text(tfRoute).font(.system(size: 15))
                                            }.padding()
                                        }.background(Color.white)
                                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.theme.azure, lineWidth: 0))
                                            .cornerRadius(8)
                                        
                                    }.padding()
                                        .frame(width: 373)
                                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20))
                                        .cornerRadius(20)
                                    
                                    Spacer()
                                }
                            }
                            
                            if showLayer && !showRoute {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Group {
                                            Text("Select Layer")
                                                .font(.system(size: 17, weight: .semibold))
                                                .foregroundColor(Color.black)
                                                .padding(.horizontal)
                                            
                                            Divider().padding(.horizontal, -16)
                                            
                                            Button(action: {
                                                if coreDataModel.selectedEvent?.flightStatus != FlightStatusEnum.COMPLETED.rawValue {
                                                    self.selectedTraffic.toggle()
                                                    self.updateTraffic()
                                                }
                                            }, label: {
                                                HStack {
                                                    Image(systemName: "checkmark")
                                                        .foregroundColor(Color.theme.azure.opacity(self.selectedTraffic ? 1 : 0))
                                                        .scaledToFit()
                                                        .aspectRatio(contentMode: .fit)
                                                    
                                                    Text("Traffic").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.theme.azure)
                                                }.frame(maxWidth: .infinity, alignment: .leading)
                                            })
                                            
                                            Divider().padding(.horizontal, -16)
                                                
                                            Button(action: {
                                                if coreDataModel.selectedEvent?.flightStatus != FlightStatusEnum.COMPLETED.rawValue {
                                                    if coreDataModel.image != nil {
                                                        self.selectedWeather.toggle()
                                                        self.updateMapOverlay()
                                                    }
                                                }
                                            }, label: {
                                                HStack {
                                                    Image(systemName: "checkmark")
                                                        .foregroundColor(Color.theme.azure.opacity(self.selectedWeather ? 1 : 0))
                                                        .scaledToFit()
                                                        .aspectRatio(contentMode: .fit)
                                                    
                                                    Text("Weather").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.theme.azure)
                                                }.frame(maxWidth: .infinity, alignment: .leading)
                                            })
                                            
                                            Divider().padding(.horizontal, -16)
                                        }
                                        
                                        Group {
                                            Button(action: {
                                                if coreDataModel.selectedEvent?.flightStatus != FlightStatusEnum.COMPLETED.rawValue {
                                                    self.selectedAABBA.toggle()
                                                    self.updateAabba()
                                                }
                                            }, label: {
                                                HStack {
                                                    Image(systemName: "checkmark")
                                                        .foregroundColor(Color.theme.azure.opacity(self.selectedAABBA ? 1 : 0))
                                                        .scaledToFit()
                                                        .aspectRatio(contentMode: .fit)
                                                    
                                                    Text("AABBA").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.theme.azure)
                                                }.frame(maxWidth: .infinity, alignment: .leading)
                                            })
                                            
                                            Divider().padding(.horizontal, -16)
                                            
//                                            Button(action: {
//                                                if coreDataModel.selectedEvent?.flightStatus != FlightStatusEnum.COMPLETED.rawValue {
//                                                    self.selectedWaypoint.toggle()
//                                                    self.updateWaypoint()
//                                                }
//                                            }, label: {
//                                                HStack {
//                                                    Image(systemName: "checkmark")
//                                                        .foregroundColor(Color.theme.azure.opacity(self.selectedWaypoint ? 1 : 0))
//                                                        .scaledToFit()
//                                                        .aspectRatio(contentMode: .fit)
//
//                                                    Text("Waypoint").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.theme.azure)
//                                                }.frame(maxWidth: .infinity, alignment: .leading)
//                                            }).buttonStyle(PlainButtonStyle())
//
//                                            Divider().padding(.horizontal, -16)
                                            
                                            Button(action: {
                                                if coreDataModel.selectedEvent?.flightStatus != FlightStatusEnum.COMPLETED.rawValue {
                                                    self.selectedAirport.toggle()
                                                    self.updateAirport()
                                                }
                                            }, label: {
                                                HStack {
                                                    Image(systemName: "checkmark")
                                                        .foregroundColor(Color.theme.azure.opacity(self.selectedAirport ? 1 : 0))
                                                        .scaledToFit()
                                                        .aspectRatio(contentMode: .fit)
                                                    
                                                    Text("Airport").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.theme.azure)
                                                }.frame(maxWidth: .infinity, alignment: .leading)
                                            }).buttonStyle(PlainButtonStyle())
                                        }
                                    }.padding()
                                        .frame(width: 194)
                                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
                                        .cornerRadius(8)
                                    
                                    Spacer()
                                }// End HStack
                            }
                            
                            if showIcon {
                                HStack {
                                    Spacer()
                                    
                                    VStack(spacing: 4) {
                                        Button(action: {
                                            self.showPopoverWeather.toggle()
                                        }, label: {
                                            HStack {
                                                Text("Weather").font(.system(size: 11, weight: .regular))
                                                Image(systemName: "cloud.sun.rain")
                                                    .foregroundColor(Color.theme.seaSerpent)
                                                    .scaledToFit()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 40, height: 40)
                                                    .background(Color.theme.seaSerpent.opacity(0.15))
                                                    .overlay(RoundedRectangle(cornerRadius: 100).stroke(Color.theme.seaSerpent, lineWidth: 1))
                                                    .cornerRadius(100)
                                            }
                                        }).buttonStyle(PlainButtonStyle())
                                            .frame(width: 116, height: 40, alignment: .trailing)
                                            .padding(.trailing, 8)
                                            .popover(isPresented: $showPopoverWeather) {
                                                WeatherPopoverView(isShowing: $showPopoverWeather).frame(width: 360).interactiveDismissDisabled()
                                            }
                                        
                                        Button(action: {
                                            self.showPopoverTurbulence.toggle()
                                        }, label: {
                                            HStack {
                                                Text("Turbulence").font(.system(size: 11, weight: .regular))
                                                Image(systemName: "water.waves")
                                                    .foregroundColor(Color.theme.coralRed1)
                                                    .scaledToFit()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 40, height: 40)
                                                    .background(Color.theme.coralRed1.opacity(0.15))
                                                    .overlay(RoundedRectangle(cornerRadius: 100).stroke(Color.theme.coralRed1, lineWidth: 1))
                                                    .cornerRadius(100)
                                            }
                                        }).buttonStyle(PlainButtonStyle())
                                            .frame(width: 116, height: 40, alignment: .trailing)
                                            .padding(.trailing, 8)
                                            .popover(isPresented: $showPopoverTurbulence) {
                                                TurbulencePopoverView(isShowing: $showPopoverTurbulence).frame(width: 360).interactiveDismissDisabled()
                                            }
                                        
                                        Button(action: {
                                            self.showPopoverVisibility.toggle()
                                        }, label: {
                                            HStack {
                                                Text("Visibility").font(.system(size: 11, weight: .regular))
                                                Image(systemName: "eye.trianglebadge.exclamationmark")
                                                    .foregroundColor(Color.theme.tangerineYellow)
                                                    .scaledToFit()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 40, height: 40)
                                                    .background(Color.theme.tangerineYellow.opacity(0.15))
                                                    .overlay(RoundedRectangle(cornerRadius: 100).stroke(Color.theme.tangerineYellow, lineWidth: 1))
                                                    .cornerRadius(100)
                                            }
                                        }).buttonStyle(PlainButtonStyle())
                                            .frame(width: 116, height: 40, alignment: .trailing)
                                            .padding(.trailing, 8)
                                            .popover(isPresented: $showPopoverVisibility) {
                                                VisibilityPopoverView(isShowing: $showPopoverVisibility).frame(width: 360).interactiveDismissDisabled()
                                            }
                                        
                                        Button(action: {
                                            self.showPopoverWind.toggle()
                                        }, label: {
                                            HStack {
                                                Text("Wind").font(.system(size: 11, weight: .regular))
                                                Image(systemName: "wind")
                                                    .foregroundColor(Color.theme.blueJeans)
                                                    .scaledToFit()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 40, height: 40)
                                                    .background(Color.theme.blueJeans.opacity(0.15))
                                                    .overlay(RoundedRectangle(cornerRadius: 100).stroke(Color.theme.blueJeans, lineWidth: 1))
                                                    .cornerRadius(100)
                                            }
                                        }).buttonStyle(PlainButtonStyle())
                                            .frame(width: 116, height: 40, alignment: .trailing)
                                            .padding(.trailing, 8)
                                            .popover(isPresented: $showPopoverWind) {
                                                WindPopoverView(isShowing: $showPopoverWind).frame(width: 360).interactiveDismissDisabled()
                                            }
                                        
                                        Button(action: {
                                            self.showPopoverRunway.toggle()
                                        }, label: {
                                            HStack {
                                                Text("Runway").font(.system(size: 11, weight: .regular))
                                                Image(systemName: "airplane.arrival")
                                                    .foregroundColor(Color.theme.vividGamboge)
                                                    .scaledToFit()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 40, height: 40)
                                                    .background(Color.theme.vividGamboge.opacity(0.15))
                                                    .overlay(RoundedRectangle(cornerRadius: 100).stroke(Color.theme.vividGamboge, lineWidth: 1))
                                                    .cornerRadius(100)
                                            }
                                        }).buttonStyle(PlainButtonStyle())
                                            .frame(width: 116, height: 40, alignment: .trailing)
                                            .padding(.trailing, 8)
                                            .popover(isPresented: $showPopoverRunway) {
                                                RunwayPopoverView(isShowing: $showPopoverRunway).frame(width: 360).interactiveDismissDisabled()
                                            }
                                        
                                        Button(action: {
                                            self.showPopoverCongestion.toggle()
                                        }, label: {
                                            HStack {
                                                Text("Congestion").font(.system(size: 11, weight: .regular))
                                                Image(systemName: "clock.badge.exclamationmark.fill")
                                                    .foregroundColor(Color.theme.cafeAuLait)
                                                    .scaledToFit()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 40, height: 40)
                                                    .background(Color.theme.cafeAuLait.opacity(0.15))
                                                    .overlay(RoundedRectangle(cornerRadius: 100).stroke(Color.theme.cafeAuLait, lineWidth: 1))
                                                    .cornerRadius(100)
                                            }
                                        }).buttonStyle(PlainButtonStyle())
                                            .frame(width: 116, height: 40, alignment: .trailing)
                                            .padding(.trailing, 8)
                                            .popover(isPresented: $showPopoverCongestion) {
                                                CongestionPopoverView(isShowing: $showPopoverCongestion).frame(width: 360).interactiveDismissDisabled()
                                            }
                                        
                                        Divider().frame(width: 72, alignment: .trailing)
                                        
                                        Button(action: {
                                            self.showPopoverHazard.toggle()
                                        }, label: {
                                            HStack {
                                                Text("Hazard").font(.system(size: 11, weight: .regular))
                                                Image(systemName: "exclamationmark.triangle")
                                                    .foregroundColor(Color.theme.coralRed1)
                                                    .scaledToFit()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 40, height: 40)
                                                    .background(Color.theme.coralRed1.opacity(0.15))
                                                    .overlay(RoundedRectangle(cornerRadius: 100).stroke(Color.theme.coralRed1, lineWidth: 1))
                                                    .cornerRadius(100)
                                            }
                                        }).buttonStyle(PlainButtonStyle())
                                            .frame(width: 116, height: 40, alignment: .trailing)
                                            .padding(.trailing, 8)
                                            .popover(isPresented: $showPopoverHazard) {
                                                HazardPopoverView(isShowing: $showPopoverHazard).frame(width: 360).interactiveDismissDisabled()
                                            }
                                        
                                        Button(action: {
                                            self.showPopoverGeneral.toggle()
                                        }, label: {
                                            HStack {
                                                Text("General").font(.system(size: 11, weight: .regular))
                                                Image(systemName: "info.bubble")
                                                    .foregroundColor(Color.theme.iris)
                                                    .scaledToFit()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 40, height: 40)
                                                    .background(Color.theme.iris.opacity(0.15))
                                                    .overlay(RoundedRectangle(cornerRadius: 100).stroke(Color.theme.iris, lineWidth: 1))
                                                    .cornerRadius(100)
                                            }
                                        }).buttonStyle(PlainButtonStyle())
                                            .frame(width: 116, height: 40, alignment: .trailing)
                                            .padding(.trailing, 8)
                                            .popover(isPresented: $showPopoverGeneral) {
                                                GeneralPopoverView(isShowing: $showPopoverGeneral).frame(width: 360).interactiveDismissDisabled()
                                            }
                                        
                                        Button(action: {
                                            self.showPopoverAskAABBA.toggle()
                                        }, label: {
                                            HStack {
                                                Text("Ask AABBA").font(.system(size: 11, weight: .regular))
                                                Image(systemName: "questionmark.bubble")
                                                    .foregroundColor(Color.theme.mediumOrchid)
                                                    .scaledToFit()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 40, height: 40)
                                                    .background(Color.theme.mediumOrchid.opacity(0.15))
                                                    .overlay(RoundedRectangle(cornerRadius: 100).stroke(Color.theme.mediumOrchid, lineWidth: 1))
                                                    .cornerRadius(100)
                                            }
                                        }).buttonStyle(PlainButtonStyle())
                                            .frame(width: 116, height: 40, alignment: .trailing)
                                            .padding(.trailing, 8)
                                            .popover(isPresented: $showPopoverAskAABBA) {
                                                AskAabbaPopoverView(isShowing: $showPopoverAskAABBA).frame(width: 318).interactiveDismissDisabled()
                                            }
                                        
                                    }.padding(.vertical, 8)
                                        .padding(.horizontal, 4)
                                        .frame(width: 120)
                                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
                                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white, lineWidth: 0))
                                        .cornerRadius(16)
                                }
                            }
                            
                        }
                        
                    }// End VStack
                    .padding()
                    
                }.padding()
                    .onAppear {
                        firstLoading = true
                        
                        
                        if let flightOverviewList = coreDataModel.selectedEvent?.flightOverviewList?.allObjects as? [FlightOverviewList], let flightOverview = flightOverviewList.first {
                            readData()
                            tfRoute = flightOverview.unwrappedRoute
                            selectedAddRoute = true
                        }
                        
                        updateMapOverlayViews()
                        
//                        if mapIconModel.firstLoading {
//                            updateMapOverlayViews()
//                        }
                    }
                    .onChange(of: mapIconModel.num) { _ in
                        coreDataModel.dataAabbaMap = coreDataModel.readDataAabbaMapList()
                    }
                    .onChange(of: mapIconModel.numAabba) { _ in
                        coreDataModel.dataAabbaMap = coreDataModel.readDataAabbaMapList()
                        updateAabba()
                    }
                    .onChange(of: isLoading) {newValue in
                        if !newValue && coreDataModel.image != nil {
                            mapView.removeOverlays(mapView.overlays)
                            if selectedWeather { addOverlay() }
                        }
                    }
                    .sheet(isPresented: $mapIconModel.showModal) {
                        MapAirportCardView().interactiveDismissDisabled(true)
                    }
            }
        }
    }
    
    func readData() {
        coreDataModel.dataTrafficMap = coreDataModel.readDataTrafficMapList()
        coreDataModel.dataAabbaMap = coreDataModel.readDataAabbaMapList()
        coreDataModel.dataWaypointMap = coreDataModel.readDataWaypontMapList()
        coreDataModel.dataAirportColorMap = coreDataModel.readDataAirportMapColorList()
        coreDataModel.dataAirportMap = coreDataModel.readDataAirportMapList()
        coreDataModel.dataTrafficMap = coreDataModel.readDataTrafficMapList()
        coreDataModel.dataNoteAabba = coreDataModel.readDataNoteAabbaPostList("")
        coreDataModel.dataNoteAabbaPreflight = coreDataModel.readDataNoteAabbaPostList("preflight")
        coreDataModel.dataNoteAabbaDeparture = coreDataModel.readDataNoteAabbaPostList("departure")
        coreDataModel.dataNoteAabbaEnroute = coreDataModel.readDataNoteAabbaPostList("enroute")
        coreDataModel.dataNoteAabbaArrival = coreDataModel.readDataNoteAabbaPostList("arrival")
        coreDataModel.dataNotams = coreDataModel.readDataNotamsList()
    }
    
    func updateMapOverlay() {
        if let mapOverlay = mapOverlay {
            if selectedWeather {
                mapView.removeOverlay(mapOverlay)
                mapView.addOverlay(mapOverlay)
            } else {
                mapView.removeOverlay(mapOverlay)
            }
        }
    }
    
    func updateWaypoint() {
        if selectedWaypoint {
            mapView.addAnnotations(waypointArr)
        } else {
            mapView.removeAnnotations(waypointArr)
        }
    }
    
    func updateAirport() {
        if selectedAirport {
            mapView.addAnnotations(airportArr)
        } else {
            mapView.removeAnnotations(airportArr)
        }
    }
    
    func updateTraffic() {
        if selectedTraffic {
            mapView.addAnnotations(mapTraffic)
        } else {
            mapView.removeAnnotations(mapTraffic)
        }
    }
    
    func updateAabba() {
        if selectedAABBA {
            mapView.removeAnnotations(mapAabba)
            mapView.addAnnotations(mapAabba)
        } else {
            mapView.removeAnnotations(mapAabba)
        }
    }
    
    func updateMapOverlayViews() {
        DispatchQueue.main.async {
            mapView.removeAnnotations(mapView.annotations)
            mapView.removeOverlays(mapView.overlays)
            
            if selectedAddRoute {
                addRoute()
                addAirportColor()
            } else {
                if let mapPolylineOverlay = mapPolylineOverlay {
                    mapView.removeOverlay(mapPolylineOverlay)
                }
            }
            
            print("traffic data===========\(coreDataModel.dataTrafficMap)")
            onAppearAirport()
            onAppearMapOverlay()
            onAppearWaypoint()
            onAppearTraffic()
            onAppearAabba()
        }
    }
    
    func onAppearMapOverlay() {
        if coreDataModel.image != nil {
            if selectedWeather {
                addOverlay()
            } else {
                if let mapOverlay = mapOverlay {
                    mapView.removeOverlay(mapOverlay)
                }
            }
        }
    }
    
    func onAppearAirport() {
        if selectedAirport {
            airportArr = addAirport(airportIds)
            
            mapView.addAnnotations(airportArr)
        } else {
            mapView.removeAnnotations(airportArr)
        }
    }
    
    func onAppearWaypoint() {
        waypointArr = addWaypoint()
        
        if selectedWaypoint {
            mapView.addAnnotations(waypointArr)
        } else {
            mapView.removeAnnotations(waypointArr)
        }
    }
    
    func onAppearTraffic() {
        if selectedTraffic {
            mapTraffic = addTraffic()
            mapView.addAnnotations(mapTraffic)
        } else {
            mapView.removeAnnotations(mapTraffic)
        }
    }
    
    func onAppearAabba() {
        if selectedAABBA {
            mapAabba = addAabba()
            mapView.addAnnotations(mapAabba)
        } else {
            mapView.removeAnnotations(mapAabba)
        }
    }
    
    func addOverlay() {
        let overlay = MapOverlay(worldMap: worldMap)
        mapOverlay = overlay
        mapView.addOverlay(overlay)
    }
    
    func addRoute() {
        let payload = extractFiveLetterWords(from: tfRoute)
        var dataWaypoint: [String] = []
        var locationCoordinate = [CLLocationCoordinate2D]()
        
        //get start and end route
        let departureLatLong = extractLatLong(forSelection: "departure", inDictionaries: coreDataModel.dataAirportColorMap)
        let arrivalLatLong = extractLatLong(forSelection: "arrival", inDictionaries: coreDataModel.dataAirportColorMap)
        
        if departureLatLong["latitude"] != nil {
            let firstCoord = CLLocationCoordinate2D(latitude: departureLatLong["latitude"]! as! CLLocationDegrees, longitude: departureLatLong["longitude"]! as! CLLocationDegrees)
            let firstImage = UIImage(named: "icon_circle_fill_blue")
            
            let firstAnnotation = CustomRouteAnnotation(coordinate: firstCoord, title: (departureLatLong["name"] as? String)!.trimmingCharacters(in: .whitespacesAndNewlines), subtitle: "", image: firstImage)
            locationCoordinate.append(firstCoord)
            mapView.addAnnotation(firstAnnotation)
            
            //Append data to route
            if let depLat = departureLatLong["latitude"], let depLong = departureLatLong["longitude"] {
                routeDatas.append(SRoute(name: (departureLatLong["name"] as? String)!.trimmingCharacters(in: .whitespacesAndNewlines), latitude: "\(depLat)", longitude: "\(depLong)"))
            }
        }
        
        for item in payload {
            if let itemExists = coreDataModel.dataWaypointMap.first(where: {$0.unwrappedName == item}) {
                let coord = CLLocationCoordinate2D(latitude: (itemExists.latitude! as NSString).doubleValue, longitude: (itemExists.longitude! as NSString).doubleValue)
                let annotation = CustomRouteAnnotation(coordinate: coord, title: itemExists.name!.trimmingCharacters(in: .whitespacesAndNewlines), subtitle: "", image: UIImage(named: "icon_triangle_fill_blue"))
                
                locationCoordinate.append(coord)
                mapView.addAnnotation(annotation)
                
                //Append data wheel picker for popover icons
                dataWaypoint.append(item)
                //Append data to route
                routeDatas.append(SRoute(name:  itemExists.name!.trimmingCharacters(in: .whitespacesAndNewlines), latitude: ((itemExists.latitude! as NSString) as String), longitude: ((itemExists.longitude! as NSString) as String)))
            }
        }
        
        if arrivalLatLong["latitude"] != nil {
            let lastCoord = CLLocationCoordinate2D(latitude: arrivalLatLong["latitude"]! as! CLLocationDegrees, longitude: arrivalLatLong["longitude"]! as! CLLocationDegrees)
            let lastImage = UIImage(named: "icon_circle_fill_blue")
            //        let lastColorName = arrivalLatLong["colour"] as? String ?? "black"
            
            //        if lastColorName.lowercased() == "green" {
            //            lastImage = UIImage(named: "icon_circle_green")
            //        } else if lastColorName.lowercased() == "amber" {
            //            lastImage = UIImage(named: "icon_circle_amber")
            //        } else if lastColorName.lowercased() == "red" {
            //            lastImage = UIImage(named: "icon_circle_red")
            //        }
            
            let lastAnnotation = CustomRouteAnnotation(coordinate: lastCoord, title: (arrivalLatLong["name"] as? String)!.trimmingCharacters(in: .whitespacesAndNewlines), subtitle: "", image:lastImage)
            locationCoordinate.append(lastCoord)
            mapView.addAnnotation(lastAnnotation)
            
            //Append data to route
            if let arrLat = arrivalLatLong["latitude"], let arrLong = arrivalLatLong["longitude"] {
                routeDatas.append(SRoute(name: (arrivalLatLong["name"] as? String)!.trimmingCharacters(in: .whitespacesAndNewlines), latitude: "\(arrLat)", longitude: "\(arrLong)"))
            }
        }
        
        let polyline = MKPolyline(coordinates: locationCoordinate, count: locationCoordinate.count)
        mapView.addOverlay(polyline)
        mapPolylineOverlay = polyline
        
        mapIconModel.dataWaypoint = dataWaypoint
    }
    
    func addWaypoint() -> [CustomWaypointAnnotation] {
        var temp = [CustomWaypointAnnotation]()
        
        for item in coreDataModel.dataWaypointMap {
            if routeDatas.count > 0 {
                let itemExist = routeDatas.first(where: {$0.name == item.unwrappedName && $0.latitude == item.unwrappedLatitude && $0.longitude == item.unwrappedLongitude})
                
                if (itemExist == nil) {
                    let coord = CLLocationCoordinate2D(latitude: (item.latitude! as NSString).doubleValue, longitude: (item.longitude! as NSString).doubleValue)
                    
                    let annotation = CustomWaypointAnnotation(coordinate: coord, title: item.name!.trimmingCharacters(in: .whitespacesAndNewlines), subtitle: "", image: UIImage(named: "icon_triangle"))
                       
                    temp.append(annotation)
                }
            } else {
                let coord = CLLocationCoordinate2D(latitude: (item.latitude! as NSString).doubleValue, longitude: (item.longitude! as NSString).doubleValue)
                
                let annotation = CustomWaypointAnnotation(coordinate: coord, title: item.name!.trimmingCharacters(in: .whitespacesAndNewlines), subtitle: "", image: UIImage(named: "icon_triangle"))
                temp.append(annotation)
            }
        }
        
        return temp
    }
    
    func addAirport(_ airportIds: [String]) -> [CustomAirportAnnotation] {
        var temp = [CustomAirportAnnotation]()
        
        for item in coreDataModel.dataAirportMap {
            if airportIds.count > 0 && item.unwrappedName != "" {
                if !airportIds.contains(item.unwrappedName) {
                    let coord = CLLocationCoordinate2D(latitude: (item.unwrappedLatitude as NSString).doubleValue, longitude: (item.unwrappedLongitude as NSString).doubleValue)

                    let annotation = CustomAirportAnnotation(coordinate: coord, title: item.name!.trimmingCharacters(in: .whitespacesAndNewlines), subtitle: "", image: UIImage(named: "icon_circle_unfilled"))
                    
                    temp.append(annotation)
                }

            }

        }
        return temp
    }
    
    func addAirportColor() {
        var temp = [CustomAirportColorAnnotation]()
        
        for item in coreDataModel.dataAirportColorMap {
            let coord = CLLocationCoordinate2D(latitude: (item.unwrappedLatitude as NSString).doubleValue, longitude: (item.unwrappedLongitude as NSString).doubleValue)
            
            var image = UIImage(named: "icon_circle_black")
            let colorName = item.colour ?? "black"
            
            if colorName.lowercased() == "green" {
                image = UIImage(named: "icon_circle_green")
            } else if colorName.lowercased() == "amber" {
                image = UIImage(named: "icon_circle_amber")
            } else if colorName.lowercased() == "red" {
                image = UIImage(named: "icon_circle_red")
            }
            
            let annotation = CustomAirportColorAnnotation(coordinate: coord, title: item.airportId!.trimmingCharacters(in: .whitespacesAndNewlines), subtitle: "", image: image, item: item)
            
            if let id = item.airportId {
                airportIds.append(id)
            }
            
            temp.append(annotation)
            mapView.addAnnotation(annotation)
        }
        mapAirportColor = temp
    }
    
    func addTraffic() -> [CustomTrafficAnnotation] {
        var temp = [CustomTrafficAnnotation]()
        
        for item in coreDataModel.dataTrafficMap {
            let coord = CLLocationCoordinate2D(latitude: (item.latitude! as NSString).doubleValue, longitude: (item.longitude! as NSString).doubleValue)

            let annotation = CustomTrafficAnnotation(coordinate: coord, title: "", subtitle: item.trueTrack, flightNum: item.unwrappedCallsign, aircraftType: item.unwrappedaircraftType, baroAltitude: item.unwrappedBaroAltitude, rotationAngle: CGFloat((item.trueTrack! as NSString).doubleValue), colour: item.colour)
            
            temp.append(annotation)
        }
        
//        mapView.addAnnotations(temp)
        return temp
    }
    
    func addAabba() -> [CustomAabbaAnnotation]  {
//        var defaultImage = UIImage(named: "icon_weather_overlay")
        var temp = [CustomAabbaAnnotation]()
        
        for(index, item) in coreDataModel.dataAabbaMap.enumerated() {
            let coord = CLLocationCoordinate2D(latitude: (item.unwrappedLatitude as NSString).doubleValue, longitude: (item.unwrappedLongitude as NSString).doubleValue)
            
            let annotation = CustomAabbaAnnotation(coordinate: coord, title: String((item.postCount as? NSString)!.integerValue), subtitle: "", index: index)

            temp.append(annotation)
        }
        
//        mapView.addAnnotations(temp)
        return temp
    }
    
    func extractFiveLetterWords(from input: String) -> [String] {
        let pattern = "\\b[A-Z]{5}\\b"
        
        if let regex = try? NSRegularExpression(pattern: pattern) {
            let range = NSRange(input.startIndex..<input.endIndex, in: input)
            let matches = regex.matches(in: input, options: [], range: range)
            
            return matches.map { match in
                let start = input.index(input.startIndex, offsetBy: match.range.lowerBound)
                let end = input.index(input.startIndex, offsetBy: match.range.upperBound)
                return String(input[start..<end])
            }
        }
        
        return []
    }
    
    func extractLatLong(forSelection selection: String, inDictionaries dictionaries: [AirportMapColorList]) -> [String: Any] {
        var latLongValues: [String: Any] = [String: Any]()
        
        for dictionary in dictionaries {
            if dictionary.selection?.lowercased() == selection.lowercased() {
                if let lat = Double(dictionary.latitude!), let long = Double(dictionary.longitude!) {
                    latLongValues["latitude"] = lat
                    latLongValues["longitude"] = long
                    latLongValues["name"] = dictionary.airportId
                    latLongValues["colour"] = dictionary.colour
                }
            }
        }
        
        return latLongValues
    }
}

struct MapView: UIViewRepresentable {
    let region: MKCoordinateRegion
    let lineCoordinates: [CLLocationCoordinate2D]
    let dataWaypointMap: [WaypointMapList]
    let dataAabbaMap: [AabbaMapList]
    let currentLocation: CLLocationCoordinate2D
    let mapType: MKMapType
    var isLoading: Bool
    var routeDatas: [SRoute]
    var airportIds: [String]
    @Binding var selectedAirport: Bool
    @Binding var selectedWaypoint: Bool
    @Binding var selectedTraffic: Bool
    @Binding var selectedAABBA: Bool
    @Binding var airportArr: [CustomAirportAnnotation]
    @Binding var waypointArr: [CustomWaypointAnnotation]
    @Binding var mapTraffic: [CustomTrafficAnnotation]
    @Binding var mapAabba: [CustomAabbaAnnotation]
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var mapIconModel: MapIconModel
    
    func makeUIView(context: Context) -> MKMapView {
//        let mapView = MKMapView()
        if routeDatas.count > 0 {
            if let firstRoute = routeDatas.first, let lastRoute = routeDatas.last {
                let startCoord = CLLocationCoordinate2D(latitude: (firstRoute.latitude as NSString).doubleValue, longitude: ((firstRoute.longitude) as NSString).doubleValue)
                let endCoord = CLLocationCoordinate2D(latitude: (lastRoute.latitude as NSString).doubleValue, longitude: (lastRoute.longitude as NSString).doubleValue)
                
                let regionCustom = calculateRegion(startCoordinate: startCoord, endCoordinate: endCoord)
                mapView.setRegion(regionCustom, animated: true)
            }
            
        }
        
        mapView.mapType = mapType
//        mapView.region = region
        mapView.pointOfInterestFilter?.includes(MKPointOfInterestCategory.airport)
        mapView.showsUserLocation = false
        mapView.showsScale = true
        mapView.showsTraffic = false
        
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: "CustomAnnotationView")
        mapView.register(CustomRouteAnnotationView.self, forAnnotationViewWithReuseIdentifier: "CustomRouteAnnotationView")
        mapView.register(CustomTrafficAnnotationView.self, forAnnotationViewWithReuseIdentifier: "CustomTrafficAnnotationView")
        mapView.register(CustomAabbaAnnotationView.self, forAnnotationViewWithReuseIdentifier: "CustomAabbaAnnotationView")
        mapView.register(CustomWaypointAnnotationView.self, forAnnotationViewWithReuseIdentifier: "CustomWaypointAnnotationView")
        mapView.register(CustomAirportAnnotationView.self, forAnnotationViewWithReuseIdentifier: "CustomAirportAnnotationView")
        mapView.register(CustomAirportColorAnnotationView.self, forAnnotationViewWithReuseIdentifier: "CustomAirportColorAnnotationView")
        mapView.delegate = context.coordinator
//        mapView.userTrackingMode = MKUserTrackingMode.follow
        
        return mapView
    }
    
    func calculateRegion(startCoordinate: CLLocationCoordinate2D, endCoordinate: CLLocationCoordinate2D) -> MKCoordinateRegion {
        let center = CLLocationCoordinate2D(
            latitude: (startCoordinate.latitude + endCoordinate.latitude) / 2,
            longitude: (startCoordinate.longitude + endCoordinate.longitude) / 2
        )
        
        let span = MKCoordinateSpan(
            latitudeDelta: abs(startCoordinate.latitude - endCoordinate.latitude) * 1.2,
            longitudeDelta: abs(startCoordinate.longitude - endCoordinate.longitude) * 1.2
        )
        
        let region = MKCoordinateRegion(center: center, span: span)

        return region
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        view.showsUserLocation = false
        
        if mapIconModel.firstLoading && routeDatas.count > 0 {
            if let firstRoute = routeDatas.first, let lastRoute = routeDatas.last {
                let startCoord = CLLocationCoordinate2D(latitude: (firstRoute.latitude as NSString).doubleValue, longitude: ((firstRoute.longitude) as NSString).doubleValue)
                let endCoord = CLLocationCoordinate2D(latitude: (lastRoute.latitude as NSString).doubleValue, longitude: (lastRoute.longitude as NSString).doubleValue)

                let regionCustom = calculateRegion(startCoordinate: startCoord, endCoordinate: endCoord)
                mapView.setRegion(regionCustom, animated: true)
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

class Coordinator: NSObject, MKMapViewDelegate {
    var parent: MapView
    
    init(_ parent: MapView) {
        self.parent = parent
    }
    
    @MainActor func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        self.parent.mapIconModel.firstLoading = false
        
//        if parent.selectedAirport {
//            if mapView.region.span.longitudeDelta < 30 && mapView.region.span.latitudeDelta < 30 {
//
//                var containAnnotation = false
//
//                for item in parent.airportArr {
//                    if mapView.view(for: item) != nil {
//                        containAnnotation = true
//                        break
//                    }
//                }
//
//                if !containAnnotation {
//                    mapView.addAnnotations(parent.airportArr)
//                }
//            } else {
//                mapView.removeAnnotations(parent.airportArr)
//            }
//        } else {
//            mapView.removeAnnotations(parent.airportArr)
//        }

//        if parent.selectedWaypoint {
//            if mapView.region.span.longitudeDelta < 10 && mapView.region.span.latitudeDelta < 10 {
//
//                var containAnnotation = false
//
//                for item in parent.waypointArr {
//                    if mapView.view(for: item) != nil {
//                        containAnnotation = true
//                        break
//                    }
//                }
//
//                if !containAnnotation {
//                    mapView.addAnnotations(parent.waypointArr)
//                }
//            } else {
//                mapView.removeAnnotations(parent.waypointArr)
//            }
//        } else {
//            mapView.removeAnnotations(parent.waypointArr)
//        }
        
//        if parent.selectedTraffic {
//            if mapView.region.span.longitudeDelta < 80 && mapView.region.span.latitudeDelta < 80 {
//
//                var containAnnotation = false
//
//                for item in parent.mapTraffic {
//                    if mapView.view(for: item) != nil {
//                        containAnnotation = true
//                        break
//                    }
//                }
//
//                if !containAnnotation {
//                    mapView.addAnnotations(parent.mapTraffic)
//                }
//            } else {
//                mapView.removeAnnotations(parent.mapTraffic)
//            }
//        } else {
//            mapView.removeAnnotations(parent.mapTraffic)
//        }
//
//        if parent.selectedAABBA {
//            var containAnnotation = false
//
//            for item in parent.mapAabba {
//                if mapView.view(for: item) != nil {
//                    containAnnotation = true
//                    break
//                }
//            }
//
//            if !containAnnotation {
//                mapView.addAnnotations(parent.mapAabba)
//            }
//        } else {
//            mapView.removeAnnotations(parent.mapAabba)
//        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Create an annotation view
        if annotation is CustomRouteAnnotation {
            let annotationView = CustomRouteAnnotationView(annotation: annotation, reuseIdentifier: "CustomRouteAnnotationView")
            annotationView.canShowCallout = false

//            let customView = MapCardView()
//            let callout = MapCalloutView(rootView: AnyView(customView))
//            annotationView.detailCalloutAccessoryView = callout
            
            // Add Title beside icons
            let annotationLabel = UILabel(frame: CGRect(x: 15, y: -8, width: 105, height: 30))
            annotationLabel.numberOfLines = 1
            annotationLabel.textAlignment = .left
            annotationLabel.text = annotation.title!!
            annotationLabel.textColor = UIColor(Color.theme.azure)
            annotationLabel.font = UIFont.systemFont(ofSize: 10)
            
            annotationView.addSubview(annotationLabel)
            
            return annotationView
        } else if annotation is CustomTrafficAnnotation {
            guard let dataAnnotation = annotation as? CustomTrafficAnnotation else { return nil }
            let annotationView = CustomTrafficAnnotationView(annotation: annotation, reuseIdentifier: "CustomTrafficAnnotationView")
            let annotationData = annotation as? CustomTrafficAnnotation
            let customView = MapTrafficCardView(title: annotationData?.flightNum as? String, aircraftType: annotationData?.aircraftType as? String, baroAltitude: annotationData?.baroAltitude as? String)
            let callout = MapCalloutView(rootView: AnyView(customView))

            annotationView.detailCalloutAccessoryView = callout
            annotationView.canShowCallout = true
            
            if dataAnnotation.colour == "dark" {
                annotationView.updateImge(image: UIImage(named: "icon_airplane_blue"))
            } else if dataAnnotation.colour == "medium" {
                annotationView.updateImge(image: UIImage(named: "icon_airplane_medium"))
            } else if dataAnnotation.colour == "light" {
                annotationView.updateImge(image: UIImage(named: "icon_airplane_light"))
            } else {
                annotationView.updateImge(image: UIImage(named: "icon_airplane_orange"))
            }
            
            annotationView.imageView?.transform = CGAffineTransform(rotationAngle: (annotation.subtitle!! as NSString).doubleValue)
//            annotationView.rotationAngle = CGFloat((annotation.subtitle!! as NSString).doubleValue)
            return annotationView
        } else if annotation is CustomAabbaAnnotation {
            let annotationView = CustomAabbaAnnotationView(annotation: annotation, reuseIdentifier: "CustomAabbaAnnotationView")
            
            let width: CGFloat = 29.0
            let height: CGFloat = 29.0
            let selectedAnnotation = annotationView.annotation
            
            let annotationLabel = UILabel()
            annotationLabel.text = selectedAnnotation?.title ?? ""
            annotationLabel.textColor = .black
            annotationLabel.textAlignment = .center
            annotationLabel.font = UIFont.systemFont(ofSize: 14.0)
            annotationLabel.bounds = CGRectMake(0.0, 0.0, width, height)
            annotationLabel.layer.cornerRadius = 16
            annotationLabel.layer.borderWidth = 2.0
            annotationLabel.layer.backgroundColor = UIColor.white.cgColor
            annotationLabel.layer.borderColor = UIColor.black.cgColor
            
            annotationView.centerOffset.x = -30
            annotationView.addSubview(annotationLabel)
            
            let index = (annotation as! CustomAabbaAnnotation).index ?? 0
            
            if parent.dataAabbaMap.count > 0 {
                let customView = MapCardView(payload: parent.dataAabbaMap[index], parentAabbaIndex: index)
                
                let callout = MapCalloutView(rootView: AnyView(customView))
                
                annotationView.detailCalloutAccessoryView = callout
                
                annotationView.canShowCallout = true
            }
            return annotationView
        } else if annotation is CustomWaypointAnnotation {
            let annotationView = CustomWaypointAnnotationView(annotation: annotation, reuseIdentifier: "CustomWaypointAnnotationView")
            let annotationLabel = UILabel(frame: CGRect(x: 15, y: -8, width: 105, height: 30))
            annotationLabel.numberOfLines = 1
            annotationLabel.textAlignment = .left
            annotationLabel.text = annotation.title!!
            annotationLabel.font = UIFont.systemFont(ofSize: 10)
            
            annotationView.addSubview(annotationLabel)
            return annotationView
        }  else if annotation is CustomAirportColorAnnotation {
            let annotationView = CustomAirportColorAnnotationView(annotation: annotation, reuseIdentifier: "CustomAirportColorAnnotationView")
            annotationView.canShowCallout = false
            
            // Add Title beside icons
            let annotationLabel = UILabel(frame: CGRect(x: 15, y: -8, width: 105, height: 30))
            annotationLabel.numberOfLines = 1
            annotationLabel.textAlignment = .left
            annotationLabel.text = annotation.title!!
            annotationLabel.font = UIFont.systemFont(ofSize: 10)
            
            annotationView.addSubview(annotationLabel)
            
            return annotationView
        } else {
            let annotationView = CustomAirportAnnotationView(annotation: annotation, reuseIdentifier: "CustomAirportAnnotationView")
            annotationView.canShowCallout = false
            
            // Add Title beside icons
            let annotationLabel = UILabel(frame: CGRect(x: 15, y: -8, width: 105, height: 30))
            annotationLabel.numberOfLines = 1
            annotationLabel.textAlignment = .left
            annotationLabel.text = annotation.title!!
            annotationLabel.font = UIFont.systemFont(ofSize: 10)
            
//            let customView = MapAirportCardView(coreDataModel: parent.coreDataModel, notamSection: parent.notamSection).environmentObject(CoreDataModelState())
//
//            let callout = MapCalloutView(rootView: AnyView(customView))
//            let uiView = UIHostingController(rootView: customView).view
            
            annotationView.addSubview(annotationLabel)
//            annotationView.detailCalloutAccessoryView = callout
            
            return annotationView
        }
    }
    
    // For selected annotation
    @MainActor func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view is CustomAabbaAnnotationView {
            let annotationView = view.annotation as? CustomAabbaAnnotation
            annotationView?.setValue("", forKey: "title")
        } else if view is CustomAirportColorAnnotationView {
            let annotationView = view.annotation as? CustomAirportColorAnnotation
            parent.mapIconModel.showModal = true
            parent.mapIconModel.titleModal = annotationView?.title ?? ""
            parent.mapIconModel.airportSelected = annotationView?.item 
        } else if view is CustomTrafficAnnotationView {
            let annotationView = view.annotation as? CustomTrafficAnnotation
            let customView = view.annotation as? CustomTrafficAnnotationView
//            view.image?.renderingMode(.template)
//            view.image?.foregroundColor(Color.theme.azure)
            
        }
    }
    
//    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
//        let clicked = UITapGestureRecognizer(target: self, action: "showDisplay:")
//        mapView.addGestureRecognizer(clicked)
//    }
//
//    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
//        let clicked = UITapGestureRecognizer(target: self, action: "showDisplay:")
//        mapView.removeGestureRecognizer(clicked)
//    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MapOverlay {
            return MapOverlayView(
                overlay: overlay,
                overlayImage: parent.coreDataModel.image
            )
        } else if let routePolyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: routePolyline)
            renderer.strokeColor = UIColor(Color.theme.azure)
            renderer.lineWidth = 1
            return renderer
        } else if let character = overlay as? CircleAnnotation {
            let circleView = MKCircleRenderer(overlay: character)
            circleView.fillColor = character.color
            circleView.strokeColor = character.color
            return circleView
        }
        return MKOverlayRenderer()
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.parent.isLoading = false
        }
    }
}
