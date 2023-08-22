//
//  fetchFuelData.swift
//  ATLAS
//
//  Created by Muhammad Adil on 30/6/23.
//

import Foundation

// class that stores the API response
class GlobalResponse: ObservableObject {
    @Published var response: String = ""
    
    static let shared = GlobalResponse()
    private init() {}
}

// class to perform API call
class APIManager: ObservableObject {
    static let shared = APIManager()
    private let globalResponse = GlobalResponse.shared

    private init() {}

    func makePostRequest(completion: @escaping (String?) -> Void = { _ in }) async {
        guard let url = URL(string: "https://accumulus-backend-atlas-lvketaariq-et.a.run.app/ATLAS_get_fuel_data") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Create the request body data
        let requestBody = [
            "airline": "accumulus air",
            "fltno": "EK352",
            "eta": "18:00",
            "arr": "SIN",
            "dep": "DXB"
        ]
        print(requestBody)
        do {
            // Convert the request body to JSON data
            let requestData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            // Set the request body data
            request.httpBody = requestData
            
            // Set the Content-Type header to indicate JSON format
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let (data, _) = try await URLSession.shared.data(for: request)
            if let responseString = String(data: data, encoding: .utf8) {
                // to deal with API response as a string
                //let trimmedString = responseString.trimmingCharacters(in: CharacterSet(charactersIn: "\""))
                DispatchQueue.main.async {
                    self.globalResponse.response = responseString
                    print("responseString: \(responseString)")
                }
                completion(responseString)
                print("fetched")              

            } else {
                completion(nil)
            }
        } catch {
            print("Error: \(error)")
            completion(nil)
        }
    }
}


// struct that defines the nested JSON structure
struct allAPIresponseNestedJSON: Codable {
       
    struct projArrivalDelaysNestedJSON: Codable {
        let delays: [ProjArrivalDelaysJSON]
        let expectedDelay: Float
        let eta: String

        private enum CodingKeys: String, CodingKey {
            case delays, expectedDelay, eta
        }
    }
    
    struct arrivalDelaysNestedJSON: Codable {
        struct DelayInfo: Codable {
            let arrTimeDelay: Int
            let arrTimeDelayWX: Int
            let eta: String
            let ymax: Int
            let delays: [ArrivalDelaysJSON]
        }

        let days3: DelayInfo
        let week1: DelayInfo
        let months3: DelayInfo

        private enum CodingKeys: String, CodingKey {
            case days3 = "days3"
            case week1 = "week1"
            case months3 = "months3"
        }
    }
    
    struct taxiNestedJSON: Codable {
        struct TimeInfo: Codable {
            let aveTime: Int
            let aveDiff: Int
            let times: [TaxiTimesJSON]
            let ymax: Int
        }

        let flights3: TimeInfo
        let week1: TimeInfo
        let months3: TimeInfo

        private enum CodingKeys: String, CodingKey {
            case flights3 = "flights3"
            case week1 = "week1"
            case months3 = "months3"
        }
    }
    
    struct trackMilesNestedJSON: Codable {
        struct trackMilesInfo: Codable {
            let sumNM: Int
            let sumMINS: Int
            let trackMiles: [TrackMilesJSON]
        }

        let flights3: trackMilesInfo
        let week1: trackMilesInfo
        let months3: trackMilesInfo

        private enum CodingKeys: String, CodingKey {
            case flights3 = "flights3"
            case week1 = "week1"
            case months3 = "months3"
        }
    }
    
    struct enrWXTrackMilesNestedJSON: Codable {
        struct trackMilesInfo: Codable {
            let aveNM: Int
            let aveMINS: Int
            let trackMiles: [EnrWXTrackMilesJSON]
        }

        let flights3: trackMilesInfo
        let week1: trackMilesInfo
        let months3: trackMilesInfo

        private enum CodingKeys: String, CodingKey {
            case flights3 = "flights3"
            case week1 = "week1"
            case months3 = "months3"
        }
    }

    struct flightLevelNestedJSON: Codable {
        struct flightLevelInfo: Codable {
            let aveDiff: Int
            let flightLevels: [FlightLevelJSON]
        }

        let flights3: flightLevelInfo
        let week1: flightLevelInfo
        let months3: flightLevelInfo

        private enum CodingKeys: String, CodingKey {
            case flights3 = "flights3"
            case week1 = "week1"
            case months3 = "months3"
        }
    }
    
    struct reciprocalRwyNestedJSON: Codable {
              
