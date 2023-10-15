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

func addDurationToDateTime(_ dateTimeString: String, _ durationString: String) -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

    guard let dateTime = dateFormatter.date(from: dateTimeString) else {
        return nil // Invalid date-time format
    }

    let durationFormatter = DateFormatter()
    durationFormatter.dateFormat = "HH:mm"
    
    guard let durationComponents = durationFormatter.date(from: durationString) else {
        return nil // Invalid duration format
    }

    let calendar = Calendar.current
    let newDateTime = calendar.date(byAdding: .hour, value: calendar.component(.hour, from: durationComponents), to: dateTime)!
    let finalDateTime = calendar.date(byAdding: .minute, value: calendar.component(.minute, from: durationComponents), to: newDateTime)!
    
    let resultFormatter = DateFormatter()
    resultFormatter.dateFormat = "yyyy-MM-dd HH:mm"

    return resultFormatter.string(from: finalDateTime)
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

func calculateDayNightDuration(_ departureUTC: String, _ arrivalUTC: String, _ departureSunrise: String, _ departureNextSunrise: String, _ departureSunset: String, _ arrivalSunset: String, _ arrivalSunrise: String, _ arrivalNextSunrise: String) -> (day: (hours: Int, minutes: Int), night: (hours: Int, minutes: Int)) {
    // Create DateFormatters for parsing the time strings
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    
    var departureDaylight: (hours: Int, minutes: Int) = (hours: 0, minutes: 0)
    var departureNight: (hours: Int, minutes: Int) = (hours: 0, minutes: 0)
    var arrivalDaylight: (hours: Int, minutes: Int) = (hours: 0, minutes: 0)
    var arrivalNight: (hours: Int, minutes: Int) = (hours: 0, minutes: 0)
    var departureToArrival: (hours: Int, minutes: Int) = (hours: 0, minutes: 0)
    
    print("departureSunrise=========\(departureSunrise)")
    print("departureSunset=========\(departureSunset)")
    print("arrivalSunrise=========\(arrivalSunrise)")
    print("arrivalSunset=========\(arrivalSunset)")
    print("arrivalNextSunrise=========\(arrivalNextSunrise)")
    print("departureNextSunrise=========\(departureNextSunrise)")
    
    let (departureSunrise1, departureNextSunrise1) = processDateStrings(departureUTC, departureSunrise, departureNextSunrise)  ?? ("", "")
    let (departureSunset1, _) = processDateStrings(departureUTC, departureSunset, departureSunset) ?? ("", "")
    let (arrivalSunrise1, arrivalNextSunrise1) = processDateStrings(arrivalUTC, arrivalSunrise, arrivalNextSunrise) ?? ("", "")
    let (arrivalSunset1, _) = processDateStrings(arrivalUTC, arrivalSunset, arrivalSunset) ?? ("", "")

    print("departureSunrise1=========\(departureSunrise1)")
    print("departureSunset1=========\(departureSunset1)")
    print("arrivalSunrise1=========\(arrivalSunrise1)")
    print("arrivalSunset1=========\(arrivalSunset1)")
    print("arrivalNextSunrise1=========\(arrivalNextSunrise1)")
    print("departureNextSunrise1=========\(departureNextSunrise1)")

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
    
    print("dayDuration=========\(dayDuration)")
    print("nightDuration=========\(nightDuration)")
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

func processDateStrings(_ dateTimeStringA: String, _ timeStringB: String, _ timeStringC: String) -> (String, String)? {
    // Create a DateFormatter to parse dateStringA
    let dateFormatter = DateFormatter()
    let dateTimeFormatter = DateFormatter()
    let timeFormatter = DateFormatter()
    
//    print("dateTimeStringA=========\(dateTimeStringA)")
//    print("timeStringB=========\(timeStringB)")
//    print("timeStringC=========\(timeStringC)")
    
    dateTimeFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    dateFormatter.dateFormat = "yyyy-MM-dd"
    timeFormatter.dateFormat = "HH:mm"
    
    // Parse dateStringA into a Date object
    let dateA = dateTimeFormatter.date(from: dateTimeStringA)
    // Create a Calendar instance
    let calendar = Calendar.current
    // Add dateA with time string B
    let dateStringA = dateFormatter.string(from: dateA!)
    let dateTimeStringB = "\(dateStringA) \(timeStringB)"
    let dateTimeB = dateTimeFormatter.date(from: dateTimeStringB)
    
//    print("dateStringA=========\(dateStringA)")
//    print("dateTimeStringB=========\(dateTimeStringB)")
//    print("dateTimeB=========\(dateTimeB)")
    
    // Add one day to dateA for date string C
    if let dateC = calendar.date(byAdding: .day, value: 1, to: dateA!) {
        // Add dateC with time string C
        let dateStringC = dateFormatter.string(from: dateC)
        let dateTimeStringC = "\(dateStringC) \(timeStringC)"
        let dateTimeC = dateTimeFormatter.date(from: dateTimeStringC)
        
//        print("dateStringC=========\(dateStringC)")
//        print("dateTimeStringC=========\(dateTimeStringC)")
//        print("dateTimeC=========\(dateTimeC)")
        
        return (dateTimeFormatter.string(from: dateTimeB!), dateTimeFormatter.string(from: dateTimeC!))
    }
    return nil
}
