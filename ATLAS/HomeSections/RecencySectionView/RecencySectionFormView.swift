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
                        }
                    }.padding()
                        .background(.white)
                        .overlay(Rectangle().inset(by: 0.17).stroke(.black.opacity(0.3), lineWidth: 0.33))
                        .roundedCorner(12, corners: [.topLeft, .topRight])
                    
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("Update your recencies").font(.system(size: 20, weight: .regular)).foregroundColor(Color.black)
                            Spacer()
                            Button(action: {
                                let obj = IProvideRecency(type: "", modelName: "", requirement: "", frequency: "", periodStart: "", completed: "", isNew: true)
                                
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
                    let obj = IProvideRecency(type: item.unwrappedType, modelName: item.unwrappedModel, requirement: item.unwrappedRequirement, frequency: item.unwrappedLimit, periodStart: item.unwrappedPeriodStart, completed: item.unwrappedStatus)
                    
                    itemList.append(obj)
                }
            }
        }.onChange(of: isChanged) {_ in
            if coreDataModel.dataRecency.count > 0 {
                for item in coreDataModel.dataRecency {
                    let obj = IProvideRecency(type: item.unwrappedType, modelName: item.unwrappedModel, requirement: item.unwrappedRequirement, frequency: item.unwrappedLimit, periodStart: item.unwrappedPeriodStart, completed: item.unwrappedStatus)
                    
                    itemList.append(obj)
                }
            }
        }
    }
    
    func update() async {
        var payloadRecency = [Any]()
        
        for item in itemList {
            payloadRecency.append([
                "id": item.isNew ? UUID().uuidString : item.id,
                "type": item.type,
                "model": item.modelName,
                "requirement": item.requirement,
                "frequency": item.frequency,
                "periodStart": item.periodStart,
                "completed": item.completed
            ] as [String : Any])
        }
        
        var payloadVisa: [Any] = []
        for item in coreDataModel.dataRecencyDocument {
            payloadVisa.append([
                "expiryDate": item.unwrappedExpiredDate,
                "type": item.unwrappedType
            ])
        }
        
        var payloadExpiry: [Any] = []
        payloadExpiry.append(["id": "6e8456d1-6c70-4a3d-8c82-09e8398b091e",
                              "medical": "2024-02-29",
                              "sep": "2024-02-29",
                              "base_check": "2024-02-29",
                              "line_check": "2024-02-29",
                              "instructor_rating": "2024-02-29",
                              "examiner_rating": "2024-02-29",
                              "passport": "2024-02-29"
                          ])
        
        let payload: [String: Any] = [
            "user_id": userID,
            "recency_data": payloadRecency,
            "expiry_data": payloadExpiry,
            "visa_data": payloadVisa
        ]
        
        await remoteService.postRecencyData(payload)
        
        persistenceController.container.viewContext.performAndWait {
            if (itemList.count > 0) {
                for item in itemList {
                    if item.isNew {
                        let newObj = RecencyList(context: persistenceController.container.viewContext)
                        newObj.id = UUID()
                        newObj.limit = item.frequency
                        newObj.requirement = item.requirement
                        newObj.periodStart = item.periodStart
                        newObj.type = item.type
                        newObj.model = item.modelName
                        newObj.status = item.completed
                        newObj.text = "\(item.requirement) in \(item.frequency) days"
                        newObj.percentage = "\(((Double(item.completed) ?? 0) / (Double(item.requirement) ?? 0)))"
                        newObj.blueText = "\(item.completed)/\(item.requirement) in \(item.frequency) days"
                        coreDataModel.save()
                    } else {
                        if let currentIndex = coreDataModel.dataRecency.firstIndex(where: {$0.id == item.id}) {
                            coreDataModel.dataRecency[currentIndex].limit = item.frequency
                            coreDataModel.dataRecency[currentIndex].requirement = item.requirement
                            coreDataModel.dataRecency[currentIndex].periodStart = item.periodStart
                            coreDataModel.dataRecency[currentIndex].type = item.type
                            coreDataModel.dataRecency[currentIndex].model = item.modelName
                            coreDataModel.dataRecency[currentIndex].status = item.completed
                            coreDataModel.dataRecency[currentIndex].text = "\(item.requirement) in \(item.frequency) days"
                            coreDataModel.dataRecency[currentIndex].percentage = "0"
                            coreDataModel.dataRecency[currentIndex].blueText = "\(item.completed)/\(item.requirement) in \(item.frequency) days"
                            coreDataModel.save()
                        }
                        
                    }
                }
            }

            isChanged += 1
            itemList = []
            coreDataModel.dataRecency = coreDataModel.readDataRecency()
        }
    }
}
