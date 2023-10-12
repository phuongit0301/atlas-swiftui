//
//  LimitationsSubSectionView.swift
//  ATLAS
//
//  Created by phuong phan on 21/09/2023.
//

import SwiftUI

struct IDataLimitation: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var period: String
    var status: String
    var color: String
}

struct ILimitationResult {
    var text: String
    var period: String
    var status: String
    var color: String
}

struct LimitationsSubSectionView: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    
    @State var isCollapse = false
    @State var isShowModal = false
    @State var isEdit = false
    @State var dataModelLimitation = [IProvideLimitation]()
    @State private var currentIndex = -1
    
    let dateFormatter = DateFormatter()
    
    var body: some View {
        GeometryReader { proxy in
            HStack(spacing: 0) {
                List {
                    HStack {
                        HStack(alignment: .center) {
                            Text("Limitations").font(.system(size: 20, weight: .semibold)).foregroundStyle(Color.black)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            let obj = IProvideLimitation(limitationFlight: "", limitation: "", duration: "", startDate: "", endDate: "", completed: "")
                            dataModelLimitation.append(obj)
                            self.isShowModal = true
                        }, label: {
                            Text("Add Item")
                                .font(.system(size: 17, weight: .regular)).textCase(nil)
                                .foregroundColor(Color.theme.azure)
                        }).buttonStyle(PlainButtonStyle())
                    }.contentShape(Rectangle())
                        .padding()
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    
                    VStack {
                        HStack {
                            Text("Limitation")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(Color.black)
                                .frame(width: proxy.size.width - 558, alignment: .leading)

                            Text("Period")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(Color.black)
                                .frame(width: 250, alignment: .leading)

                            Text("Status")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(Color.black)
                                .frame(width: 220, alignment: .leading)
                        }
                        
                        Divider().padding(.horizontal, -24)
                    }.listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets.init(top: 0, leading: 16, bottom: -14, trailing: 16))
                        .frame(height: 44)
                        .padding(.horizontal)
                    
                    if coreDataModel.dataLogbookLimitation.count == 0 {
                        HStack {
                            Text("No limitations")
                                .font(.system(size: 15, weight: .regular))
                                .frame(alignment: .leading)
                        }.frame(height: 44)
                    } else {
                        ForEach(coreDataModel.dataLogbookLimitation.indices, id: \.self) {index in
                            VStack {
                                HStack {
                                    Text(coreDataModel.dataLogbookLimitation[index].unwrappedText)
                                        .foregroundColor(fontColor(coreDataModel.dataLogbookLimitation[index].unwrappedColour))
                                        .font(.system(size: 17, weight: .regular))
                                        .frame(width: proxy.size.width - 558, alignment: .leading)
                                    
                                    Text(coreDataModel.dataLogbookLimitation[index].unwrappedPeriodText)
                                        .foregroundColor(fontColor(coreDataModel.dataLogbookLimitation[index].unwrappedColour))
                                        .font(.system(size: 17, weight: .regular))
                                        .frame(width: 250, alignment: .leading)
                                    
                                    Text(coreDataModel.dataLogbookLimitation[index].unwrappedStatusText)
                                        .foregroundColor(fontColor(coreDataModel.dataLogbookLimitation[index].unwrappedColour))
                                        .font(.system(size: 17, weight: .regular))
                                        .frame(width: 220, alignment: .leading)
                                }.frame(height: 44)
                                
                                if index + 1 < coreDataModel.dataLogbookLimitation.count {
                                    Divider().padding(.horizontal, -16)
                                }
                            }.id(UUID())
                                .swipeActions(allowsFullSwipe: false) {
                                    Button {
                                        edit(index)
                                    } label: {
                                        Text("Update").font(.system(size: 15, weight: .medium)).foregroundColor(.white)
                                    }.tint(Color.theme.orangePeel)
                                }.padding(.bottom, index + 1 == coreDataModel.dataLogbookLimitation.count ? 8 : 0)
                                .padding(.leading, index + 1 == coreDataModel.dataLogbookLimitation.count ? 4 : 0)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets.init(top: 0, leading: 16, bottom: 0, trailing: 16))
                        }
                    }
                }
                
            }
        }.sheet(isPresented: $isShowModal) {
            LimitationSubsectionFormView(isShowing: $isShowModal, isEdit: $isEdit, currentIndex: $currentIndex).interactiveDismissDisabled(true)
        }
    }
        
    func edit(_ index: Int) {
        self.isEdit.toggle()
        self.currentIndex = index
        self.isShowModal.toggle()
    }
    
    func fontColor(_ color: String) -> Color {
        if color == "red" {
            return Color.theme.coralRed
        } else if color == "amber" {
            return Color.theme.vividGamboge
        } else {
            return Color.black
        }
    }
}

