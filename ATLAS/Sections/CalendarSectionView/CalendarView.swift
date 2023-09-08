//
//  CalendarView.swift
//  ATLAS
//
//  Created by phuong phan on 07/09/2023.
//

import SwiftUI

struct CalendarView: View {
    private var calendar: Calendar
    private let monthFormatter: DateFormatter
    private let dayFormatter: DateFormatter
    private let weekDayFormatter: DateFormatter
    private let fullFormatter: DateFormatter
    
    @State private var selected = ""
    @State private var selectedDate = Self.now
    private static var now = Date()
    
    @State private var entries: [IEntries] = CalendarModel().listItem
    @State private var events: [IEvent] = CalendarModel().listEvent
    @State private var dateRange: [ClosedRange<Date>] = CalendarModel().dateRange
    
    // Draw BG Event
    @State var countDate = 1
    
    init(calendar: Calendar) {
        self.calendar = calendar
        self.calendar.firstWeekday = 2
        self.monthFormatter = DateFormatter(dateFormat: "MMMM YYYY", calendar: calendar)
        self.dayFormatter = DateFormatter(dateFormat: "d", calendar: calendar)
        self.weekDayFormatter = DateFormatter(dateFormat: "EEEEE", calendar: calendar)
        self.fullFormatter = DateFormatter(dateFormat: "dd MMMM yyyy", calendar: calendar)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            CalendarViewComponent(
                calendar: calendar,
                date: $selectedDate,
                entries: $entries,
                events: $events,
                content: { (date, dateRange) in
                    VStack(alignment: .center, spacing: 0) {
                        Button(action: { selectedDate = date }) {
                            VStack {
                                Text(dayFormatter.string(from: date))
                                    .padding(6)
                                // Added to make selection sizes equal on all numbers.
                                    .frame(width: 33, height: 33)
                                    .foregroundColor(calendar.isDateInToday(date) ? Color.white : .primary)
                                    .background(
                                        calendar.isDateInToday(date) ? Color.theme.azure
                                        : calendar.isDate(date, inSameDayAs: selectedDate) ? .blue
                                        : .clear
                                    )
                                    .cornerRadius(100)
                            }
                        }.frame(maxWidth: .infinity)
                        
                        ForEach(events, id: \.self) {event in
                            CalendarBg(date: date, event: event, countDate: $countDate)
                        }
                    }.frame(height: 103, alignment: .topLeading)
                    .background(eventsOfRange(date: date))
                },
                // assign color for past and future dates
                trailing: { date in
                    VStack {
                        Text(dayFormatter.string(from: date))
                            .foregroundColor(.secondary)
                            .padding(6)
                            .frame(width: 33, height: 33)
                        Circle().fill(Color.clear).frame(width: 8, height: 8)
                    }.padding(.bottom)
                },
                header: { date in
                    Text(weekDayFormatter.string(from: date)).font(.system(size: 15, weight: .semibold))
                },
                title: { date in
                    HStack(alignment: .center, spacing: 0) {
                        HStack(spacing: 0) {
                            Button {
                                guard let newDate = calendar.date(
                                    byAdding: .month,
                                    value: -1,
                                    to: selectedDate
                                ) else {
                                    return
                                }
                                
                                selectedDate = newDate
                                
                            } label: {
                                Image(systemName: "chevron.left")
                                    .font(.title2).padding(.horizontal)
                                    .foregroundColor(Color.theme.azure)
                            }.buttonStyle(PlainButtonStyle())
                            
                            Text("\(monthFormatter.string(from: date)) (Local Time)")
                                .foregroundColor(Color.theme.azure)
                                .font(.system(size: 17, weight: .regular))
                            
                            Button {
                                guard let newDate = calendar.date(
                                    byAdding: .month,
                                    value: 1,
                                    to: selectedDate
                                ) else {
                                    return
                                }
                                selectedDate = newDate
                            } label: {
                                Image(systemName: "chevron.right")
                                    .font(.title2).padding(.horizontal)
                                    .foregroundColor(Color.theme.azure)
                            }.buttonStyle(PlainButtonStyle())
                        }
                        
                        Spacer()
                        
                        HStack {
                            Picker("", selection: $selected) {
                                ForEach(CalendarMonthDropDown.allCases, id: \.self) {
                                    Text($0.rawValue).tag($0.rawValue)
                                }
                            }.pickerStyle(MenuPickerStyle())
                            
                            Text("Today").foregroundColor(Color.theme.azure).font(.system(size: 15, weight: .regular))
                        }.padding(.horizontal)
                    }.background(Color.white)
                }
            ).equatable()
        }.padding()
    }
    
    func numberOfEventsInDate(date: Date) -> Int {
        var count: Int = 0
        for entry in entries {
            if calendar.isDate(date, inSameDayAs: entry.timestamp) {
                count += 1
            }
        }
        return count
    }
    
    func eventsOfRange(date: Date) -> Color {
        for range in dateRange {
            if date >= range.lowerBound && date <= range.upperBound {
                return Color.theme.azure.opacity(0.1)
            }
        }
        return Color.clear;
    }
}

