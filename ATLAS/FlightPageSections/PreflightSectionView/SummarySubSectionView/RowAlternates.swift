//
//  RowAlternates.swift
//  ATLAS
//
//  Created by phuong phan on 25/09/2023.
//

import SwiftUI
import UIKit

struct RowAlternates: View {
    let width: CGFloat
    let item: IAlternate
    @Binding var itemList: [IAlternate]
    let create: () -> Void
    
    @State private var selectAltn = ""
    @State private var tfVis: String = ""
    @State private var tfMinima: String = ""
    
    // For ETA modal
    @State private var currentDateEta = Date()
    @State private var currentDateEtaTemp = Date()
    @State private var isShowModal = false
    @State private var currentIndex = -1
    
    let dateFormatter = DateFormatter()
    let columns = [GridItem(.flexible())]
    
    var body: some View {
        HStack {
            HStack {
                Button(action: {
                    print("itemList========\(itemList)")
                    print("item========\(item)")
                    itemList.removeAll(where: {$0.id == item.id})
                }, label: {
                    Image(systemName: "minus.circle")
                        .foregroundColor(Color.theme.azure)
                        .frame(width: 24, height: 24)
                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                }).padding(.trailing)
                
                Picker("", selection: $selectAltn) {
                    Text("Select ALTN").tag("")
//                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(ALTN_DROP_DOWN, id: \.self) {
                            Text($0).tag($0)
                        }
//                    }
                }.pickerStyle(MenuPickerStyle()).fixedSize()
                    .padding(.leading, -12)
            }.fixedSize()
                .frame(width: calculateWidthSummary(width - 56, 4), alignment: .leading)
            
            HStack {
                ButtonDateStepper(onToggle: onEta, value: $currentDateEta, suffix: "").fixedSize()
            }.frame(width: calculateWidthSummary(width - 56, 4), alignment: .leading)
            
            TextField("Enter VIS",text: $tfVis)
                .frame(width: calculateWidthSummary(width - 56, 4), alignment: .leading)
                .onSubmit {
                    if itemList.count > 0 {
                        itemList[currentIndex].vis = tfVis
                    }
                }
            
            TextField("Enter Minima",text: $tfMinima)
                .frame(width: calculateWidthSummary(width - 56, 4), alignment: .leading)
                .onSubmit {
                    if itemList.count > 0 {
                        itemList[currentIndex].minima = tfMinima
                    }
                }
            
        }.frame(height: 44)
            .onChange(of: selectAltn) {newValue in
                if itemList.count > 0 {
                    itemList[currentIndex].altn = newValue
                }
            }
            .formSheet(isPresented: $isShowModal) {
                VStack {
                    HStack(alignment: .center) {
                        Button(action: {
                            self.isShowModal.toggle()
                        }) {
                            Text("Cancel").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                        }
                        
                        Spacer()
                        
                        Text("ETA").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.black)
                        
                        Spacer()
                        Button(action: {
                            // assign value from modal to entries form
                            self.currentDateEta = currentDateEtaTemp
                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            
                            if itemList.count > 0 {
                                itemList[currentIndex].eta = dateFormatter.string(from: currentDateEtaTemp)
                            }
                            // Save data
                            //                            let dateFormatter = DateFormatter()
                            //                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            //                            let str = dateFormatter.string(from: currentDateEtaTemp)
                            //
                            //                            if coreDataModel.existDataArrivalEntries {
                            //                                coreDataModel.dataArrivalEntries.entLdg = str
                            //                            } else {
                            //                                let item = ArrivalEntriesList(context: persistenceController.container.viewContext)
                            //                                item.entLdg = dateFormatter.string(from: currentDateLandingTemp)
                            //                            }
                            //                            coreDataModel.save()
                            //                            coreDataModel.readArrivalEntries()
                            
                            self.isShowModal.toggle()
                        }) {
                            Text("Done").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                        }
                    }.padding()
                        .background(.white)
                        .roundedCorner(12, corners: [.topLeft, .topRight])
                    
                    Divider()
                    
                    VStack {
                        DatePicker("", selection: $currentDateEtaTemp, displayedComponents: [.date, .hourAndMinute]).labelsHidden().datePickerStyle(WheelDatePickerStyle())
                            .environment(\.locale, Locale(identifier: "en_GB"))
                    }
                    Spacer()
                }
            }.onAppear {
                if let selectedIndex = itemList.firstIndex(of: item) {
                    currentIndex = selectedIndex
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    selectAltn = itemList[currentIndex].altn
                    tfVis = itemList[currentIndex].vis ?? ""
                    tfMinima = itemList[currentIndex].minima ?? ""
                    
                    if let eta = dateFormatter.date(from: itemList[currentIndex].eta) {
                        currentDateEta = eta
                        currentDateEtaTemp = eta
                    }
                }
                
            }
    }
    
    func onEta() {
        self.isShowModal.toggle()
    }
}
