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
    
    func getFlightPlanWX(completion: @escaping (IFlightPlanDataModel?) -> Void) async  {
        guard let url = URL(string: "https://accumulus-backend-atlas-lvketaariq-et.a.run.app/ATLAS_get_flightPlan_data") else { fatalError("Missing URL") }
            //make request
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            // Create the request body data
            let requestBody = [
                "company": "Test Company",
                "flight_no": "TR753",
                "flightDate": "2023-07-08"
            ]
            
            do {
                // Convert the request body to JSON data
                let requestData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
                // Set the request body data
                request.httpBody = requestData
                
                // Set the Content-Type header to indicate JSON format
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        print("Request error: ", error)
                        return
                    }
                    
                    guard let response = response as? HTTPURLResponse else { return }
                    if response.statusCode == 200 {
                        guard let jsonObject = data else { return }
                        
                        do {
                            let decodedSearch = try JSONDecoder().decode(IFlightPlanDataModel.self, from: jsonObject)
                            completion(decodedSearch)
                        } catch let error {
                            print("Error decoding: ", error)
                        }
                    }
                }
                
                dataTask.resume()
            } catch {
                print("Error: \(error)")
            }
    }
    
    func getFuelData(completion: @escaping (IFuelDataModel?) -> Void) async  {
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
                
                let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        print("Request error: ", error)
                        return
                    }

                    guard let response = response as? HTTPURLResponse else { return }
                    if response.statusCode == 200 {
                        guard let jsonObject = data else { return }
                        
                        do {
                            let decodedSearch = try JSONDecoder().decode(IFuelDataModel.self, from: jsonObject)
                            completion(decodedSearch)
                        } catch let error {
                            print("Error decoding: ", error)
                        }
                    }
                }
                
                dataTask.resume()
            } catch {
                print("Error: \(error)")
            }
    }
    
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
