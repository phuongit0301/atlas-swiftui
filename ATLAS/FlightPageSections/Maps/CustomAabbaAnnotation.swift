//
//  CustomAabbaAnnotation.swift
//  ATLAS
//
//  Created by phuong phan on 13/09/2023.
//

import Foundation
import UIKit
import MapKit

class CustomAabbaAnnotation: NSObject, MKAnnotation {
    
    // This property must be key-value observable, which the `@objc dynamic` attributes provide.
    let coordinate: CLLocationCoordinate2D
    var title: String?
    let subtitle: String?
    let index: Int?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?, index: Int?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.index = index
    }
}
