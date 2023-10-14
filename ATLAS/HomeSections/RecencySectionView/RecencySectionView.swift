//
//  RecencySectionView.swift
//  ATLAS
//
//  Created by phuong phan on 06/09/2023.
//

import SwiftUI

struct IDataExpiringSoon: Identifiable, Hashable {
    var id = UUID()
    var item: String
    var expireDate: String
    var requirement: String
    var remark: String
}

struct DocumentExpiry {
    let id: String
    let type: String
    let expiryDate: String
}

struct RecencySectionView: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @StateObject var recencySection = RecencySection()
    
//    @State var dataExpiringSoon = [DocumentExpiry]()
    @State var isCollapse = false
    @State var isCollapseRecency = false
    @State var isCollapseDocument = false
    @State var isShowDocumentModal = false
    @State private var selectedPicker = ""
    @State private var selectedExpiring = ""
    @State private var selectedExpirySoon = ""
    @State var progress = 0.0
    @State private var count = 0
    @State private var isEdit = false
    @State private var isEditRecency = false
//    let monthsAhead = 6
    let dateFormatter = DateFormatter()
    
    //for calculate recency
    let recencyRequirement = 1
    let recencyLimit = 35
    
    var body: some View {
        GeometryReader { proxy in
            HStack(spacing: 0) {
                List {
                    Section {
                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                HStack(alignment: .center) {
                                    Text("Expiring Soon").font(.system(size: 20, weight: .semibold)).foregroundStyle(Color.black)
                                    
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
                                
                                //                                HStack {
                                //                                    Picker("", selection: $selectedPicker) {
                                //                                        Text("Show All").tag("")
                                //                                        ForEach(recencySection.dataItemDropDown, id: \.self) {
                                //                                            Text($0).tag($0)
                                //                                        }
                                //                                    }.pickerStyle(MenuPickerStyle()).fixedSize()
                                //
                                //                                    Picker("", selection: $selectedPicker) {
                                //                                        Text("Show All").tag("")
                                //                                        ForEach(recencySection.dataExpiringDropDown, id: \.self) {
                                //                                            Text($0).tag($0)
                                //                                        }
                                //                                    }.pickerStyle(MenuPickerStyle()).fixedSize()
                                //                                }
                            }.contentShape(Rectangle())
                                .padding()
                            
                            if !isCollapse {
                                VStack(alignment: .leading) {
                                    Grid(alignment: .topLeading, horizontalSpacing: 8, verticalSpacing: 12) {
                                        GridRow {
                                            Text("Item")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundColor(Color.black)
                                                .frame(alignment: .leading)
                                            
                                            Text("Expiry Date")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundColor(Color.black)
                                                .frame(alignment: .leading)
                                        }
                                        
                                        Divider().padding(.horizontal, -16)
                                        
                                        if coreDataModel.dataExpiringSoon.count == 0 {
                                            GridRow {
                                                Text("No expiring soon")
                                                    .font(.system(size: 15, weight: .regular))
                                                    .frame(height: 44, alignment: .leading)
                                            }
                                        } else {
                                            ForEach(coreDataModel.dataExpiringSoon.indices, id: \.self) {index in
                                                GridRow {
                                                    Group {
                                                        Text(coreDataModel.dataExpiringSoon[index].type)
                                                            .font(.system(size: 15, weight: .regular))
                                                            .frame(alignment: .leading)
                                                        
                                                        Text(coreDataModel.dataExpiringSoon[index].expiryDate)
                                                            .font(.system(size: 15, weight: .regular))
                                                            .frame(alignment: .leading)
                                                    }.frame(height: 44)
                                                    
                                                }
                                            }
                                        }
                                        
                                    }
                                }.padding()
                            }
                            
                        }.listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.theme.vividGamboge, lineWidth: 1))
                    } // End Section
                    
                    Section {
                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                HStack(alignment: .center) {
                                    Text("Recency").font(.system(size: 20, weight: .semibold)).foregroundStyle(Color.black)
                                    
                                    Button(action: {
                                        self.isCollapseRecency.toggle()
                                    }, label: {
                                        if isCollapseRecency {
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
                                    isEditRecency.toggle()
                                }, label: {
                                    Text("Edit")
                                        .font(.system(size: 17, weight: .regular)).textCase(nil)
                                        .foregroundColor(Color.theme.azure)
                                }).buttonStyle(PlainButtonStyle())
                                
                                //                                HStack {
                                //                                    Picker("", selection: $selectedExpirySoon) {
                                //                                        Text("Expiry (Soonest)").tag("")
                                //                                        ForEach(recencySection.dataExpirySoonDropDown, id: \.self) {
                                //                                            Text($0).tag($0)
                                //                                        }
                                //                                    }.pickerStyle(MenuPickerStyle()).fixedSize()
                                //                                }
                            }.contentShape(Rectangle())
                                .padding()
                            
                            if !isCollapseRecency {
                                VStack(alignment: .leading) {
                                    Grid(alignment: .topLeading, horizontalSpacing: 8, verticalSpacing: 12) {
                                        GridRow {
                                            Text("Type")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundColor(Color.black)
                                                .frame(alignment: .leading)
                                            
                                            Text("Model")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundColor(Color.black)
                                                .frame(alignment: .leading)
                                            
                                            Text("Requirement")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundColor(Color.black)
                                                .frame(alignment: .leading)
                                        }
                                        
                                        Divider().padding(.horizontal, -16)
                                        
                                        if coreDataModel.dataRecency.count == 0 {
                                            HStack {
                                                Text("No recency saved").foregroundColor(Color.theme.philippineGray2).font(.system(size: 17, weight: .regular))
                                                Spacer()
                                            }.frame(height: 44)
                                        } else {
                                            ForEach(coreDataModel.dataRecency.indices, id: \.self) {index in
                                                GridRow {
                                                    Group {
                                                        Text(coreDataModel.dataRecency[index].unwrappedType)
                                                            .font(.system(size: 17, weight: .regular))
                                                            .frame(alignment: .leading)
                                                        
                                                        Text("B737")
                                                            .font(.system(size: 17, weight: .regular))
                                                            .frame(alignment: .leading)
                                                        
                                                        HStack(alignment: .top) {
                                                            VStack(alignment: .leading, spacing: 16) {
                                                                Text(coreDataModel.dataRecency[index].unwrappedRequirement)
                                                                    .font(.system(size: 17, weight: .regular))
                                                                    .frame(alignment: .leading)
                                                                Text("\(count) / \(coreDataModel.dataRecency[index].unwrappedRequirement) landings in the last \(coreDataModel.dataRecency[index].unwrappedLimit) days")
                                                                    .foregroundColor(Color.theme.azure)
                                                                    .font(.system(size: 17, weight: .regular))
                                                                    .frame(alignment: .leading)
                                                            }
                                                            ProgressView(value: progress).frame(width: 220).padding(.top, 8)
                                                        }
                                                        
                                                    }
                                                    
                                                }
                                                
                                                if index + 1 < coreDataModel.dataRecency.count {
                                                    Divider().padding(.horizontal, -16)
                                                }
                                            }
                                        }
                                        
                                    }
                                }.padding()
                            }
                            
                        }.listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    } // End Section
                    
                    Section {
                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                HStack {
                                    HStack(alignment: .center) {
                                        Text("Documents").font(.system(size: 20, weight: .semibold)).foregroundStyle(Color.black)
                                        
                                        Button(action: {
                                            self.isCollapseDocument.toggle()
                                        }, label: {
                                            if isCollapseDocument {
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
                                }.contentShape(Rectangle())
                                
                                HStack(spacing: 16) {
                                    //                                    Picker("", selection: $selectedExpirySoon) {
                                    //                                        Text("Expiry (Soonest)").tag("")
                                    //                                        ForEach(recencySection.dataRecencyDropDown, id: \.self) {
                                    //                                            Text($0).tag($0)
                                    //                                        }
                                    //                                    }.pickerStyle(MenuPickerStyle()).fixedSize()
                                    
                                    Button(action: {
                                        self.isShowDocumentModal.toggle()
                                    }, label: {
                                        Text("Add")
                                            .font(.system(size: 17, weight: .regular)).textCase(nil)
                                            .foregroundColor(Color.white)
                                    }).padding(.vertical, 11)
                                        .padding(.horizontal)
                                        .buttonStyle(PlainButtonStyle())
                                        .background(Color.theme.azure)
                                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(.white, lineWidth: 1))
                                        .cornerRadius(8)
                                    
                                    Button(action: {
                                        isEdit.toggle()
                                    }, label: {
                                        Text(isEdit ? "Done" : "Edit")
                                            .font(.system(size: 17, weight: .regular)).textCase(nil)
                                            .foregroundColor(Color.theme.azure)
                                    }).buttonStyle(PlainButtonStyle())
                                }
                            }.padding()
                            
                            if !isCollapseDocument {
                                VStack(alignment: .leading) {
                                        HStack {
                                            Text("Type")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundColor(Color.black)
                                                .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                            
                                            Text("Expire Date")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundColor(Color.black)
                                                .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                        }
                                        
                                        Divider().padding(.horizontal, -16)
                                        
                                        if coreDataModel.dataRecencyDocument.count == 0 {
                                            HStack {
                                                Text("No documents saved").foregroundColor(Color.theme.philippineGray2).font(.system(size: 17, weight: .regular))
                                                Spacer()
                                            }.frame(height: 44)
                                        } else {
                                            ForEach(coreDataModel.dataRecencyDocument.indices, id: \.self) {index in
                                                if isEdit {
                                                    RecencyDocumentRowEdit(width: proxy.size.width, item: coreDataModel.dataRecencyDocument[index], itemList: $coreDataModel.dataRecencyDocument)
                                                } else {
                                                    HStack {
                                                        Text(coreDataModel.dataRecencyDocument[index].unwrappedType)
                                                            .font(.system(size: 17, weight: .regular))
                                                            .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                                        
                                                        Text(coreDataModel.dataRecencyDocument[index].unwrappedExpiredDate)
                                                            .font(.system(size: 17, weight: .regular))
                                                            .frame(width: calculateWidthSummary(proxy.size.width - 32, 2), alignment: .leading)
                                                    }.frame(height: 44)
                                                }
                                                
                                                if index + 1 < coreDataModel.dataRecencyDocument.count {
                                                    Divider().padding(.horizontal, -16)
                                                }
                                            }
                                        }
                                }.padding()
                            }
                            
                        }.listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    } // End Section
                }
            }.keyboardAvoidView()
            .onAppear {
                let data = calculateRecencyPercentage(coreDataModel.dataLogbookEntries, recencyRequirement, recencyLimit)
                self.progress = data.percentage
                self.count = data.count
            }
        }.sheet(isPresented: $isShowDocumentModal) {
            RecencyDocumentFormView(isShowing: $isShowDocumentModal).interactiveDismissDisabled(true)
        }.sheet(isPresented: $isEditRecency) {
            RecencySectionFormView(isShowing: $isEditRecency)
        }
    }
    
    
