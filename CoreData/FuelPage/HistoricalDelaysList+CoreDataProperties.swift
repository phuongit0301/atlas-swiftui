//
//  HistoricalDelaysList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 09/07/2023.
//
//

import Foundation
import CoreData


extension HistoricalDelaysList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HistoricalDelaysList> {
        return NSFetchRequest<HistoricalDelaysList>(entityName: "HistoricalDelays")
    }

    @NSManaged public var delays: Data?
    @NSManaged public var arrTimeDelayWX: Int
    @NSManaged public var arrTimeDelay: Int
    @NSManaged public var id: UUID?
    @NSManaged public var ymax: Int
    @NSManaged public var type: String?
    @NSManaged public var eta: String?
    
    public var unwrappedDelays: [String: Any] {
        if let delays = delays {
            do {
                if let arr = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(delays) as? [String: Any] {
                  print("arr=====>\(arr)")
                return arr
              }
          } catch {
            print("could not unarchive array: \(error)")
          }
        }
        return ["condition": "", "time": "", "delay": 0]
    }
    
    public var unwrappedType: String {
        type ?? "" // flight3, week1, months3
    }
    
    public var unwrappedEta: String {
        eta ?? ""
    }
}

extension HistoricalDelaysList : Identifiable {

}
