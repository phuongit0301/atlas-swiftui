//
//  CommonModel.swift
//  ATLAS
//
//  Created by phuong phan on 09/10/2023.
//

struct ICommonResponse {
    var success: Bool
    var message: String
}

struct WeatherPathTime: Codable {
    var time: Int
    var path: String
}

struct WeatherRadaModel: Codable {
    var past: [WeatherPathTime]
    var nowcast: [WeatherPathTime]
}

struct WeatherInfrared: Codable {
    var infrared: [WeatherPathTime]
}

struct WeatherModel: Codable {
   var version: String
   var generated: Int
   var host: String
    
   var radar: WeatherRadaModel
   var satellite: WeatherInfrared
}
