//
//  MapView.swift
//  ATLAS
//
//  Created by phuong phan on 22/08/2023.
//

import SwiftUI
import CoreLocation
import MapKit

struct AnnotatedItem: Identifiable {
    let id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
}

struct MapViewModal: View {

    @StateObject var locationViewModel = LocationViewModel()
    @State private var mapType: MKMapType = .standard
    
//    var parent = MapView(mapType: $mapType)

    var body: some View {
        VStack {
            MapView(mapType: $mapType)
                .ignoresSafeArea()
                .overlay {

                    Button(action: {
                        var parent = MapView(mapType: $mapType)
                        parent.testFunc()
                    }) {
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                ZStack {
                                    RoundedRectangle(cornerRadius: 5)
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.white)

                                    Image(systemName: "map.fill")
                                        .font(.system(size: 30))
                                        .foregroundColor(.gray)

                                }
                                .padding(.trailing, 10)
                            }
                            Spacer()
                        }
                    }
                }
        }
        .onAppear {
            if locationViewModel.authorizationStatus == .notDetermined {
                locationViewModel.requestPermission()
            }
        }
    }
}

struct MapView: UIViewRepresentable {
    @Binding var mapType: MKMapType
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }

        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            //print(mapView.centerCoordinate)
        }

        func mapView(_ mapView: MKMapView,
                     didUpdate userLocation: MKUserLocation) {
            print("User location\(userLocation.coordinate)")
        }

        func mapViewWillStartLoadingMap(_ mapView: MKMapView) {
            print("Map will start loading")
        }

        func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
            print("Map did finish loading")
        }

        func mapViewWillStartLocatingUser(_ mapView: MKMapView) {
            print("Map will start locating user")
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
            view.canShowCallout = true
            return view
        }
    }

    func makeUIView(context: Context) -> MKMapView {

        let region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -37.8136, longitude: 144.9631), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.region = region

        mapView.showsScale = true
        mapView.setUserTrackingMode(MKUserTrackingMode.followWithHeading, animated: true)
        mapView.userTrackingMode = MKUserTrackingMode.followWithHeading

        mapView.showsUserLocation = true
        //mapView.showsCompass = false

        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        view.mapType = mapType
    }

    func testFunc()  {
        print("Toggle Compass")
    }
}

class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var authorizationStatus: CLAuthorizationStatus

    private let locationManager: CLLocationManager

    override init() {
        locationManager = CLLocationManager()
        authorizationStatus = locationManager.authorizationStatus

        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }

    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
}
//
//struct MapView: View {
//    private var pointsOfInterest = [
//        AnnotatedItem(name: "Times Square", coordinate: .init(latitude: 40.75773, longitude: -73.985708)),
//        AnnotatedItem(name: "Flatiron Building", coordinate: .init(latitude: 40.741112, longitude: -73.989723)),
//        AnnotatedItem(name: "Empire State Building", coordinate: .init(latitude: 40.748817, longitude: -73.985428))
//        ]
//
//    @State private var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40.75773, longitude: -73.985708), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
//
//    var body: some View {
//        Map(coordinateRegion: $region, annotationItems: pointsOfInterest) { item in
//            MapMarker(coordinate: item.coordinate, tint: .red)
//        }.edgesIgnoringSafeArea(.all)
//    }
//}

//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView()
//    }
//}

