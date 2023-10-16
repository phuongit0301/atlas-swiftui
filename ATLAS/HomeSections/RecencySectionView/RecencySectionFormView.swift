//
//  RecencySectionFormView.swift
//  ATLAS
//
//  Created by phuong phan on 14/10/2023.
//

import SwiftUI

struct RecencySectionFormView: View {
    @AppStorage("uid") var userID: String = ""
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var remoteService: RemoteService
    @EnvironmentObject var persistenceController: PersistenceController
    @Binding var isShowing: Bool
    @State private var itemList = [IProvideRecency]()
    
    @State var isEdit: Bool = false
    @State var isLoading = false
    @State var isChanged = 0
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .center) {
                        Button(action: {
                            isEdit = false
                            self.isShowing.toggle()
                        }) {
                            Text("Cancel").font(.system(size: 15, weight: .regular)).foregroundColor(Color.theme.azure)
                        }
                        
                        Spacer()
                        
                        Text("Update Recencies").font(.system(size: 15, weight: .semibold)).foregroundColor(Color.black)
                        
                        Spacer()
                        
                        Button(action: {
                            Task {
                                await update()
                                self.isShowing.toggle()
                            }
                        }) {
                            Text("Done").font(.system(size: 15, weight: .semibold)).foregroundColor(Color.theme.azure)
                        }.disabled(isLoading)
                    }.padding()
                        .background(.white)
                        .overlay(Rectangle().inset(by: 0.17).stroke(.black.opacity(0.3), lineWidth: 0.33))
                        .roundedCorner(12, corners: [.topLeft, .topRight])
                    
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("Update your recencies").font(.system(size: 20, weight: .regular)).foregroundColor(Color.black)
                            Spacer()
                            Button(action: {
                                let obj = IProvideRecency(remoteId: UUID().uuidString, type: "", modelName: "", requirement: "", frequency: "", periodStart: "", completed: "", isNew: true)
                                
                                itemList.append(obj)
                            }, label: {
                                Text("Add Item").font(.system(size: 15, weight: .regular)).foregroundColor(Color.theme.azure)
                            })
                        }.frame(height: 44)
                        
                        ForEach(itemList, id: \.self) { item in
                            RecencyRowView(dataModel: $itemList, item: item, width: proxy.size.width)
                        }
                        
                    }.padding(.horizontal)
                    
                    Spacer()
                }
                Spacer()
            }.background(Color.theme.antiFlashWhite)
        }.onAppear {
            if coreDataModel.dataRecency.count > 0 {
                for item in coreDataModel.dataRecency {
                    let obj = IProvideRecency(remoteId: item.unwrappedRemoteId, type: item.unwrappedType, modelName: item.unwrappedModel, requirement: item.unwrappedRequirement, frequency: item.unwrappedLimit, periodStart: item.unwrappedPeriodStart, completed: item.unwrappedStatus)
                    
                    itemList.append(obj)
                }
            }
        }.onChange(of: isChanged) {_ in
            if coreDataModel.dataRecency.count > 0 {
                for item in coreDataModel.dataRecency {
                    let obj = IProvideRecency(remoteId: item.unwrappedRemoteId, type: item.unwrappedType, modelName: item.unwrappedModel, requirement: item.unwrappedRequirement, frequency: item.unwrappedLimit, periodStart: item.unwrappedPeriodStart, completed: item.unwrappedStatus)
                    
                    itemList.append(obj)
                }
            }
        }
    }
    
    func update() async {
        isLoading = true
        var payloadRecency = [Any]()
        
        for item in itemList {
            payloadRecency.append([
                "id": item.remoteId,
                "recency_type": item.type,
                "recency_aircraft_model": item.modelName,
                "recency_requirement": item.requirement,
                "recency_limit": item.frequency,
                "recency_period_start": item.periodStart,
                "recency_status": item.completed
            ] as [String : Any])
        }
        
        var payloadVisa: [Any] = []
        for item in coreDataModel.dataRecencyDocument {
            if item.unwrappedType.lowercased().contains("visa") {
                payloadVisa.append([
                    "expiry": item.unwrappedExpiredDate,
                    "visa": item.unwrappedType.lowercased().replacingOccurrences(of: "visa", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                ])
            }
        }
        
        var payloadExpiry: [Any] = []
        for item in coreDataModel.dataRecencyDocument {
            var temp = [String: Any]()
            let key = item.unwrappedType.lowercased().replacingOccurrences(of: " ", with:
            "_")
            
            temp[key] = item.unwrappedExpiredDate
            
            payloadExpiry.append(temp)
        }
        
        let payload: [String: Any] = [
            "user_id": userID,
            "recency_data": payloadRecency,
            "expiry_data": payloadExpiry,
            "visa_data": payloadVisa
        ]
        
        print("payload=======\(payload)")
        await remoteService.postRecencyData(payload)
        let response = await remoteService.getRecencyData()

        if let recencyData = response?.recency_data, recencyData.count > 0 {
            await coreDataModel.deleteAllRecencyList()
            coreDataModel.dataRecency = []
            coreDataModel.initDataRecency(recencyData)
        }

        isChanged += 1
        itemList = []
        isLoading = false
        coreDataModel.dataRecency = coreDataModel.readDataRecency()
    }
}
