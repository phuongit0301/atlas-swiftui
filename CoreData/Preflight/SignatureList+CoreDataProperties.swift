//
//  SignatureList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 08/10/2023.
//
//

import Foundation
import CoreData


extension SignatureList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SignatureList> {
        return NSFetchRequest<SignatureList>(entityName: "Signature")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var imageString: String?
    @NSManaged public var licenseNumber: String?
    @NSManaged public var comment: String?
    @NSManaged public var flightNumber: String?
    
    public var unwrappedImageString: String {
        imageString ?? ""
    }
    
    public var unwrappedLicenseNumber: String {
        licenseNumber ?? ""
    }
    
    public var unwrappedComment: String {
        comment ?? ""
    }
}

extension SignatureList : Identifiable {

}
