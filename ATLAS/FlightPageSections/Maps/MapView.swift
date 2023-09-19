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
    @State private var mapType: MKMapType = .mutedStandard
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
    
    //Variable for verify data exists in Route Direction or not
    @State private var routeDatas = [SRoute]()

    var body: some View {
        VStack {
            if coreDataModel.imageLoading {
                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.white)).padding(.leading)
            } else {
                ZStack(alignment: .top) {
                    MapView(
                        region: coreDataModel.region,
                        lineCoordinates: coreDataModel.lineCoordinates,
                        dataWaypointMap: coreDataModel.dataWaypointMap,
                        dataAabbaMap: coreDataModel.dataAabbaMap,
                        currentLocation: locationViewModel.currentLocation,
                        mapType: mapType
                    ).overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.theme.azure, lineWidth: 0))
                        .cornerRadius(8)
                    
                    VStack {
                        HStack(alignment: .top) {
                            Button(action: {
                                self.showRoute.toggle()
                                self.showLayer = false
                            }, label: {
                                HStack {
                                    Text("SIN - BER")
                                        .font(.system(size: 17, weight: .semibold)).foregroundColor(showRoute ? Color.white : Color.black)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal)
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
                                                Text("Enter Route")
                                                    .font(.system(size: 15, weight: .semibold)).foregroundColor(Color.black)
                                                    .padding(.vertical, 8)
                                                
                                                Divider().padding(.horizontal, -16)
                                                
                                                TextField("Enter waypoint(s) route must pass through", text: $tfRoute)
                                                    .font(.system(size: 15))
                                                    .onSubmit {
                                                        if tfRoute != "" {
                                                            selectedAddRoute = true
                                                            updateMapOverlayViews()
                                                        } else {
                                                            selectedAddRoute = false
                                                            routeDatas = []
                                                            updateMapOverlayViews()
                                                        }
                                                    }
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
                                                self.selectedTraffic.toggle()
                                                self.updateMapOverlayViews()
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
                                                self.selectedWeather.toggle()
                                                self.updateMapOverlayViews()
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
                                                self.selectedAABBA.toggle()
                                                self.updateMapOverlayViews()
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
                                            
                                            Button(action: {
                                                self.selectedWaypoint.toggle()
                                                self.updateMapOverlayViews()
                                            }, label: {
                                                HStack {
                                                    Image(systemName: "checkmark")
                                                        .foregroundColor(Color.theme.azure.opacity(self.selectedWaypoint ? 1 : 0))
                                                        .scaledToFit()
                                                        .aspectRatio(contentMode: .fit)
                                                    
                                                    Text("Waypoint").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.theme.azure)
                                                }.frame(maxWidth: .infinity, alignment: .leading)
                                            }).buttonStyle(PlainButtonStyle())
                                            
                                            Divider().padding(.horizontal, -16)
                                            
                                            Button(action: {
                                                self.selectedAirport.toggle()
                                                self.updateMapOverlayViews()
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
            }
        }.onAppear {
            updateMapOverlayViews()
        }.onChange(of: mapIconModel.num) { _ in
            coreDataModel.dataAabbaMap = coreDataModel.readDataAabbaMapList()
        }
    }
    
    func updateMapOverlayViews() {
      mapView.removeAnnotations(mapView.annotations)
      mapView.removeOverlays(mapView.overlays)

      if selectedWeather { addOverlay() }
      if selectedAddRoute { addRoute() }
      if selectedWaypoint { addWaypoint() }
      if selectedAirport { addAirportColor() }
      if selectedTraffic { addTraffic() }
      if selectedAABBA { addAabba() }
    }
    
    func addOverlay() {
        let overlay = MapOverlay(worldMap: worldMap)
        mapView.addOverlay(overlay)
    }
    
    func addRoute() {
        let payload = extractFiveLetterWords(from: tfRoute)
        var dataWaypoint: [String] = []
        var locationCoordinate = [CLLocationCoordinate2D]()
        
        //get start and end route
        let departureLatLong = extractLatLong(forSelection: "departure", inDictionaries: coreDataModel.dataAirportColorMap)
        let arrivalLatLong = extractLatLong(forSelection: "arrival", inDictionaries: coreDataModel.dataAirportColorMap)
        
        let firstCoord = CLLocationCoordinate2D(latitude: departureLatLong["latitude"]! as! CLLocationDegrees, longitude: departureLatLong["longitude"]! as! CLLocationDegrees)
        let firstImage = UIImage(named: "icon_circle_fill_blue")
//        let firstColorName = departureLatLong["colour"] as? String ?? "black"
        
//        if firstColorName.lowercased() == "green" {
//            firstImage = UIImage(named: "icon_circle_green")
//        } else if firstColorName.lowercased() == "amber" {
//            firstImage = UIImage(named: "icon_circle_amber")
//        } else if firstColorName.lowercased() == "red" {
//            firstImage = UIImage(named: "icon_circle_red")
//        }
        
        let firstAnnotation = CustomRouteAnnotation(coordinate: firstCoord, title: (departureLatLong["name"] as? String)!.trimmingCharacters(in: .whitespacesAndNewlines), subtitle: "", image: firstImage)
        locationCoordinate.append(firstCoord)
        mapView.addAnnotation(firstAnnotation)
        
        //Append data to route
        routeDatas.append(SRoute(name: (departureLatLong["name"] as? String)!.trimmingCharacters(in: .whitespacesAndNewlines), latitude: departureLatLong["latitude"] as? String ?? "0", longitude: departureLatLong["longitude"] as? String ?? "0"))
        
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
        routeDatas.append(SRoute(name: (arrivalLatLong["name"] as? String)!.trimmingCharacters(in: .whitespacesAndNewlines), latitude: arrivalLatLong["latitude"] as? String ?? "0", longitude: arrivalLatLong["longitude"] as? String ?? "0"))
        
        let polyline = MKPolyline(coordinates: locationCoordinate, count: locationCoordinate.count)
        mapView.addOverlay(polyline)
        
        mapIconModel.dataWaypoint = dataWaypoint
    }
    
    func addWaypoint() {
        for item in coreDataModel.dataWaypointMap {
            if routeDatas.count > 0 {
                let itemExist = routeDatas.first(where: {$0.name == item.unwrappedName && $0.latitude == item.unwrappedLatitude && $0.longitude == item.unwrappedLongitude})
                
                if (itemExist == nil) {
                    let coord = CLLocationCoordinate2D(latitude: (item.latitude! as NSString).doubleValue, longitude: (item.longitude! as NSString).doubleValue)
                    
                    let annotation = CustomWaypointAnnotation(coordinate: coord, title: item.name!.trimmingCharacters(in: .whitespacesAndNewlines), subtitle: "", image: UIImage(named: "icon_triangle"))
                    
                    mapView.addAnnotation(annotation)
                }
            } else {
                let coord = CLLocationCoordinate2D(latitude: (item.latitude! as NSString).doubleValue, longitude: (item.longitude! as NSString).doubleValue)
                
                let annotation = CustomWaypointAnnotation(coordinate: coord, title: item.name!.trimmingCharacters(in: .whitespacesAndNewlines), subtitle: "", image: UIImage(named: "icon_triangle"))
                
                mapView.addAnnotation(annotation)
            }
        }
    }
    
    func addAirport(_ airportIds: [String]) {
        for item in coreDataModel.dataAirportMap {
            if airportIds.count > 0 && item.unwrappedName != "" {
                if !airportIds.contains(item.unwrappedName) {
                    let coord = CLLocationCoordinate2D(latitude: (item.unwrappedLatitude as NSString).doubleValue, longitude: (item.unwrappedLongitude as NSString).doubleValue)
                    
                    let annotation = CustomAirportAnnotation(coordinate: coord, title: item.name!.trimmingCharacters(in: .whitespacesAndNewlines), subtitle: "", image: UIImage(named: "icon_circle_unfilled"))
                    
                    mapView.addAnnotation(annotation)
                }
                
            }
            
        }
    }
    
    func addAirportColor() {
        var airportIds = [String]()
        
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
            
            let annotation = CustomAnnotation(coordinate: coord, title: item.airportId!.trimmingCharacters(in: .whitespacesAndNewlines), subtitle: "", image: image)
            
            if let id = item.airportId {
                airportIds.append(id)
            }
            
            mapView.addAnnotation(annotation)
        }
        
        addAirport(airportIds)
    }
    
    func addTraffic() {
        for item in coreDataModel.dataTrafficMap {
            let coord = CLLocationCoordinate2D(latitude: (item.latitude! as NSString).doubleValue, longitude: (item.longitude! as NSString).doubleValue)
            var defaultImage = UIImage(named: "icon_airplane_orange")
            
            if item.colour == "unfilled" {
                defaultImage = UIImage(named: "icon_airplane_unfilled_orange")
            }
            let annotation = CustomTrafficAnnotation(coordinate: coord, title: item.unwrappedCallsign, subtitle: item.trueTrack, image: defaultImage, rotationAngle: CGFloat((item.trueTrack! as NSString).doubleValue))
            mapView.addAnnotation(annotation)
        }
    }
    
    func addAabba() {
//        var defaultImage = UIImage(named: "icon_weather_overlay")
        
        for(index, item) in coreDataModel.dataAabbaMap.enumerated() {
            let coord = CLLocationCoordinate2D(latitude: (item.unwrappedLatitude as NSString).doubleValue, longitude: (item.unwrappedLongitude as NSString).doubleValue)

            let annotation = CustomAabbaAnnotation(coordinate: coord, title: String(item.postCount), subtitle: "", index: index)

            mapView.addAnnotation(annotation)
        }
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
    @EnvironmentObject var coreDataModel: CoreDataModelState
    
    func makeUIView(context: Context) -> MKMapView {
//        let mapView = MKMapView()
        mapView.mapType = mapType
//        mapView.region = region
        mapView.setRegion(region, animated: true)
        
        mapView.showsUserLocation = false
        mapView.showsScale = true
        mapView.showsTraffic = true
        
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: "CustomAnnotationView")
        mapView.register(CustomRouteAnnotationView.self, forAnnotationViewWithReuseIdentifier: "CustomRouteAnnotationView")
        mapView.register(CustomTrafficAnnotationView.self, forAnnotationViewWithReuseIdentifier: "CustomTrafficAnnotationView")
        mapView.register(CustomAabbaAnnotationView.self, forAnnotationViewWithReuseIdentifier: "CustomAabbaAnnotationView")
        mapView.register(CustomWaypointAnnotationView.self, forAnnotationViewWithReuseIdentifier: "CustomWaypointAnnotationView")
        mapView.register(CustomAirportAnnotationView.self, forAnnotationViewWithReuseIdentifier: "CustomAirportAnnotationView")
        mapView.delegate = context.coordinator
        mapView.userTrackingMode = MKUserTrackingMode.follow
        
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
//        view.showsUserLocation = true
        view.setCenter(currentLocation, animated: true)
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
            let annotationView = CustomTrafficAnnotationView(annotation: annotation, reuseIdentifier: "CustomTrafficAnnotationView")
            annotationView.canShowCallout = true
            annotationView.rotationAngle = CGFloat((annotation.subtitle!! as NSString).doubleValue)
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

            annotationView.addSubview(annotationLabel)
            
            let index = (annotation as! CustomAabbaAnnotation).index ?? 0
            let itemAabba = parent.dataAabbaMap[index]

            let customView = MapCardView(payload: itemAabba, parentAabbaIndex: index)

            let callout = MapCalloutView(rootView: AnyView(customView))

            annotationView.detailCalloutAccessoryView = callout
            
            annotationView.canShowCallout = true
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
        }  else if annotation is CustomAirportAnnotation {
            let annotationView = CustomAirportAnnotationView(annotation: annotation, reuseIdentifier: "CustomAirportAnnotationView")
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
            let annotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: "CustomAnnotationView")
            annotationView.canShowCallout = true
            
            // Add Title beside icons
            let annotationLabel = UILabel(frame: CGRect(x: 15, y: -8, width: 105, height: 30))
            annotationLabel.numberOfLines = 1
            annotationLabel.textAlignment = .left
            annotationLabel.text = annotation.title!!
            annotationLabel.font = UIFont.systemFont(ofSize: 10)
            
            annotationView.addSubview(annotationLabel)
            
            return annotationView
        }
    }
    
    // For selected annotation
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // Calculate the angle by which the annotation view is rotated
        if view is CustomTrafficAnnotationView {
            let annotation = view.annotation as? CustomTrafficAnnotation
            
//            let calloutOffset = CGPoint(x: view.frame.midX, y: view.frame.midY)
            // Calculate the angle by which the annotation view is rotated
            let rotationAngle = annotation?.rotationAngle
            // Apply the inverse rotation to the callout view
            let calloutOffset = CGPoint(x: -sin(rotationAngle!) * view.frame.midX, y: -cos(rotationAngle!) * view.frame.midY)
                                                    
            view.calloutOffset = calloutOffset
            view.detailCalloutAccessoryView?.transform = CGAffineTransform(rotationAngle: CGFloat(90 * 3.14 / 180))
            // Adjust the transform of the callout view to cancel the annotation rotation
//            view.transform = CGAffineTransform(rotationAngle: CGFloat(90 * 3.14 / 180))
        } else if view is CustomAabbaAnnotationView {
            let annotationView = view.annotation as? CustomAabbaAnnotation
            annotationView?.setValue("", forKey: "title")
            
//            let itemAabba = parent.dataAabbaMap[annotationView?.index ?? 0]
//
//            let customView = MapCardView(payload: itemAabba)
//
//            let callout = MapCalloutView(rootView: AnyView(customView))
////            annotation.setValue(<#T##Any?#>, forKey: <#T##String#>)
//            view.detailCalloutAccessoryView = callout
        }
//
//
//        let rotationAngle = annotationView.rotate
//
//        // Apply the inverse rotation to the callout view
//        view.calloutOffset = CGPoint(x: -sin(rotationAngle) * calloutOffset, y: -cos(rotationAngle) * calloutOffset)
//
//        // Adjust the transform of the callout view to cancel the annotation rotation
//        view.calloutView?.transform = CGAffineTransform(rotationAngle: -rotationAngle)
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
}
