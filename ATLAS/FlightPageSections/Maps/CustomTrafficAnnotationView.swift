//
//  CustomTrafficAnnotationView.swift
//  ATLAS
//
//  Created by phuong phan on 13/09/2023.
//

import SwiftUI
import MapKit

class CustomTrafficAnnotationView: MKAnnotationView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        guard let attractionAnnotation = self.annotation as? CustomTrafficAnnotation else { return }
        
//        image = attractionAnnotation.image
    }
    
    var imageView: UIImageView?

    override func prepareForReuse() {
        imageView?.image = nil
    }

    func updateImge(image: UIImage?) {
        guard let aImage = image else {
            return
        }

        if imageView == nil {
            imageView = UIImageView(image: aImage)
            if imageView != nil {
                frame = imageView!.frame
                addSubview(imageView!)
            }
        } else {
            imageView!.image = aImage
            frame = imageView!.frame
        }
    }
    //    func update(for annotation: MKAnnotation?) {
    //       guard let annotation = annotation as? CustomRouteAnnotation else { return }
    //
    //        markerTintColor = UIColor(Color(annotation.colour!))
    //   }
}
