//
//  RemoteService.swift
//  ATLAS
//
//  Created by phuong phan on 07/07/2023.
//

import Foundation
import SwiftUI

enum RemoteError: Error {
    case error(String)
}

class RemoteService: ObservableObject {
    @AppStorage("uid") var userID: String = ""
    static let shared = RemoteService()
    
    let baseURL = "https://accumulus-backend-atlas-lvketaariq-et.a.run.app"
    
    private init() {}
    
    func getCalendarData() async -> ICalendarResponse?  {
        guard let url = URL(string: "https://accumulus-backend-atlas-lvketaariq-et.a.run.app/ATLAS_get_calendar_data") else { fatalError("Missing URL") }
            //make request
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            // Create the request body data
            let requestBody = [
                "user_id": userID,
            ]
            
            do {
                // Convert the request body to JSON data
                let requestData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
                // Set the request body data
                request.httpBody = requestData
                
                // Set the Content-Type header to indicate JSON format
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let (data, _) = try await URLSession.shared.data(for: request)
                
                do {
                    let decodedSearch = try JSONDecoder().decode(ICalendarResponse.self, from: data)
                    return decodedSearch
                } catch let error {
                    print("Error decoding: ", error)
                }
                 
            } catch {
                print("Error: \(error)")
            }
        return nil
    }
    
    func postCalendarData(_ parameters: Any) async -> Bool  {
        guard let url = URL(string: "https://accumulus-backend-atlas-lvketaariq-et.a.run.app/ATLAS_post_calendar_data") else { fatalError("Missing URL") }
        //make request
        var request = URLRequest(url: url)
        let postData: Data? = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = postData
        
        do {
            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Request error: ", error)
                    return
                }
                DispatchQueue.main.async {
                    guard let response = response as? HTTPURLResponse else { return }
                    if response.statusCode == 200 {
                        print("Update calendar successfully")
                        return
                    }
                }
            }
            
