//
//  HomeCalendarView.swift
//  ATLAS
//
//  Created by phuong phan on 06/09/2023.
//

import SwiftUI

struct HomeCalendarView: View {
    private var calendar: Calendar
    private let monthFormatter: DateFormatter
    private let dayFormatter: DateFormatter
    private let weekDayFormatter: DateFormatter
    private let fullFormatter: DateFormatter
    
    @State private var selectedDate = Self.now
    private static var now = Date()
    
    @State private var entries: [IEntries] = CalendarModel().listItem
    @State private var dateRange: [ClosedRange<Date>] = CalendarModel().dateRange
    
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
            HomeCalendarViewComponent(
                calendar: calendar,
                date: $selectedDate,
                entries: $entries,
                content: { date in
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
                                
                                Circle().fill(eventsOfDate(date: date)).frame(width: 8, height: 8)
                            }
                        }.frame(maxWidth: .infinity)
                    }.padding(.bottom)
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
                    Text(weekDayFormatter.string(from: date)).font(.system(size: 10, weight: .semibold))
                },
                title: { date in
                    HStack(alignment: .center) {
                        
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
                                .font(.title2)
                                .foregroundColor(Color.theme.azure)
                        }.buttonStyle(PlainButtonStyle())
                        
                        Button {
                            selectedDate = Date.now
                        } label: {
                            Text("\(monthFormatter.string(from: date)) (Local Time)")
                                .foregroundColor(Color.theme.azure)
                                .font(.system(size: 17, weight: .regular))
                        }.buttonStyle(PlainButtonStyle())
                            .padding(.horizontal)

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
                                .font(.title2)
                                .foregroundColor(Color.theme.azure)
                        }.buttonStyle(PlainButtonStyle())
                    }
                }
            ).equatable()
        }.padding()
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 8).stroke(.white, lineWidth: 1)
            )
            .cornerRadius(8)
    }
    
    func dateHasEvents(date: Date) -> Bool {
        
        for entry in entries {
            if calendar.isDate(date, inSameDayAs: entry.timestamp) {
                return true
            }
        }
        
        return false
    }
    
    func eventsOfDate(date: Date) -> Color {
        for entry in entries {
            if calendar.isDate(date, inSameDayAs: entry.timestamp) {
                if entry.status == 1 {
                    return Color.theme.lavenderGray
                }
                
                if entry.status == 2 {
                    return Color.theme.azure
                }
                
                if entry.status == 3 {
                    return Color.theme.coralRed1
                }
                
                if entry.status == 4 {
                    return Color.theme.mediumOrchid
                }
            }
        }
        
        return Color.clear
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

// MARK: - Component
public struct HomeCalendarViewComponent<Day: View, Header: View, Title: View, Trailing: View>: View {
    @Environment(\.colorScheme) var colorScheme

    // Injected dependencies
    private var calendar: Calendar
    @Binding private var date: Date
    @Binding private var entries: [IEntries]
    private let content: (Date) -> Day
    private let trailing: (Date) -> Trailing
    private let header: (Date) -> Header
    private let title: (Date) -> Title
    
    // Constants
    private let daysInWeek = 7
    
    init(
        calendar: Calendar,
        date: Binding<Date>,
        entries: Binding<[IEntries]>,
        @ViewBuilder content: @escaping (Date) -> Day,
        @ViewBuilder trailing: @escaping (Date) -> Trailing,
        @ViewBuilder header: @escaping (Date) -> Header,
        @ViewBuilder title: @escaping (Date) -> Title
    ) {
        self.calendar = calendar
        self._date = date
        self._entries = entries
        self.content = content
        self.trailing = trailing
        self.header = header
        self.title = title
    }
    
    public var body: some View {
        let month = date.startOfMonth(using: calendar)
        let days = makeDays()
        
        VStack(spacing: 0) {
            
            Section(header:
                        title(month)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12.5)
                            .background(Color.theme.cultured1)
                            .roundedCorner(8, corners: [.topLeft, .topRight])
            ){ }
            
            VStack {
                
                LazyVGrid(columns: Array(repeating: GridItem(spacing: 0), count: daysInWeek)) {
                    ForEach(days.prefix(daysInWeek), id: \.self, content: header)
                }
                
                Divider()
                
                LazyVGrid(columns: Array(repeating: GridItem(spacing: 0), count: daysInWeek), spacing: 0) {
                    ForEach(days, id: \.self) { date in
                        if calendar.isDate(date, equalTo: month, toGranularity: .month) {
                            content(date)
                        } else {
                            trailing(date)
                        }
                    }
                }
            }
            .frame(height: 412)
            .background(Color.theme.cultured1)
            .roundedCorner(8, corners: [.bottomLeft, .bottomRight])
            
            
            // List Entries
            List(entries) { entry in
                HStack(alignment: .top) {
                    Rectangle().fill(eventsOfDate(entry))
                        .frame(width: 4, height: 24)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8).stroke(.white, lineWidth: 1)
                        )
                        .cornerRadius(100)
                    
                    VStack(alignment: .center) {
                        HStack {
                            Text("234 SIN DXB LIS DXB SIN").font(.system(size: 17, weight: .semibold))
                            Spacer()
                            Text("\(entry.timestamp, formatter: dateFormatter)").font(.system(size: 15, weight: .regular))
                        }
                        
                        Divider()
                    }
                }.listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets.init(top: 16, leading: 0, bottom: 16, trailing: 0))
            }.listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            
        }
    }
    
    func eventsOfDate(_ entry: IEntries) -> Color {
        if entry.status == 1 {
            return Color.theme.lavenderGray
        }
        
        if entry.status == 2 {
            return Color.theme.azure
        }
        
        if entry.status == 3 {
            return Color.theme.coralRed1
        }
        
        if entry.status == 4 {
            return Color.theme.mediumOrchid
        }
        
        return Color.clear
    }
}

// MARK: - Conformances
extension HomeCalendarViewComponent: Equatable {
    public static func == (lhs: HomeCalendarViewComponent<Day, Header, Title, Trailing>, rhs: HomeCalendarViewComponent<Day, Header, Title, Trailing>) -> Bool {
        lhs.calendar == rhs.calendar && lhs.date == rhs.date
    }
}

// MARK: - Helpers

private extension HomeCalendarViewComponent {
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

