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
    let index: Int
    @Binding var itemList: [IAlternate]
    let create: () -> Void
    let removeItem: (_ index: Int) -> Void
    
    @State private var selectAltn = ""
    @State private var tfVis: String = ""
    @State private var tfMinima: String = ""
    
    // For ETA modal
    @State private var currentDateEta = Date()
    @State private var currentDateEtaTemp = Date()
    @State private var isShowModal = false
    
    var ALTN_DROP_DOWN: [String] = ["ALTN 1", "ALTN 2", "ALTN 3"]
    let dateFormatter = DateFormatter()
    
    var body: some View {
        HStack {
            HStack {
                Button(action: {
                    removeItem(index)
                }, label: {
                    Image(systemName: "minus.circle")
                        .foregroundColor(Color.theme.azure)
                        .frame(width: 24, height: 24)
                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                }).padding(.trailing)
                
                Picker("", selection: $selectAltn) {
                    Text("Select ALTN").tag("")
                    ForEach(ALTN_DROP_DOWN, id: \.self) {
                        Text($0).tag($0)
                    }
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
                        itemList[index].vis = tfVis
                    }
                }
            
            TextField("Enter Minima",text: $tfMinima)
                .frame(width: calculateWidthSummary(width - 56, 4), alignment: .leading)
                .onSubmit {
                    if itemList.count > 0 {
                        itemList[index].minima = tfMinima
                    }
                }
            
        }.frame(height: 44)
            .onChange(of: selectAltn) {newValue in
                if itemList.count > 0 {
                    itemList[index].altn = newValue
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
                                itemList[index].eta = dateFormatter.string(from: currentDateEtaTemp)
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
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                selectAltn = itemList[index].altn
                tfVis = itemList[index].vis ?? ""
                tfMinima = itemList[index].minima ?? ""
                
                if let eta = dateFormatter.date(from: itemList[index].eta) {
                    currentDateEta = eta
                    currentDateEtaTemp = eta
                }
            }
    }
    
    func onEta() {
        self.isShowModal.toggle()
    }
}
