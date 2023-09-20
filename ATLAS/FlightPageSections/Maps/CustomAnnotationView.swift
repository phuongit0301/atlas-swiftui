//
//  CustomAnnotationView.swift
//  ATLAS
//
//  Created by phuong phan on 13/09/2023.
//

import SwiftUI
import MapKit

class CustomAnnotationView: MKAnnotationView {
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
    }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
      super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
      guard let attractionAnnotation = self.annotation as? CustomAnnotation else { return }

      image = attractionAnnotation.image
    }
//    
//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//            let hitView = super.hitTest(point, with: event)
//            if (hitView != nil)
//            {
//                self.superview?.bringSubviewToFront(self)
//            }
//            return hitView
//        }
//        
//        override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
//            let rect = self.bounds
//            var isInside: Bool = rect.contains(point)
//            if(!isInside) {
//                for view in self.subviews {
//                    isInside = view.frame.contains(point)
//                    if isInside {
//                        break
//                    }
//                }
//            }
//            return isInside
//        }
}
