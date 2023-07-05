//
//  FuelDataList+CoreDataProperties.swift
//  ATLAS
//
//  Created by phuong phan on 04/07/2023.
//
//

import Foundation
import CoreData


extension FuelDataList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FuelDataList> {
        return NSFetchRequest<FuelDataList>(entityName: "FuelData")
    }

    @NSManaged public var burnoff: Data?
    @NSManaged public var cont: Data?
    @NSManaged public var id: UUID?
    @NSManaged public var altn: Data?
    @NSManaged public var hold: Data?
    @NSManaged public var topup60: Data?
    @NSManaged public var taxi: Data?
    @NSManaged public var planReq: Data?
    @NSManaged public var dispAdd: Data?
    
    public var unwrappedBurnoff: [String: String] {
        if let burnoff = burnoff {
            do {
              if let arr = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(burnoff) as? [String: String] {
                return arr
              }
          } catch {
            print("could not unarchive array: \(error)")
          }
        }
        return ["time": "0", "fuel": "0", "unit": "0"]
    }
    
    public var unwrappedCont: [String: String] {
        if let cont = cont {
            do {
              if let arr = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(cont) as? [String: String] {
                return arr
              }
          } catch {
            print("could not unarchive array: \(error)")
          }
        }
        return ["time": "0", "fuel": "0", "policy": "0"]
    }
    
    public var unwrappedAltn: [String: String] {
        if let altn = altn {
            do {
              if let arr = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(altn) as? [String: String] {
                return arr
              }
          } catch {
            print("could not unarchive array: \(error)")
          }
        }
        return ["time": "0", "fuel": "0", "unit": "0"]
    }
    
    public var unwrappedHold: [String: String] {
        if let hold = hold {
            do {
              if let arr = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(hold) as? [String: String] {
                return arr
              }
          } catch {
            print("could not unarchive array: \(error)")
          }
        }
        return ["time": "0", "fuel": "0", "unit": "0"]
    }
    
    public var unwrappedTopup60: [String: String] {
        if let topup60 = topup60 {
            do {
              if let arr = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(topup60) as? [String: String] {
                return arr
              }
          } catch {
            print("could not unarchive array: \(error)")
          }
        }
        return ["time": "0", "fuel": "0"]
    }
    
    public var unwrappedTaxi: [String: String] {
        if let taxi = taxi {
            do {
              if let arr = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(taxi) as? [String: String] {
                return arr
              }
          } catch {
            print("could not unarchive array: \(error)")
          }
        }
        return ["time": "0", "fuel": "0", "policy": "", "unit": ""]
    }
    
    public var unwrappedPlanReq: [String: String] {
        if let planReq = planReq {
            do {
              if let arr = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(planReq) as? [String: String] {
                return arr
              }
          } catch {
            print("could not unarchive array: \(error)")
          }
        }
        return ["time": "0", "fuel": "0"]
    }
    
    public var unwrappedDispAdd: [String: String] {
        if let dispAdd = dispAdd {
            do {
              if let arr = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(dispAdd) as? [String: String] {
                return arr
              }
          } catch {
            print("could not unarchive array: \(error)")
          }
        }
        return ["time": "0", "fuel": "0", "policy": ""]
    }
}

extension FuelDataList : Identifiable {

}
