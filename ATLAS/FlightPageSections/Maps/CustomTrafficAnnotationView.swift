//
//  CustomTrafficAnnotationView.swift
//  ATLAS
//
//  Created by phuong phan on 13/09/2023.
//

import SwiftUI
import MapKit

class CustomTrafficAnnotationView: MKAnnotationView {
    //    override var annotation: MKAnnotation? { didSet { update(for: annotation) } }
    var rotationAngle: CGFloat = 0.0 {
        didSet {
            transform = CGAffineTransform(rotationAngle: rotationAngle)
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // Ensure that user interactions are correctly handled for the rotated annotation view
        let hitView = super.hitTest(point, with: event)
        return hitView != nil ? hitView : self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        guard let attractionAnnotation = self.annotation as? CustomTrafficAnnotation else { return }
        
        image = attractionAnnotation.image
    }
    
    //    func update(for annotation: MKAnnotation?) {
    //       guard let annotation = annotation as? CustomRouteAnnotation else { return }
    //       
    //        markerTintColor = UIColor(Color(annotation.colour!))
    //   }
}
