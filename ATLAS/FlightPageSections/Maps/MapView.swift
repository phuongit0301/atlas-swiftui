//
//  MapView.swift
//  ATLAS
//
//  Created by phuong phan on 22/08/2023.
//

import SwiftUI
import CoreLocation
import MapKit

//struct AnnotatedItem: MKAnnotation {
//    let id = UUID()
//    var name: String
//    var coordinate: CLLocationCoordinate2D
//}
//
//struct MapViewModal: View {
//
//    @StateObject var locationViewModel = LocationViewModel()
//    @State private var mapType: MKMapType = .standard
//
////    var parent = MapView(mapType: $mapType)
//
//    var body: some View {
//        VStack {
//            MapView(mapType: $mapType)
//                .ignoresSafeArea()
//                .overlay {
//
//                    Button(action: {
//                        var parent = MapView(mapType: $mapType)
//                        parent.testFunc()
//                    }) {
//                        VStack {
//                            Spacer()
//                            HStack {
//                                Spacer()
//                                ZStack {
//                                    RoundedRectangle(cornerRadius: 5)
//                                        .frame(width: 40, height: 40)
//                                        .foregroundColor(.white)
//
//                                    Image(systemName: "map.fill")
//                                        .font(.system(size: 30))
//                                        .foregroundColor(.gray)
//
//                                }
//                                .padding(.trailing, 10)
//                            }
//                            Spacer()
//                        }
//                    }
//                }
//        }
//        .onAppear {
//            if locationViewModel.authorizationStatus == .notDetermined {
//                locationViewModel.requestPermission()
//            }
//        }
//    }
//}
//
//struct MapView: UIViewRepresentable {
//    @Binding var mapType: MKMapType
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject, MKMapViewDelegate {
//        var parent: MapView
//
//        init(_ parent: MapView) {
//            self.parent = parent
//        }
//
//        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
//            //print(mapView.centerCoordinate)
//        }
//
//        func mapView(_ mapView: MKMapView,
//                     didUpdate userLocation: MKUserLocation) {
//            print("User location\(userLocation.coordinate)")
//        }
//
//        func mapViewWillStartLoadingMap(_ mapView: MKMapView) {
//            print("Map will start loading")
//        }
//
//        func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
//            print("Map did finish loading")
//        }
//
//        func mapViewWillStartLocatingUser(_ mapView: MKMapView) {
//            print("Map will start locating user")
//        }
//
//        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//            let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
//            view.canShowCallout = true
//            return view
//        }
//    }
//
//    func makeUIView(context: Context) -> MKMapView {
//
//        let region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -37.8136, longitude: 144.9631), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//
//        let mapView = MKMapView()
//        mapView.delegate = context.coordinator
//        mapView.region = region
//
//        mapView.showsScale = true
//        mapView.setUserTrackingMode(MKUserTrackingMode.followWithHeading, animated: true)
//        mapView.userTrackingMode = MKUserTrackingMode.followWithHeading
//
//        mapView.showsUserLocation = true
//        //mapView.showsCompass = false
//
//        return mapView
//    }
//
//    func updateUIView(_ view: MKMapView, context: Context) {
//        view.mapType = mapType
//    }
//
//    func testFunc()  {
//        print("Toggle Compass")
//    }
//}
//
//class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
//    @Published var authorizationStatus: CLAuthorizationStatus
//
//    private let locationManager: CLLocationManager
//
//    override init() {
//        locationManager = CLLocationManager()
//        authorizationStatus = locationManager.authorizationStatus
//
//        super.init()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.startUpdatingLocation()
//    }
//
//    func requestPermission() {
//        locationManager.requestWhenInUseAuthorization()
//    }
//
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        authorizationStatus = manager.authorizationStatus
//    }
//}
//

struct MapViewModal: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @StateObject var locationViewModel = LocationViewModel()
    @State private var mapType: MKMapType = .mutedStandard

    var body: some View {
        VStack {
            MapView(
                region: coreDataModel.region,
                lineCoordinates: coreDataModel.lineCoordinates,
                annotation: coreDataModel.pointsOfInterest,
                currentLocation: locationViewModel.currentLocation,
                mapType: mapType
            )
        }
    }
}

let worldMap = WorldMap(filename: "WorldCoordinates")

struct MapView: UIViewRepresentable {
    let region: MKCoordinateRegion
    let lineCoordinates: [CLLocationCoordinate2D]
    let annotation: [MKAnnotation]
    let currentLocation: CLLocationCoordinate2D
    let mapType: MKMapType
    @EnvironmentObject var coreDataModel: CoreDataModelState
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.mapType = mapType
//        mapView.region = region
        mapView.setRegion(region, animated: true)
        
        mapView.showsUserLocation = false
        mapView.showsScale = true
        
        mapView.addAnnotations(annotation)
        let overlay = MapOverlay(worldMap: worldMap)
        mapView.addOverlay(overlay)
        
        let polyline = MKPolyline(coordinates: lineCoordinates, count: lineCoordinates.count)
        mapView.addOverlay(polyline)
        
        mapView.delegate = context.coordinator
        mapView.userTrackingMode = MKUserTrackingMode.follow
        
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        if annotation.count != view.annotations.count {
            view.removeAnnotations(view.annotations)
            view.addAnnotations(annotation)
        }
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
    
//    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
//        if !mapView.showsUserLocation {
//            parent.centerCoordinate = mapView.centerCoordinate
//        }
//    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // If the annotation is the user dot then return nil
        if annotation is MKPointAnnotation {
            return nil
        }
        
        // Create an annotation view
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "business")
        
        annotationView.image = UIImage(systemName: "triangle.inset.filled")
        annotationView.canShowCallout = false
        annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        //        annotationView.isHidden = true
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
            renderer.strokeColor = UIColor.systemBlue
            renderer.lineWidth = 10
            return renderer
        }
        return MKOverlayRenderer()
    }
}

//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView()
//    }
//}