//    func extractExpiringDocuments(expiryData: [RecencyExpiryList], monthsAhead: Int) -> [DocumentExpiry] {
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//
//        // Get the current date
//
//        // Calculate the date 6 months from now
//        if let sixMonthsFromNow = Calendar.current.date(byAdding: .month, value: monthsAhead, to: currentDate) {
//            // Create an array to store expiring documents
//            var expiringDocuments: [DocumentExpiry] = []
//            // Iterate through each document in the expiry data
//            for row in expiryData {
//                if let expiryDate = dateFormatter.date(from: row.expiredDate!) {
//                    // Check if the expiry date is within the next 6 months
//                    if expiryDate <= sixMonthsFromNow {
//                        let documentExpiry = DocumentExpiry(id: UUID().uuidString,
//                                                            type: row.unwrappedName,
//                                                            expiryDate: dateFormatter.string(from: expiryDate))
//                        expiringDocuments.append(documentExpiry)
//                    }
//                }
//            }
//
//            return expiringDocuments
//        }
//
//        return []
//    }
//
    func calculateRecencyPercentage(_ logbookEntries: [LogbookEntriesList], _ recencyRequirement: Int, _ recencyLimit: Int) -> (count: Int, percentage: Double) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Get today's date in UTC
        let currentDate = Date()
        
        // Calculate the date "recencyLimit" days ago
        if let startDate = Calendar.current.date(byAdding: .day, value: -recencyLimit, to: currentDate) {
            // Filter logbook entries within the recency limit
            let filteredEntries = logbookEntries.filter { entry in
                if let dateString = entry.date,
                   let entryDate = dateFormatter.date(from: dateString) {
                    // Check if the entry date is within the recency limit
                    if entryDate >= startDate && entryDate <= currentDate {
                        // Check if any of the time values are not zero
                        let picDay = parseTime(entry.picDay)
                        let picNight = parseTime(entry.picNight)
                        let picUsDay = parseTime(entry.picUUsDay)
                        let picUsNight = parseTime(entry.picUUsNight)
                        let p1Day = parseTime(entry.p1Day)
                        let p1Night = parseTime(entry.p1Night)
                        
                        return picDay > 0 || picNight > 0 || picUsDay > 0 || picUsNight > 0 || p1Day > 0 || p1Night > 0
                    }
                }
                return false
            }
            
            // Calculate the count of landings
            let landingCount = filteredEntries.count
            
            // Calculate the percentage
            let percentage = min((Double(landingCount) / Double(recencyRequirement)), 1.0)
            
            return (landingCount, percentage)
        }
        
        return (0, 0.0)
    }
    
    func parseTime(_ timeString: String?) -> Int {
        guard let timeString = timeString else {
            return 0
        }

        let arr = timeString.components(separatedBy: " ")
        
        if arr.count == 3 {
            let timeComponents = arr[2].components(separatedBy: ":")
            if timeComponents.count == 3 {
                if let hours = Int(timeComponents[0]), let minutes = Int(timeComponents[1]), let seconds = Int(timeComponents[2]) {
                    return hours * 3600 + minutes * 60 + seconds
                }
            }
        }
        

        return 0
    }
}

struct RecencySectionView_Previews: PreviewProvider {
    static var previews: some View {
        RecencySectionView()
    }
}
