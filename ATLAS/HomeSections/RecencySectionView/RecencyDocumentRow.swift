//
//  RecencyDocumentRow.swift
//  ATLAS
//
//  Created by phuong phan on 11/10/2023.
//

import SwiftUI
import UIKit

struct RecencyDocumentRow: View {
    let width: CGFloat
    let item: IDocument
    
    @Binding var itemList: [IDocument]
    
    @State private var currentExpiredDate = Date()
    @State private var tfDocumentType = ""
    @State private var tfRequirement = ""
    @State private var currentIndex = -1
    
    let dateFormatter = DateFormatter()
    
    var body: some View {
        VStack {
            VStack {
                HStack(spacing: 16) {
                    Button(action: {
                        let isNew = item.isNew ?? false
                        if isNew {
                            itemList.removeAll(where: {$0.id == item.id})
                        } else {
                            itemList[currentIndex].isDeleted = true
                        }
                    }, label: {
                        Image(systemName: "minus.circle").font(.system(size: 24)).foregroundColor(Color.theme.azure)
                    })
                    
                    Text("Document Type").font(.system(size: 15, weight: .semibold)).foregroundColor(Color.black)
                    
                    TextField("Enter Document Type",text: $tfDocumentType)
                        .frame(alignment: .leading)
                        .onSubmit {
                            if itemList.count > 0 {
                                itemList[currentIndex].type = tfDocumentType
                                
                            }
                        }
                }.frame(height: 44)
                
                HStack {
                    Text("Expiry Date").font(.system(size: 15, weight: .medium)).foregroundColor(Color.black).frame(width: calculateWidthSummary(width - 32, 2), alignment: .leading)
                    
                    Text("Requirement (Optional)").font(.system(size: 15, weight: .medium)).foregroundColor(Color.black).frame(width: calculateWidthSummary(width - 32, 2), alignment: .leading)
                }.frame(height: 44)
                
                Divider().padding(.horizontal, -24)
                
                HStack {
                    HStack {
                        DatePicker("", selection: $currentExpiredDate, displayedComponents: [.date, .hourAndMinute]).labelsHidden().environment(\.locale, Locale(identifier: "en_GB"))
                    }.frame(width: calculateWidthSummary(width - 32, 2), alignment: .leading)
                    
                    HStack {
                        TextField("Enter Requirement",text: $tfRequirement)
                            .frame(width: calculateWidthSummary(width - 56, 4), alignment: .leading)
                            .onSubmit {
                                if itemList.count > 0 {
                                    itemList[currentIndex].requirement = tfRequirement
                                }
                            }
                    }.frame(width: calculateWidthSummary(width - 32, 2), alignment: .leading)
                }.frame(height: 44)
                
            }.padding(8)
                .background(Color.white)
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .onChange(of: currentExpiredDate) { newValue in
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                        itemList[currentIndex].expiredDate = dateFormatter.string(from: newValue)
                    }
                    .onAppear {
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                        if let selectedIndex = itemList.firstIndex(of: item) {
                            currentIndex = selectedIndex
                            tfDocumentType = itemList[currentIndex].type
                            tfRequirement = itemList[currentIndex].requirement ?? ""
                            
                            if let expiredDate = dateFormatter.date(from: itemList[currentIndex].expiredDate) {
                                currentExpiredDate = expiredDate
                            }
                        }
                    }
            Spacer()
        }.padding(.bottom)
    }
}

