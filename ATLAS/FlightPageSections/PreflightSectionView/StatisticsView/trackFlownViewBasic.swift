//
//  trackFlownView.swift
//  playground_swift
//
//  Created by Muhammad Adil on 26/9/23.
//

//
//  MapView.swift
//  ATLAS
//
//  Created by phuong phan on 22/08/2023.
//

import SwiftUI
import CoreLocation
import MapKit

//let mapView = MKMapView(frame: UIScreen.main.bounds)
//let worldMap = WorldMap(filename: "WorldCoordinates")

//struct SRoute {
//    let name: String
//    let latitude: String
//    let longitude: String
//}

struct MapViewModalTrackFlown: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @StateObject var locationViewModel = LocationViewModel()
    @EnvironmentObject var mapIconModel: MapIconModel
    @State private var mapType: MKMapType = .mutedStandard
    
    private var tfRoute: [TrackFlown] = TrackFlownData  // todo create this coredata
    
    @State private var showLayer = false
    
    @State var selectedRouteFlights3 = true
    @State var selectedRouteFlights2 = true
    @State var selectedRouteFlights1 = true
    @State var selectedWaypoint = true
    
    @State private var isLoading = true
    
    private var routeDatas: [SRoute]
    
    var body: some View {
        VStack {
            if coreDataModel.imageLoading {
                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.white)).padding(.leading)
            } else {
                ZStack(alignment: .top) {
                    MapViewTrackFlown(
                        region: coreDataModel.region,
                        lineCoordinates: coreDataModel.lineCoordinates,
                        dataWaypointMap: coreDataModel.dataWaypointMap,
                        currentLocation: locationViewModel.currentLocation,
                        mapType: mapType,
                        isLoading: isLoading
                    ).overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.theme.azure, lineWidth: 0))
                        .cornerRadius(8)
                    
                    VStack {
                        HStack(alignment: .top) {
                            
                            Button(action: {
                                self.showLayer.toggle()
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
                            
                        }
                        
                        HStack(alignment: .top) {
                            if showLayer {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Group {
                                            Text("Select Layer")
                                                .font(.system(size: 17, weight: .semibold))
                                                .foregroundColor(Color.black)
                                                .padding(.horizontal)
                                            
                                            Divider().padding(.horizontal, -16)
                                            
                                            Button(action: {
                                                self.selectedRouteFlights3.toggle()
                                                self.updateMapOverlayViews()
                                            }, label: {
                                                HStack {
                                                    Image(systemName: "checkmark")
                                                        .foregroundColor(Color.theme.azure.opacity(self.selectedTraffic ? 1 : 0))
                                                        .scaledToFit()
                                                        .aspectRatio(contentMode: .fit)
                                                    
                                                    Text("3 days ago").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.theme.azure)
                                                }.frame(maxWidth: .infinity, alignment: .leading)
                                            })
                                            
                                            Divider().padding(.horizontal, -16)
                                            
                                            Button(action: {
                                                self.selectedRouteFlights2.toggle()
                                                self.updateMapOverlayViews()
                                            }, label: {
                                                HStack {
                                                    Image(systemName: "checkmark")
                                                        .foregroundColor(Color.theme.azure.opacity(self.selectedTraffic ? 1 : 0))
                                                        .scaledToFit()
                                                        .aspectRatio(contentMode: .fit)
                                                    
                                                    Text("2 days ago").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.theme.azure)
                                                }.frame(maxWidth: .infinity, alignment: .leading)
                                            })
                                            
                                            Divider().padding(.horizontal, -16)
                                            
                                            Button(action: {
                                                self.selectedRouteFlights1.toggle()
                                                self.updateMapOverlayViews()
                                            }, label: {
                                                HStack {
                                                    Image(systemName: "checkmark")
                                                        .foregroundColor(Color.theme.azure.opacity(self.selectedTraffic ? 1 : 0))
                                                        .scaledToFit()
                                                        .aspectRatio(contentMode: .fit)
                                                    
                                                    Text("Yesterday").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.theme.azure)
                                                }.frame(maxWidth: .infinity, alignment: .leading)
                                            })
                                            
                                            Divider().padding(.horizontal, -16)
                                            
                                        }
                                        
                                        Group {
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
                                            
                                        }
                                    }.padding()
                                        .frame(width: 194)
                                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
                                        .cornerRadius(8)
                                    
                                    Spacer()
                                }// End HStack
                            }
                            
                        }
                        
                    }// End VStack
                    .padding()
                    
                }.padding()
            }
        }.onAppear {
            updateMapOverlayViews()
        }
        .onChange(of: isLoading) {newValue in
            if !newValue {
                mapView.removeOverlays(mapView.overlays)
            }
        }
        .sheet(isPresented: $mapIconModel.showModal) {
            MapAirportCardView().interactiveDismissDisabled(true)
        }
    }
    
    func updateMapOverlayViews() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        
        if selectedRouteFlights3 { addRoute(payload: tfRoute["flights3"]) }
        if selectedRouteFlights2 { addRoute(payload: tfRoute["flights2"]) }
        if selectedRouteFlights1 { addRoute(payload: tfRoute["flights1"]) }
        if selectedWaypoint { addWaypoint() }
    }
    
    func addOverlay() {
        let overlay = MapOverlay(worldMap: worldMap)
        mapView.addOverlay(overlay)
    }
    
    mutating func addRoute(payload: [TrackFlown]) {
        var dataWaypoint: [String] = []
        var locationCoordinate = [CLLocationCoordinate2D]()
        
        // starting point (departure airport)
        let firstCoord = CLLocationCoordinate2D(latitude: payload.first.lat! as! CLLocationDegrees, longitude: payload.first.long! as! CLLocationDegrees)
        let firstImage = UIImage(named: "icon_circle_fill_blue")
        
        let firstAnnotation = CustomRouteAnnotation(coordinate: firstCoord, title: (payload.first.name as? String)!.trimmingCharacters(in: .whitespacesAndNewlines), subtitle: "", image: firstImage)
        locationCoordinate.append(firstCoord)
        mapView.addAnnotation(firstAnnotation)
        
        routeDatas.append(SRoute(name: (payload.first.name as? String)!.trimmingCharacters(in: .whitespacesAndNewlines), latitude: payload.first.lat as? String ?? "0", longitude: payload.first.long as? String ?? "0"))
        
        // rest of route
        for item in payload {
            if item != payload.first || item != payload.last {
                let coord = CLLocationCoordinate2D(latitude: (item.lat as NSString).doubleValue, longitude: (item.long! as NSString).doubleValue)
                //let annotation = CustomRouteAnnotation(coordinate: coord, title: itemExists.name!.trimmingCharacters(in: .whitespacesAndNewlines), subtitle: "", image: UIImage(named: "icon_triangle_fill_blue"))
                
                locationCoordinate.append(coord)
                //mapView.addAnnotation(annotation)
                routeDatas.append(SRoute(name: "", latitude: item.lat as String), longitude: item.long as String)
            }
        }
    
        // last point (arrival airport)
        let lastCoord = CLLocationCoordinate2D(latitude: payload.last.lat! as! CLLocationDegrees, longitude: payload.last.long! as! CLLocationDegrees)
        let lastImage = UIImage(named: "icon_circle_fill_blue")
        
        let lastAnnotation = CustomRouteAnnotation(coordinate: lastCoord, title: (payload.last.name as? String)!.trimmingCharacters(in: .whitespacesAndNewlines), subtitle: "", image:lastImage)
        locationCoordinate.append(lastCoord)
        mapView.addAnnotation(lastAnnotation)
        
        routeDatas.append(SRoute(name: (payload.last.name as? String)!.trimmingCharacters(in: .whitespacesAndNewlines), latitude: payload.last.lat as? String ?? "0", longitude: payload.last.long as? String ?? "0"))
        
        let polyline = MKPolyline(coordinates: locationCoordinate, count: locationCoordinate.count)
        mapView.addOverlay(polyline)
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
    
}

