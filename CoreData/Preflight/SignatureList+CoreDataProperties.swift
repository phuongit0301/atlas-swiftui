//
//  SignatureList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 27/09/2023.
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

}

extension SignatureList : Identifiable {

}