        let trackMiles: [ReciprocalRwyTrackMilesJSON]
        let aveNM: Int
        let aveMINS: Int

        private enum CodingKeys: String, CodingKey {
            case trackMiles, aveNM, aveMINS
        }
    }
       
    let projDelays: projArrivalDelaysNestedJSON
    let historicalDelays: arrivalDelaysNestedJSON
    let taxi: taxiNestedJSON
    let trackMiles: trackMilesNestedJSON
    let enrWX: enrWXTrackMilesNestedJSON
    let flightLevel: flightLevelNestedJSON
    let reciprocalRwy: reciprocalRwyNestedJSON
    
    private enum CodingKeys: String, CodingKey {
        case projDelays = "projDelays"
        case historicalDelays = "historicalDelays"
        case taxi = "taxi"
        case trackMiles = "trackMiles"
        case enrWX = "enrWX"
        case flightLevel = "flightLevel"
        case reciprocalRwy = "reciprocalRwy"
    }

}

// struct that defines the processed data model structure for Swift Data
struct processedFuelDataModel: Codable {
       
    struct projArrivalDelaysNestedJSON: Codable {
        let delays: [ProjArrivalDelays]
        let expectedDelay: Int
        let eta: Date

        private enum CodingKeys: String, CodingKey {
            case delays, expectedDelay, eta
        }
    }
    
    struct arrivalDelaysNestedJSON: Codable {
        struct DelayInfo: Codable {
            let arrTimeDelay: Int
            let arrTimeDelayWX: Int
            let eta: Date
            let ymax: Int
            let delays: [ArrivalDelays]
        }

        var days3: DelayInfo?
        var week1: DelayInfo?
        var months3: DelayInfo?

        private enum CodingKeys: String, CodingKey {
            case days3 = "days3"
            case week1 = "week1"
            case months3 = "months3"
        }
    }
    
    struct taxiNestedJSON: Codable {
        struct TimeInfo: Codable {
            let aveTime: Int
            let aveDiff: Int
            let times: [TaxiTimes]
            let ymax: Int
        }

        var flights3: TimeInfo?
        var week1: TimeInfo?
        var months3: TimeInfo?

        private enum CodingKeys: String, CodingKey {
            case flights3 = "flights3"
            case week1 = "week1"
            case months3 = "months3"
        }
    }
    
    struct trackMilesNestedJSON: Codable {
        struct trackMilesInfo: Codable {
            let sumNM: Int
            let sumMINS: Int
            let trackMiles: [TrackMiles]
        }

        var flights3: trackMilesInfo?
        var week1: trackMilesInfo?
        var months3: trackMilesInfo?

        private enum CodingKeys: String, CodingKey {
            case flights3 = "flights3"
            case week1 = "week1"
            case months3 = "months3"
        }
    }
    
    struct enrWXTrackMilesNestedJSON: Codable {
        struct trackMilesInfo: Codable {
            let aveNM: Int
            let aveMINS: Int
            let trackMiles: [EnrWXTrackMiles]
        }

        var flights3: trackMilesInfo?
        var week1: trackMilesInfo?
        var months3: trackMilesInfo?

        private enum CodingKeys: String, CodingKey {
            case flights3 = "flights3"
            case week1 = "week1"
            case months3 = "months3"
        }
    }

    struct flightLevelNestedJSON: Codable {
        struct flightLevelInfo: Codable {
            let aveDiff: Int
            let flightLevels: [FlightLevel]
        }

        var flights3: flightLevelInfo?
        var week1: flightLevelInfo?
        var months3: flightLevelInfo?

        private enum CodingKeys: String, CodingKey {
            case flights3 = "flights3"
            case week1 = "week1"
            case months3 = "months3"
        }
    }
    
    struct reciprocalRwyNestedJSON: Codable {
              
        let trackMiles: [ReciprocalRwyTrackMiles]
        let aveNM: Int
        let aveMINS: Int

        private enum CodingKeys: String, CodingKey {
            case trackMiles, aveNM, aveMINS
        }
    }
       
    var projDelays: projArrivalDelaysNestedJSON?
    var historicalDelays: arrivalDelaysNestedJSON?
    var taxi: taxiNestedJSON?
    var trackMiles: trackMilesNestedJSON?
    var enrWX: enrWXTrackMilesNestedJSON?
    var flightLevel: flightLevelNestedJSON?
    var reciprocalRwy: reciprocalRwyNestedJSON?
    
