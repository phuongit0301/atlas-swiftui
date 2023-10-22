//
//  HomeInformationView.swift
//  ATLAS
//
//  Created by phuong phan on 07/09/2023.
//

import SwiftUI

struct HomeInformationView: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var remoteService: RemoteService
    
    @State var isCollapseFlight = false
    @State var isCollapseExpiring = false
    @State var isCollapseLimitations = false
    @State private var upcomingEvent = [EventList]()
    @State private var dataLimitation: [ILimitationResult] = []
    
    let dateFormatter = DateFormatter()
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        HStack(alignment: .center) {
                            Text("Your Flights").font(.system(size: 20, weight: .semibold)).foregroundStyle(Color.black)
                            
                            Button(action: {
                                self.isCollapseFlight.toggle()
                            }, label: {
                                if isCollapseFlight {
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
                            self.isCollapseFlight.toggle()
                        }, label: {
                            Text("See All")
                                .font(.system(size: 17, weight: .regular)).textCase(nil)
                                .foregroundColor(Color.theme.azure)
                        }).buttonStyle(PlainButtonStyle())
                    }.contentShape(Rectangle())
                        .padding()
                    
                    if !isCollapseFlight {
                        VStack(alignment: .leading, spacing: 0) {
//                            HStack {
//                                Text("Current COP: 234 SIN DXB LIS DXB SIN")
//
//                                Spacer()
//                            }.padding(.vertical, 8)
//                                .padding(.horizontal)
//                                .background(Color.theme.azureishWhite1)
//                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Group {
                                Text("UPCOMING")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(Color.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.top)
                                    .padding(.bottom, 8)
                                    .padding(.horizontal)
                                
                                
                                Divider()
                                
                                ForEach(coreDataModel.dataEventUpcoming.indices, id: \.self) { index in
//                                    NavigationLink(destination: HomeFlightSectionView()) {
                                        HStack {
                                            Text(renderItem(coreDataModel.dataEventUpcoming[index]))
                                                .font(.system(size: 15, weight: .regular))
                                                .foregroundColor(Color.black)
                                            
                                            Spacer()
                                            
                                            HStack {
                                                Text(coreDataModel.dataEventUpcoming[index].unwrappedName)
                                                    .font(.system(size: 15, weight: .regular))
                                                    .foregroundColor(Color.black)

                                                Image(systemName: "chevron.right")
                                                    .foregroundColor(Color.theme.arsenic.opacity(0.3))
                                                    .frame(width: 11, height: 22)
                                                    .scaledToFit()
                                                    .aspectRatio(contentMode: .fit)
                                            }
                                        }.id(UUID())
                                            .frame(height: 44)
                                            .padding(.horizontal)
                                            .contentShape(Rectangle())
                                            .onTapGesture {
                                                Task {
                                                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                                                    let currentEvent = coreDataModel.dataEventUpcoming[index]
                                                    
                                                    coreDataModel.selectedEvent = currentEvent
                                                    coreDataModel.isEventActive = true
                                                    
                                                    if let startDate = dateFormatter.date(from: currentEvent.unwrappedStartDate),
                                                       let endDate = dateFormatter.date(from: currentEvent.unwrappedEndDate) {
                                                        
                                                        dateFormatter.dateFormat = "HH:mm"
                                                        let startTime = dateFormatter.string(from: startDate)
                                                        let endTime = dateFormatter.string(from: endDate)
                                                        
                                                        let requestBody = [
                                                            "flight_number": currentEvent.unwrappedName,
                                                            "dep": currentEvent.unwrappedDep,
                                                            "arr": currentEvent.unwrappedDest,
                                                            "std": startTime,
                                                            "sta": endTime
                                                        ]
                                                        
//                                                        print("stat======\(requestBody)")
                                                        coreDataModel.loadingInitFuel = true

                                                        await coreDataModel.syncDataFlightStats(requestBody, callback: { success in
                                                            coreDataModel.loadingInitFuel = false
                                                        })
                                                    }
                                                }
                                               
                                            }
//                                    }
                                    
                                    if index + 1 < coreDataModel.dataEventUpcoming.count {
                                        Divider()
                                    }
                                }
                            }
                            
                            Group {
                                Text("COMPLETED")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(Color.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.top)
                                    .padding(.bottom, 8)
                                    .padding(.horizontal)
                                
                                
                                Divider()
                                
                                if coreDataModel.dataEventCompleted.count == 0 {
                                    HStack {
                                        Text("No flight plan completed")
                                            .font(.system(size: 15, weight: .regular))
                                            .foregroundColor(Color.black)
                                        Spacer()
                                    }.frame(height: 44)
                                    .padding(.horizontal)
                                } else {
                                    
                                    ForEach(coreDataModel.dataEventCompleted.indices, id: \.self) { index in
                                        HStack {
                                            Text(renderItemCompleted(coreDataModel.dataEventCompleted[index]))
                                                .font(.system(size: 15, weight: .regular))
                                                .foregroundColor(Color.black)
                                            
                                            Spacer()
                                            
                                            HStack {
                                                Text(coreDataModel.dataEventCompleted[index].unwrappedName)
                                                    .font(.system(size: 15, weight: .regular))
                                                    .foregroundColor(Color.black)

                                                Image(systemName: "chevron.right")
                                                    .foregroundColor(Color.theme.arsenic.opacity(0.3))
                                                    .frame(width: 11, height: 22)
                                                    .scaledToFit()
                                                    .aspectRatio(contentMode: .fit)
                                            }
//                                            Button(action: {
//                                                //TODO
//                                            }, label: {
//                                                Text("Report Submitted")
//                                                    .font(.system(size: 15, weight: .regular))
//                                                    .foregroundColor(Color.black)
//                                                    .padding(.vertical, 8)
//                                                    .padding(.horizontal)
//                                            }).background(Color.theme.tealDeer)
//                                                .cornerRadius(8)
//                                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 0))
//                                                .buttonStyle(PlainButtonStyle())
                                            
                                        }// End HStack
                                        .frame(height: 44)
                                        .padding(.horizontal)
                                        .onTapGesture {
                                            Task {
                                                if coreDataModel.dataEventCompleted.count > 0 {
                                                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                                                    let currentEvent = coreDataModel.dataEventCompleted[index]
                                                    
                                                    coreDataModel.selectedEvent = currentEvent
                                                    coreDataModel.isEventActive = true
                                                    
                                                    if let startDate = dateFormatter.date(from: currentEvent.unwrappedStartDate),
                                                       let endDate = dateFormatter.date(from: currentEvent.unwrappedEndDate) {
                                                        
                                                        dateFormatter.dateFormat = "HH:mm"
                                                        let startTime = dateFormatter.string(from: startDate)
                                                        let endTime = dateFormatter.string(from: endDate)
                                                        
                                                        let requestBody = [
                                                            "flight_number": currentEvent.unwrappedName,
                                                            "dep": currentEvent.unwrappedDep,
                                                            "arr": currentEvent.unwrappedDest,
                                                            "std": startTime,
                                                            "sta": endTime
                                                        ]
                                                        
                                                        coreDataModel.loadingInitFuel = true
                                                        
                                                        await coreDataModel.syncDataFlightStats(requestBody, callback: { success in
                                                            coreDataModel.loadingInitFuel = false
                                                        })
                                                    }
                                                }
                                            }
                                           
                                        }
                                        
                                        if index + 1 < coreDataModel.dataEventCompleted.count {
                                            Divider()
                                        }
                                    }
                                }
                            }
                            
                        }.frame(maxWidth: .infinity)
                            .padding(.bottom)
                        
                    }
                    
                } // End View
                .background(Color.white)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.theme.gainsboro, lineWidth: 0.5))
                
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        HStack(alignment: .center) {
                            Text("Expiring Soon").font(.system(size: 20, weight: .semibold)).foregroundStyle(Color.black)
                            
                            Button(action: {
                                self.isCollapseExpiring.toggle()
                            }, label: {
                                if isCollapseExpiring {
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
                            self.isCollapseExpiring.toggle()
                        }, label: {
                            Text("See All")
                                .font(.system(size: 17, weight: .regular)).textCase(nil)
                                .foregroundColor(Color.theme.azure)
                        }).buttonStyle(PlainButtonStyle())
                    }.contentShape(Rectangle())
                        .padding()
                    
                    if !isCollapseExpiring {
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(coreDataModel.dataExpiringSoon.indices, id: \.self) { index in
                                HStack(spacing: 0) {
                                    Text(coreDataModel.dataExpiringSoon[index].type)
                                        .font(.system(size: 15, weight: .regular))
                                        .foregroundColor(Color.black)
                                    
                                    Spacer()
                                    
                                    HStack {
                                        Text(coreDataModel.dataExpiringSoon[index].expiryDate)
                                            .font(.system(size: 15, weight: .regular))
                                            .foregroundColor(Color.black)
                                    }
                                }.frame(height: 44)
                                    .padding(.horizontal)
                                
                                if index + 1 < coreDataModel.dataExpiringSoon.count {
                                    Divider()
                                }
                            }
                        }.frame(maxWidth: .infinity)
                            .padding(.bottom)
                    }
                    
                }.background(Color.white)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.theme.gainsboro, lineWidth: 0.5))
                
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        HStack(alignment: .center) {
                            Text("Approaching Limitations").font(.system(size: 20, weight: .semibold)).foregroundStyle(Color.black)
                            
                            Button(action: {
                                self.isCollapseLimitations.toggle()
                            }, label: {
                                if isCollapseLimitations {
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
                            self.isCollapseLimitations.toggle()
                        }, label: {
                            Text("See All")
                                .font(.system(size: 17, weight: .regular)).textCase(nil)
                                .foregroundColor(Color.theme.azure)
                        }).buttonStyle(PlainButtonStyle())
                    }.contentShape(Rectangle())
                        .padding()
                    
                    if !isCollapseLimitations {
                        VStack(alignment: .leading) {
                            Grid(alignment: .topLeading) {
                                if dataLimitation.count == 0 {
                                    HStack {
                                        Text("No Limitation")
                                            .font(.system(size: 15, weight: .regular))
                                            .foregroundColor(Color.black)
                                        Spacer()
                                    }.padding(.horizontal)
                                    
                                } else {
                                    ForEach(dataLimitation.indices, id: \.self) { index in
                                        GridRow {
                                            Text(dataLimitation[index].text)
                                                .font(.system(size: 15, weight: .regular))
                                                .foregroundColor(Color.theme.coralRed1)
                                            
                                            Text(dataLimitation[index].period)
                                                .font(.system(size: 15, weight: .regular))
                                                .foregroundColor(Color.theme.coralRed1)
                                            
                                            Text(dataLimitation[index].status)
                                                .font(.system(size: 15, weight: .regular))
                                                .foregroundColor(Color.theme.coralRed1)
                                        }.padding(.vertical, 8)
                                            .padding(.horizontal)
                                            .frame(alignment: .leading)
                                        
                                        Divider()
                                    }
                                }
                            }
                        }.frame(maxWidth: .infinity)
                            .padding(.bottom)
                        
                    }
                    
                }.background(Color.white)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.theme.gainsboro, lineWidth: 0.5))
            }.padding(.leading, 8)
                .onAppear {
                    dataLimitation = checkLimitations(coreDataModel.dataLogbookEntries, coreDataModel.dataLogbookLimitation)
                }
        } // End VStack
        .background(
            NavigationLink(destination: HomeFlightSectionView(), isActive: $coreDataModel.isEventActive) { EmptyView() }
        )
    }
    
    func renderItem(_ item: EventList) -> String {
        let date = renderDate(item.unwrappedStartDate)
        let startTime = renderTime(item.unwrappedStartDate)
        let endTime = renderTime(item.unwrappedEndDate)
        
        return "\(date) \(item.dep ?? "")-\(item.dest ?? "") \(startTime)-\(endTime)"
    }
    
    func renderItemCompleted(_ item: EventList) -> String {
        let date = renderDate(item.unwrappedStartDate)
        
        return "\(date) \(item.dep ?? "")-\(item.dest ?? "") \(item.unwrappedName)"
    }
    
    func renderDate(_ date: String) -> String {
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm"
        if let temp = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "YY/MM/dd"
            return dateFormatter.string(from: temp)
        }

        return ""
    }
    
    func renderTime(_ date: String) -> String {
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm"
        if let temp = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: temp)
        }

        return ""
    }
}

struct HomeInformationView_Previews: PreviewProvider {
    static var previews: some View {
        HomeInformationView()
    }
}
