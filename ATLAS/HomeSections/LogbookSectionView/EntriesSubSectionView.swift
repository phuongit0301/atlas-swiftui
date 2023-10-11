//
//  EntriesSubSectionView.swift
//  ATLAS
//
//  Created by phuong phan on 21/09/2023.
//

import SwiftUI

struct EntriesSubSectionView: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    
    @State var isCollapse = false
    @State private var isShowDateModal: Bool = false
    @State private var selectedDate: String = "Selected Date"
    @State private var selectedStartDate: String = ""
    @State private var selectedEndDate: String = ""
    @State private var dataLogbookEntries = [LogbookEntriesList]()
    
    var body: some View {
        GeometryReader { proxy in
            HStack(spacing: 0) {
                List {
                    Section {
                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                HStack(alignment: .center) {
                                    Text("All Logbook Entries").font(.system(size: 20, weight: .semibold)).foregroundStyle(Color.black)
                                }
                                Spacer()
                                
                                HStack {
                                    CommonStepper(onToggle: onToggleDate, value: $selectedDate, suffix: "").fixedSize()
                                    
//                                    Button(action: {
//                                        //Todo
//                                    }, label: {
//                                        Text("Extract").font(.system(size: 15, weight: .regular)).foregroundColor(Color.white)
//                                    }).padding(.vertical, 11)
//                                        .padding(.horizontal)
//                                        .background(Color.theme.azure)
//                                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(.white, lineWidth: 1))
//                                        .cornerRadius(8)
//                                        .buttonStyle(PlainButtonStyle())
                                }
                            }.contentShape(Rectangle())
                                .padding()
                            
                            if !isCollapse {
                                VStack {
                                    Grid(alignment: .topLeading, horizontalSpacing: 8, verticalSpacing: 2) {
                                        GridRow {
                                            Group {
                                                Text("Date")
                                                    .font(.system(size: 15, weight: .medium))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                                
                                                Text("Aircraft Type")
                                                    .font(.system(size: 15, weight: .medium))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                                
                                                Text("Aircraft")
                                                    .font(.system(size: 15, weight: .medium))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                                
                                                Text("Dep.")
                                                    .font(.system(size: 15, weight: .medium))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                                
                                                Text("Dest.")
                                                    .font(.system(size: 15, weight: .medium))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                                
                                                Text("PIC Day")
                                                    .font(.system(size: 15, weight: .medium))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                            }.frame(height: 44)
                                            
                                            Group {
                                                Text("PIC(u/us) Day")
                                                    .font(.system(size: 15, weight: .medium))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                                
                                                Text("P1 Day")
                                                    .font(.system(size: 15, weight: .medium))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                                
                                                Text("P2 Day")
                                                    .font(.system(size: 15, weight: .medium))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                                
                                                Text("PIC Night")
                                                    .font(.system(size: 15, weight: .medium))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                                
                                                Text("PIC(u/us) Night")
                                                    .font(.system(size: 15, weight: .medium))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                                
                                                Text("P1 Night")
                                                    .font(.system(size: 15, weight: .medium))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                                
                                                Text("P2 Night")
                                                    .font(.system(size: 15, weight: .medium))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                            }.frame(height: 44, alignment: .center)
                                        }
                                        GridRow {
                                            Group {
                                                Text("Comments")
                                                    .font(.system(size: 15, weight: .medium))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                                    .gridCellColumns(7)
                                                Text("Signature")
                                                    .font(.system(size: 15, weight: .medium))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                                    .gridCellColumns(6)
                                            }.frame(height: 44, alignment: .center)
                                            
                                        }
                                        
                                        Divider().padding(.horizontal, -16)
                                        
                                        if dataLogbookEntries.count == 0 {
                                            HStack {
                                                Text("No Logbook Entries saved").foregroundColor(Color.theme.philippineGray2).font(.system(size: 17, weight: .regular))
                                                Spacer()
                                            }.frame(height: 44)
                                        } else {
                                            ForEach(dataLogbookEntries.indices, id: \.self) {index in
                                                GridRow {
                                                    Group {
                                                        Text(dataLogbookEntries[index].unwrappedDate)
                                                            .font(.system(size: 15, weight: .regular))
                                                            .frame(alignment: .leading)
                                                        
                                                        Text(dataLogbookEntries[index].unwrappedAircraftType)
                                                            .font(.system(size: 15, weight: .regular))
                                                            .frame(alignment: .leading)
                                                        
                                                        Text(dataLogbookEntries[index].unwrappedAircraft)
                                                            .font(.system(size: 15, weight: .regular))
                                                            .frame(alignment: .leading)
                                                        
                                                        Text(dataLogbookEntries[index].unwrappedDeparture)
                                                            .font(.system(size: 15, weight: .regular))
                                                            .frame(alignment: .leading)
                                                        
                                                        Text(dataLogbookEntries[index].unwrappedDestination)
                                                            .font(.system(size: 15, weight: .regular))
                                                            .frame(alignment: .leading)
                                                        
                                                        Text(dataLogbookEntries[index].unwrappedPicDay)
                                                            .font(.system(size: 15, weight: .regular))
                                                            .frame(alignment: .leading)
                                                    }.frame(height: 44, alignment: .center)
                                                    
                                                    Group {
                                                        Text(dataLogbookEntries[index].unwrappedPicUUsDay)
                                                            .font(.system(size: 15, weight: .regular))
                                                            .frame(alignment: .leading)
                                                        
                                                        Text(dataLogbookEntries[index].unwrappedP1Day)
                                                            .font(.system(size: 15, weight: .regular))
                                                            .frame(alignment: .leading)
                                                        
                                                        Text(dataLogbookEntries[index].unwrappedP2Day)
                                                            .font(.system(size: 15, weight: .regular))
                                                            .frame(alignment: .leading)
                                                        
                                                        Text(dataLogbookEntries[index].unwrappedPicNight)
                                                            .font(.system(size: 15, weight: .regular))
                                                            .frame(alignment: .leading)
                                                        
                                                        Text(dataLogbookEntries[index].unwrappedPicUUsNight)
                                                            .font(.system(size: 15, weight: .regular))
                                                            .frame(alignment: .leading)
                                                        
                                                        Text(dataLogbookEntries[index].unwrappedP1Night)
                                                            .font(.system(size: 15, weight: .regular))
                                                            .frame(alignment: .leading)
                                                        
                                                        Text(dataLogbookEntries[index].unwrappedP2Night)
                                                            .font(.system(size: 15, weight: .regular))
                                                            .frame(alignment: .leading)
                                                    }.frame(height: 44, alignment: .center)
                                                }
                                                
                                                GridRow {
                                                    Group {
                                                        Text(dataLogbookEntries[index].unwrappedComments)
                                                            .font(.system(size: 15, weight: .regular))
                                                            .frame(alignment: .leading)
                                                            .gridCellColumns(7)
                                                        
                                                        if let fileUrl = dataLogbookEntries[index].signFileUrl, fileUrl != "none" {
                                                            if fileUrl.contains("http") {
                                                                AsyncImage(url: URL(string: fileUrl)).frame(width: 100, height: 80)
                                                            } else {
                                                                if let uiImage = convertBase64ToImage(imageString: fileUrl) {
                                                                    Image(uiImage: uiImage).resizable().scaledToFit().frame(width: 100, height: 80)
                                                                }
                                                            }
                                                        } else {
                                                            Text("None")
                                                                .font(.system(size: 15, weight: .regular))
                                                                .frame(alignment: .leading)
                                                                .gridCellColumns(6)
                                                        }
                                                        
                                                    }.frame(height: 44, alignment: .center)
                                                }
                                                
                                                if index + 1 < dataLogbookEntries.count {
                                                    Divider().padding(.horizontal, -16)
                                                }
                                            }
                                        }
                                        
                                    }
                                    
                                }//End VStack
                                .padding(.vertical)
                                .padding(.horizontal, 8)
                            }//End if
                            
                        }.listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    } // End Section
                }
            }.sheet(isPresented: $isShowDateModal) {
                ModalDateRangeView(isShowing: $isShowDateModal, selectedDate: $selectedDate, selectedStartDate: $selectedStartDate, selectedEndDate: $selectedEndDate)
            }
            .onAppear {
                dataLogbookEntries = coreDataModel.dataLogbookEntries
            }
            .onChange(of: selectedDate) {_ in
                dataLogbookEntries = extractEntriesInRange(coreDataModel.dataLogbookEntries, selectedStartDate, selectedEndDate)
            }
        }
    }
    
    func onToggleDate() {
        self.isShowDateModal.toggle()
    }
}

func extractEntriesInRange(_ entries: [LogbookEntriesList], _ startDate: String, _ endDate: String) -> [LogbookEntriesList] {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    guard let startDate = dateFormatter.date(from: startDate),
          let endDate = dateFormatter.date(from: endDate) else {
        return []
    }
    
    var filteredEntries: [LogbookEntriesList] = []
    
    for entry in entries {
        if let dateString = entry.date,
           let entryDate = dateFormatter.date(from: dateString),
           entryDate >= startDate && entryDate <= endDate {
            filteredEntries.append(entry)
        }
    }
    
    return filteredEntries
}

struct EntriesSubSectionView_Previews: PreviewProvider {
    static var previews: some View {
        EntriesSubSectionView()
    }
}
