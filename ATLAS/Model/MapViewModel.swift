////
////  MapViewModel.swift
////  ATLAS
////
////  Created by phuong phan on 25/08/2023.
////
//
import SwiftUI
import MapKit
//
//class MapViewModel: NSObject, ObservableObject {
//    
//    @Published var mapView = MKMapView()
//    
//    
//  
//    func restrictionsInfo(completion: @escaping ([RestrictionInfo]) -> ()) {
//        guard let url = URL(string: "https://flightplan.romatsa.ro/init/static/zone_restrictionate_uav.json") else {
//            fatalError("Unable to get geoJSON") }
//        
//        downloadData(fromURL: url) { (returnedData) in
//            if let data = returnedData {
//                var geoJson = [MKGeoJSONObject]()
//                do {
//                    geoJson = try MKGeoJSONDecoder().decode(data)
//                } catch {
//                    fatalError("Unable to decode GeoJSON")
//                }
//                
//                
//                var restrictionsInfo = [RestrictionInfo]()
//                for item in geoJson {
//                    if let feature = item as? MKGeoJSONFeature {
//                        let propData = feature.properties!
//                        for geo in feature.geometry {
//                            if geo is MKPolygon {
//                                let polygonInfo = try? JSONDecoder.init().decode(RestrictionInfo.self, from: propData)
//                                restrictionsInfo.append(polygonInfo!)
//                            }
//                        }
//                    }
//                }
//                DispatchQueue.main.async {
//                    completion(restrictionsInfo)
//                }
//            }
//        }
//    }
//    
//    
//    // Decode GeoJSON from the server
//    func showRestrictedZones(completion: @escaping ([MKOverlay]) -> ()) {
//        guard let url = URL(string: "https://flightplan.romatsa.ro/init/static/zone_restrictionate_uav.json") else {
//            fatalError("Unable to get geoJSON") }
//        
//        downloadData(fromURL: url) { (returnedData) in
//            if let data = returnedData {
//                var geoJson = [MKGeoJSONObject]()
//                do {
//                    geoJson = try MKGeoJSONDecoder().decode(data)
//                } catch {
//                    fatalError("Unable to decode GeoJSON")
//                }
//
//                var overlays = [MKOverlay]()
//                for item in geoJson {
//                    if let feature = item as? MKGeoJSONFeature {
//                        let propData = feature.properties!
//                        for geo in feature.geometry {
//                            if let polygon = geo as? MKPolygon {
//                                let polygonInfo = try? JSONDecoder.init().decode(RestrictionInfo.self, from: propData)
//                                polygon.title = polygonInfo?.zone_id
//                                overlays.append(polygon)
//                            }
//                        }
//                    }
//                }
//                DispatchQueue.main.async {
//                    completion(overlays)
//                }
//            }
//        }
//    }
//    
//    func downloadData( fromURL url: URL, completion: @escaping (_ data: Data?) -> ()) {
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//            guard
//                let data = data,
//                error == nil,
//                let response = response as? HTTPURLResponse,
//                response.statusCode >= 200 && response.statusCode < 300 else {
//                print("Error downloading data.")
//                completion(nil)
//                return
//            }
//            completion(data)
//        }
//        .resume()
//    }
//}

struct IMapModel: Identifiable, Decodable {
    var id = UUID()
    var name: String
    var coord: String
}

//let DATA_MAP = [
//    IMapModel(name: "KIGOB", coord: "N1306.8 E10051.1"),
//    IMapModel(name: "PASVA", coord: "N0615.5 E10204.5"),
//    IMapModel(name: "NUFFA", coord: "N0253.7 E10338.5"),
//    IMapModel(name: "PIBAP", coord: "N0230.4 E10406.3"),
//    IMapModel(name: "PASPU", coord: "N0159.3 E10406.3"),
//    IMapModel(name: "NYLON", coord: "N0136.9 E10406.4"),
//    IMapModel(name: "POSUB", coord: "N0127.4 E10407.8"),
//    IMapModel(name: "SANAT", coord: "N0107.8 E10359.5"),
//]

class MapViewModel: ObservableObject {
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 1.988333, longitude: 104.105), span: MKCoordinateSpan(latitudeDelta: 8, longitudeDelta: 8))
    @Published var lineCoordinates = [CLLocationCoordinate2D]()
    @Published var pointsOfInterest = [MKAnnotation]()
    @StateObject var coreDataModel = CoreDataModelState()
    
    init() {
        var pointAnnotation = [MKPointAnnotation]()
        var locationCoordinate = [CLLocationCoordinate2D]()
        let dataMap = coreDataModel.readDataMapList()
        
        for item in dataMap {
            let annotation = MKPointAnnotation()
            let coord = CLLocationCoordinate2D(latitude: (item.latitude! as NSString).doubleValue, longitude: (item.longitude! as NSString).doubleValue)
            annotation.title = item.title
            annotation.coordinate = coord
            
            pointAnnotation.append(annotation)
            locationCoordinate.append(coord)
        }
        
        self.lineCoordinates = locationCoordinate
        self.pointsOfInterest = pointAnnotation
    }
}

func convertCoordinates(_ coordinateString: String) -> [String: String] {
    let components = coordinateString.components(separatedBy: " ")
    
    if components.count == 2 {
        let latitudeComponent = components[0]
        let longitudeComponent = components[1]
        
        let latDegree = String(latitudeComponent.dropFirst())
        let lonDegree = String(longitudeComponent.dropFirst())
        
        let latDegreeIndex = latDegree.index(latDegree.startIndex, offsetBy: 2)
        let lonDegreeIndex = lonDegree.index(lonDegree.startIndex, offsetBy: 3)
        
        if let latDegrees = Double(latDegree[..<latDegreeIndex]),
           let latMinutes = Double(latDegree[latDegreeIndex...]),
           let lonDegrees = Double(lonDegree[..<lonDegreeIndex]),
           let lonMinutes = Double(lonDegree[lonDegreeIndex...]) {
            
            let decimalLat = latDegrees + (latMinutes / 60)
            let decimalLon = lonDegrees + (lonMinutes / 60)
            
            let decimalLatitude = String(format: "%.6f", decimalLat)
            let decimalLongitude = String(format: "%.6f", decimalLon)
            
            return ["latitude": decimalLatitude, "longitude": decimalLongitude]
//            return CLLocationCoordinate2D(latitude: (decimalLatitude as NSString).doubleValue, longitude: (decimalLongitude as NSString).doubleValue)
        }
    }
    return ["latitude": "0", "longitude": "0"]
//    return CLLocationCoordinate2D(latitude: 0, longitude: 0)
}

class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var currentLocation: CLLocationCoordinate2D

    private let locationManager: CLLocationManager

    override init() {
        locationManager = CLLocationManager()
        currentLocation = CLLocationCoordinate2D()
        authorizationStatus = locationManager.authorizationStatus

        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        getCurrentLocation()
    }

    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
    
    func getCurrentLocation() {
        let lat = locationManager.location?.coordinate.latitude ?? 0
        let log = locationManager.location?.coordinate.longitude ?? 0
        currentLocation.latitude = lat
        currentLocation.longitude = log
    }
}
