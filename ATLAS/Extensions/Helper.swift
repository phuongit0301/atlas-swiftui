import Foundation
import SwiftUI
import CoreLocation
import Solar

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


func segmentFlightAndCalculateDaylightAndNightHours(departureLocation: CLLocationCoordinate2D, destinationLocation: CLLocationCoordinate2D, chocksOff: Date, chocksOn: Date, averageGroundSpeedKph: Double) -> (day: (hours: Int, minutes: Int), night: (hours: Int, minutes: Int)) {
    
    let departureTime = chocksOff
    let arrivalTime = chocksOn
    let coordinate₀ = CLLocation(latitude: departureLocation.latitude, longitude: departureLocation.longitude)
    let coordinate₁ = CLLocation(latitude: destinationLocation.latitude, longitude: destinationLocation.longitude)
    let distanceKm = coordinate₀.distance(from: coordinate₁)  / 1000.0
    let timeStep: TimeInterval = 1800  // 30mins in seconds
    
    var totalDaylightHours: Double = 0
    var totalNightHours: Double = 0
    var currentTime = departureTime
    
    while currentTime < arrivalTime {
        let currentSegmentDistance = (currentTime.timeIntervalSince(departureTime)) / 3600 * averageGroundSpeedKph
        let currentSegmentPercentage = currentSegmentDistance / distanceKm
        let currentCoordinate = intermediateCoordinateAlongGreatCircle(start: departureLocation, end: destinationLocation, percentage: currentSegmentPercentage)

        let solar = Solar(for: currentTime, coordinate: currentCoordinate)

//        let currentLatitude = departureLocation.latitude + (destinationLocation.latitude - departureLocation.latitude) * currentSegmentPercentage
//        let currentLongitude = departureLocation.longitude + (destinationLocation.longitude - departureLocation.longitude) * currentSegmentPercentage
//        print("currentSegmentDistance=========\(currentSegmentDistance)")
//        print("currentSegmentPercentage=========\(currentSegmentPercentage)")
//        print("currentLatitude=========\(currentLatitude)")
//        print("currentLongitude=========\(currentLongitude)")
        
//        let solar = Solar(for: currentTime, coordinate: CLLocationCoordinate2D(latitude: currentLatitude, longitude: currentLongitude))

        if solar?.isDaytime != nil {
            totalDaylightHours += timeStep
//            print("totalDaylightHours=========\(totalDaylightHours)")

        } else {
            totalNightHours += timeStep
//            print("totalNightHours=========\(totalNightHours)")

        }
        
        currentTime = currentTime.addingTimeInterval(timeStep)
        print("currentTime=========\(currentTime)")

    }
    print("totalDaylightHours=========\(totalDaylightHours)")
    print("totalNightHours=========\(totalNightHours)")
    let dayDuration = doubleToHoursMinutesTuple(totalDaylightHours)
    let nightDuration = doubleToHoursMinutesTuple(totalNightHours)
    print("dayDuration=========\(dayDuration)")
    print("nightDuration=========\(nightDuration)")

    return (day: (hours: dayDuration.hours, minutes: dayDuration.minutes), night: (hours: nightDuration.hours, minutes: nightDuration.minutes))
}

func doubleToHoursMinutesTuple(_ durationInSeconds: Double) -> (hours: Int, minutes: Int) {
    let totalMinutes = Int(durationInSeconds) / 60
    let hours = totalMinutes / 60
    let minutes = totalMinutes % 60

    return (hours, minutes)
}

func intermediateCoordinateAlongGreatCircle(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D, percentage: Double) -> CLLocationCoordinate2D {
    let EarthRadiusKilometers: Double = 6371.0
    let φ1 = start.latitude.toRadians
    let λ1 = start.longitude.toRadians
    let φ2 = end.latitude.toRadians
    let λ2 = end.longitude.toRadians

    let Δφ = φ2 - φ1
    let Δλ = λ2 - λ1

    let a = sin(Δφ / 2) * sin(Δφ / 2) + cos(φ1) * cos(φ2) * sin(Δλ / 2) * sin(Δλ / 2)
    let c = 2 * atan2(sqrt(a), sqrt(1 - a))

    let distance = Double(EarthRadiusKilometers) * c
    let azimuth = atan2(sin(Δλ) * cos(φ2), cos(φ1) * sin(φ2) - sin(φ1) * cos(φ2) * cos(Δλ))

    let newDistance = distance * percentage
    let newφ = asin(sin(φ1) * cos(newDistance / Double(EarthRadiusKilometers)) + cos(φ1) * sin(newDistance / Double(EarthRadiusKilometers)) * cos(azimuth))
    let newλ = λ1 + atan2(sin(azimuth) * sin(newDistance / Double(EarthRadiusKilometers)) * cos(φ1), cos(newDistance / Double(EarthRadiusKilometers)) - sin(φ1) * sin(newφ))

    return CLLocationCoordinate2D(latitude: newφ.toDegrees, longitude: newλ.toDegrees)
}

extension Double {
    var toRadians: Double {
        return self * .pi / 180.0
    }

    var toDegrees: Double {
        return self * 180.0 / .pi
    }
}

func renderTag(_ tag: String) -> [String]? {
    if tag != "" {
        if tag.contains(", ") {
            return tag.components(separatedBy: ", ")
        } else {
            return [tag]
        }
    }
    return []
}
