////
////  MapViewModel.swift
////  ATLAS
////
////  Created by phuong phan on 25/08/2023.
////
//
import SwiftUI
import MapKit

class WorldMap {
    var name: String?
    var boundary: [CLLocationCoordinate2D] = []

    var midCoordinate = CLLocationCoordinate2D()
    var overlayTopLeftCoordinate = CLLocationCoordinate2D()
    var overlayTopRightCoordinate = CLLocationCoordinate2D()
    var overlayBottomLeftCoordinate = CLLocationCoordinate2D()
    var overlayBottomRightCoordinate: CLLocationCoordinate2D {
      return CLLocationCoordinate2D(
        latitude: overlayBottomLeftCoordinate.latitude,
        longitude: overlayTopRightCoordinate.longitude)
    }

    var overlayBoundingMapRect: MKMapRect {
      let topLeft = MKMapPoint(overlayTopLeftCoordinate)
      let topRight = MKMapPoint(overlayTopRightCoordinate)
      let bottomLeft = MKMapPoint(overlayBottomLeftCoordinate)

      return MKMapRect(
        x: topLeft.x,
        y: topLeft.y,
        width: fabs(topLeft.x - topRight.x),
        height: fabs(topLeft.y - bottomLeft.y))
    }

    init(filename: String) {
      guard
        let properties = WorldMap.plist(filename) as? [String: Any],
        let boundaryPoints = properties["boundary"] as? [String]
        else { return }

      midCoordinate = WorldMap.parseCoord(dict: properties, fieldName: "midCoord")
      overlayTopLeftCoordinate = WorldMap.parseCoord(
        dict: properties,
        fieldName: "overlayTopLeftCoord")
      overlayTopRightCoordinate = WorldMap.parseCoord(
        dict: properties,
        fieldName: "overlayTopRightCoord")
      overlayBottomLeftCoordinate = WorldMap.parseCoord(
        dict: properties,
        fieldName: "overlayBottomLeftCoord")

      let cgPoints = boundaryPoints.map { NSCoder.cgPoint(for: $0) }
      boundary = cgPoints.map { CLLocationCoordinate2D(
        latitude: CLLocationDegrees($0.x),
        longitude: CLLocationDegrees($0.y))
      }
    }

    static func plist(_ plist: String) -> Any? {
      guard
        let filePath = Bundle.main.path(forResource: plist, ofType: "plist"),
        let data = FileManager.default.contents(atPath: filePath)
        else { return nil }

      do {
        return try PropertyListSerialization.propertyList(from: data, options: [], format: nil)
      } catch {
        return nil
      }
    }

    static func parseCoord(dict: [String: Any], fieldName: String) -> CLLocationCoordinate2D {
      if let coord = dict[fieldName] as? String {
        let point = NSCoder.cgPoint(for: coord)
        return CLLocationCoordinate2D(
          latitude: CLLocationDegrees(point.x),
          longitude: CLLocationDegrees(point.y))
      }
      return CLLocationCoordinate2D()
    }
}

class MapOverlay: NSObject, MKOverlay{
    let coordinate: CLLocationCoordinate2D
    let boundingMapRect: MKMapRect

    init(worldMap: WorldMap) {
        boundingMapRect = worldMap.overlayBoundingMapRect
        coordinate = worldMap.midCoordinate
    }
}

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

//class MapViewModel: ObservableObject {
//    @Published var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 1.988333, longitude: 104.105), span: MKCoordinateSpan(latitudeDelta: 8, longitudeDelta: 8))
//    @Published var lineCoordinates = [CLLocationCoordinate2D]()
//    @Published var pointsOfInterest = [MKAnnotation]()
//    @ObservedObject var coreDataModel: CoreDataModelState
//    
//    init() {
//        var pointAnnotation = [MKPointAnnotation]()
//        var locationCoordinate = [CLLocationCoordinate2D]()
//        
//        for item in coreDataModel.dataMap {
//            let annotation = MKPointAnnotation()
//            let coord = CLLocationCoordinate2D(latitude: (item.latitude! as NSString).doubleValue, longitude: (item.longitude! as NSString).doubleValue)
//            annotation.title = item.title
//            annotation.coordinate = coord
//            
//            pointAnnotation.append(annotation)
//            locationCoordinate.append(coord)
//        }
//        
//        self.lineCoordinates = locationCoordinate
//        self.pointsOfInterest = pointAnnotation
//    }
//}

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

class MapOverlayView: MKOverlayRenderer{
    
    let overlayImage: UIImage
    
    init(overlay: MKOverlay, overlayImage: UIImage){
        self.overlayImage = overlayImage
        super.init(overlay: overlay)
    }
    
    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        guard let imageReference = overlayImage.cgImage else {return}
        let rect = self.rect(for: overlay.boundingMapRect)
        context.scaleBy(x: 1.0, y: -1.0)
        context.translateBy(x: 0.0, y: -rect.size.height)
        context.draw(imageReference, in: rect)
    }
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

enum WaypointDataDropDown: String, CaseIterable, Identifiable {
    case waypoint1 = "Waypoint 1"
    case waypoint2 = "Waypoint 2"
    case waypoint3 = "Waypoint 3"
    
    var id: Self { self }
}

enum FlightLevelDataDropDown: String, CaseIterable, Identifiable {
    case level1 = "Flight Level 1"
    case level2 = "Flight Level 2"
    case level3 = "Flight Level 3"
    
    var id: Self { self }
}

enum StationDataDropDown: String, CaseIterable, Identifiable {
    case item1 = "Station 1"
    case item2 = "Station 2"
    case item3 = "Station 3"
    
    var id: Self { self }
}

enum ModerateDataDropDown: String, CaseIterable, Identifiable {
    case fight
    case moderate
    case severe
    
    var id: Self { self }
}

enum RunwayDataDropDown: String, CaseIterable, Identifiable {
    case item1 = "1"
    case item2 = "2"
    case item3 = "3"
    case item4 = "4"
    case item5 = "5"
    case item6 = "6"
    case item7 = "7"
    case item8 = "8"
    case item9 = "9"
    case item10 = "10"
    
    var id: Self { self }
}

class MapIconModel: ObservableObject {
    @Published var dataWaypoint: [String] = []
}
