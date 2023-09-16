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

struct MapViewModal: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @StateObject var locationViewModel = LocationViewModel()
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
    
    @State private var showPopoverEye = false
    @State private var showPopoverWind = false
    @State private var showPopoverWater = false
    @State private var showPopoverAirplane = false
    @State private var showPopoverClock = false
    @State private var showPopoverExclamationMark = false
    @State private var showPopoverInfo = false
    @State private var showPopoverQuestionMark = false

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
                                Text("SIN - BER")
                                    .font(.system(size: 17, weight: .semibold)).foregroundColor(showRoute ? Color.white : Color.black)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal)
                            }).frame(alignment: .center)
                                .background(showRoute ? Color.theme.azure : Color.white)
                                .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.theme.azure, lineWidth: 1))
                                .cornerRadius(24)
                                .buttonStyle(PlainButtonStyle())
                            
                            Button(action: {
                                self.showLayer.toggle()
                                self.showRoute = false
                            }, label: {
                                Image(systemName: "square.3.layers.3d")
                                    .foregroundColor(showLayer ? Color.white : Color.theme.azure)
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fit)
                                    .padding(11)
                            }).frame(width: 44, height: 44, alignment: .center)
                                .background(showLayer ? Color.theme.azure : Color.white)
                                .overlay(RoundedRectangle(cornerRadius: 100).stroke(Color.theme.azure, lineWidth: 1))
                                .cornerRadius(100)
                                .buttonStyle(PlainButtonStyle())
                            
                            Spacer()
                            
                            Button(action: {
                                self.showIcon.toggle()
                            }, label: {
                                Image(systemName: "plus")
                                    .foregroundColor(Color.white)
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fit)
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
                                                }
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
                                                }
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
                                                }
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
                                                }
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
                                                }
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
                                            self.showPopoverEye.toggle()
                                        }, label: {
                                            Image(systemName: "eye.trianglebadge.exclamationmark")
                                                .foregroundColor(Color.theme.tangerineYellow)
                                                .scaledToFit()
                                                .aspectRatio(contentMode: .fit)
                                        }).buttonStyle(PlainButtonStyle())
                                            .frame(width: 40, height: 40, alignment: .center)
                                            .background(Color.theme.tangerineYellow.opacity(0.15))
                                            .overlay(RoundedRectangle(cornerRadius: 100).stroke(Color.theme.tangerineYellow, lineWidth: 0))
                                            .cornerRadius(100)
                                            .popover(isPresented: $showPopoverEye) {
                                                VStack {
                                                    Text("Eye").foregroundColor(Color.black)
                                                }.frame(width: 318, height: 318)
                                                
                                            }
                                        
                                        Button(action: {
                                            self.showPopoverWind.toggle()
                                        }, label: {
                                            Image(systemName: "wind")
                                                .foregroundColor(Color.theme.blueJeans)
                                                .scaledToFit()
                                                .aspectRatio(contentMode: .fit)
                                        }).buttonStyle(PlainButtonStyle())
                                            .frame(width: 40, height: 40, alignment: .center)
                                            .background(Color.theme.blueJeans.opacity(0.15))
                                            .overlay(RoundedRectangle(cornerRadius: 100).stroke(Color.theme.blueJeans, lineWidth: 0))
                                            .cornerRadius(100)
                                            .popover(isPresented: $showPopoverWind) {
                                                VStack {
                                                    Text("Wind").foregroundColor(Color.black)
                                                }.frame(width: 318, height: 318)
                                            }
                                        
                                        Button(action: {
                                            self.showPopoverWater.toggle()
                                        }, label: {
                                            Image(systemName: "water.waves")
                                                .foregroundColor(Color.theme.coralRed1)
                                                .scaledToFit()
                                                .aspectRatio(contentMode: .fit)
                                        }).buttonStyle(PlainButtonStyle())
                                            .frame(width: 40, height: 40, alignment: .center)
                                            .background(Color.theme.coralRed1.opacity(0.15))
                                            .overlay(RoundedRectangle(cornerRadius: 100).stroke(Color.theme.coralRed1, lineWidth: 0))
                                            .cornerRadius(100)
                                            .popover(isPresented: $showPopoverWater) {
                                                VStack {
                                                    Text("Water").foregroundColor(Color.black)
                                                }.frame(width: 318, height: 318)
                                            }
                                        
                                        Button(action: {
                                            self.showPopoverAirplane.toggle()
                                        }, label: {
                                            Image(systemName: "airplane.arrival")
                                                .foregroundColor(Color.theme.vividGamboge)
                                                .scaledToFit()
                                                .aspectRatio(contentMode: .fit)
                                        }).buttonStyle(PlainButtonStyle())
                                            .frame(width: 40, height: 40, alignment: .center)
                                            .background(Color.theme.vividGamboge.opacity(0.15))
                                            .overlay(RoundedRectangle(cornerRadius: 100).stroke(Color.theme.vividGamboge, lineWidth: 0))
                                            .cornerRadius(100)
                                            .popover(isPresented: $showPopoverAirplane) {
                                                VStack {
                                                    Text("Airplane").foregroundColor(Color.black)
                                                }.frame(width: 318, height: 318)
                                            }
                                        
                                        Button(action: {
                                            self.showPopoverClock.toggle()
                                        }, label: {
                                            Image(systemName: "clock.badge.exclamationmark.fill")
                                                .foregroundColor(Color.theme.cafeAuLait)
                                                .scaledToFit()
                                                .aspectRatio(contentMode: .fit)
                                        }).buttonStyle(PlainButtonStyle())
                                            .frame(width: 40, height: 40, alignment: .center)
                                            .background(Color.theme.cafeAuLait.opacity(0.15))
                                            .overlay(RoundedRectangle(cornerRadius: 100).stroke(Color.theme.cafeAuLait, lineWidth: 0))
                                            .cornerRadius(100)
                                            .popover(isPresented: $showPopoverClock) {
                                                VStack {
                                                    Text("Airplane").foregroundColor(Color.black)
                                                }.frame(width: 318, height: 318)
                                            }
                                        
                                        Button(action: {
                                            self.showPopoverExclamationMark.toggle()
                                        }, label: {
                                            Image(systemName: "exclamationmark.triangle")
                                                .foregroundColor(Color.theme.coralRed1)
                                                .scaledToFit()
                                                .aspectRatio(contentMode: .fit)
                                        }).buttonStyle(PlainButtonStyle())
                                            .frame(width: 40, height: 40, alignment: .center)
                                            .background(Color.theme.coralRed1.opacity(0.15))
                                            .overlay(RoundedRectangle(cornerRadius: 100).stroke(Color.theme.coralRed1, lineWidth: 0))
                                            .cornerRadius(100)
                                            .popover(isPresented: $showPopoverExclamationMark) {
                                                VStack {
                                                    Text("ExclamationMark").foregroundColor(Color.black)
                                                }.frame(width: 318, height: 318)
                                            }
                                        
                                        Button(action: {
                                            self.showPopoverInfo.toggle()
                                        }, label: {
                                            Image(systemName: "info.bubble")
                                                .foregroundColor(Color.theme.iris)
                                                .scaledToFit()
                                                .aspectRatio(contentMode: .fit)
                                        }).buttonStyle(PlainButtonStyle())
                                            .frame(width: 40, height: 40, alignment: .center)
                                            .background(Color.theme.iris.opacity(0.15))
                                            .overlay(RoundedRectangle(cornerRadius: 100).stroke(Color.theme.iris, lineWidth: 0))
                                            .cornerRadius(100)
                                            .popover(isPresented: $showPopoverInfo) {
                                                VStack {
                                                    Text("Info").foregroundColor(Color.black)
                                                }.frame(width: 318, height: 318)
                                            }
                                        
                                        Button(action: {
                                            self.showPopoverQuestionMark.toggle()
                                        }, label: {
                                            Image(systemName: "questionmark.bubble")
                                                .foregroundColor(Color.theme.mediumOrchid)
                                                .scaledToFit()
                                                .aspectRatio(contentMode: .fit)
                                        }).buttonStyle(PlainButtonStyle())
                                            .frame(width: 40, height: 40, alignment: .center)
                                            .background(Color.theme.mediumOrchid.opacity(0.15))
                                            .overlay(RoundedRectangle(cornerRadius: 100).stroke(Color.theme.mediumOrchid, lineWidth: 0))
                                            .cornerRadius(100)
                                            .popover(isPresented: $showPopoverQuestionMark) {
                                                VStack {
                                                    Text("Info").foregroundColor(Color.black)
                                                }.frame(width: 318, height: 318)
                                            }
                                        
                                    }.padding(.vertical, 8)
                                        .padding(.horizontal, 4)
                                        .frame(width: 48)
                                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 40))
                                        .overlay(RoundedRectangle(cornerRadius: 40).stroke(Color.white, lineWidth: 0))
                                        .cornerRadius(40)
                                }
                            }
                            
                        }
                        
                    }// End VStack
                    .padding()
                    
                }.padding()
            }
        }.onAppear {
            updateMapOverlayViews()
        }
    }
    
    func updateMapOverlayViews() {
      mapView.removeAnnotations(mapView.annotations)
      mapView.removeOverlays(mapView.overlays)

      if selectedWeather { addOverlay() }
      if selectedWaypoint { addWaypoint() }
      if selectedAirport { addAirportColor() }
      if selectedTraffic { addTraffic() }
      if selectedAABBA { addAabba() }
      if selectedAddRoute { addRoute() }
    }
    
    func addOverlay() {
        let overlay = MapOverlay(worldMap: worldMap)
        mapView.addOverlay(overlay)
    }
    
    func addRoute() {
        let payload = extractFiveLetterWords(from: tfRoute)
        
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
        
        for item in payload {
            if let itemExists = coreDataModel.dataWaypointMap.first(where: {$0.unwrappedName == item}) {
                let coord = CLLocationCoordinate2D(latitude: (itemExists.latitude! as NSString).doubleValue, longitude: (itemExists.longitude! as NSString).doubleValue)
                let annotation = CustomRouteAnnotation(coordinate: coord, title: itemExists.name!.trimmingCharacters(in: .whitespacesAndNewlines), subtitle: "", image: UIImage(named: "icon_triangle_fill_blue"))
                
                locationCoordinate.append(coord)
                mapView.addAnnotation(annotation)
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
        
        let polyline = MKPolyline(coordinates: locationCoordinate, count: locationCoordinate.count)
        mapView.addOverlay(polyline)
    }
    
    func addWaypoint() {
        for item in coreDataModel.dataWaypointMap {
            let coord = CLLocationCoordinate2D(latitude: (item.latitude! as NSString).doubleValue, longitude: (item.longitude! as NSString).doubleValue)
            
            let annotation = CustomAnnotation(coordinate: coord, title: item.name!.trimmingCharacters(in: .whitespacesAndNewlines), subtitle: "", image: UIImage(named: "icon_triangle"))
            
            mapView.addAnnotation(annotation)
        }
    }
    
    func addAirport(_ airportIds: [String]) {
        for item in coreDataModel.dataAirportMap {
            if airportIds.count > 0 && item.unwrappedName != "" {
                if !airportIds.contains(item.unwrappedName) {
                    let coord = CLLocationCoordinate2D(latitude: (item.unwrappedLatitude as NSString).doubleValue, longitude: (item.unwrappedLongitude as NSString).doubleValue)
                    
                    let annotation = CustomAnnotation(coordinate: coord, title: item.name!.trimmingCharacters(in: .whitespacesAndNewlines), subtitle: "", image: UIImage(named: "icon_circle_unfilled"))
                    
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
            let annotation = CustomTrafficAnnotation(coordinate: coord, title: item.unwrappedCallsign, subtitle: item.trueTrack, image: defaultImage)
            mapView.addAnnotation(annotation)
        }
    }
    
    func addAabba() {
        var defaultImage = UIImage(named: "icon_weather_overlay")
        
        for item in coreDataModel.dataAabbaMap {
            if item.unwrappedCategory == "Turbulence" {
                defaultImage = UIImage(named: "icon_turbulence_overlay")
            } else if item.unwrappedCategory == "Visibility" {
                defaultImage = UIImage(named: "icon_visibility_overlay")
            } else if item.unwrappedCategory == "Wind" {
                defaultImage = UIImage(named: "icon_wind_overlay")
            } else if item.unwrappedCategory == "Runway" {
                defaultImage = UIImage(named: "icon_runway_overlay")
            } else if item.unwrappedCategory == "Congestion" {
                defaultImage = UIImage(named: "icon_congestion_overlay")
            } else if item.unwrappedCategory == "Hazard" {
                defaultImage = UIImage(named: "icon_hazard_overlay")
            } else if item.unwrappedCategory == "General" {
                defaultImage = UIImage(named: "icon_general_overlay")
            } else if item.unwrappedCategory == "Ask AABBA" {
                defaultImage = UIImage(named: "icon_ask_overlay")
            }
            
            let coord = CLLocationCoordinate2D(latitude: (item.latitude! as NSString).doubleValue, longitude: (item.longitude! as NSString).doubleValue)
            
            let annotation = CustomAabbaAnnotation(coordinate: coord, title: item.unwrappedPostTitle, subtitle: "", image: defaultImage)
            
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
            annotationView.canShowCallout = true

            let customView = MapCardView()
            let callout = MapCalloutView(rootView: AnyView(customView))
            annotationView.detailCalloutAccessoryView = callout
            
            // Add Title beside icons
            let annotationLabel = UILabel(frame: CGRect(x: 15, y: 0, width: 105, height: 30))
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
            annotationView.transform = CGAffineTransform(rotationAngle: CGFloat((annotation.subtitle!! as NSString).doubleValue))
            return annotationView
        } else if annotation is CustomAabbaAnnotation {
            let annotationView = CustomAabbaAnnotationView(annotation: annotation, reuseIdentifier: "CustomAabbaAnnotationView")
            annotationView.canShowCallout = true
            annotationView.transform = CGAffineTransform(rotationAngle: CGFloat((annotation.subtitle!! as NSString).doubleValue))
            return annotationView
        } else {
            let annotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: "CustomAnnotationView")
            annotationView.canShowCallout = true
            
            // Add Title beside icons
            let annotationLabel = UILabel(frame: CGRect(x: 20, y: -5, width: 105, height: 30))
            annotationLabel.numberOfLines = 1
            annotationLabel.textAlignment = .left
            annotationLabel.text = annotation.title!!
            annotationLabel.font = UIFont.systemFont(ofSize: 10)
            
            annotationView.addSubview(annotationLabel)
            
            return annotationView
        }
    }
    
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
