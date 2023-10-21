//
//  RowAlternates.swift
//  ATLAS
//
//  Created by phuong phan on 25/09/2023.
//

import SwiftUI
import UIKit

enum Focusable: Hashable {
  case none
  case row(id: String)
}

struct RowAlternates: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    
    let width: CGFloat
    let item: IAlternate
    @Binding var itemList: [IAlternate]
    @Binding var isRouteFormChange: Bool
    let create: () -> Void
    
    @State private var selectAltn = ""
    @State private var tfVis: String = ""
    @State private var tfMinima: String = ""
    
    @State private var tfRoute = ""
    @State private var listRoutes = [String]()
    
    // For ETA modal
    @State private var currentDateEta = Date()
    @State private var currentDateEtaTemp = Date()
    @State private var isShowModal = false
    @State private var currentIndex = -1
    
    @FocusState var focusedRoute: Focusable?
    
    let dateFormatter = DateFormatter()
    let columns = [GridItem(.flexible())]
    
    var body: some View {
        HStack {
            HStack(alignment: .center) {
                Button(action: {
                    itemList.removeAll(where: {$0.id == item.id})
                }, label: {
                    Image(systemName: "minus.circle")
                        .foregroundColor(Color.theme.azure)
                        .frame(width: 24, height: 24)
                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                }).padding(.trailing)
                
//                Picker("", selection: $selectAltn) {
//                    Text("Select ALTN").tag("")
//                    ForEach(ALTN_DROP_DOWN, id: \.self) {
//                        Text($0).tag($0)
//                    }
//                }.pickerStyle(MenuPickerStyle()).fixedSize()
//                    .padding(.leading, -12)
                
                    HStack {
                        TextField("Enter Route", text: $tfRoute)
                            .focused($focusedRoute, equals: .row(id: item.id.uuidString))
                            .onChange(of: tfRoute) {newValue in
                                if itemList[currentIndex].altn != newValue {
                                    listRoutes = AIRLINE_DROP_DOWN.filter {$0.lowercased().hasPrefix(newValue.lowercased())}
//                                    coreDataModel.listRoutes = listRoutes
                                    isRouteFormChange = true
                               }
                            }.frame(height: 44)
                        
                            if listRoutes.count > 0 {
                                ScrollView {
                                    VStack {
                                        ForEach(listRoutes.indices, id: \.self) { index in
                                            Text(listRoutes[index])
                                                .font(.system(size: 15, weight: .regular))
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .padding(8)
                                                .onTapGesture {
                                                    tfRoute = listRoutes[index]
                                                    if itemList.count > 0 {
                                                        isRouteFormChange = true
                                                        itemList[currentIndex].altn = listRoutes[index]
                                                        listRoutes = []
                                                    }
                                                }
                                            
                                            if index + 1 < listRoutes.count {
                                                Divider().padding(.horizontal, -8)
                                            }
                                        }
                                    }.background(Color.theme.antiFlashWhite)
                                        .cornerRadius(8)
                                }.frame(height: 200)
                                    .offset(x: -30, y: 50)
                                    .zIndex(50)
                            }
                }
            }.frame(width: calculateWidthSummary(width - 56, 4), alignment: .leading)
            
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
//            .onChange(of: selectAltn) {newValue in
//                if itemList.count > 0 {
//                    if itemList[currentIndex].altn != newValue {
//                        isRouteFormChange = true
//                    }
//
//                    itemList[currentIndex].altn = newValue
//                }
//            }
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
                    tfRoute = itemList[currentIndex].altn
                    tfVis = itemList[currentIndex].vis ?? ""
                    tfMinima = itemList[currentIndex].minima ?? ""
                    
                    if let eta = dateFormatter.date(from: itemList[currentIndex].eta) {
                        currentDateEta = eta
                        currentDateEtaTemp = eta
                    }
                }
                
            }
//            .onChange(of: focusedRoute) { newValue in
//                if Focusable.row(id: item.id.uuidString) != newValue {
//                    listRoutes = []
//                }
//            }
    }
    
    func onEta() {
        self.isShowModal.toggle()
    }
}