    private enum CodingKeys: String, CodingKey {
        case projDelays = "projDelays"
        case historicalDelays = "historicalDelays"
        case taxi = "taxi"
        case trackMiles = "trackMiles"
        case enrWX = "enrWX"
        case flightLevel = "flightLevel"
        case reciprocalRwy = "reciprocalRwy"
    }

}

// inner function to convert from JSON to swift data structure
func convertAllResponseJSONToObject(json: allAPIresponseNestedJSON) -> processedFuelDataModel {
    var object: processedFuelDataModel = processedFuelDataModel(projDelays: nil, historicalDelays: nil, taxi: nil, trackMiles: nil, enrWX: nil, flightLevel: nil, reciprocalRwy: nil)
    
    var trackMilesObject: processedFuelDataModel.trackMilesNestedJSON = processedFuelDataModel.trackMilesNestedJSON(flights3: nil, week1: nil, months3: nil)
    var arrivalDelaysObject: processedFuelDataModel.arrivalDelaysNestedJSON = processedFuelDataModel.arrivalDelaysNestedJSON(days3: nil, week1: nil, months3: nil)
    var taxiObject: processedFuelDataModel.taxiNestedJSON = processedFuelDataModel.taxiNestedJSON(flights3: nil, week1: nil, months3: nil)
    var enrWxObject: processedFuelDataModel.enrWXTrackMilesNestedJSON = processedFuelDataModel.enrWXTrackMilesNestedJSON(flights3: nil, week1: nil, months3: nil)
    var flightLevelObject: processedFuelDataModel.flightLevelNestedJSON = processedFuelDataModel.flightLevelNestedJSON(flights3: nil, week1: nil, months3: nil)
    var reciprocalRwyObject: processedFuelDataModel.reciprocalRwyNestedJSON? = nil
    var projDelaysObject: processedFuelDataModel.projArrivalDelaysNestedJSON? = nil

    for (_, value) in Mirror(reflecting: json).children {
        if let nestedJSON = value as? allAPIresponseNestedJSON.trackMilesNestedJSON {
            for (key, value) in Mirror(reflecting: nestedJSON).children {
                if let nestedNestedJSON = value as? allAPIresponseNestedJSON.trackMilesNestedJSON.trackMilesInfo {
                    var trackMiles: [TrackMiles] = []
                    for trackMilesJSON in nestedNestedJSON.trackMiles {
                        let trackmile = TrackMiles(
                            phase: trackMilesJSON.phase,
                            condition: trackMilesJSON.condition,
                            trackMilesDiff: trackMilesJSON.trackMilesDiff
                        )
                        trackMiles.append(trackmile)
                    }
                    let nestedTrackMilesObject: processedFuelDataModel.trackMilesNestedJSON.trackMilesInfo = processedFuelDataModel.trackMilesNestedJSON.trackMilesInfo(sumNM: nestedNestedJSON.sumNM, sumMINS: nestedNestedJSON.sumMINS, trackMiles: trackMiles)
                    if key == "flights3" {
                        print("entered")
                        trackMilesObject.flights3 = nestedTrackMilesObject
                    } else if key == "week1" {
                        trackMilesObject.week1 = nestedTrackMilesObject
                    } else {
                        trackMilesObject.months3 = nestedTrackMilesObject
                    }
                }
            }
            object.trackMiles = trackMilesObject
        }
        else if let nestedJSON = value as? allAPIresponseNestedJSON.arrivalDelaysNestedJSON {
            for (key, value) in Mirror(reflecting: nestedJSON).children {
                if let nestedNestedJSON = value as? allAPIresponseNestedJSON.arrivalDelaysNestedJSON.DelayInfo {
                    var delays: [ArrivalDelays] = []
                    for delayJSON in nestedNestedJSON.delays {
                        let arrivalDelay = ArrivalDelays(
                            condition: delayJSON.condition,
                            time: parseTimeString(delayJSON.time)!,
                            delay: delayJSON.delay,
                            weather: "" // TODO handle weather
                        )
                        delays.append(arrivalDelay)
                    }
                    let nestedArrivalDelaysObject: processedFuelDataModel.arrivalDelaysNestedJSON.DelayInfo = processedFuelDataModel.arrivalDelaysNestedJSON.DelayInfo(arrTimeDelay: nestedNestedJSON.arrTimeDelay, arrTimeDelayWX: nestedNestedJSON.arrTimeDelayWX, eta: parseTimeString(nestedNestedJSON.eta)!, ymax: nestedNestedJSON.ymax, delays: delays)
                    if key == "days3" {
                        arrivalDelaysObject.days3 = nestedArrivalDelaysObject
                    } else if key == "week1" {
                        arrivalDelaysObject.week1 = nestedArrivalDelaysObject
                    } else {
                        arrivalDelaysObject.months3 = nestedArrivalDelaysObject
                    }
                }
            }
            object.historicalDelays = arrivalDelaysObject
        }
        else if let nestedJSON = value as? allAPIresponseNestedJSON.taxiNestedJSON {
            for (key, value) in Mirror(reflecting: nestedJSON).children {
                if let nestedNestedJSON = value as? allAPIresponseNestedJSON.taxiNestedJSON.TimeInfo {
                    var times: [TaxiTimes] = []
                    for timesJSON in nestedNestedJSON.times {
                        let time = TaxiTimes(
                            date: parseDateString(timesJSON.date)!,
                            condition: timesJSON.condition,
                            taxiTime: timesJSON.taxiTime
                        )
                        times.append(time)
                    }
                    let nestedTaxiObject: processedFuelDataModel.taxiNestedJSON.TimeInfo = processedFuelDataModel.taxiNestedJSON.TimeInfo(aveTime: nestedNestedJSON.aveTime, aveDiff: nestedNestedJSON.aveDiff, times: times, ymax: nestedNestedJSON.ymax)
                    if key == "flights3" {
                        taxiObject.flights3 = nestedTaxiObject
                    } else if key == "week1" {
                        taxiObject.week1 = nestedTaxiObject
                    } else {
                        taxiObject.months3 = nestedTaxiObject
                    }
                }
            }
            object.taxi = taxiObject
        }
        else if let nestedJSON = value as? allAPIresponseNestedJSON.enrWXTrackMilesNestedJSON {
            for (key, value) in Mirror(reflecting: nestedJSON).children {
                if let nestedNestedJSON = value as? allAPIresponseNestedJSON.enrWXTrackMilesNestedJSON.trackMilesInfo {
                    var trackMiles: [EnrWXTrackMiles] = []
                    for trackMilesJSON in nestedNestedJSON.trackMiles {
                        let trackmile = EnrWXTrackMiles(
                            date: parseDateString(trackMilesJSON.date)!,
                            condition: trackMilesJSON.condition,
                            trackMilesDiff: trackMilesJSON.trackMilesDiff
                        )
                        trackMiles.append(trackmile)
                    }
                    let nestedEnrWxObject: processedFuelDataModel.enrWXTrackMilesNestedJSON.trackMilesInfo = processedFuelDataModel.enrWXTrackMilesNestedJSON.trackMilesInfo(aveNM: nestedNestedJSON.aveNM, aveMINS: nestedNestedJSON.aveMINS, trackMiles: trackMiles)
                    if key == "flights3" {
                        enrWxObject.flights3 = nestedEnrWxObject
                    } else if key == "week1" {
                        enrWxObject.week1 = nestedEnrWxObject
                    } else {
                        enrWxObject.months3 = nestedEnrWxObject
                    }
                }
            }
            object.enrWX = enrWxObject
        }
        else if let nestedJSON = value as? allAPIresponseNestedJSON.flightLevelNestedJSON {
            for (key, value) in Mirror(reflecting: nestedJSON).children {
                if let nestedNestedJSON = value as? allAPIresponseNestedJSON.flightLevelNestedJSON.flightLevelInfo {
                    var flightLevels: [FlightLevel] = []
                    for flightLevelsJSON in nestedNestedJSON.flightLevels {
                        let level = FlightLevel(
                            waypoint: flightLevelsJSON.waypoint,
                            condition: flightLevelsJSON.condition,
                            flightLevel: flightLevelsJSON.flightLevel
                        )
                        flightLevels.append(level)
                    }
                    let nestedFlightLevelObject: processedFuelDataModel.flightLevelNestedJSON.flightLevelInfo = processedFuelDataModel.flightLevelNestedJSON.flightLevelInfo(aveDiff: nestedNestedJSON.aveDiff, flightLevels: flightLevels)
                    if key == "flights3" {
                        flightLevelObject.flights3 = nestedFlightLevelObject
                    } else if key == "week1" {
                        flightLevelObject.week1 = nestedFlightLevelObject
                    } else {
                        flightLevelObject.months3 = nestedFlightLevelObject
                    }
                }
            }
            object.flightLevel = flightLevelObject
        }
        else if let nestedJSON = value as? allAPIresponseNestedJSON.reciprocalRwyNestedJSON {
            var trackMiles: [ReciprocalRwyTrackMiles] = []
            for trackMilesJSON in nestedJSON.trackMiles {
                let trackMile = ReciprocalRwyTrackMiles(date: parseDateString(trackMilesJSON.date)!, condition: trackMilesJSON.condition, trackMilesDiff: trackMilesJSON.trackMilesDiff)
                trackMiles.append(trackMile)
            }
            
            let nestedReciprocalRwyObject: processedFuelDataModel.reciprocalRwyNestedJSON = processedFuelDataModel.reciprocalRwyNestedJSON(trackMiles: trackMiles, aveNM: nestedJSON.aveNM, aveMINS: nestedJSON.aveMINS)
            
            reciprocalRwyObject = nestedReciprocalRwyObject
            object.reciprocalRwy = reciprocalRwyObject
        }
        else if let nestedJSON = value as? allAPIresponseNestedJSON.projArrivalDelaysNestedJSON {
            var delays: [ProjArrivalDelays] = []
            for delayJSON in nestedJSON.delays {
                let projArrivalDelay = ProjArrivalDelays(
                    time: parseTimeString(delayJSON.time)!,
                    delay: Int(delayJSON.delay),
                    mindelay: Int(delayJSON.mindelay),
                    maxdelay: Int(delayJSON.maxdelay)
                )
                delays.append(projArrivalDelay)
            }
            
            let nestedProjDelayObject: processedFuelDataModel.projArrivalDelaysNestedJSON = processedFuelDataModel.projArrivalDelaysNestedJSON(delays: delays, expectedDelay: Int(nestedJSON.expectedDelay), eta: parseTimeString(nestedJSON.eta)!)
            
            projDelaysObject = nestedProjDelayObject
            object.projDelays = projDelaysObject
        }
    }
    return object
}

