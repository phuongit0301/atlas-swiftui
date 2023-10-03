//
//  RemoteService.swift
//  ATLAS
//
//  Created by phuong phan on 07/07/2023.
//

import Foundation

enum RemoteError: Error {
    case error(String)
}

class RemoteService: ObservableObject {
    static let shared = RemoteService()
    
    let baseURL = "https://accumulus-backend-atlas-lvketaariq-et.a.run.app"
    
    private init() {}
    
    func getFlightPlanData() async -> IFlightPlanDataModel?  {
        guard let url = URL(string: "https://accumulus-backend-atlas-lvketaariq-et.a.run.app/ATLAS_get_flightPlan_data") else { fatalError("Missing URL") }
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
    
    func getFuelData() async -> IFuelDataModel?  {
        guard let url = URL(string: "https://accumulus-backend-atlas-lvketaariq-et.a.run.app/ATLAS_get_fuel_data") else { fatalError("Missing URL") }
            //make request
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            // Create the request body data
            let requestBody = [
                "airline": "accumulus air",
                "fltno": "EK352",
                "eta": "18:00",
                "arr": "SIN",
                "dep": "DXB"
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
    
    func getMapData() async -> IMapDataModel?  {
        guard let url = URL(string: "https://accumulus-backend-atlas-lvketaariq-et.a.run.app/ATLAS_get_map_data") else { fatalError("Missing URL") }
            //make request
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            // Create the request body data
            let requestBody = [
                "depAirport": "VTBS",
                "arrAirport": "WSSS",
                "enrAirports": ["WMKP", "WMKK"],
                "altnAirports": ["WMKJ", "WIDD"],
                "route": "VTBS/19L F410 KIGOB Y11 PASVA/F410 Y514 NUFFA DCT PIBAP DCT PASPU DCT NYLON DCT POSUB DCT SANAT WSSS/02L"
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
                    let decodedSearch = try JSONDecoder().decode(IMapDataModel.self, from: data)
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
                "user_id": "abc123",
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
    
    func getRecencyData() async -> IRecencyJson?  {
        guard let url = URL(string: "https://accumulus-backend-atlas-lvketaariq-et.a.run.app/ATLAS_get_recency_data") else { fatalError("Missing URL") }
            //make request
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            // Create the request body data
            let requestBody = [
                "user_id": "abc123",
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
    func updateMapTrafficData(_ parameters: Any) async -> [ITrafficData]?  {
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
    func updateMapAabbaData(_ parameters: Any) async -> [IAabbaData]?  {
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
    func updateMapWaypointData(_ parameters: Any) async -> [IWaypointData]?  {
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
    func updateMapAirportData() async -> [IAirportData]? {
        guard let url = URL(string: "https://accumulus-backend-atlas-lvketaariq-et.a.run.app/ATLAS_get_map_airports_data") else { fatalError("Missing URL") }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
        do {
            // Set the Content-Type header to indicate JSON format
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            do {
                let decodedSearch = try JSONDecoder().decode(IAirportDataJsonResponse.self, from: data)
                return decodedSearch.all_airports_data
            } catch let error {
                print("Error decoding: ", error)
            }
        } catch {
            print("Error: \(error)")
        }
        return nil
    }
    
    //ATLAS_get_notam_wx_data
    func updateNotamData(_ parameters: Any) async  {
//        guard let url = URL(string: "https://accumulus-backend-atlas-lvketaariq-et.a.run.app/ATLAS_get_notam_wx_data") else { fatalError("Missing URL") }
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//
//        do {
//            // Convert the request body to JSON data
//            let requestData = try JSONSerialization.data(withJSONObject: parameters, options: [])
//            // Set the request body data
//            request.httpBody = requestData
//
//            // Set the Content-Type header to indicate JSON format
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//            let (data, _) = try await URLSession.shared.data(for: request)
//
//            do {
//                let decodedSearch = try JSONDecoder().decode(IWaypointDataJson.self, from: data)
//                return decodedSearch.all_waypoints_data
//            } catch let error {
//                print("Error decoding: ", error)
//            }
//        } catch {
//            print("Error: \(error)")
//        }
//        return nil
        
        guard let url = URL(string: "https://accumulus-backend-atlas-lvketaariq-et.a.run.app/ATLAS_get_notam_wx_data") else { fatalError("Missing URL") }
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

                DispatchQueue.main.async {
                    do {
                        guard let response = response as? HTTPURLResponse else { return }
                        if response.statusCode == 200 {
                            print("Update successfully")
                            return
                        } else {
                            return
                        }
                    } catch {
                        print("Error: \(error)")
                        return
                    }

                }

            }

            dataTask.resume()
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
}