struct CalendarBg: View {
    var date: Date
    @State var event: IEvent?
    @Binding var countDate: Int
    
    var body: some View {
        var dateHasEvents: [String: Bool] {
            var isLeftCorner = false
            var isCenter = false
            var isRightCorner = false
            var hasEvent = false
            
            let dateFormmater = DateFormatter()
            dateFormmater.dateFormat = "yyyy-MM-dd"
            
            let startDate = dateFormmater.date(from: event!.startDate)
            let endDate = dateFormmater.date(from: event!.endDate)
            
            if date == startDate {
                isLeftCorner = true
                hasEvent = true
            } else if date >= startDate! && date < endDate! {
                isCenter = true
                hasEvent = true
            }
            
            if date == endDate {
                isRightCorner = true
                hasEvent = true
            }
            
            return ["hasEvent": hasEvent, "isLeftCorner": isLeftCorner, "isCenter": isCenter, "isRightCorner": isRightCorner]
        }
        
        HStack {
            if dateHasEvents["hasEvent"]! {
                if dateHasEvents["isCenter"]!  {
                    HStack(alignment: .center, spacing: 0) {
                        Text("")
                            .font(.system(size: 11, weight: .regular))
                            .padding(.vertical, 4)
                    }.frame(height: 22)
                        .frame(maxWidth: .infinity)
                        .background(bgColor(event!))
                }

                if dateHasEvents["isLeftCorner"]! && dateHasEvents["isRightCorner"]! {
                    HStack(alignment: .center, spacing: 0) {
                        Text(event?.name ?? "").padding(.vertical, 4)
                            .font(.system(size: 11, weight: .regular))
                    }.frame(height: 22)
                        .frame(maxWidth: .infinity)
                        .background(bgColor(event!))
                        .roundedCorner(8, corners: [.topLeft, .bottomLeft, .topRight, .bottomRight])
                } else {
                    if dateHasEvents["isLeftCorner"]! {
                        HStack(alignment: .center, spacing: 0) {
                            Text(event?.name ?? "").padding(.vertical, 4)
                                .font(.system(size: 11, weight: .regular))
                        }.frame(height: 22)
                            .frame(maxWidth: .infinity)
                            .background(bgColor(event!))
                            .roundedCorner(8, corners: [.topLeft, .bottomLeft])
                    }

                    if dateHasEvents["isRightCorner"]! {
                        HStack(alignment: .center, spacing: 0) {
                            Text("").padding(.vertical, 4)
                        }
                        .frame(height: 22)
                            .frame(maxWidth: .infinity)
                            .background(bgColor(event!))
                            .roundedCorner(8, corners: [.topRight, .bottomRight])
                    }
                }
                
            }
            else {
                Spacer()
//                if countDate < 7 {
//                    Text("").padding(.vertical, 4).frame(height: 22)
//                }
            }
        }
        .onAppear {
//            var num: Double = 1/7
//            var num2: Double = 8/7
//            print(num.rounded(.up))
//            print(num2.rounded(.up))
            if countDate == 7 || dateHasEvents["hasEvent"]! {
                countDate = 1
            } else {
                countDate += 1
            }
        }
    }
    
    func bgColor(_ event: IEvent) -> Color {
        if event.status == 1 {
            return Color.theme.lavenderGray
        }
        
        if event.status == 2 {
            return Color.theme.azure
        }
        
        if event.status == 3 {
            return Color.theme.coralRed1
        }
        
        if event.status == 4 {
            return Color.theme.mediumOrchid
        }
        
        if event.status == 5 || event.status == 6 {
            return Color.theme.lavenderGray
        }
        
        return Color.clear
    }
    
    func borderColor(_ event: IEvent) -> Color {
        if event.status == 5 {
            return Color.theme.azure
        }
        
        if event.status == 6 {
            return Color.theme.coralRed1
        }
        
        return Color.clear
    }
}
    // MARK: - Component
public struct CalendarViewComponent<Day: View, Header: View, Title: View, Trailing: View>: View {
    @Environment(\.colorScheme) var colorScheme
    
    // Injected dependencies
    private var calendar: Calendar
    @Binding private var date: Date
    @Binding private var entries: [IEntries]
    @Binding private var events: [IEvent]
    private let content: (Date, ClosedRange<Date>?) -> Day
    private let trailing: (Date) -> Trailing
    private let header: (Date) -> Header
    private let title: (Date) -> Title
    
