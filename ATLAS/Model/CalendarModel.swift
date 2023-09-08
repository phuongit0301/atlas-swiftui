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
    var status: Int = 1 // 1: StandBy, 2: Completed, 3: Leave, 4: Internal training, 5: InProgress, 6: Rest
}

struct IEvent: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var status: Int = 1 // 1: StandBy, 2: Completed, 3: Leave, 4: Internal training, 5: InProgress, 6: Rest
    var startDate: String
    var endDate: String
}

class CalendarModel: ObservableObject {
    @Published var listItem: [IEntries] = []
    @Published var dateRange: [ClosedRange<Date>] = []
    @Published var listEvent: [IEvent] = []
    
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
        
        listEvent = [
            IEvent(id: UUID(), name: "COP: 234 SIN DXB LIS DXB SIN", status: 5, startDate: dateFormatter.string(from: today), endDate: dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: 12, to: today)!)),
            IEvent(id: UUID(), name: "EK231 SIN-DXB", status: 2, startDate: dateFormatter.string(from: today), endDate: dateFormatter.string(from: today)),
            IEvent(id: UUID(), name: "EK231 SIN-DXB", status: 2, startDate: dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: 3, to: today)!), endDate: dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: 3, to: today)!)),
            IEvent(id: UUID(), name: "EK231 SIN-DXB", status: 2, startDate: dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: 10, to: today)!), endDate: dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: 10, to: today)!)),
            IEvent(id: UUID(), name: "EK231 SIN-DXB", status: 2, startDate: dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: 12, to: today)!), endDate: dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: 12, to: today)!)),
            IEvent(id: UUID(), name: "Leave", status: 3, startDate: dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: 13, to: today)!), endDate: dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: 20, to: today)!)),
            IEvent(id: UUID(), name: "Internal training", status: 4, startDate: dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: 20, to: today)!), endDate: dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: 22, to: today)!)),
        ]
    }
}

enum EventDataDropDown: String, CaseIterable, Identifiable {
    case flight = "Flight"
    case cop = "COP"
    case otherEvent = "Other Event"
    var id: Self { self }
}

enum ReminderDataDropDown: String, CaseIterable, Identifiable {
    case before = "24 hours before"
    case after = "24 hours after"
    var id: Self { self }
}

enum CalendarMonthDropDown: String, CaseIterable, Identifiable {
    case month = "Month"
    case year = "Year"
    case week = "Week"
    case day = "Day"
    case navaid = "Navaid"
    case obstacles = "Obstacles"
    case others = "Others"
    var id: Self { self }
}
