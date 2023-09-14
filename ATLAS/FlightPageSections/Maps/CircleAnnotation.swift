//
//  CircleAnnotation.swift
//  ATLAS
//
//  Created by phuong phan on 14/09/2023.
//

import MapKit

class CircleAnnotation: MKCircle {
    var latitude: Double?
    var longitude: Double?
    var name: String?
    var color: UIColor?
    
    convenience init(latitude: Double, longitude: Double, name: String, color: UIColor) {
        let coords = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        self.init(center: coords, radius: 1200)
        self.name = name
        self.color = color
    }
}
