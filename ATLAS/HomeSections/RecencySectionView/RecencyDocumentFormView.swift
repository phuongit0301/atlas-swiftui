//
//  RecencyDocumentFormView.swift
//  ATLAS
//
//  Created by phuong phan on 11/10/2023.
//

import SwiftUI

struct IDocument: Identifiable, Hashable {
    var id = UUID()
    var type: String
    var expiredDate: String
    var requirement: String?
    var isNew: Bool?
    var isDeleted: Bool?
}

struct RecencyDocumentFormView: View {
    @AppStorage("uid") var userID: String = ""
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController
    @EnvironmentObject var remoteService: RemoteService
    
    @Binding var isShowing: Bool
    @State var isLoading: Bool = false
    @State var itemList: [IDocument] = []
    
    let dateFormatter = DateFormatter()
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .center) {
                        Button(action: {
                            self.isShowing.toggle()
                        }) {
                            Text("Cancel").font(.system(size: 15, weight: .regular)).foregroundColor(Color.theme.azure)
                        }
                        
                        Spacer()
                        
                        Text("Add Documents").font(.system(size: 15, weight: .semibold)).foregroundColor(Color.black)
                        
                        Spacer()
                        
                        Button(action: {
                            Task {
                                await create()
                            }
                        }) {
                            Text("Done").font(.system(size: 15, weight: .semibold)).foregroundColor(Color.theme.azure)
                        }.buttonStyle(PlainButtonStyle())
                            .disabled(isLoading)
                    }.padding()
                        .background(.white)
                        .overlay(Rectangle().inset(by: 0.17).stroke(.black.opacity(0.3), lineWidth: 0.33))
                        .roundedCorner(12, corners: [.topLeft, .topRight])
                    
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("Update your documents").font(.system(size: 20, weight: .regular)).foregroundColor(Color.black)
                            Spacer()
                            Button(action: {
                                dateFormatter.dateFormat = "yyyy-MM-dd"
                                itemList.append(IDocument(type: "", expiredDate: dateFormatter.string(from: Date()), isNew: true, isDeleted: false))
                            }, label: {
                                Text("Add Item").font(.system(size: 15, weight: .regular)).foregroundColor(Color.theme.azure)
                            })
                        }.padding(.horizontal)
                            .frame(height: 44)
                        
                        ForEach(itemList, id: \.self) { item in
                            if let isDeleted = item.isDeleted, !isDeleted {
                                RecencyDocumentRow(width: proxy.size.width, item: item, itemList: $itemList)
                            }
                        }
                        
                    }
                    
                    Spacer()
                }
                Spacer()
            }.background(Color.theme.antiFlashWhite)
        }
    }
    
    func create() async {
        isLoading = true
        coreDataModel.dataRecencyDocument = coreDataModel.readDataRecencyDocument()
        
        let payloadRecency = [Any]()
        
        let payloadVisa: [Any] = []
        
        var payloadExpiry: [String: Any] = [:]
                
        for item in itemList {
            let key = item.type.lowercased().replacingOccurrences(of: " ", with:
            "_")
            
            payloadExpiry.updateValue(item.expiredDate, forKey: key)
        }
        
        for item in coreDataModel.dataRecencyDocument {
            let key = item.unwrappedType.lowercased().replacingOccurrences(of: " ", with:
            "_")
            
            payloadExpiry.updateValue(item.unwrappedExpiredDate, forKey: key)
        }
        
        let payload: [String: Any] = [
            "user_id": userID,
            "recency_data": payloadRecency,
            "expiry_data": [payloadExpiry],
            "visa_data": payloadVisa
        ]
        
        print("payload=======\(payload)")
        await remoteService.postRecencyData(payload)
        
        persistenceController.container.viewContext.performAndWait {
            if (itemList.count > 0) {
                for item in itemList {
                    do {
                        let isNew = item.isNew ?? false
                        
                        if isNew {
                            if item.type != "" && item.expiredDate != "" {
                                let newObject = RecencyDocumentList(context: persistenceController.container.viewContext)
                                newObject.id = UUID()
                                newObject.type = item.type
                                newObject.expiredDate = item.expiredDate
                                newObject.requirement = item.requirement
                                
                                try persistenceController.container.viewContext.save()
                                print("saved Recency Document successfully")
                            }
                        } else {
                            let isDeleted = item.isDeleted ?? false
                            
                            if isDeleted {
                                if let newObject = coreDataModel.readDataRecencyDocumentById(item.id) {
                                    persistenceController.container.viewContext.delete(newObject)
                                    try persistenceController.container.viewContext.save()
                                }
                                
                            } else {
                                if let newObject = coreDataModel.readDataRecencyDocumentById(item.id) {
                                    newObject.type = item.type
                                    newObject.expiredDate = item.expiredDate
                                    newObject.requirement = item.requirement
                                    
                                    try persistenceController.container.viewContext.save()
                                }
                            }
                            
                        }
                    } catch {
                        print("Failed to Enroute save: \(error)")
                        // Rollback any changes in the managed object context
                        persistenceController.container.viewContext.rollback()
                    }
                }
            }
            
            isLoading = false
            isShowing.toggle()
            coreDataModel.dataRecency = coreDataModel.readDataRecency()
            coreDataModel.dataRecencyDocument = coreDataModel.readDataRecencyDocument()
            coreDataModel.dataExpiringSoon = coreDataModel.extractExpiringDocuments(expiryData: coreDataModel.dataRecencyDocument, monthsAhead: coreDataModel.monthsAhead)
        }
    }
}
