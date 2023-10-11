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
    @State var itemList: [IProvideLimitation] = []
    
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
                        
                        Text("Add Limitations").font(.system(size: 15, weight: .semibold)).foregroundColor(Color.black)
                        
                        Spacer()
                        
                        Button(action: {
                            create()
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
                                let obj = IProvideLimitation(limitationFlight: "", limitation: "", duration: "", startDate: "", endDate: "", completed: "")
                                
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
        }
    }
    
    func create() {
        persistenceController.container.viewContext.performAndWait {
            if (itemList.count > 0) {
                //todo
            }
            
            coreDataModel.dataRecencyDocument = coreDataModel.readDataRecencyDocument()
        }
    }
}
