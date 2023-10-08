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
    
    @State var arrNotams = [NotamsDataList]()
    @State var parentIndex: Int = 0
    //For picker
    @State private var selectionCategory = ""
    //For collpase and expand
    @State private var isShow = true
    
    let redWords: [String] = ["TEMPO", "RA", "SHRA", "RESHRA", "-SHRA", "+SHRA", "TS", "TSRA", "-TSRA", "+TSRA", "RETS"]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {

            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Button(action: {
                        self.mapIconModel.showModal.toggle()
                    }) {
                        Text("Cancel").foregroundColor(Color.theme.azure).font(.system(size: 17, weight: .regular))
                    }
                    
                    Spacer()
                    
                    Text(self.mapIconModel.titleModal).foregroundColor(.black).font(.system(size: 17, weight: .semibold))
                    
                    Spacer()
                    
                    Button(action: {
                        self.mapIconModel.showModal.toggle()
                    }) {
                        Text("Done").foregroundColor(Color.theme.azure).font(.system(size: 17, weight: .regular))
                    }
                }
                .padding()
                .background(.white)
                
                VStack {
                    VStack(spacing: 0) {
                        HStack(alignment: .center, spacing: 0) {
                            HStack {
                                Text("NOTAMS").foregroundStyle(Color.black).font(.system(size: 15, weight: .semibold))
                                
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
                                
                                Spacer().frame(maxWidth: .infinity)
                            }.contentShape(Rectangle())
                                .onTapGesture {
                                    self.isShow.toggle()
                                }
                            
                            HStack {
                                Picker("", selection: $selectionCategory) {
                                    ForEach(notamSection.dataDropDown, id: \.self) {
                                        Text($0).tag($0)
                                    }
                                }
                            }.fixedSize()
                        }.padding(.vertical)
                            
                        if isShow {
                            Divider().padding(.horizontal, -16)
                            
                            ForEach(arrNotams, id: \.id) { item in
                                HStack(alignment: .center, spacing: 0) {
                                    // notam text
                                    Text(item.unwrappedNotam)
                                        .font(.system(size: 17, weight: .regular))
                                    Spacer()
                                    // star function to add to reference
                                    Button(action: {
                                        item.isChecked.toggle()
                                        coreDataModel.save()
                                        coreDataModel.dataNotams = coreDataModel.readDataNotamsList()
                                        coreDataModel.dataNotamsRef = coreDataModel.readDataNotamsRefList()
                                        arrNotams.removeAll(where: {$0.id == item.id})
                                    }) {
                                        if item.isChecked {
                                            Image(systemName: "star.fill").foregroundColor(Color.theme.azure)
                                        } else {
                                            Image(systemName: "star").foregroundColor(Color.theme.azure)
                                        }
                                    }.fixedSize()
                                        .buttonStyle(PlainButtonStyle())
                                }.padding(.vertical)
                                
                                Divider().padding(.horizontal, -16)
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("METAR / TAF").font(.system(size: 15, weight: .semibold)).foregroundStyle(Color.black)
                        
                        Divider().padding(.horizontal, -16)
                        
                        HStack {
//                            NewFlowLayout(alignment: .leading) {
//                                ForEach(coreDataModel.dataMetarTaf.unwrappedMetar.components(separatedBy: " "), id: \.self) { word in
//                                    if redWords.contains(word) {
//                                        Text(word)
//                                            .font(.system(size: 17, weight: .regular))
//                                            .foregroundColor(.red)
//                                    } else if let number = Int(word), number < 3000 {
//                                        Text(word)
//                                            .font(.system(size: 17, weight: .regular))
//                                            .foregroundColor(.red)
//                                    } else if word.range(of: #"^\d{3}$"#, options: .regularExpression) != nil {
//                                        Text(word)
//                                            .font(.system(size: 17, weight: .regular))
//                                            .foregroundColor(.green)
//                                    } else if word.range(of: #"\d+KT"#, options: .regularExpression) != nil || word.range(of: #"^\d{4}$"#, options: .regularExpression) != nil {
//                                        Text(word)
//                                            .font(.system(size: 17, weight: .regular))
//                                            .foregroundColor(.green)
//                                    } else {
//                                        Text(word).font(.system(size: 17, weight: .regular))
//                                    }
//                                }
//                            }
                            
                        }.frame(maxWidth: .infinity, alignment: .leading)
                        
                        Divider().padding(.horizontal, -16)
                        
                        HStack {
//                            NewFlowLayout(alignment: .leading) {
//                                ForEach(coreDataModel.dataMetarTaf.unwrappedTaf.components(separatedBy: " "), id: \.self) { word in
//                                    if redWords.contains(word) {
//                                        Text(word)
//                                            .font(.system(size: 17, weight: .regular))
//                                            .foregroundColor(.red)
//                                    } else if let number = Int(word), number < 3000 {
//                                        Text(word)
//                                            .font(.system(size: 17, weight: .regular))
//                                            .foregroundColor(.red)
//                                    } else if word.range(of: #"^\d{3}$"#, options: .regularExpression) != nil {
//                                        Text(word)
//                                            .font(.system(size: 17, weight: .regular))
//                                            .foregroundColor(.green)
//                                    } else if word.range(of: #"\d+KT"#, options: .regularExpression) != nil || word.range(of: #"^\d{4}$"#, options: .regularExpression) != nil {
//                                        Text(word)
//                                            .font(.system(size: 17, weight: .regular))
//                                            .foregroundColor(.green)
//                                    } else {
//                                        Text(word).font(.system(size: 17, weight: .regular))
//                                    }
//                                }
//                            }
                        }.frame(maxWidth: .infinity, alignment: .leading)
                        
                    }
                }.padding()
            }
        }
        .onAppear {
            var temp = [NotamsDataList]()
            selectionCategory = notamSection.dataDropDown.first ?? ""
            
            coreDataModel.dataNotamsRef.forEach { item in
                let category = item.category ?? ""
                
                if category == selectionCategory  {
                    temp.append(item)
                }
            }
            arrNotams = temp
        }
        .onChange(of: selectionCategory) { newValue in
            var temp = [NotamsDataList]()
            coreDataModel.dataNotamsRef.forEach { item in
                let category = item.category ?? ""
                
                if category == selectionCategory  {
                    temp.append(item)
                }
            }
            arrNotams = temp
        }
    }
    

}
