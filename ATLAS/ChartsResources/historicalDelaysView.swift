//
//  arrDelaysView.swift
//  ATLAS
//
//  Created by Muhammad Adil on 25/5/23.
//

import Foundation
import SwiftUI

struct historicalDelaysView: View {
    var convertedJSON: [String : [String : Any]]
    @SceneStorage("historyTimeframe") private var timeframe: delayTimeframe = .days
    
    @State private var showWeather = true
    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading) {
                    HStack(alignment: .center) {
                        Text("Historical delays")
                            .font(.title2)
                            .foregroundColor(.blue)
                        Spacer()
                        Toggle(isOn: $showWeather) {
                        Text("Weather delays")
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                    Picker("Timeframe", selection: $timeframe) {
                        Label("3 Days", systemImage: "calendar")
                            .tag(delayTimeframe.days)
                        
                        Label("1 Week", systemImage: "calendar")
                            .tag(delayTimeframe.week)
                        
                        Label("3 Months", systemImage: "calendar")
                            .tag(delayTimeframe.months)
                    }
                    .pickerStyle(.segmented)
                    .padding(.bottom, 10)
                    if showWeather {
                        Text("Historical average delay during arrival time")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("\(arrTimeDelayWX.formatted()) mins")
                            .font(.headline)
                        historicalDelaysChart(arrivalDelays: delays, eta: eta, arrTimeDelay: arrTimeDelayWX, ymax: ymax)
                            .frame(minHeight: 300)
                            .chartYScale(domain: 0 ... ymax) // set dynamic domain to max of y value
                    } else {
                        Text("Historical average delay during arrival time")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("\(arrTimeDelay.formatted()) mins")
                            .font(.headline)
                        let filteredDelays = delays.filter { $0.condition != "Added delay due WX" }
                        historicalDelaysChart(arrivalDelays: filteredDelays, eta: eta, arrTimeDelay: arrTimeDelay, ymax: ymax)
                            .frame(minHeight: 300)
                            .chartYScale(domain: 0 ... ymax) // set dynamic domain to max of y value
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Historical Delays")
        .background()
    }
    // switcher by period
    var delays: [ArrivalDelays] {
        let fetchedDelays: [String : [String : Any]] = convertedJSON

        //let fetchedDelays: [String : [String : Any]] = fetchArrivalDelays()
        switch timeframe {
        case .days:
            let fetchedDelaysItems = fetchedDelays["days3"]!
            return fetchedDelaysItems["delays"] as! [ArrivalDelays]
        case .week:
            let fetchedDelaysItems = fetchedDelays["week1"]!
            return fetchedDelaysItems["delays"] as! [ArrivalDelays]
        case .months:
            let fetchedDelaysItems = fetchedDelays["months3"]!
            return fetchedDelaysItems["delays"] as! [ArrivalDelays]
        }
    }
    var arrTimeDelay: Int {
        let fetchedDelays: [String : [String : Any]] = convertedJSON

        //let fetchedDelays: [String : [String : Any]] = fetchArrivalDelays()
        switch timeframe {
        case .days:
            let fetchedDelaysItems = fetchedDelays["days3"]!
            return fetchedDelaysItems["arrTimeDelay"] as! Int
        case .week:
            let fetchedDelaysItems = fetchedDelays["week1"]!
            return fetchedDelaysItems["arrTimeDelay"] as! Int
        case .months:
            let fetchedDelaysItems = fetchedDelays["months3"]!
            return fetchedDelaysItems["arrTimeDelay"] as! Int
        }
    }
    var arrTimeDelayWX: Int{
        let fetchedDelays: [String : [String : Any]] = convertedJSON

        //let fetchedDelays: [String : [String : Any]] = fetchArrivalDelays()
        switch timeframe {
        case .days:
            let fetchedDelaysItems = fetchedDelays["days3"]!
            return fetchedDelaysItems["arrTimeDelayWX"] as! Int
        case .week:
            let fetchedDelaysItems = fetchedDelays["week1"]!
            return fetchedDelaysItems["arrTimeDelayWX"] as! Int
        case .months:
            let fetchedDelaysItems = fetchedDelays["months3"]!
            return fetchedDelaysItems["arrTimeDelayWX"] as! Int
        }
    }
    var eta: Date{
        let fetchedDelays: [String : [String : Any]] = convertedJSON

        //let fetchedDelays: [String : [String : Any]] = fetchArrivalDelays()
        switch timeframe {
        case .days:
            let fetchedDelaysItems = fetchedDelays["days3"]!
            return fetchedDelaysItems["eta"] as! Date
        case .week:
            let fetchedDelaysItems = fetchedDelays["week1"]!
            return fetchedDelaysItems["eta"] as! Date
        case .months:
            let fetchedDelaysItems = fetchedDelays["months3"]!
            return fetchedDelaysItems["eta"] as! Date
        }
    }
    var ymax: Int{
        let fetchedDelays: [String : [String : Any]] = convertedJSON

        //let fetchedDelays: [String : [String : Any]] = fetchArrivalDelays()
        switch timeframe {
        case .days:
            let fetchedDelaysItems = fetchedDelays["days3"]!
            return fetchedDelaysItems["ymax"] as! Int
        case .week:
            let fetchedDelaysItems = fetchedDelays["week1"]!
            return fetchedDelaysItems["ymax"] as! Int
        case .months:
            let fetchedDelaysItems = fetchedDelays["months3"]!
            return fetchedDelaysItems["ymax"] as! Int
        }
    }
    
}


// replace with API call
func fetchArrivalDelays() -> [String : [String : Any]] {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"

    let entry1 = ArrivalDelays(condition: "Delay due congestion", time: dateFormatter.date(from: "08:00")!, delay: 10)
    let entry2 = ArrivalDelays(condition: "Delay due congestion", time: dateFormatter.date(from: "09:00")!, delay: 15)
    let entry3 = ArrivalDelays(condition: "Delay due congestion", time: dateFormatter.date(from: "10:00")!, delay: 5)
    let entry4 = ArrivalDelays(condition: "Delay due congestion", time: dateFormatter.date(from: "11:00")!, delay: 8)
    let entry5 = ArrivalDelays(condition: "Delay due congestion", time: dateFormatter.date(from: "12:00")!, delay: 2)
    let entry6 = ArrivalDelays(condition: "Delay due congestion", time: dateFormatter.date(from: "13:00")!, delay: 3)
    let entry7 = ArrivalDelays(condition: "Delay due congestion", time: dateFormatter.date(from: "14:00")!, delay: 7)
    let entry8 = ArrivalDelays(condition: "Delay due congestion", time: dateFormatter.date(from: "15:00")!, delay: 8)
    let entry9 = ArrivalDelays(condition: "Delay due congestion", time: dateFormatter.date(from: "16:00")!, delay: 5)
    let entry10 = ArrivalDelays(condition: "Delay due congestion", time: dateFormatter.date(from: "17:00")!, delay: 25)
    let entry11 = ArrivalDelays(condition: "Delay due congestion", time: dateFormatter.date(from: "18:00")!, delay: 10)
    let entry12 = ArrivalDelays(condition: "Delay due congestion", time: dateFormatter.date(from: "19:00")!, delay: 11)
    let entry13 = ArrivalDelays(condition: "Delay due congestion", time: dateFormatter.date(from: "20:00")!, delay: 7)
    let entry14 = ArrivalDelays(condition: "Delay due congestion", time: dateFormatter.date(from: "21:00")!, delay: 5)
    let entry15 = ArrivalDelays(condition: "Delay due congestion", time: dateFormatter.date(from: "22:00")!, delay: 5)
    
    let entry1x = ArrivalDelays(condition: "Added delay due WX", time: dateFormatter.date(from: "08:00")!, delay: 5)
    let entry2x = ArrivalDelays(condition: "Added delay due WX", time: dateFormatter.date(from: "09:00")!, delay: 2)
    let entry3x = ArrivalDelays(condition: "Added delay due WX", time: dateFormatter.date(from: "10:00")!, delay: 3)
    let entry4x = ArrivalDelays(condition: "Added delay due WX", time: dateFormatter.date(from: "11:00")!, delay: 8)
    let entry5x = ArrivalDelays(condition: "Added delay due WX", time: dateFormatter.date(from: "12:00")!, delay: 4)
    let entry6x = ArrivalDelays(condition: "Added delay due WX", time: dateFormatter.date(from: "13:00")!, delay: 2)
    let entry7x = ArrivalDelays(condition: "Added delay due WX", time: dateFormatter.date(from: "14:00")!, delay: 8)
    let entry8x = ArrivalDelays(condition: "Added delay due WX", time: dateFormatter.date(from: "15:00")!, delay: 1)
    let entry9x = ArrivalDelays(condition: "Added delay due WX", time: dateFormatter.date(from: "16:00")!, delay: 9)
    let entry10x = ArrivalDelays(condition: "Added delay due WX", time: dateFormatter.date(from: "17:00")!, delay: 10)
    let entry11x = ArrivalDelays(condition: "Added delay due WX", time: dateFormatter.date(from: "18:00")!, delay: 5)
    let entry12x = ArrivalDelays(condition: "Added delay due WX", time: dateFormatter.date(from: "19:00")!, delay: 3)
    let entry13x = ArrivalDelays(condition: "Added delay due WX", time: dateFormatter.date(from: "20:00")!, delay: 2)
    let entry14x = ArrivalDelays(condition: "Added delay due WX", time: dateFormatter.date(from: "21:00")!, delay: 10)
    let entry15x = ArrivalDelays(condition: "Added delay due WX", time: dateFormatter.date(from: "22:00")!, delay: 5)
    
    let entry1w = ArrivalDelays(condition: "Delay due congestion", time: dateFormatter.date(from: "08:00")!, delay: 7)
    let entry2w = ArrivalDelays(condition: "Delay due congestion", time: dateFormatter.date(from: "09:00")!, delay: 18)
    let entry3w = ArrivalDelays(condition: "Delay due congestion", time: dateFormatter.date(from: "10:00")!, delay: 2)
    let entry4w = ArrivalDelays(condition: "Delay due congestion", time: dateFormatter.date(from: "11:00")!, delay: 8)
    let entry5w = ArrivalDelays(condition: "Delay due congestion", time: dateFormatter.date(from: "12:00")!, delay: 4)
    let entry6w = ArrivalDelays(condition: "Delay due congestion", time: dateFormatter.date(from: "13:00")!, delay: 3)
    let entry7w = ArrivalDelays(condition: "Delay due congestion", time: dateFormatter.date(from: "14:00")!, delay: 3)
    let entry8w = ArrivalDelays(condition: "Delay due congestion", time: dateFormatter.date(from: "15:00")!, delay: 11)
    let entry9w = ArrivalDelays(condition: "Delay due congestion", time: dateFormatter.date(from: "16:00")!, delay: 7)
    let entry10w = ArrivalDelays(condition: "Delay due congestion", time: dateFormatter.date(from: "17:00")!, delay: 18)
    let entry11w = ArrivalDelays(condition: "Delay due congestion", time: dateFormatter.date(from: "18:00")!, delay: 15)
    let entry12w = ArrivalDelays(condition: "Delay due congestion", time: dateFormatter.date(from: "19:00")!, delay: 9)
    let entry13w = ArrivalDelays(condition: "Delay due congestion", time: dateFormatter.date(from: "20:00")!, delay: 5)
    let entry14w = ArrivalDelays(condition: "Delay due congestion", time: dateFormatter.date(from: "21:00")!, delay: 2)
    let entry15w = ArrivalDelays(condition: "Delay due congestion", time: dateFormatter.date(from: "22:00")!, delay: 3)
    
    let entry1wx = ArrivalDelays(condition: "Added delay due WX", time: dateFormatter.date(from: "08:00")!, delay: 1)
    let entry2wx = ArrivalDelays(condition: "Added delay due WX", time: dateFormatter.date(from: "09:00")!, delay: 1)
    let entry3wx = ArrivalDelays(condition: "Added delay due WX", time: dateFormatter.date(from: "10:00")!, delay: 5)
    let entry4wx = ArrivalDelays(condition: "Added delay due WX", time: dateFormatter.date(from: "11:00")!, delay: 3)
    let entry5wx = ArrivalDelays(condition: "Added delay due WX", time: dateFormatter.date(from: "12:00")!, delay: 2)
    let entry6wx = ArrivalDelays(condition: "Added delay due WX", time: dateFormatter.date(from: "13:00")!, delay: 3)
    let entry7wx = ArrivalDelays(condition: "Added delay due WX", time: dateFormatter.date(from: "14:00")!, delay: 10)
    let entry8wx = ArrivalDelays(condition: "Added delay due WX", time: dateFormatter.date(from: "15:00")!, delay: 8)
    let entry9wx = ArrivalDelays(condition: "Added delay due WX", time: dateFormatter.date(from: "16:00")!, delay: 4)
    let entry10wx = ArrivalDelays(condition: "Added delay due WX", time: dateFormatter.date(from: "17:00")!, delay: 4)
    let entry11wx = ArrivalDelays(condition: "Added delay due WX", time: dateFormatter.date(from: "18:00")!, delay: 7)
    let entry12wx = ArrivalDelays(condition: "Added delay due WX", time: dateFormatter.date(from: "19:00")!, delay: 21)
    let entry13wx = ArrivalDelays(condition: "Added delay due WX", time: dateFormatter.date(from: "20:00")!, delay: 6)
    let entry14wx = ArrivalDelays(condition: "Added delay due WX", time: dateFormatter.date(from: "21:00")!, delay: 9)
    let entry15wx = ArrivalDelays(condition: "Added delay due WX", time: dateFormatter.date(from: "22:00")!, delay: 2)
   
    let entry1m = ArrivalDelays(condition: "Delay due congestion", time: dateFormatter.date(from: "08:00")!, delay: 6)
    let entry2m = ArrivalDelays(condition: "Delay due congestion", time: dateFormatter.date(from: "09:00")!, delay: 12)
    let entry3m = ArrivalDelays(condition: "Delay due congestion", time: dateFormatter.date(from: "10:00")!, delay: 3)
    let entry4m = ArrivalDelays(condition: "Delay due congestion", time: dateFormatter.date(from: "11:00")!, delay: 2)
    let entry5m = ArrivalDelays(condition: "Delay due congestion", time: dateFormatter.date(from: "12:00")!, delay: 2)
    let entry6m = ArrivalDelays(condition: "Delay due congestion", time: dateFormatter.date(from: "13:00")!, delay: 3)
    let entry7m = ArrivalDelays(condition: "Delay due congestion", time: dateFormatter.date(from: "14:00")!, delay: 9)
    let entry8m = ArrivalDelays(condition: "Delay due congestion", time: dateFormatter.date(from: "15:00")!, delay: 11)
    let entry9m = ArrivalDelays(condition: "Delay due congestion", time: dateFormatter.date(from: "16:00")!, delay: 5)
    let entry10m = ArrivalDelays(condition: "Delay due congestion", time: dateFormatter.date(from: "17:00")!, delay: 17)
    let entry11m = ArrivalDelays(condition: "Delay due congestion", time: dateFormatter.date(from: "18:00")!, delay: 8)
    let entry12m = ArrivalDelays(condition: "Delay due congestion", time: dateFormatter.date(from: "19:00")!, delay: 5)
    let entry13m = ArrivalDelays(condition: "Delay due congestion", time: dateFormatter.date(from: "20:00")!, delay: 5)
    let entry14m = ArrivalDelays(condition: "Delay due congestion", time: dateFormatter.date(from: "21:00")!, delay: 2)
    let entry15m = ArrivalDelays(condition: "Delay due congestion", time: dateFormatter.date(from: "22:00")!, delay: 2)
    
    let entry1mx = ArrivalDelays(condition: "Added delay due WX", time: dateFormatter.date(from: "08:00")!, delay: 12)
    let entry2mx = ArrivalDelays(condition: "Added delay due WX", time: dateFormatter.date(from: "09:00")!, delay: 18)
    let entry3mx = ArrivalDelays(condition: "Added delay due WX", time: dateFormatter.date(from: "10:00")!, delay: 8)
    let entry4mx = ArrivalDelays(condition: "Added delay due WX", time: dateFormatter.date(from: "11:00")!, delay: 8)
    let entry5mx = ArrivalDelays(condition: "Added delay due WX", time: dateFormatter.date(from: "12:00")!, delay: 0)
    let entry6mx = ArrivalDelays(condition: "Added delay due WX", time: dateFormatter.date(from: "13:00")!, delay: 3)
    let entry7mx = ArrivalDelays(condition: "Added delay due WX", time: dateFormatter.date(from: "14:00")!, delay: 2)
    let entry8mx = ArrivalDelays(condition: "Added delay due WX", time: dateFormatter.date(from: "15:00")!, delay: 9)
    let entry9mx = ArrivalDelays(condition: "Added delay due WX", time: dateFormatter.date(from: "16:00")!, delay: 0)
    let entry10mx = ArrivalDelays(condition: "Added delay due WX", time: dateFormatter.date(from: "17:00")!, delay: 5)
    let entry11mx = ArrivalDelays(condition: "Added delay due WX", time: dateFormatter.date(from: "18:00")!, delay: 10)
    let entry12mx = ArrivalDelays(condition: "Added delay due WX", time: dateFormatter.date(from: "19:00")!, delay: 7)
    let entry13mx = ArrivalDelays(condition: "Added delay due WX", time: dateFormatter.date(from: "20:00")!, delay: 2)
    let entry14mx = ArrivalDelays(condition: "Added delay due WX", time: dateFormatter.date(from: "21:00")!, delay: 5)
    let entry15mx = ArrivalDelays(condition: "Added delay due WX", time: dateFormatter.date(from: "22:00")!, delay: 5)

    let arrivalDelaysDays: [ArrivalDelays] = [entry1, entry2, entry3, entry4, entry5, entry6, entry7, entry8, entry9, entry10, entry11, entry12, entry13, entry14, entry15, entry1x, entry2x, entry3x, entry4x, entry5x, entry6x, entry7x, entry8x, entry9x, entry10x, entry11x, entry12x, entry13x, entry14x, entry15x]
    let arrivalDelaysWeek: [ArrivalDelays] = [entry1w, entry2w, entry3w, entry4w, entry5w, entry6w, entry7w, entry8w, entry9w, entry10w, entry11w, entry12w, entry13w, entry14w, entry15w, entry1wx, entry2wx, entry3wx, entry4wx, entry5wx, entry6wx, entry7wx, entry8wx, entry9wx, entry10wx, entry11wx, entry12wx, entry13wx, entry14wx, entry15wx]
    let arrivalDelaysMonths: [ArrivalDelays] = [entry1m, entry2m, entry3m, entry4m, entry5m, entry6m, entry7m, entry8m, entry9m, entry10m, entry11m, entry12m, entry13m, entry14m, entry15m, entry1mx, entry2mx, entry3mx, entry4mx, entry5mx, entry6mx, entry7mx, entry8mx, entry9mx, entry10mx, entry11mx, entry12mx, entry13mx, entry14mx, entry15mx]
    
    let aveDelayDays = 10
    let aveDelayWXDays = 15
    let aveDelayWeek = 15
    let aveDelayWXWeek = 22
    let aveDelayMonths = 8
    let aveDelayWXMonths = 18
    
    let eta = dateFormatter.date(from: "18:00")!
    let ymax = 40
        
    let days = ["delays": arrivalDelaysDays, "arrTimeDelay": aveDelayDays, "arrTimeDelayWX": aveDelayWXDays, "eta": eta, "ymax": ymax] as [String : Any]
    let week = ["delays": arrivalDelaysWeek, "arrTimeDelay": aveDelayWeek, "arrTimeDelayWX": aveDelayWXWeek, "eta": eta, "ymax": ymax] as [String : Any]
    let months = ["delays": arrivalDelaysMonths, "arrTimeDelay": aveDelayMonths, "arrTimeDelayWX": aveDelayWXMonths, "eta": eta, "ymax": ymax] as [String : Any]

    let arrivalDelaysAll = ["days3": days, "week1": week, "months3": months]
//    print(arrivalDelaysAll)
    return arrivalDelaysAll
}

struct ArrivalDelaysJSON: Codable {
        let condition: String
        let time: String
        let delay: Int
    }