func checkLimitations(_ logbookEntries: [LogbookEntriesList], _ limitationData: [LogbookLimitationList]) -> [ILimitationResult] {
    dateFormatter.dateFormat = "dd/MM/yy"
    
    // Create an array to store limitation results
    var limitationResults: [ILimitationResult] = []
    
    // Iterate through each limitation in the limitation data
    for limitationInfo in limitationData {
        if let requirementString = limitationInfo.requirement,
           let requirement = Int(requirementString),
           let limitString = limitationInfo.limit,
           let startDateString = limitationInfo.start,
           let startDate = dateFormatter.date(from: startDateString),
           let endDateString = limitationInfo.end,
           let endDate = dateFormatter.date(from: endDateString),
           let text = limitationInfo.text {
            
            // Filter logbook entries within the limitation period
            let filteredEntries = logbookEntries.filter { entry in
                if let dateString = entry.date {
                    let entryDate = convertDateFormat(sourceDateString: dateString, sourceDateFormat: "yyyy-MM-DD", destinationFormat: "dd/MM/yy")
                    // Check if the entry date is within the limitation period
                    return entryDate >= startDate && entryDate <= endDate
                }
                return false
            }
            
            // Calculate the total hours for the filtered entries
            var grandTotalHours: Int = 0
            for entry in filteredEntries {
                let picDayTime = formatTime(entry.picDay)
                let picNightTime = formatTime(entry.picNight)
                let picUsDayTime = formatTime(entry.picUUsDay)
                let picUsNightTime = formatTime(entry.picUUsNight)
                let p1DayTime = formatTime(entry.p1Day)
                let p1NightTime = formatTime(entry.p1Night)
                let p2DayTime = formatTime(entry.p2Day)
                let p2NightTime = formatTime(entry.p2Night)
                let totalHours = picDayTime + picNightTime + picUsDayTime + picUsNightTime + p1DayTime + p1NightTime + p2DayTime + p2NightTime
                
                grandTotalHours += totalHours
            }
            
            // Calculate the color based on the logic provided
            var color = "black"
            let percentage = (grandTotalHours / requirement) * 100
            
            if percentage > 90 {
                color = "red"
            } else if percentage > 70 {
                color = "amber"
            }
            
            // Create a dictionary for the limitation result and append it to the array
            let limitationResult = ILimitationResult(text: text, period: "\(startDateString) to \(endDateString)", status: "\(minutes2Timestamp(grandTotalHours)) / \(limitString)", color: color)
            
            limitationResults.append(limitationResult)
        }
    }
    
    return limitationResults
}

func convertDateFormat(sourceDateString : String, sourceDateFormat: String, destinationFormat: String) -> Date {
    let dateFormatter = DateFormatter();
    dateFormatter.dateFormat = sourceDateFormat;

    if let date = dateFormatter.date(from: sourceDateString) {
        dateFormatter.dateFormat = destinationFormat;
        let temp = dateFormatter.string(from: date)
        return dateFormatter.date(from: temp)!
        
    } else {
        dateFormatter.dateFormat = destinationFormat;
        let temp = dateFormatter.string(from: Date())
        return dateFormatter.date(from: temp)!
    }
}


func formatTime(_ timeString: String?) -> Int {
    guard let timeString = timeString else {
        return 0
    }
    
    let timeComponents = timeString.components(separatedBy: ":")
    if timeComponents.count == 3 {
        if let hours = Int(timeComponents[0]), let minutes = Int(timeComponents[1]) {
            return hours * 3600 + minutes * 60
        }
    }
    
    return 0
}

func minutes2Timestamp(_ intSeconds: Int) -> String {
   let mins:Int = (intSeconds % 3600) / 60
   let hours:Int = intSeconds / 3600

   let strTimestamp: String = ((hours<10) ? "0" : "") + String(hours) + ":" + ((mins<10) ? "0" : "") + String(mins)
   return strTimestamp
}

struct LimitationsSubSectionView_Previews: PreviewProvider {
    static var previews: some View {
        LimitationsSubSectionView()
    }
}
