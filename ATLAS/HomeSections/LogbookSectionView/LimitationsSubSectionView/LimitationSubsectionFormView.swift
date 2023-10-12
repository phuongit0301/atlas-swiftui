//
//  LimitationSubsectionFormView.swift
//  ATLAS
//
//  Created by phuong phan on 11/10/2023.
//

import SwiftUI

struct LimitationSubsectionFormView: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController
    
    @Binding var isShowing: Bool
    @Binding var isEdit: Bool
    @Binding var currentIndex: Int
    @State var itemList: [IProvideLimitation] = []
    
    let dateFormatter = DateFormatter()
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .center) {
                        Button(action: {
                            currentIndex = -1
                            isEdit = false
                            self.isShowing.toggle()
                        }) {
                            Text("Cancel").font(.system(size: 15, weight: .regular)).foregroundColor(Color.theme.azure)
                        }
                        
                        Spacer()
                        
                        if isEdit {
                            Text("Update Limitations").font(.system(size: 15, weight: .semibold)).foregroundColor(Color.black)
                        } else {
                            Text("Add Limitations").font(.system(size: 15, weight: .semibold)).foregroundColor(Color.black)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            updateOrCreate()
                            currentIndex = -1
                            isEdit = false
                            self.isShowing.toggle()
                        }) {
                            Text("Done").font(.system(size: 15, weight: .semibold)).foregroundColor(Color.theme.azure)
                        }
                    }.padding()
                        .background(.white)
                        .overlay(Rectangle().inset(by: 0.17).stroke(.black.opacity(0.3), lineWidth: 0.33))
                        .roundedCorner(12, corners: [.topLeft, .topRight])
                    
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("Update your limitation").font(.system(size: 20, weight: .regular)).foregroundColor(Color.black)
                            Spacer()
                            Button(action: {
                                let obj = IProvideLimitation(limitationFlight: "", limitation: "", duration: "", startDate: "", endDate: "", completed: "", isNew: true)
                                
                                itemList.append(obj)
                            }, label: {
                                Text("Add Item").font(.system(size: 15, weight: .regular)).foregroundColor(Color.theme.azure)
                            })
                        }.frame(height: 44)
                        
                        ForEach(itemList, id: \.self) { item in
                            LimitationRowView(dataModel: $itemList, item: item, width: proxy.size.width).padding(.bottom)
                        }
                        
                    }.padding(.horizontal)
                    
                    Spacer()
                }
                Spacer()
            }.background(Color.theme.antiFlashWhite)
        }.onAppear {
            if isEdit {
                let item = coreDataModel.dataLogbookLimitation[currentIndex]
                
                let obj = IProvideLimitation(limitationFlight: item.unwrappedType, limitation: item.unwrappedLimit, duration: item.unwrappedRequirement, startDate: item.unwrappedStart, endDate: item.unwrappedEnd, completed: item.unwrappedStatus, isNew: false)
                
                itemList.append(obj)
            }
        }
    }
    
    func updateOrCreate() {
        persistenceController.container.viewContext.performAndWait {
            if (itemList.count > 0) {
                for item in itemList {
                    if item.isNew {
                        let newObj = LogbookLimitationList(context: persistenceController.container.viewContext)
                        
                        newObj.id = UUID()
                        newObj.remoteId = UUID().uuidString
                        newObj.type = item.limitationFlight
                        newObj.requirement = item.duration
                        newObj.limit = item.limitation
                        newObj.start = item.startDate
                        newObj.end = item.endDate
                        newObj.text = "Max \(item.duration) \(item.limitationFlight) in \(item.limitation) days"
                        newObj.status = item.completed
                        newObj.colour = "black"
                        newObj.periodText = "\(item.startDate) to \(item.endDate)"
                        newObj.statusText = "\(item.completed) / \(item.limitation)"
                        coreDataModel.save()
                    } else {
                        let newObj = coreDataModel.dataLogbookLimitation[currentIndex]
                        newObj.type = item.limitationFlight
                        newObj.requirement = item.duration
                        newObj.limit = item.limitation
                        newObj.start = item.startDate
                        newObj.end = item.endDate
                        newObj.text = "Max \(item.duration) \(item.limitationFlight) in \(item.limitation) days"
                        newObj.status = item.completed
                        newObj.colour = "black"
                        newObj.periodText = "\(item.startDate) to \(item.endDate)"
                        newObj.statusText = "\(item.completed) / \(item.limitation)"
                        coreDataModel.save()
                    }
                }
            }
            
            coreDataModel.dataLogbookLimitation = coreDataModel.readDataLogbookLimitation()
        }
    }
}
