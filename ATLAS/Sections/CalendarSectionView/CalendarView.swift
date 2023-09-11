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
    @EnvironmentObject var calendarModel: CalendarModel
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
                events: $calendarModel.listEvent,
                content: { (date, dateRange) in
                    VStack(alignment: .center, spacing: 0) {
                        Button(action: {
                            selectedDate = date
                        }, label: {
                            HStack(alignment: .center) {
                                Text(dayFormatter.string(from: date))
                                    .frame(width: 32, height: 32)
                                    .foregroundColor(calendar.isDateInToday(date) ? Color.white : .primary)
                                    .background(
                                        calendar.isDateInToday(date) ? Color.theme.azure
                                        : calendar.isDate(date, inSameDayAs: selectedDate) ? .blue
                                        : .clear
                                    ).cornerRadius(100)
                            }.frame(height: 35)
                        }).buttonStyle(PlainButtonStyle())
                        .frame(maxWidth: .infinity)

                    }.frame(height: 103, alignment: .top)
                    .background(eventsOfRange(date: date))
                },
                // assign color for past and future dates
                trailing: { date in
                    VStack(alignment: .center, spacing: 0) {
                        Text(dayFormatter.string(from: date))
                            .foregroundColor(.secondary)
                            .padding(6)
                            .frame(width: 33, height: 33)
                    }.frame(height: 103, alignment: .top)
                        .frame(maxWidth: .infinity)
                },
                header: { date in
                    Text(weekDayFormatter.string(from: date)).font(.system(size: 15, weight: .semibold)).frame(maxWidth: .infinity)
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
        }.padding(.horizontal)
            .padding(.vertical, 8)
            .coordinateSpace(name: "cellWidth")
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
        let daysByRows = prepareDays(days)
        let eventByRow = countEventByRow(events, days)
        let rows = Int(days.count / 7)
        
        GeometryReader { reader in
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
                        ForEach(days.prefix(daysInWeek), id: \.self, content: header)
                    }.padding(.vertical, 8)
                        .background(Color.theme.cultured1)
                    
                    
                    Divider()
                    
                    ForEach(0..<rows, id: \.self) { index in
                        
                        ZStack(alignment: .leading) {
                            HStack(spacing: 0) {
                                ForEach(daysByRows[index + 1]!, id: \.self) { date in
                                    if calendar.isDate(date, equalTo: month, toGranularity: .month) {
                                        content(date, dateRange)
                                    } else {
                                        trailing(date)
                                    }
                                }
                            }
                            
                            
                            if let events = eventByRow["\(index + 1)"] as? [String: Any] {
                                VStack(spacing: 0) {
                                    Text("").frame(height: 35)
                                    
                                    ForEach(Array(events.keys), id: \.self) { eventKey in
                                        HStack(alignment: .top, spacing: 0) {
                                            if let event = events[eventKey] as? [String: Any] {
                                                HStack(spacing: 0) {
                                                    if (event["space"] as? Int ?? 0) > 0 {
                                                        Text("").frame(width: calculateWidth1(Int(reader.frame(in: .named("cellWidth")).width) / 7, event["space"] as? Int))
                                                    }
                                                    HStack(spacing: 0) {
                                                        Text("\((event["name"] as? String)!)")
                                                            .font(.system(size: 11, weight: .regular))
                                                            .foregroundColor(textColor((event["name"] as? String)!))
                                                            .lineLimit(1)
                                                            .padding(.horizontal, 8)
                                                        
                                                        Spacer()
                                                    }
                                                    .frame(width: calculateWidth((Int(reader.frame(in: .named("cellWidth")).width)) / 7, event["column"] as? Int), height: 17)
                                                    .background(bgColor((event["name"] as? String)!))
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 4)
                                                            .stroke(borderColor((event["name"] as? String)!), lineWidth: 1)
                                                    )
                                                    .cornerRadius(4)
                                                }.padding(.trailing, -12)
                                            }
                                            
                                            Spacer()
                                        }.frame(maxWidth: .infinity)
                                        .frame(alignment: .leading)
                                    }
                                }
                            }
                        }.frame(maxWidth: .infinity)
                    }
                    Spacer()
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .background(Color.white)
                .roundedCorner(8, corners: [.bottomLeft, .bottomRight])
            }
        }
    }
    
    func calculateWidth1(_ currentWidth: Int?, _ space: Int?) -> CGFloat {
        if let space = space, let currentWidth = currentWidth {
            return CGFloat(currentWidth * space)
        }
        return CGFloat(0)
    }
    
    func calculateWidth(_ currentWidth: Int?, _ column: Int?) -> CGFloat {
        if let column = column, let currentWidth = currentWidth {
            return CGFloat(currentWidth * column)
        }
        return CGFloat(120)
    }
    
    func calculateXOffset(_ rowNum: Int?) -> CGFloat {
        if let rowNum = rowNum {
            return CGFloat(rowNum * 200)
        }
        return CGFloat(40)
    }
    
    func calculateYOffset(_ rowNum: Int?) -> CGFloat {
        if let rowNum = rowNum {
            return CGFloat(rowNum * 20)
        }
        return 0
    }
    
    func bgColor(_ name: String) -> Color {
        if name.contains("Standby") {
            return Color.theme.lavenderGray
        }
        
        if name.contains("COP") || name.contains("Rest") {
            return Color.clear
        }
        
        if name.contains("Leave") {
            return Color.theme.coralRed1
        }
        
        if name.contains("Internal training") {
            return Color.theme.mediumOrchid
        }

        return Color.theme.azure
    }
    
    func borderColor(_ name: String) -> Color {
        if name.contains("COP") {
            return Color.theme.azure
        }
        
        if name.contains("Rest") {
            return Color.theme.coralRed1
        }
        
        return Color.clear
    }
    
    func textColor(_ name: String) -> Color {
        if name.contains("COP") {
            return Color.theme.azure
        }
        
        if name.contains("Standby") {
            return Color.black
        }
        
        if name.contains("Rest") {
            return Color.theme.coralRed1
        }
        
        return Color.white
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
    func countEventByRow(_ events: [IEvent], _ days: [Date]) -> [String: Any] {
        
        let dateFormmater = DateFormatter()
        dateFormmater.dateFormat = "yyyy-MM-dd"
        var tempIndex = [String: Any]()
        
        for (i, event) in events.enumerated() {
            
            var space = 0
            
            for (index, row) in days.enumerated() {
                if index % 7 == 0 {
                    space = 0
                }
                
                let startDate = dateFormmater.date(from: event.startDate)
                let endDate = dateFormmater.date(from: event.endDate)
                let dateString = dateFormmater.string(from: row)
                
                let num: Double = Double(index + 1)/7
                let rowIndex = num.rounded(.up)
                let parseRowIndex = Int(rowIndex)
                
                let strIndex = "\(parseRowIndex)"
                let strStartDate = "\(parseRowIndex).\(event.id).startDate"
                let strColumn = "\(parseRowIndex).\(event.id).column"
                let strEventName = "\(parseRowIndex).\(event.id).name"
                let strRowNum = "\(parseRowIndex).\(event.id).rowNum"
                let strSpace = "\(parseRowIndex).\(event.id).space"
                
                if row >= startDate! && row <= endDate! {
                    if tempIndex[keyPath: strIndex] != nil && tempIndex[keyPath: strStartDate] != nil {
                        tempIndex[keyPath: strColumn] = (tempIndex[keyPath: strColumn] as! Int) + 1
                        tempIndex[keyPath: strRowNum] = i + 1
                    } else {
                        tempIndex[keyPath: strStartDate] = dateString
                        tempIndex[keyPath: strEventName] = event.name
                        tempIndex[keyPath: strColumn] = 1
                        tempIndex[keyPath: strRowNum] = i + 1
                        tempIndex[keyPath: strSpace] = space
                    }
                }
                else {
                    space += 1
                }
                
            }
        }
        
        return tempIndex
    }
}

