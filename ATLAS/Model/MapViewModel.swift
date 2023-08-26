////
////  MapViewModel.swift
////  ATLAS
////
////  Created by phuong phan on 25/08/2023.
////
//
//import SwiftUI
//import MapKit
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
