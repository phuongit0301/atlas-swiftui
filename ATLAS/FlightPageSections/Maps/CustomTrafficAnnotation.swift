//
//  CustomRoutCustomTrafficAnnotationeAnnotation.swift
//  ATLAS
//
//  Created by phuong phan on 13/09/2023.
//

import Foundation
import UIKit
import MapKit

class CustomTrafficAnnotation: NSObject, MKAnnotation {
    
    // This property must be key-value observable, which the `@objc dynamic` attributes provide.
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?
    let flightNum: String?
    let aircraftType: String?
    let baroAltitude: String?
    let trueTrack: CGFloat?
    let rotationAngle: CGFloat?
    let colour: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?, flightNum: String?, aircraftType: String?, baroAltitude: String?, trueTrack: CGFloat? = 0, rotationAngle: CGFloat? = 0, colour: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.flightNum = flightNum
        self.aircraftType = aircraftType
        self.baroAltitude = baroAltitude
        self.trueTrack = trueTrack
        self.rotationAngle = rotationAngle
        self.colour = colour
    }
}