private extension CalendarViewComponent {
    func prepareDays(_ days: [Date]) -> [Int: [Date]] {
        var response: Dictionary<Int, [Date]> = [Int: [Date]]()
        
        for (index, row) in days.enumerated() {
            let num: Double = Double(index + 1)/7
            
            let rowIndex = num.rounded(.up)
            let parseRowIndex = Int(rowIndex)
            
            if response[parseRowIndex] != nil {
                response[parseRowIndex]!.append(row)
            } else {
                response.updateValue([row], forKey: parseRowIndex)
            }
        }
        
        return response
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

extension Dictionary {
  subscript(keyPath keyPath: String) -> Any? {
    get {
      guard let keyPath = Dictionary.keyPathKeys(forKeyPath: keyPath)
        else { return nil }
      return getValue(forKeyPath: keyPath)
    }
    set {
      guard let keyPath = Dictionary.keyPathKeys(forKeyPath: keyPath),
        let newValue = newValue else { return }
      self.setValue(newValue, forKeyPath: keyPath)
    }
  }

  static private func keyPathKeys(forKeyPath: String) -> [Key]? {
    let keys = forKeyPath.components(separatedBy: ".").compactMap({ $0 as? Key })
    return keys.isEmpty ? nil : keys
  }

  // recursively (attempt to) access queried subdictionaries
  // (keyPath will never be empty here; the explicit unwrapping is safe)
  private func getValue(forKeyPath keyPath: [Key]) -> Any? {
    guard let value = self[keyPath.first!] else { return nil }
    return keyPath.count == 1 ? value : (value as? [Key: Any])
      .flatMap { $0.getValue(forKeyPath: Array(keyPath.dropFirst())) }
  }

  // recursively (attempt to) access the queried subdictionaries to
  // finally replace the "inner value", given that the key path is valid
  private mutating func setValue(_ value: Any, forKeyPath keyPath: [Key]) {
    if keyPath.count == 1 {
      self[keyPath.first!] = value as? Value
    }
    else {
      if self[keyPath.first!] == nil {
        self[keyPath.first!] = ([Key: Value]() as? Value)
      }
      if var subDict = self[keyPath.first!] as? [Key: Value] {
        subDict.setValue(value, forKeyPath: Array(keyPath.dropFirst()))
        self[keyPath.first!] = subDict as? Value
      }
    }
  }
}


