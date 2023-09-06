//
//  CalendarModel.swift
//  ATLAS
//
//  Created by phuong phan on 06/09/2023.
//

import Foundation

import Foundation

struct IEntries: Identifiable, Hashable {
    var id = UUID()
    var timestamp: Date
    var status: Int = 1 // 1: StandBy, 2: Completed, 3: Leave, 4: TODO
}

class CalendarModel: ObservableObject {
    @Published var listItem: [IEntries] = []
    @Published var dateRange: [ClosedRange<Date>] = []
    
    init() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let today = Date()
        
        var dateRange1: ClosedRange<Date> {
            let endDate = Calendar.current.date(byAdding: .day, value: 6, to: today)
            return today...endDate!
        }
        
        var dateRange2: ClosedRange<Date> {
            let startDate = Calendar.current.date(byAdding: .day, value: 9, to: today)
            
            let endDate = Calendar.current.date(byAdding: .day, value: 6, to: startDate!)
            return startDate!...endDate!
        }
        
        dateRange.append(dateRange1)
        dateRange.append(dateRange2)

        listItem = [
            IEntries(timestamp: today, status: 2),
            IEntries(timestamp: Calendar.current.date(byAdding: .day, value: 1, to: today)!, status: 1),
            IEntries(timestamp: Calendar.current.date(byAdding: .day, value: 2, to: today)!, status: 1),
            IEntries(timestamp: Calendar.current.date(byAdding: .day, value: 3, to: today)!, status: 2),
            IEntries(timestamp: Calendar.current.date(byAdding: .day, value: 4, to: today)!, status: 1),
            IEntries(timestamp: Calendar.current.date(byAdding: .day, value: 5, to: today)!, status: 3),
            IEntries(timestamp: Calendar.current.date(byAdding: .day, value: 6, to: today)!, status: 3),
            IEntries(timestamp: Calendar.current.date(byAdding: .day, value: 7, to: today)!, status: 3),
            IEntries(timestamp: Calendar.current.date(byAdding: .day, value: 8, to: today)!, status: 3),
            IEntries(timestamp: Calendar.current.date(byAdding: .day, value: 9, to: today)!, status: 4),
            IEntries(timestamp: Calendar.current.date(byAdding: .day, value: 10, to: today)!, status: 4)
        ]
    }
}
