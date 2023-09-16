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
    let image: UIImage?
    let trueTrack: CGFloat?
    let rotationAngle: CGFloat?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?, image: UIImage?, trueTrack: CGFloat? = 0, rotationAngle: CGFloat? = 0) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.trueTrack = trueTrack
        self.rotationAngle = rotationAngle
    }
}
