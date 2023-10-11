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
    @Binding var isRouteFormChange: Bool
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
                    if itemList[currentIndex].altn != newValue {
                        isRouteFormChange = true
                    }
                    
                    itemList[currentIndex].altn = newValue
                }
            }
            .formSheet(isPresented: $isShowModal) {
                GeometryReader { proxy in
                    VStack {
                        HStack(alignment: .center) {
                            Button(action: {
                                self.isShowModal.toggle()
                            }) {
                                Text("Cancel").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                            }.buttonStyle(PlainButtonStyle())
                                .contentShape(Rectangle())
                            
                            Spacer()
                            
                            Text("ETA").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.black)
                            
                            Spacer()
                            Button(action: {
                                // assign value from modal to entries form
                                self.currentDateEta = currentDateEtaTemp
                                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                                
                                if itemList.count > 0 {
                                    itemList[currentIndex].eta = dateFormatter.string(from: currentDateEtaTemp)
                                    isRouteFormChange = true
                                }
                                self.isShowModal.toggle()
                            }) {
                                Text("Done").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                            }.buttonStyle(PlainButtonStyle())
                                .contentShape(Rectangle())
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
                }
            }.onAppear {
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                if let selectedIndex = itemList.firstIndex(of: item) {
                    currentIndex = selectedIndex
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
