//
//  fetchFuelData.swift
//  ATLAS
//
//  Created by Muhammad Adil on 30/6/23.
//

import Foundation

class GlobalResponse: ObservableObject {
    @Published var response: String = ""
    
    static let shared = GlobalResponse()
    private init() {}
}

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
                    //print("responseString: \(responseString)")
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
       
    let projDelays: projArrivalDelaysNestedJSON
    let historicalDelays: arrivalDelaysNestedJSON
    let taxi: taxiNestedJSON
    let trackMiles: trackMilesNestedJSON
    let enrWX: enrWXTrackMilesNestedJSON
    let flightLevel: flightLevelNestedJSON
    
    private enum CodingKeys: String, CodingKey {
        case projDelays = "projDelays"
        case historicalDelays = "historicalDelays"
        case taxi = "taxi"
        case trackMiles = "trackMiles"
        case enrWX = "enrWX"
        case flightLevel = "flightLevel"
    }

}

func convertAllResponseJSONToObject(json: allAPIresponseNestedJSON) -> [String: Any] {
    var object: [String: Any] = [:]

    for (key, value) in Mirror(reflecting: json).children {
        var nestedObject: [String: Any] = [:]
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
                    let nestedNestedObject: [String: Any] = [
                        "sumNM": nestedNestedJSON.sumNM,
                        "sumMINS": nestedNestedJSON.sumMINS,
                        "trackMiles": trackMiles
                    ]
                    nestedObject[key!] = nestedNestedObject
                }
            }
            object[key!] = nestedObject
        }
        else if let nestedJSON = value as? allAPIresponseNestedJSON.arrivalDelaysNestedJSON {
            for (key, value) in Mirror(reflecting: nestedJSON).children {
                if let nestedNestedJSON = value as? allAPIresponseNestedJSON.arrivalDelaysNestedJSON.DelayInfo {
                    var delays: [ArrivalDelays] = []
                    for delayJSON in nestedNestedJSON.delays {
                        let arrivalDelay = ArrivalDelays(
                            condition: delayJSON.condition,
                            time: parseTimeString(delayJSON.time)!,
                            delay: delayJSON.delay
                        )
                        delays.append(arrivalDelay)
                    }
                    let nestedNestedObject: [String: Any] = [
                        "arrTimeDelay": nestedNestedJSON.arrTimeDelay,
                        "arrTimeDelayWX": nestedNestedJSON.arrTimeDelayWX,
                        "delays": delays,
                        "eta": parseTimeString(nestedNestedJSON.eta)!,
                        "ymax": nestedNestedJSON.ymax
                    ]
                    nestedObject[key!] = nestedNestedObject
                }
            }
            object[key!] = nestedObject
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
                    let nestedNestedObject: [String: Any] = [
                        "aveTime": nestedNestedJSON.aveTime,
                        "aveDiff": nestedNestedJSON.aveDiff,
                        "times": times,
                        "ymax": nestedNestedJSON.ymax
                    ]
                    nestedObject[key!] = nestedNestedObject
                }
            }
            object[key!] = nestedObject
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
                    let nestedNestedObject: [String: Any] = [
                        "aveNM": nestedNestedJSON.aveNM,
                        "aveMINS": nestedNestedJSON.aveMINS,
                        "trackMiles": trackMiles
                    ]
                    nestedObject[key!] = nestedNestedObject
                }
            }
            object[key!] = nestedObject
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
                    let nestedNestedObject: [String: Any] = [
                        "aveDiff": nestedNestedJSON.aveDiff,
                        "flightLevels": flightLevels
                    ]
                    nestedObject[key!] = nestedNestedObject
                }
            }
            object[key!] = nestedObject
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
            let nestedObject: [String: Any] = [
                "expectedDelay": Int(nestedJSON.expectedDelay),
                "eta": parseTimeString(nestedJSON.eta)!,
                "delays": delays
            ]
            object[key!] = nestedObject
        }
    }
    return object
}

func convertAllresponseFromAPI(jsonString: String) -> [String : Any] {
    let jsonData = jsonString.data(using: .utf8)!
    //print("jsonString: \(jsonString)")
    var object: [String : Any] = [:]
    do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let nestedJSON = try decoder.decode(allAPIresponseNestedJSON.self, from: jsonData)
        //print("nestedJSON: \(nestedJSON)")
        object = convertAllResponseJSONToObject(json: nestedJSON)
        //print(object)
    } catch {
        print("Error decoding JSON: \(error)")
    }
    return object
}