// function to convert from API response string to the right swift data structure for use
func convertAllresponseFromAPI(jsonString: String) -> processedFuelDataModel {
    let jsonData = jsonString.data(using: .utf8)!
    //print("jsonString: \(jsonString)")
    //var object: [String: Any] = [:]
    var objectStruct: processedFuelDataModel = processedFuelDataModel(projDelays: nil, historicalDelays: nil, taxi: nil, trackMiles: nil, enrWX: nil, flightLevel: nil)
    do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        // convert from string to JSON
        let nestedJSON = try decoder.decode(allAPIresponseNestedJSON.self, from: jsonData)
        //print("nestedJSON: \(nestedJSON)")
        // convert from JSON to swift data structure
        objectStruct = convertAllResponseJSONToObject(json: nestedJSON)
        //print("objectStruct: ", objectStruct)
    } catch {
        print("Error decoding JSON: \(error)")
    }
    return objectStruct
}

// SwiftData class which relies on the processedFuelDataModel struct
//@Model
//class FuelPageData {
//    var projDelays: processedFuelDataModel.projArrivalDelaysNestedJSON
//    var historicalDelays: processedFuelDataModel.arrivalDelaysNestedJSON
//    var taxi: processedFuelDataModel.taxiNestedJSON
//    var trackMiles: processedFuelDataModel.trackMilesNestedJSON
//    var enrWX: processedFuelDataModel.enrWXTrackMilesNestedJSON
//    var flightLevel: processedFuelDataModel.flightLevelNestedJSON
//    var reciprocalRwy: processedFuelDataModel.reciprocalRwyNestedJSON
//    
//    init(projDelays: processedFuelDataModel.projArrivalDelaysNestedJSON, historicalDelays: processedFuelDataModel.arrivalDelaysNestedJSON, taxi: processedFuelDataModel.taxiNestedJSON, trackMiles: processedFuelDataModel.trackMilesNestedJSON, enrWX: processedFuelDataModel.enrWXTrackMilesNestedJSON, flightLevel: processedFuelDataModel.flightLevelNestedJSON, reciprocalRwy: processedFuelDataModel.reciprocalRwyNestedJSON) {
//        self.projDelays = projDelays
//        self.historicalDelays = historicalDelays
//        self.taxi = taxi
//        self.trackMiles = trackMiles
//        self.enrWX = enrWX
//        self.flightLevel = flightLevel
//        self.reciprocalRwy = reciprocalRwy
//    }
//}