    // Constants
    private let daysInWeek = 7
    @State private var dateRange: ClosedRange<Date>?
    
    init(
        calendar: Calendar,
        date: Binding<Date>,
        entries: Binding<[IEntries]>,
        events: Binding<[IEvent]>,
        @ViewBuilder content: @escaping (Date, ClosedRange<Date>?) -> Day,
        @ViewBuilder trailing: @escaping (Date) -> Trailing,
        @ViewBuilder header: @escaping (Date) -> Header,
        @ViewBuilder title: @escaping (Date) -> Title
    ) {
        self.calendar = calendar
        self._date = date
        self._entries = entries
        self._events = events
        self.content = content
        self.trailing = trailing
        self.header = header
        self.title = title
    }
    
    public var body: some View {
        let month = date.startOfMonth(using: calendar)
        let days = makeDays()
        let temp = countEventByRow(events, days)
        
        VStack(spacing: 0) {
            Section(header:
                        title(month)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12.5)
                .background(Color.white)
                .roundedCorner(8, corners: [.topLeft, .topRight])
            ){ }
            
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    LazyVGrid(columns: Array(repeating: GridItem(spacing: 0), count: daysInWeek)) {
                        ForEach(days.prefix(daysInWeek), id: \.self, content: header)
                    }
                }.padding(.vertical, 8)
                .background(Color.theme.cultured1)
                    
                
                Divider()
                
                VStack {
                    LazyVGrid(columns: Array(repeating: GridItem(spacing: 0), count: daysInWeek), spacing: 0) {
                        ForEach(days, id: \.self) { date in
                            if calendar.isDate(date, equalTo: month, toGranularity: .month) {
                                content(date, dateRange)
                            } else {
                                trailing(date)
                            }
                        }
                    }
                }.frame(alignment: .topLeading)
                Spacer()
            }
            .frame(maxHeight: .infinity)
            .background(Color.white)
            .roundedCorner(8, corners: [.bottomLeft, .bottomRight])
        }
    }
}

// MARK: - Conformances
extension CalendarViewComponent: Equatable {
    public static func == (lhs: CalendarViewComponent<Day, Header, Title, Trailing>, rhs: CalendarViewComponent<Day, Header, Title, Trailing>) -> Bool {
        lhs.calendar == rhs.calendar && lhs.date == rhs.date
    }
}

    // MARK: - Helpers
private extension CalendarViewComponent {
    func makeDays() -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: date),
              let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
              let monthLastWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.end - 1)
        else {
            return []
        }
        
        let dateInterval = DateInterval(start: monthFirstWeek.start, end: monthLastWeek.end)
        return calendar.generateDays(for: dateInterval)
    }
}

private extension CalendarViewComponent {
    func countEventByRow(_ events: [IEvent], _ days: [Date]) -> [Int: Int] {
//        let temp[Int: Int] = [:]
        
        let dateFormmater = DateFormatter()
        dateFormmater.dateFormat = "yyyy-MM-dd"
        var tempIndex = [String: Int]()
        var countEventByRow = [Int: Int]()
        
        for row in days {
            for event in events {
                let startDate = dateFormmater.date(from: event.startDate)
                let endDate = dateFormmater.date(from: event.endDate)
                let dateString = dateFormmater.string(from: row)
                
                if row >= startDate! && row <= endDate! {
                    if tempIndex[dateString] != nil {
                        tempIndex.updateValue(tempIndex[dateString]! + 1, forKey: dateString)
                    } else {
                        tempIndex[dateString] = 1
                    }
                }
            }
        }
        
        for (index, row) in tempIndex.enumerated() {
            let num: Double = Double(index + 1)/7
            let rowIndex = num.rounded(.up)
            
            
        }
        
        return [1: 1]
    }
}

private extension Calendar {
    func generateDates(
        for dateInterval: DateInterval,
        matching components: DateComponents
    ) -> [Date] {
        var dates = [dateInterval.start]
        
        enumerateDates(
            startingAfter: dateInterval.start,
            matching: components,
            matchingPolicy: .nextTime
        ) { date, _, stop in
            guard let date = date else { return }
            
            guard date < dateInterval.end else {
                stop = true
                return
            }
            
            dates.append(date)
        }
        
        return dates
    }
    
    func generateDays(for dateInterval: DateInterval) -> [Date] {
        generateDates(
            for: dateInterval,
            matching: dateComponents([.hour, .minute, .second], from: dateInterval.start)
        )
    }
}

private extension Date {
    func startOfMonth(using calendar: Calendar) -> Date {
        calendar.date(
            from: calendar.dateComponents([.year, .month], from: self)
        ) ?? self
    }
}

private extension DateFormatter {
    convenience init(dateFormat: String, calendar: Calendar) {
        self.init()
        self.dateFormat = dateFormat
        self.calendar = calendar
    }
}
