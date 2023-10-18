//
//  MapAirportCardView.swift
//  ATLAS
//
//  Created by phuong phan on 14/09/2023.
//

import SwiftUI
import MapKit

struct MapAirportCardView: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController
    @EnvironmentObject var mapIconModel: MapIconModel
    @StateObject var notamSection = NotamSection()
    
    @State var parentIndex: Int = 0
    //For picker
    @State private var selectionCategory = ""
    //For collpase and expand
    @State private var isShow = true
    @State private var isShowNotam = true
    @State private var isShowMetar = true
    @State private var dataFlightOverview: FlightOverviewList?
    @State var dataNotams: [NotamsDataList] = []
    let dateFormmater = DateFormatter()
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text(self.mapIconModel.titleModal).foregroundColor(.black).font(.system(size: 15, weight: .semibold))
                    Text("Last Update: \(renderTitle())").foregroundColor(.black).font(.system(size: 15, weight: .regular))
                    
                    Spacer()
                    
                    Button(action: {
                        self.mapIconModel.showModal.toggle()
                    }) {
                        Text("Done").foregroundColor(Color.theme.azure).font(.system(size: 17, weight: .regular))
                    }
                }.padding()
                .background(.white)
                .roundedCorner(12, corners: [.topLeft, .topRight])
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        VStack(spacing: 8) {
                            VStack {
                                HStack(alignment: .center) {
                                    Text("Average Delays").foregroundStyle(Color.black).font(.system(size: 15, weight: .semibold))
                                    
                                    Button(action: {
                                        isShow.toggle()
                                    }, label: {
                                        if isShow {
                                            Image(systemName: "chevron.down")
                                                .foregroundColor(Color.theme.azure)
                                                .scaledToFit()
                                                .aspectRatio(contentMode: .fit)
                                        } else {
                                            Image(systemName: "chevron.up")
                                                .foregroundColor(Color.theme.azure)
                                                .scaledToFit()
                                                .aspectRatio(contentMode: .fit)
                                        }
                                    })
                                    Spacer()
                                    
                                }.frame(height: 44)
                                
                                if isShow {
                                    HStack(alignment: .center, spacing: 8) {
                                        HStack {
                                            VStack(alignment: .leading, spacing: 8) {
                                                Text("Arrival").font(.system(size: 11, weight: .regular)).foregroundColor(Color.black)
                                                Text("\(mapIconModel.airportSelected?.unwrappedArrDelay ?? "0") min").font(.system(size: 17, weight: .regular)).foregroundColor(Color.black)
                                            }
                                            
                                            Spacer()
                                        }.padding(8)
                                            .frame(alignment: .leading)
                                            .frame(maxWidth: .infinity)
                                            .background(renderBackground(mapIconModel.airportSelected?.unwrappedArrDelayColour ?? ""))
                                            .cornerRadius(8)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(lineWidth: 0)
                                                    .foregroundColor(Color.theme.ufoGreen)
                                                
                                            )
                                        
                                        HStack {
                                            VStack(alignment: .leading, spacing: 8) {
                                                Text("Departure").font(.system(size: 11, weight: .regular)).foregroundColor(Color.black)
                                                Text("\(mapIconModel.airportSelected?.unwrappedDepDelay ?? "0") min").font(.system(size: 17, weight: .regular)).foregroundColor(Color.black)
                                            }
                                            Spacer()
                                        }.padding(8)
                                            .frame(alignment: .leading)
                                            .frame(maxWidth: .infinity)
                                            .background(renderBackground(mapIconModel.airportSelected?.unwrappedDepDelayColour ?? ""))
                                            .cornerRadius(8)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(lineWidth: 0)
                                                    .foregroundColor(Color.theme.tangerineYellow)
                                                
                                            )
                                        
                                    }.padding(.bottom, 16)
                                }
                            }.padding(.horizontal, 8)
                                .background(Color.white)
                                .cornerRadius(8)
                            
                            VStack {
                                HStack(alignment: .center, spacing: 8) {
                                    Text("Saved NOTAMs").font(.system(size: 15, weight: .semibold)).foregroundColor(Color.black)
                                        .frame(height: 44)
                                    
                                    Button(action: {
                                        isShowNotam.toggle()
                                    }, label: {
                                        if isShowNotam {
                                            Image(systemName: "chevron.down")
                                                .foregroundColor(Color.theme.azure)
                                                .scaledToFit()
                                                .aspectRatio(contentMode: .fit)
                                        } else {
                                            Image(systemName: "chevron.up")
                                                .foregroundColor(Color.theme.azure)
                                                .scaledToFit()
                                                .aspectRatio(contentMode: .fit)
                                        }
                                    })
                                    
                                    Spacer()
                                }.frame(height: 44)
                                
                                if isShowNotam {
                                    if dataNotams.count == 0 {
                                        HStack {
                                            Text("No NOTAMs saved").foregroundColor(Color.theme.philippineGray2).font(.system(size: 17, weight: .regular))
                                            Spacer()
                                        }.frame(height: 44)
                                    } else {
                                        VStack(spacing: 8) {
                                            ForEach(dataNotams.indices, id: \.self) {index in
                                                HStack {
                                                    Text(dataNotams[index].unwrappedNotam).font(.system(size: 15, weight: .regular)).foregroundColor(Color.black)
                                                    
                                                    Spacer()
                                                    
                                                    Button(action: {
                                                        dataNotams[index].isChecked.toggle()
                                                        coreDataModel.save()
                                                        
                                                        coreDataModel.dataNotams = coreDataModel.readDataNotamsList()
                                                        coreDataModel.dataNotamsRef = coreDataModel.readDataNotamsRefList()
                                                        coreDataModel.dataEnrouteNotamsRef = coreDataModel.readDataNotamsByType("enrNotams")
                                                        coreDataModel.dataDestinationNotamsRef = coreDataModel.readDataNotamsByType("destNotams")
                                                        
                                                        if let notamsDataList = coreDataModel.selectedEvent?.notamsDataList?.allObjects as? [NotamsDataList] {
                                                            var temp: [NotamsDataList] = []
                                                            for item in notamsDataList {
                                                                if item.isChecked {
                                                                    temp.append(item)
                                                                }
                                                            }
                                                            
                                                            dataNotams = temp
                                                        }
                                                    }, label: {
                                                        Image(systemName: "star.fill")
                                                            .foregroundColor(Color.theme.azure)
                                                            .font(.system(size: 18))
                                                    })
                                                    
                                                }.id(UUID())
                                                
                                                if index + 1 < dataNotams.count {
                                                    Divider().padding(.horizontal, -16)
                                                }
                                            }
                                        }.padding(.bottom, 16)
                                    }
                                    
                                }
                            }.padding(.horizontal, 8)
                                .background(Color.white)
                                .cornerRadius(8)
                            
                            
                            VStack {
                                HStack(spacing: 8) {
                                    Text("METAR & TAF").font(.system(size: 15, weight: .semibold)).foregroundColor(Color.black)
                                        .frame(height: 44)
                                    
                                    Button(action: {
                                        isShowMetar.toggle()
                                    }, label: {
                                        if isShowMetar {
                                            Image(systemName: "chevron.down")
                                                .foregroundColor(Color.theme.azure)
                                                .scaledToFit()
                                                .aspectRatio(contentMode: .fit)
                                        } else {
                                            Image(systemName: "chevron.up")
                                                .foregroundColor(Color.theme.azure)
                                                .scaledToFit()
                                                .aspectRatio(contentMode: .fit)
                                        }
                                    })
                                    
                                    Spacer()
                                }.frame(height: 44)
                                
                                if isShowMetar {
                                    VStack(spacing: 8) {
                                        VStack(alignment: .leading) {
                                            HStack {
                                                Text("METAR").font(.system(size: 15, weight: .semibold)).foregroundColor(Color.black)
                                                
                                                Spacer()
                                            }.frame(height: 44)
                                            
                                            Divider().padding(.horizontal, -16)
                                            
                                            if mapIconModel.airportSelected?.unwrappedMetar == "" {
                                                HStack {
                                                    Text("No METAR saved").foregroundColor(Color.theme.philippineGray2).font(.system(size: 17, weight: .regular))
                                                    Spacer()
                                                }.frame(height: 44)
                                            } else {
                                                HStack {
                                                    Text(mapIconModel.airportSelected?.unwrappedMetar ?? "").font(.system(size: 15, weight: .regular)).foregroundColor(Color.black)
                                                }.padding(.vertical, 8)
                                            }
                                        }
                                        
                                        VStack(alignment: .leading) {
                                            HStack {
                                                Text("TAF").font(.system(size: 15, weight: .semibold)).foregroundColor(Color.black)
                                                
                                                Spacer()
                                            }.frame(height: 44)
                                                
                                            Divider().padding(.horizontal, -16)
                                            if mapIconModel.airportSelected?.unwrappedTaf == "" {
                                                HStack {
                                                    Text("No TAF saved").foregroundColor(Color.theme.philippineGray2).font(.system(size: 17, weight: .regular))
                                                    Spacer()
                                                }.frame(height: 44)
                                            } else {
                                                HStack {
                                                    Text(mapIconModel.airportSelected?.unwrappedTaf ?? "").font(.system(size: 15, weight: .regular)).foregroundColor(Color.black)
                                                }.padding(.vertical, 8)
                                            }
                                        }
                                    }
                                }
                            }.padding(.horizontal, 8)
                                .padding(.bottom, 8)
                                .background(Color.white)
                                .cornerRadius(8)
                        }
                        
                        Spacer()
                    }.padding()
                }
            }
            Spacer()
        }.background(Color.theme.antiFlashWhite)
            .onAppear {
                prepareData()
            }
        
    }
    
    func prepareData() {
        if let notamsDataList = coreDataModel.selectedEvent?.notamsDataList?.allObjects as? [NotamsDataList] {
            print("notamsDataList===========\(notamsDataList)")
            
            for item in notamsDataList {
                if item.isChecked && item.unwrappedAirport == self.mapIconModel.titleModal {
                    dataNotams.append(item)
                }
            }
        }
    }

    func renderBackground(_ airportColor: String) -> Color {
        if airportColor != "" {
            if airportColor == "blue" {
                return Color.theme.aeroBlue
            } else if airportColor == "amber" {
                return Color.theme.vividGamboge
            } else {
                return Color.theme.ufoGreen
            }
        }
        return Color.theme.ufoGreen
    }
    
    func renderTitle() -> String {
        dateFormmater.dateFormat = "yyyy-MM-dd HH:mm"
        
        let toDate = Date()
        
        if let updatedAt = mapIconModel.airportSelected?.unwrappedUpdatedAt, let fromDate = dateFormmater.date(from: updatedAt) {
            let delta = Calendar.current.dateComponents([.hour, .minute], from: fromDate, to: toDate)
            return  "\(String(format: "%02d", delta.hour ?? 0)) hrs \(String(format: "%02d", delta.minute ?? 0)) mins ago"
        }
        return ""
    }
}
