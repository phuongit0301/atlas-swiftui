//
//  CustomAabbaAnnotationView.swift
//  ATLAS
//
//  Created by phuong phan on 13/09/2023.
//

import SwiftUI
import MapKit

class CustomAabbaAnnotationView: MKAnnotationView {
//    override var annotation: MKAnnotation? { didSet { update(for: annotation) } }
    
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
    }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
      super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
      guard let attractionAnnotation = self.annotation as? CustomAabbaAnnotation else { return }

      image = attractionAnnotation.image
    }
    
//    func update(for annotation: MKAnnotation?) {
//       guard let annotation = annotation as? CustomRouteAnnotation else { return }
//       
//        markerTintColor = UIColor(Color(annotation.colour!))
//   }
}
