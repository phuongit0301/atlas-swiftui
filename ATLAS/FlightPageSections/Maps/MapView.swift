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
                                                    .font(.system(size: 15)).frame(maxWidth: .infinity)
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
//        mapView.showsTraffic = selectedTraffic
      if selectedAddRoute { addRoute() }
      if selectedWeather { addOverlay() }
      if selectedWaypoint { addWaypoint() }
      if selectedAirport { addAirport() }
//      if mapRoute { addRoute() }
    }
    
    func addOverlay() {
        let overlay = MapOverlay(worldMap: worldMap)
        mapView.addOverlay(overlay)
    }
    
    func addRoute() {
        let polyline = MKPolyline(coordinates: coreDataModel.lineCoordinates, count: coreDataModel.lineCoordinates.count)
        mapView.addOverlay(polyline)
    }
    
    func addWaypoint() {
        for item in coreDataModel.dataWaypointMap {
            let coord = CLLocationCoordinate2D(latitude: (item.latitude! as NSString).doubleValue, longitude: (item.longitude! as NSString).doubleValue)
            
            let annotation = CustomAnnotation(coordinate: coord, title: item.name, subtitle: "", image: UIImage(systemName: "triangle.inset.filled"))
            
            mapView.addAnnotation(annotation)
        }
    }
    
    func addAirport() {
        for item in coreDataModel.dataAirportMap {
            mapView.addOverlay(CircleAnnotation(latitude: (item.unwrappedLatitude as NSString).doubleValue, longitude: (item.unwrappedLongitude as NSString).doubleValue, name: item.unwrappedName, color: .red))
        }
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
        
//        for item in dataWaypointMap {
//            let coord = CLLocationCoordinate2D(latitude: (item.latitude! as NSString).doubleValue, longitude: (item.longitude! as NSString).doubleValue)
//
//            let annotation = CustomAnnotation(coordinate: coord, title: item.name, subtitle: "", image: UIImage(systemName: "triangle.inset.filled"))
//
//            mapView.addAnnotation(annotation)
//        }
//        let overlay = MapOverlay(worldMap: worldMap)
//        mapView.addOverlay(overlay)
        
//        let polyline = MKPolyline(coordinates: lineCoordinates, count: lineCoordinates.count)
//        mapView.addOverlay(polyline)
        
        mapView.delegate = context.coordinator
        mapView.userTrackingMode = MKUserTrackingMode.follow
        
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        view.showsUserLocation = true
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
        let annotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: "Custom")
        
        annotationView.tintColor = UIColor.red
        annotationView.canShowCallout = true
        return annotationView
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MapOverlay {
            return MapOverlayView(
                overlay: overlay,
                overlayImage: parent.coreDataModel.image
            )
        } else if let routePolyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: routePolyline)
            renderer.strokeColor = UIColor.black
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
