//
//  CustomAirportAnnotationView.swift
//  ATLAS
//
//  Created by phuong phan on 13/09/2023.
//

import SwiftUI
import MapKit

class CustomAirportAnnotationView: MKAnnotationView {
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
    }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
      super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
      guard let attractionAnnotation = self.annotation as? CustomAirportAnnotation else { return }

      image = attractionAnnotation.image
    }
}
