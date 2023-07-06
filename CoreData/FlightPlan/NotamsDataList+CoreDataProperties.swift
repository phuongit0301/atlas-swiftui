//
//  NotamsDataList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 06/07/2023.
//
//

import Foundation
import CoreData


extension NotamsDataList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NotamsDataList> {
        return NSFetchRequest<NotamsDataList>(entityName: "NotamsData")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var depNotams: Data?
    @NSManaged public var enrNotams: Data?
    @NSManaged public var arrNotams: Data?
    @NSManaged public var isArrReference: Bool
    @NSManaged public var isDepReference: Bool
    @NSManaged public var isEnrReference: Bool
    
    public var unwrappedDepNotams: [String] {
        if let depNotams = depNotams {
            do {
              if let arr = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(depNotams) as? [String] {
                return arr
              }
          } catch {
            print("could not unarchive array: \(error)")
          }
        }
        return [""]
    }
    
    public var unwrappedEnrNotams: [String] {
        if let enrNotams = enrNotams {
            do {
              if let arr = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(enrNotams) as? [String] {
                return arr
              }
          } catch {
            print("could not unarchive array: \(error)")
          }
        }
        return [""]
    }
    
    public var unwrappedArrNotams: [String] {
        if let arrNotams = arrNotams {
            do {
              if let arr = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(arrNotams) as? [String] {
                return arr
              }
          } catch {
            print("could not unarchive array: \(error)")
          }
        }
        return [""]
    }
}

extension NotamsDataList : Identifiable {

}
