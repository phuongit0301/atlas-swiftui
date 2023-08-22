//
//  MapView.swift
//  ATLAS
//
//  Created by phuong phan on 22/08/2023.
//

import SwiftUI
import MapKit

struct AnnotatedItem: Identifiable {
    let id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
}

struct MapView: View {
    private var pointsOfInterest = [
        AnnotatedItem(name: "Times Square", coordinate: .init(latitude: 40.75773, longitude: -73.985708)),
        AnnotatedItem(name: "Flatiron Building", coordinate: .init(latitude: 40.741112, longitude: -73.989723)),
        AnnotatedItem(name: "Empire State Building", coordinate: .init(latitude: 40.748817, longitude: -73.985428))
        ]
    
    @State private var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40.75773, longitude: -73.985708), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: pointsOfInterest) { item in
            MapMarker(coordinate: item.coordinate, tint: .red)
        }.edgesIgnoringSafeArea(.all)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}

