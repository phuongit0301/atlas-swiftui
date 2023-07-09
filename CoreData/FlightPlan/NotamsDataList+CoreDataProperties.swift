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
    
    public var unwrappedDepNotams: [[String: String]] {
        if let depNotams = depNotams {
            do {
                if let arr = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(depNotams) as? [[String: String]] {
                  print("arr=====>\(arr)")
                return arr
              }
          } catch {
            print("could not unarchive array: \(error)")
          }
        }
        return [["date": "", "notam": "", "rank": ""]]
    }
    
    public var unwrappedEnrNotams: [[String: String]] {
        if let enrNotams = enrNotams {
            do {
                if let arr = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(enrNotams) as? [[String: String]] {
                return arr
              }
          } catch {
            print("could not unarchive array: \(error)")
          }
        }
        return [["date": "", "notam": "", "rank": ""]]
    }
    
    public var unwrappedArrNotams: [[String: String]] {
        if let arrNotams = arrNotams {
            do {
                if let arr = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(arrNotams) as? [[String: String]] {
                return arr
              }
          } catch {
            print("could not unarchive array: \(error)")
          }
        }
        return [["date": "", "notam": "", "rank": ""]]
    }
}

extension NotamsDataList : Identifiable {

}