            dataTask.resume()
        } catch {
            print("Error: \(error)")
            return false
        }
        
        return true
    }
    
    func getFlightStatsData(_ parameters: Any) async -> IFuelDataModel?  {
        guard let url = URL(string: "https://accumulus-backend-atlas-lvketaariq-et.a.run.app/ATLAS_get_flight_stats") else { fatalError("Missing URL") }
            //make request
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            do {
                // Convert the request body to JSON data
                let requestData = try JSONSerialization.data(withJSONObject: parameters, options: [])
                // Set the request body data
                request.httpBody = requestData
                
                // Set the Content-Type header to indicate JSON format
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let (data, _) = try await URLSession.shared.data(for: request)
                
                do {
                    let decodedSearch = try JSONDecoder().decode(IFuelDataModel.self, from: data)
                    return decodedSearch
                } catch let error {
                    print("Error decoding: ", error)
                }
                 
            } catch {
                print("Error: \(error)")
            }
        return nil
    }
    
    func postUserData(_ parameters: Any, completion: @escaping (_ success: Bool) -> Void) async  {
        guard let url = URL(string: "https://accumulus-backend-atlas-lvketaariq-et.a.run.app/ATLAS_post_user_data") else { fatalError("Missing URL") }
        //make request
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            // Convert the request body to JSON data
            let requestData: Data? = try JSONSerialization.data(withJSONObject: parameters, options: [])
//            print("json=============\(String(data: requestData!, encoding: .utf8)!)")
            // Set the request body data
            request.httpBody = requestData
            
            let (_, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else { return }
            
            if response.statusCode == 200 {
                print("Create Profile successfully")
                completion(true)
            }
        } catch {
            print("Error: \(error)")
            completion(false)
        }
    }
    
    func getFlightPlanDataV3() async -> [FlightDataV30Json]  {
        guard let url = URL(string: "https://accumulus-backend-atlas-lvketaariq-et.a.run.app/ATLAS_get_flights_data") else { fatalError("Missing URL") }
            //make request
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            // Create the request body data
            let requestBody = [
                "user_id": userID,
            ]
        
            do {
                // Convert the request body to JSON data
                let requestData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
                // Set the request body data
                request.httpBody = requestData
                
                // Set the Content-Type header to indicate JSON format
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let (data, _) = try await URLSession.shared.data(for: request)
                
                do {
                    let decodedSearch = try JSONDecoder().decode([FlightDataV30Json].self, from: data)
                    return decodedSearch
                } catch let error {
                    print("Error decoding: ", error)
                }
                 
            } catch {
                print("Error: \(error)")
            }
        return []
    }
    
    func postFlightPlanDataV3(_ parameters: Any) async -> Bool  {
        guard let url = URL(string: "https://accumulus-backend-atlas-lvketaariq-et.a.run.app/ATLAS_post_flights_data") else { fatalError("Missing URL") }
        //make request
        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"

        do {
            // Convert the request body to JSON data
            let requestData: Data? = try? JSONSerialization.data(withJSONObject: parameters, options: [])
            print("json=============\(String(data: requestData!, encoding: .utf8)!)")
            // Set the request body data
            request.httpBody = requestData
            
            let (_, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else { return false }
            
            if response.statusCode == 200 {
                print("Update Flight Plan successfully")
                return true
            }
        } catch {
            print("Error: \(error)")
            return false
        }
        return false
    }
    
    func getFlightPlanData() async -> IFlightPlanDataModel?  {
        guard let url = URL(string: "https://accumulus-backend-atlas-lvketaariq-et.a.run.app/ATLAS_get_flightPlan_data") else { fatalError("Missing URL") }
            //make request
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            // Create the request body data
            let requestBody = [
                "user_id": userID,
            ]
            
            do {
                // Convert the request body to JSON data
                let requestData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
                // Set the request body data
                request.httpBody = requestData
                
                // Set the Content-Type header to indicate JSON format
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let (data, _) = try await URLSession.shared.data(for: request)
                
                do {
                    let decodedSearch = try JSONDecoder().decode(IFlightPlanDataModel.self, from: data)
                    return decodedSearch
                } catch let error {
                    print("Error decoding: ", error)
                }
                 
            } catch {
                print("Error: \(error)")
            }
        return nil
    }
    
    func getFlightPlanWX() async -> IFlightPlanWXResponseModel?  {
        guard let url = URL(string: "https://accumulus-backend-atlas-lvketaariq-et.a.run.app/ATLAS_get_flightPlan_wx") else { fatalError("Missing URL") }
            //make request
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            // Create the request body data
            let requestBody = [
                "company": "Test Company",
                "flight_no": "TR753",
                "flightDate": "2023-07-24"
//                "flightDate": "2023-07-08"
            ]
            
            do {
                // Convert the request body to JSON data
                let requestData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
                // Set the request body data
                request.httpBody = requestData
                
                // Set the Content-Type header to indicate JSON format
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let (data, _) = try await URLSession.shared.data(for: request)
                
                do {
                    let decodedSearch = try JSONDecoder().decode(IFlightPlanWXResponseModel.self, from: data)
                    return decodedSearch
                } catch let error {
                    print("Error decoding: ", error)
                }
                 
            } catch {
                print("Error: \(error)")
            }
        return nil
    }
    
    func getLogbookData() async -> ILogbookJson?  {
        guard let url = URL(string: "https://accumulus-backend-atlas-lvketaariq-et.a.run.app/ATLAS_get_logbook_data") else { fatalError("Missing URL") }
            //make request
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            // Create the request body data
            let requestBody = [
                "user_id": userID,
            ] as [String : Any]
            
            do {
                // Convert the request body to JSON data
                let requestData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
                // Set the request body data
                request.httpBody = requestData
                
                // Set the Content-Type header to indicate JSON format
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let (data, _) = try await URLSession.shared.data(for: request)
                
                do {
                    let decodedSearch = try JSONDecoder().decode(ILogbookJson.self, from: data)
                    return decodedSearch
                } catch let error {
                    print("Error decoding: ", error)
                }
            } catch {
                print("Error: \(error)")
            }
        return nil
    }
    
    func postLogbookData(_ parameters: Any) async -> Bool  {
        guard let url = URL(string: "https://accumulus-backend-atlas-lvketaariq-et.a.run.app/ATLAS_post_logbook_data") else { fatalError("Missing URL") }
        //make request
        var request = URLRequest(url: url)
        let postData: Data? = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = postData
        
        do {
            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Request error: ", error)
                    return
                }
                DispatchQueue.main.async {
                    guard let response = response as? HTTPURLResponse else { return }
                    if response.statusCode == 200 {
                        print("Update calendar successfully")
                        return
                    }
                }
            }
            
            dataTask.resume()
        } catch {
            print("Error: \(error)")
            return false
        }
        
        return true
    }
    
    func getLimitationData() async -> ILimitationJson?  {
        guard let url = URL(string: "https://accumulus-backend-atlas-lvketaariq-et.a.run.app/ATLAS_get_limitation_data") else { fatalError("Missing URL") }
            //make request
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            // Create the request body data
            let requestBody = [
                "user_id": userID,
            ] as [String : Any]
            
            do {
                // Convert the request body to JSON data
                let requestData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
                // Set the request body data
                request.httpBody = requestData
                
                // Set the Content-Type header to indicate JSON format
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let (data, _) = try await URLSession.shared.data(for: request)
                
                do {
                    let decodedSearch = try JSONDecoder().decode(ILimitationJson.self, from: data)
                    return decodedSearch
                } catch let error {
                    print("Error decoding: ", error)
                }
            } catch {
                print("Error: \(error)")
            }
        return nil
    }
    
    func postLimitationData(_ parameters: Any) async -> Bool  {
        guard let url = URL(string: "https://accumulus-backend-atlas-lvketaariq-et.a.run.app/ATLAS_post_limitation_data") else { fatalError("Missing URL") }
        //make request
        var request = URLRequest(url: url)
        let postData: Data? = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }
            guard let response = response as? HTTPURLResponse else { return }
            
            if response.statusCode == 200 {
                print("Update Limitation successfully")
                return
            }
        }
        
        dataTask.resume()
        return true
    }
    
    func getRecencyData() async -> IRecencyJson?  {
        guard let url = URL(string: "https://accumulus-backend-atlas-lvketaariq-et.a.run.app/ATLAS_get_recency_data") else { fatalError("Missing URL") }
            //make request
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            // Create the request body data
            let requestBody = [
                "user_id": userID,
            ] as [String : Any]
            
            do {
                // Convert the request body to JSON data
                let requestData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
                // Set the request body data
                request.httpBody = requestData
                
                // Set the Content-Type header to indicate JSON format
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let (data, _) = try await URLSession.shared.data(for: request)
                
                do {
                    let decodedSearch = try JSONDecoder().decode(IRecencyJson.self, from: data)
                    return decodedSearch
                } catch let error {
                    print("Error decoding: ", error)
                }
            } catch {
                print("Error: \(error)")
            }
        return nil
    }
    
    func postRecencyData(_ parameters: Any) async -> Bool  {
        guard let url = URL(string: "https://accumulus-backend-atlas-lvketaariq-et.a.run.app/ATLAS_post_recency_data") else { fatalError("Missing URL") }
        //make request
        var request = URLRequest(url: url)
        let postData: Data? = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = postData
//        let convertedString = String(data: postData!, encoding: .utf8)
//        print("convertedString======\(convertedString)")
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else { return false }
            if response.statusCode == 200 {
                print("Update recency successfully")
                return true
            }
        } catch {
            print("Request error: ", error)
            return false
        }
        return false
    }
    
    func updateFuelData(_ parameters: Any, completion: @escaping (_ success: Bool) -> Void) async  {
        guard let url = URL(string: "https://accumulus-backend-atlas-lvketaariq-et.a.run.app/ATLAS_update_flightPlan_data") else { fatalError("Missing URL") }
            //make request
            var request = URLRequest(url: url)
            let postData: Data? = try? JSONSerialization.data(withJSONObject: parameters, options: [])
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = postData
            
            do {
                let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        print("Request error: ", error)
                        return
                    }
                    DispatchQueue.main.async {
                        guard let response = response as? HTTPURLResponse else { return }
                        if response.statusCode == 200 {
                            print("Update successfully")
                            completion(true)
                        }
                    }
                }
                
                dataTask.resume()
            } catch {
                completion(false)
                print("Error: \(error)")
            }
    }
    
    func getAabbaNoteData(_ parameters: Any) async -> [String: [INoteResponse]]?  {
        guard let url = URL(string: "https://accumulus-backend-atlas-lvketaariq-et.a.run.app/ATLAS_get_aabba_notes") else { fatalError("Missing URL") }
            //make request
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            // Create the request body data
            do {
                // Convert the request body to JSON data
                let requestData = try JSONSerialization.data(withJSONObject: parameters, options: [])
                // Set the request body data
                request.httpBody = requestData
                
                // Set the Content-Type header to indicate JSON format
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let (data, _) = try await URLSession.shared.data(for: request)
                
                do {
                    let decodedSearch = try JSONDecoder().decode([String: [INoteResponse]].self, from: data)
                    return decodedSearch
                } catch let error {
                    print("Error decoding: ", error)
                }
            } catch {
                print("Error: \(error)")
            }
        return nil
    }
    
    func updateMapData(_ parameters: Any, completion: @escaping (_ success: Bool) -> Void) async  {
        guard let url = URL(string: "https://accumulus-backend-atlas-lvketaariq-et.a.run.app/ATLAS_update_map_data") else { fatalError("Missing URL") }
            //make request
            var request = URLRequest(url: url)

            let postData: Data? = try? JSONSerialization.data(withJSONObject: parameters, options: [])
//            let convertedString = String(data: postData!, encoding: .utf8)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = postData
       
            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Request error: ", error)
                    completion(false)
                    return
                }
                
                DispatchQueue.main.async {
                    do {
                        guard let response = response as? HTTPURLResponse else { return }
                        if response.statusCode == 200 {
                            print("Update successfully")
                            completion(true)
                        } else {
                            completion(false)
                        }
                    } catch {
                        print("Error: \(error)")
                        completion(false)
                    }
                    
                }
                
            }
            
            dataTask.resume()
    }
    
    // Update data for Pre Flight
    
    //ATLAS_get_map_traffic_data
    func getMapTrafficData(_ parameters: Any) async -> [ITrafficData]?  {
        guard let url = URL(string: "https://accumulus-backend-atlas-lvketaariq-et.a.run.app/ATLAS_get_map_traffic_data") else { fatalError("Missing URL") }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
        do {
            // Convert the request body to JSON data
            let requestData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            // Set the request body data
            request.httpBody = requestData
            
            // Set the Content-Type header to indicate JSON format
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            do {
                let decodedSearch = try JSONDecoder().decode(ITrafficDataResponseAPI.self, from: data)
                return decodedSearch.traffic_data
            } catch let error {
                print("Error decoding: ", error)
            }
        } catch {
            print("Error: \(error)")
        }
        return nil
    }
    
    
    //ATLAS_get_map_aabba_data
    func getMapAabbaData(_ parameters: Any) async -> [IAabbaData]?  {
        guard let url = URL(string: "https://accumulus-backend-atlas-lvketaariq-et.a.run.app/ATLAS_get_map_aabba_data") else { fatalError("Missing URL") }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
        do {
            // Convert the request body to JSON data
            let requestData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            // Set the request body data
            request.httpBody = requestData
            
            // Set the Content-Type header to indicate JSON format
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            do {
                let decodedSearch = try JSONDecoder().decode(IAabbaDataJsonResponse.self, from: data)
                return decodedSearch.aabba_data
            } catch let error {
                print("Error decoding: ", error)
            }
        } catch {
            print("Error: \(error)")
        }
        return nil
    }
    
    //ATLAS_get_map_waypoints_data
    func getMapWaypointData(_ parameters: Any) async -> [IWaypointData]?  {
        guard let url = URL(string: "https://accumulus-backend-atlas-lvketaariq-et.a.run.app/ATLAS_get_map_waypoints_data") else { fatalError("Missing URL") }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
        do {
            // Convert the request body to JSON data
            let requestData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            // Set the request body data
            request.httpBody = requestData
            
            // Set the Content-Type header to indicate JSON format
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            do {
                let decodedSearch = try JSONDecoder().decode(IWaypointDataJsonResponse.self, from: data)
                return decodedSearch.all_waypoints_data
            } catch let error {
                print("Error decoding: ", error)
            }
        } catch {
            print("Error: \(error)")
        }
        return nil
    }
    
    //ATLAS_get_map_airports_data
    func getMapAirportData(_ parameters: Any) async -> IAirportDataJsonResponse? {
        guard let url = URL(string: "https://accumulus-backend-atlas-lvketaariq-et.a.run.app/ATLAS_get_map_airports_data") else { fatalError("Missing URL") }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
        do {
            // Convert the request body to JSON data
            let requestData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            print("json=============\(String(data: requestData, encoding: .utf8)!)")
            // Set the request body data
            request.httpBody = requestData
            // Set the Content-Type header to indicate JSON format
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
//            let (data, _) = try await URLSession.shared.data(for: request)
            let data: IAirportDataJsonResponse = load("airport_data.json")
//            print("json=============\(String(data: data, encoding: .utf8)!)")
            do {
//                let decodedSearch = try JSONDecoder().decode(IAirportDataJsonResponse.self, from: data)
                return data
            } catch let error {
                print("Error decoding: ", error)
            }
        } catch {
            print("Error: \(error)")
        }
        return nil
    }
    
    //ATLAS_get_notam_wx_data
    func getNotamData(_ parameters: Any) async -> INotamWXDataJson?  {
        guard let url = URL(string: "https://accumulus-backend-atlas-lvketaariq-et.a.run.app/ATLAS_get_notam_wx_data") else { fatalError("Missing URL") }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"

        do {
            // Convert the request body to JSON data
            let requestData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            // Set the request body data
            request.httpBody = requestData

            // Set the Content-Type header to indicate JSON format
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let (data, _) = try await URLSession.shared.data(for: request)
//            print("json=============\(String(data: data, encoding: .utf8)!)")
            do {
                let decodedSearch = try JSONDecoder().decode(INotamWXDataJson.self, from: data)
                return decodedSearch
            } catch let error {
                print("Error decoding: ", error)
            }
        } catch {
            print("Error: \(error)")
        }
        return nil
    }
    
    // End Update data for Pre Flight
    
    func load<T: Decodable>(_ filename: String) -> T {
        let data: Data

        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
            else {
                fatalError("Couldn't find \(filename) in main bundle.")
        }

        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }
    
    // CREATE event, will call the API ATLAS_get_sector_data
    func getSectorData(_ parameters: Any) async -> SectorDataJson?  {
        guard let url = URL(string: "https://accumulus-backend-atlas-lvketaariq-et.a.run.app/ATLAS_get_sector_data") else { fatalError("Missing URL") }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
        do {
            // Convert the request body to JSON data
            let requestData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            // Set the request body data
            request.httpBody = requestData
            // Set the Content-Type header to indicate JSON format
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            do {
                return try JSONDecoder().decode(SectorDataJson.self, from: data)
            } catch let error {
                print("Error decoding: ", error)
            }
        } catch {
            print("Error: \(error)")
        }
        return nil
    }
    
    //ATLAS_get_user_data
    func getUserData(_ parameters: Any) async -> UserProfileDataJson?  {
        guard let url = URL(string: "https://accumulus-backend-atlas-lvketaariq-et.a.run.app/ATLAS_get_user_data") else { fatalError("Missing URL") }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
        do {
            // Convert the request body to JSON data
            let requestData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            // Set the request body data
            request.httpBody = requestData
            // Set the Content-Type header to indicate JSON format
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            do {
                return try JSONDecoder().decode(UserProfileDataJson.self, from: data)
            } catch let error {
                print("Error decoding: ", error)
            }
        } catch {
            print("Error: \(error)")
        }
        return nil
    }
}
