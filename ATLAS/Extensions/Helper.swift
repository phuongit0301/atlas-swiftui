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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return (min(startDate, endDate) ... max(startDate, endDate)) ~= self
    }
}

func convertUTCToLocalTime(timeString: String, timeDiff: String) -> String {
    let timeDiffInt = (timeDiff as NSString).integerValue
    // Create a DateFormatter
    let dateFormatter = DateFormatter()
    
    // Set the input format of the timeString
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    
    // Set the time zone of the input string to UTC
    dateFormatter.timeZone = TimeZone(identifier: "UTC")
    
    // Parse the input time string to get a Date object
    if let date = dateFormatter.date(from: timeString) {
        // Create a Calendar instance
        var calendar = Calendar.current
        
        // Set the time zone of the calendar to the local time zone (UTC + timeDiff hours)
        calendar.timeZone = TimeZone(secondsFromGMT: timeDiffInt * 3600)!
        
        // Use the calendar to convert the Date object to the local time zone
        let localDate = calendar.date(from: calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date))
        
        // Set the output format for the local time
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        // Set the time zone of the DateFormatter to the local time zone
        dateFormatter.timeZone = TimeZone(secondsFromGMT: timeDiffInt * 3600)
        
        // Format the local date as a string
        return dateFormatter.string(from: localDate!)
    }
    
    // Return nil if the conversion fails
    return ""
}

func calculateDayNightDuration(_ departureUTC: String, _ arrivalUTC: String, _ departureLocal: String, _ arrivalLocal: String, _ departureSunrise: String, _ departureNextSunrise: String, _ departureSunset: String, _ arrivalSunset: String, _ arrivalSunrise: String, _ arrivalNextSunrise: String) -> (day: (hours: Int, minutes: Int), night: (hours: Int, minutes: Int)) {
    // Create DateFormatters for parsing the time strings
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    
    var departureDaylight: (hours: Int, minutes: Int) = (hours: 0, minutes: 0)
    var departureNight: (hours: Int, minutes: Int) = (hours: 0, minutes: 0)
    var arrivalDaylight: (hours: Int, minutes: Int) = (hours: 0, minutes: 0)
    var arrivalNight: (hours: Int, minutes: Int) = (hours: 0, minutes: 0)
    var departureToArrival: (hours: Int, minutes: Int) = (hours: 0, minutes: 0)
    
    let (departureSunrise1, departureNextSunrise1) = processDateStrings(departureUTC, departureSunrise, departureNextSunrise)  ?? ("", "")
    let (departureSunset1, departureNextSunset1) = processDateStrings(departureUTC, departureSunset, departureSunset) ?? ("", "")
    let (arrivalSunrise1, arrivalNextSunrise1) = processDateStrings(arrivalUTC, arrivalSunrise, arrivalNextSunrise) ?? ("", "")
    let (arrivalSunset1, arrivalNextSunset1) = processDateStrings(arrivalUTC, arrivalSunset, arrivalSunset) ?? ("", "")

    // Create Calendar instances for working with dates and times
    let calendar = Calendar.current

    // Function to calculate the time difference in hours and minutes
    func calculateTimeDifference(_ start: Date, _ end: Date) -> (hours: Int, minutes: Int) {
        let components = calendar.dateComponents([.hour, .minute], from: start, to: end)
        return (components.hour ?? 0, components.minute ?? 0)
    }
    
    if let departureSunrise1 = dateFormatter.date(from: departureSunrise1), let departureSunset1 = dateFormatter.date(from: departureSunset1) {
        departureDaylight = calculateTimeDifference(departureSunrise1, departureSunset1)
    }
    
    if let departureSunset1 = dateFormatter.date(from: departureSunset1), let departureNextSunrise1 = dateFormatter.date(from: departureNextSunrise1) {
        departureNight =  calculateTimeDifference(departureSunset1, departureNextSunrise1)
    }
    
    if let arrivalSunrise1 = dateFormatter.date(from: arrivalSunrise1), let arrivalSunset1 = dateFormatter.date(from: arrivalSunset1) {
        arrivalDaylight =  calculateTimeDifference(arrivalSunrise1, arrivalSunset1)
    }
    
    if let arrivalSunset1 = dateFormatter.date(from: arrivalSunset1), let arrivalNextSunrise1 = dateFormatter.date(from: arrivalNextSunrise1) {
        arrivalNight =  calculateTimeDifference(arrivalSunset1, arrivalNextSunrise1)
    }
    
    if let departureUTCDate = dateFormatter.date(from: departureUTC), let arrivalUTCDate = dateFormatter.date(from: arrivalUTC) {
        departureToArrival = calculateTimeDifference(departureUTCDate, arrivalUTCDate)
    }
    
    let dayDuration = minimumDuration(departureDaylight, arrivalDaylight, departureToArrival)
    let nightDuration = minimumDuration(departureNight, arrivalNight, departureToArrival)
    
    return (day: (hours: dayDuration.hours, minutes: dayDuration.minutes), night: (hours: nightDuration.hours, minutes: nightDuration.minutes))
}

func minimumDuration(_ durationA: (hours: Int, minutes: Int), _ durationB: (hours: Int, minutes: Int), _ durationC: (hours: Int, minutes: Int)) -> (hours: Int, minutes: Int) {
    let durations = [durationA, durationB, durationC]
    
    // Sort the durations based on total minutes
    let sortedDurations = durations.sorted { (a, b) in
        let totalMinutesA = a.hours * 60 + a.minutes
        let totalMinutesB = b.hours * 60 + b.minutes
        return totalMinutesA < totalMinutesB
    }
    
    // The first element in sortedDurations will be the minimum duration
    return sortedDurations[0]
}

func processDateStrings(_ dateStringA: String, _ timeStringB: String, _ timeStringC: String) -> (String, String)? {
    // Create a DateFormatter to parse dateStringA
    let dateFormatterA = DateFormatter()
    dateFormatterA.dateFormat = "yyyy-MM-dd HH:mm"
    
    // Parse dateStringA into a Date object
    if let dateA = dateFormatterA.date(from: dateStringA) {
        // Create a Calendar instance
        let calendar = Calendar.current
        
        // Add zero days to dateA for date string B
//        if let dateForB = dateA {
            // Create a DateFormatter to format the combined date and time
            let dateFormatterCombined = DateFormatter()
            dateFormatterCombined.dateFormat = "yyyy-MM-dd HH:mm"
            
            // Format dateForB with timeStringB
            let combinedDateB = dateFormatterCombined.string(from: dateA)
            
            // Add one day to dateA for date string C
            if let dateForC = calendar.date(byAdding: .day, value: 1, to: dateA) {
                // Format dateForC with timeStringC
                let combinedDateC = dateFormatterCombined.string(from: dateForC)
                
                return (combinedDateB, combinedDateC)
            }
//        }
    }
    
    return nil
}
