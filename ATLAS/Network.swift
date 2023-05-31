//
//  Network.swift
//  ATLAS
//
//  Created by phuong phan on 30/05/2023.
//

import Foundation

class Network: ObservableObject {
    @Published var dataSearch: SearchModel = SearchModel(result: "")
    @Published var txtCount: Int = 0
    
    func handleSearch(question: String, onSuccess: @escaping (SearchModel) -> Void, onFailure: @escaping (Error) -> Void) {
        guard let url = URL(string: "https://accumulus-backend-atlas-lvketaariq-et.a.run.app/ATLAS_OnlineSearch") else { fatalError("Missing URL") }
        let parameter = ["question": question]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: parameter)
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            if response.statusCode == 200 {
                guard let data = data else { return }
                
                DispatchQueue.main.async {
                    do {
                        let decodedSearch = try JSONDecoder().decode(SearchModel.self, from: data)
                        self.dataSearch = decodedSearch
                        self.txtCount = decodedSearch.result.count
                        onSuccess(decodedSearch)
                    } catch let error {
                        print("Error decoding: ", error)
                        onFailure(error)
                    }
                }
            }
        }
        
        dataTask.resume()
    }
}
