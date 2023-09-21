//
//  OverviewSubSectionView.swift
//  ATLAS
//
//  Created by phuong phan on 21/09/2023.
//

import SwiftUI

struct IData: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var date: String
    var time: String
    var color: String
}

let MOCK_DATA = [
    IData(id: UUID(), name: "Max 900 flight hours in 365 days", date: "DD/MM/YY to DD/MM/YY", time: "922:47 / 900:00", color: "red"),
    IData(id: UUID(), name: "Max 20 flight hours in 30 days", date: "DD/MM/YY to DD/MM/YY", time: "922:47 / 900:00", color: "yellow"),
]

struct IDataTime: Identifiable, Hashable {
    var id = UUID()
    var total: String
    var pic1: String
    var pic2: String
    var p1: String
    var p2: String
    var instr: String
    var exam: String
    var totalTime: String
}


let MOCK_DATA_TIME = [
    IDataTime(id: UUID(), total: "B777-300ER/SF", pic1: "H,HHH:MM", pic2: "H,HHH:MM", p1: "H,HHH:MM", p2: "H,HHH:MM", instr: "HH:MM", exam: "HH:MM", totalTime: "H,HHH:MM"),
    IDataTime(id: UUID(), total: "A320-200", pic1: "H,HHH:MM", pic2: "H,HHH:MM", p1: "H,HHH:MM", p2: "H,HHH:MM", instr: "HH:MM", exam: "HH:MM", totalTime: "H,HHH:MM"),
    IDataTime(id: UUID(), total: "A350-1000", pic1: "H,HHH:MM", pic2: "H,HHH:MM", p1: "H,HHH:MM", p2: "H,HHH:MM", instr: "HH:MM", exam: "HH:MM", totalTime: "H,HHH:MM"),
]

struct OverviewSubSectionView: View {
    @Environment(\.calendar) var calendar
    @Environment(\.timeZone) var timeZone
    
    let formatter = DateFormatter()
    @State var isCollapse = false
    @State private var selectedDates: Set<DateComponents> = []
    @State private var selectedDatesFormatted: Set<DateComponents> = []
    
    @State private var selectedDate: String = "Selected Date"
    @State private var formattedDates: String = "Day and Night"
    @State private var selectedAircraft = ""
    @State private var isShowModal: Bool = false
    @State private var isShowDateModal: Bool = false