struct MapViewTrackFlown: UIViewRepresentable {
    let region: MKCoordinateRegion
    let lineCoordinates: [CLLocationCoordinate2D]
    let dataWaypointMap: [WaypointMapList]
    let currentLocation: CLLocationCoordinate2D
    let mapType: MKMapType
    var isLoading: Bool
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var mapIconModel: MapIconModel
    
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
        mapView.register(CustomWaypointAnnotationView.self, forAnnotationViewWithReuseIdentifier: "CustomWaypointAnnotationView")
        mapView.delegate = context.coordinator
//        mapView.userTrackingMode = MKUserTrackingMode.follow
        
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
//        view.showsUserLocation = true
        view.setCenter(currentLocation, animated: true)
    }
    
    func makeCoordinator() -> CoordinatorTrackFlown {
        CoordinatorTrackFlown(self)
    }
}

class CoordinatorTrackFlown: NSObject, MKMapViewDelegate {
    var parent: MapViewTrackFlown
    
    init(_ parent: MapViewTrackFlown) {
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
        } else if annotation is CustomWaypointAnnotation {
            let annotationView = CustomWaypointAnnotationView(annotation: annotation, reuseIdentifier: "CustomWaypointAnnotationView")
            let annotationLabel = UILabel(frame: CGRect(x: 15, y: -8, width: 105, height: 30))
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
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.parent.isLoading = false
        }
    }
}

