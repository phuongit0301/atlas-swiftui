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
    @State private var currentDocumentType = ""
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
                    
                    HStack(spacing: 8) {
                        Picker("", selection: $currentDocumentType) {
                            ForEach(DataDocumentTypeDropdown, id: \.self) {
                                Text($0).tag($0)
                            }
                        }.pickerStyle(MenuPickerStyle())
                        Spacer()
                    }.frame(height: 44)
                        .padding(.horizontal)
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(lineWidth: 1)
                                .foregroundColor(.white)
                            
                        )
                }.frame(height: 44)
                
                HStack {
                    Text("Expiry Date").font(.system(size: 15, weight: .medium)).foregroundColor(Color.black).frame(width: calculateWidthSummary(width - 32, 2), alignment: .leading)
                    
                    Text("Requirement (Optional)").font(.system(size: 15, weight: .medium)).foregroundColor(Color.black).frame(width: calculateWidthSummary(width - 32, 2), alignment: .leading)
                }.frame(height: 44)
                
                Divider().padding(.horizontal, -24)
                
                HStack {
                    HStack {
                        DatePicker("", selection: $currentExpiredDate, displayedComponents: [.date]).labelsHidden().environment(\.locale, Locale(identifier: "en_GB"))
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
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        itemList[currentIndex].expiredDate = dateFormatter.string(from: newValue)
                    }
                    .onChange(of: currentDocumentType) { newValue in
                        itemList[currentIndex].type = newValue
                    }
                    .onAppear {
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        if let selectedIndex = itemList.firstIndex(of: item) {
                            currentIndex = selectedIndex
//                            tfDocumentType = itemList[currentIndex].type
                            tfRequirement = itemList[currentIndex].requirement ?? ""
                            
                            if itemList[currentIndex].type != "" {
                                currentDocumentType = itemList[currentIndex].type
                            } else {
                                currentDocumentType = DataDocumentTypeDropdown.first ?? ""
                            }
                            
                            if let expiredDate = dateFormatter.date(from: itemList[currentIndex].expiredDate) {
                                currentExpiredDate = expiredDate
                            }
                        }
                    }
            Spacer()
        }.padding(.bottom)
    }
}