    var body: some View {
        GeometryReader { proxy in
            HStack(spacing: 0) {
                List {
                    Section {
                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                HStack(alignment: .center) {
                                    Text("Approaching Limitations").font(.system(size: 17, weight: .semibold)).foregroundStyle(Color.black)
                                    
                                    Button(action: {
                                        self.isCollapse.toggle()
                                    }, label: {
                                        if isCollapse {
                                            Image(systemName: "chevron.up")
                                                .foregroundColor(Color.blue)
                                                .scaledToFit()
                                                .aspectRatio(contentMode: .fit)
                                        } else {
                                            Image(systemName: "chevron.down")
                                                .foregroundColor(Color.blue)
                                                .scaledToFit()
                                                .aspectRatio(contentMode: .fit)
                                        }
                                        
                                    }).buttonStyle(PlainButtonStyle())
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    // ToDo
                                }, label: {
                                    Text("See All")
                                        .font(.system(size: 17, weight: .regular)).textCase(nil)
                                        .foregroundColor(Color.theme.azure)
                                }).buttonStyle(PlainButtonStyle())
                            }.contentShape(Rectangle())
                                .padding()
                            
                            if !isCollapse {
                                VStack(alignment: .leading) {
                                    Grid(alignment: .topLeading, horizontalSpacing: 8, verticalSpacing: 12) {
                                        GridRow {
                                            Text("Limitation")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundColor(Color.black)
                                                .frame(alignment: .leading)
                                            
                                            Text("Period")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundColor(Color.black)
                                                .frame(alignment: .leading)
                                            
                                            Text("Status")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundColor(Color.black)
                                                .frame(alignment: .leading)
                                        }
                                        
                                        Divider()
                                        
                                        ForEach(MOCK_DATA.indices, id: \.self) {index in
                                            GridRow {
                                                Group {
                                                    Text(MOCK_DATA[index].name)
                                                        .font(.system(size: 17, weight: .regular))
                                                        .frame(alignment: .leading)
                                                    
                                                    Text(MOCK_DATA[index].date)
                                                        .font(.system(size: 17, weight: .regular))
                                                        .frame(alignment: .leading)
                                                    
                                                    Text(MOCK_DATA[index].time)
                                                        .font(.system(size: 17, weight: .regular))
                                                        .frame(alignment: .leading)
                                                }.foregroundColor(fontColor(MOCK_DATA[index].color))
                                            }
                                            
                                            if index + 1 < MOCK_DATA.count {
                                                Divider().padding(.horizontal, -16)
                                            }
                                        }
                                    }
                                }.padding()
                            }
                            
                        }.listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    } // End Sectionnpx
                    
                    Section {
                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                HStack(alignment: .center) {
                                    Text("Total Function Time").font(.system(size: 17, weight: .semibold)).foregroundStyle(Color.black)
                                }
                                
                                Spacer()
                                
                                HStack(spacing: 16) {
                                    CommonStepper(onToggle: onToggleDate, value: $selectedDate, suffix: "").fixedSize()
                                    
                                    Picker("", selection: $selectedAircraft) {
                                        Text("All Aircraft").tag("")
                                        ForEach(AircraftDataDropDown.allCases, id: \.self) {
                                            Text($0.rawValue).tag($0)
                                        }
                                    }.pickerStyle(MenuPickerStyle()).fixedSize()
                                    
                                    CommonStepper(onToggle: onToggle, value: $formattedDates, suffix: "").fixedSize()
                                }
                            }.contentShape(Rectangle())
                                .padding()
                            
                            if !isCollapse {
                                VStack(alignment: .leading) {
                                    Grid(alignment: .topLeading, horizontalSpacing: 16, verticalSpacing: 16) {
                                        GridRow {
                                            Text("Aircraft Model")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundColor(Color.black)
                                                .frame(alignment: .leading)
                                            
                                            Text("PIC")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundColor(Color.black)
                                                .frame(alignment: .leading)
                                            
                                            Text("PIC(u/us)")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundColor(Color.black)
                                                .frame(alignment: .leading)
                                            
                                            Text("P1")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundColor(Color.black)
                                                .frame(alignment: .leading)
                                            
                                            Text("P2")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundColor(Color.black)
                                                .frame(alignment: .leading)
                                            
                                            Text("Instr")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundColor(Color.black)
                                                .frame(alignment: .leading)
                                            
                                            Text("Exam")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundColor(Color.black)
                                                .frame(alignment: .leading)
                                            
                                            Text("Total Time (P1+P2)")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundColor(Color.black)
                                                .frame(alignment: .leading)
                                        }
                                        
                                        Divider().padding(.horizontal, -16)
                                        
                                        GridRow {
                                            Text("Total")
                                                .font(.system(size: 17, weight: .semibold))
                                                .foregroundColor(Color.black)
                                                .frame(alignment: .leading)
                                            
                                            Text("H,HHH:MM")
                                                .font(.system(size: 17, weight: .semibold))
                                                .foregroundColor(Color.black)
                                                .frame(alignment: .leading)
                                            
                                            Text("H,HHH:MM")
                                                .font(.system(size: 17, weight: .semibold))
                                                .foregroundColor(Color.black)
                                                .frame(alignment: .leading)
                                            
                                            Text("H,HHH:MM")
                                                .font(.system(size: 17, weight: .semibold))
                                                .foregroundColor(Color.black)
                                                .frame(alignment: .leading)
                                            
                                            Text("H,HHH:MM")
                                                .font(.system(size: 17, weight: .semibold))
                                                .foregroundColor(Color.black)
                                                .frame(alignment: .leading)
                                            
                                            Text("HH:MM")
                                                .font(.system(size: 17, weight: .semibold))
                                                .foregroundColor(Color.black)
                                                .frame(alignment: .leading)
                                            
                                            Text("HH:MM")
                                                .font(.system(size: 17, weight: .semibold))
                                                .foregroundColor(Color.black)
                                                .frame(alignment: .leading)
                                            
                                            Text("H,HHH:MM")
                                                .font(.system(size: 17, weight: .semibold))
                                                .foregroundColor(Color.black)
                                                .frame(alignment: .leading)
                                            
                                        }
                                        
                                        Divider().padding(.horizontal, -16)
                                        
                                        ForEach(MOCK_DATA_TIME.indices, id: \.self) {index in
                                            GridRow {
                                                Text(MOCK_DATA_TIME[index].total)
                                                    .font(.system(size: 17, weight: .regular))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                                
                                                Text(MOCK_DATA_TIME[index].pic1)
                                                    .font(.system(size: 17, weight: .regular))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                                
                                                Text(MOCK_DATA_TIME[index].pic2)
                                                    .font(.system(size: 17, weight: .regular))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                                
                                                Text(MOCK_DATA_TIME[index].p1)
                                                    .font(.system(size: 17, weight: .regular))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                                
                                                Text(MOCK_DATA_TIME[index].p2)
                                                    .font(.system(size: 17, weight: .regular))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                                
                                                Text(MOCK_DATA_TIME[index].instr)
                                                    .font(.system(size: 17, weight: .regular))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                                
                                                Text(MOCK_DATA_TIME[index].exam)
                                                    .font(.system(size: 17, weight: .regular))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                                
                                                Text(MOCK_DATA_TIME[index].totalTime)
                                                    .font(.system(size: 17, weight: .regular))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                            }
                                            
                                            if index + 1 < MOCK_DATA_TIME.count {
                                                Divider().padding(.horizontal, -16)
                                            }
                                            
                                        }
                                        
                                    }
                                    
                                }.padding()
                            }
                        }.listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    } // End Section
                    
                }// End List
            }// End HStack
            .formSheet(isPresented: $isShowModal) {
                MultiDatePicker("Dates Available", selection: $selectedDates, in: .now...)
            }
            .sheet(isPresented: $isShowDateModal) {
                ModalDateRangeView(isShowing: $isShowDateModal, selectedDate: $selectedDate)
            }
            .onChange(of: selectedDates, perform: { _ in
                if (selectedDates.count == 2) {
                    selectedDatesFormatted = selectedDates
                    let temp = Array(selectedDates)
                    let fromDate = Calendar.current.date(from: selectedDates.first!)
                    let toDate = Calendar.current.date(from: temp[1])
                    selectedDates = datesRange(from: fromDate!, to: toDate!)
                    
                    formatSelectedDates()
                }
            })
        }// End GeometryReader
    }
    
    func onToggle() {
        self.isShowModal.toggle()
    }
    
    func onToggleDate() {
        self.isShowDateModal.toggle()
    }
    
    func datesRange(from: Date, to: Date) -> Set<DateComponents> {
        // in case of the "from" date is more than "to" date,
        // it should returns an empty array:
        if from > to { return Set<DateComponents>() }

        var tempDate = from
        var array: Set<DateComponents> = [Calendar.current.dateComponents([.year, .month, .day], from: tempDate)]
        
        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            let components = Calendar.current.dateComponents([.year, .month, .day], from: tempDate)
            array.insert(components)
        }

        return array
    }
    
    private func formatSelectedDates() {
        formatter.dateFormat = "dd-MM-YY"
        let dates = selectedDatesFormatted
            .compactMap { date in
                Calendar.current.date(from: date)
            }
            .map { date in
                formatter.string(from: date)
            }
        formattedDates = dates.joined(separator: " to ")
    }
    
    func fontColor(_ color: String) -> Color {
        if color == "red" {
            return Color.theme.coralRed
        } else if color == "yellow" {
            return Color.theme.vividGamboge
        } else {
            return Color.black
        }
    }
}

struct OverviewSubSectionView_Previews: PreviewProvider {
    static var previews: some View {
        OverviewSubSectionView()
    }
}
