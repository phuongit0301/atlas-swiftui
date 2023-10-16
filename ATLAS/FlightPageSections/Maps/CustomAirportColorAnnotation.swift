//
//  CustomAirportColorAnnotation.swift
//  ATLAS
//
//  Created by phuong phan on 13/09/2023.
//

import Foundation
import UIKit
import MapKit

class CustomAirportColorAnnotation: NSObject, MKAnnotation {
    
    // This property must be key-value observable, which the `@objc dynamic` attributes provide.
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?
    let image: UIImage?
    let item: AirportMapColorList?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?, image: UIImage?, item: AirportMapColorList?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.item = item
    }
}
