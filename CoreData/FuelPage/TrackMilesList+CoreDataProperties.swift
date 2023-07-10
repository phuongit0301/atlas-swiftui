//
//  TrackMilesList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 09/07/2023.
//
//

import Foundation
import CoreData


extension TrackMilesList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrackMilesList> {
        return NSFetchRequest<TrackMilesList>(entityName: "TrackMiles")
    }

    @NSManaged public var trackMiles: Data?
    @NSManaged public var id: UUID?
    @NSManaged public var sumMINS: Int64
    @NSManaged public var sumNM: Int64
    @NSManaged public var type: String?
    
    public var unwrappedTrackMiles: [String: Any] {
        if let trackMiles = trackMiles {
            do {
                if let arr = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(trackMiles) as? [String: Any] {
                  print("arr=====>\(arr)")
                return arr
              }
          } catch {
            print("could not unarchive array: \(error)")
          }
        }
        return ["phase": "", "condition": "", "trackMilesDiff": 0]
    }
    
    public var unwrappedType: String {
        type ?? "" // flight3, week1, months3
    }
}

extension TrackMilesList : Identifiable {

}
