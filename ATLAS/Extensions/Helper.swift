//
//  Helper.swift
//  ATLAS
//
//  Created by phuong phan on 22/08/2023.
//

import Foundation
import SwiftUI

func calculateTime(_ startTime: String, _ endTime: String) -> String {
    var eTempTime = 0
    var sTempTime = 0
    
    if startTime.contains(":") {
        let arr = startTime.components(separatedBy: ":")
        
        if arr.count > 0 {
            sTempTime = (Int(arr[0]) ?? 0) * 60 + (Int(arr[1]) ?? 0)
        }
    }
    
    if endTime.contains(":") {
        let arr = endTime.components(separatedBy: ":")
        
        if arr.count > 0 {
            eTempTime = (Int(arr[0]) ?? 0) * 60 + (Int(arr[1]) ?? 0)
        }
    }
    
    let result = eTempTime - sTempTime
    let hours = result / 60
    let minutes = result % 60
    
    return String(format: "%02d:%02d", hours, minutes)
}

func calculateDateTime(_ startTime: String, _ endTime: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HHmm"
    
    let dateFormatterOut = DateFormatter()
    dateFormatterOut.dateFormat = "HHmm"
    
    var sDateTime = dateFormatter.date(from: dateFormatter.string(from: Date()))
    var eDateTime = dateFormatter.date(from: dateFormatter.string(from: Date()))
    
    if startTime.contains(" | ") {
        let arr = startTime.components(separatedBy: " | ")
        
        if arr.count > 0 {
            let dateMonth = arr[0].components(separatedBy: "/")
            let currentYear = Calendar.current.component(.year, from: Date())
            let formattedDateString = "\(currentYear)-\(dateMonth[1])-\(dateMonth[0]) \(arr[1])"
            sDateTime = dateFormatter.date(from: formattedDateString)
        }
    }
    
    if endTime.contains(" | ") {
        let arr = endTime.components(separatedBy: " | ")
        
        if arr.count > 0 {
            let dateMonth = arr[0].components(separatedBy: "/")
            let currentYear = Calendar.current.component(.year, from: Date())
            let formattedDateString = "\(currentYear)-\(dateMonth[1])-\(dateMonth[0]) \(arr[1])"
            eDateTime = dateFormatter.date(from: formattedDateString)
        }
    }
    
    let components = Calendar.current.dateComponents([.day, .hour, .minute], from: sDateTime!, to: eDateTime!)
    return "\(String(format:"%02d:%02d", components.hour ?? 0, components.minute ?? 0))"
}

extension Date {
    func isBetweeen(startDate: Date, endDate: Date) -> Bool {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return (min(startDate, endDate) ... max(startDate, endDate)) ~= self
    }
}
