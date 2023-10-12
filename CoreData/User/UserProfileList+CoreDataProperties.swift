//
//  UserProfileList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 12/10/2023.
//
//

import Foundation
import CoreData


extension UserProfileList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserProfileList> {
        return NSFetchRequest<UserProfileList>(entityName: "UserProfile")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var username: String?
    @NSManaged public var email: String?
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var airline: String?
    @NSManaged public var mobileCountry: String?
    @NSManaged public var mobileNumber: String?
    @NSManaged public var isSubscribe: Bool
    @NSManaged public var userId: String?
    
    public var unwrappedUserId: String {
        userId ?? ""
    }
    
    public var unwrappedUsername: String {
        username ?? ""
    }
    
    public var unwrappedEmail: String {
        email ?? ""
    }
    
    public var unwrappedFirstName: String {
        firstName ?? ""
    }
    
    public var unwrappedLastName: String {
        lastName ?? ""
    }
    
    public var unwrappedAirline: String {
        airline ?? ""
    }
    
    public var unwrappedMobileCountry: String {
        mobileCountry ?? ""
    }
    
    public var unwrappedMobileNumber: String {
        mobileNumber ?? ""
    }
}

extension UserProfileList : Identifiable {

}
