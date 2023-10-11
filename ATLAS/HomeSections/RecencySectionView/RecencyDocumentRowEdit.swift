//
//  RecencyDocumentRowEdit.swift
//  ATLAS
//
//  Created by phuong phan on 11/10/2023.
//

import SwiftUI
import UIKit

struct RecencyDocumentRowEdit: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    
    let width: CGFloat
    let item: RecencyDocumentList
    
    @Binding var itemList: [RecencyDocumentList]
    
    @State private var currentExpiredDate = Date()
    @State private var tfDocumentType = ""
    @State private var currentIndex = -1
    
    let dateFormatter = DateFormatter()
    
    var body: some View {
        HStack {
            HStack {
                TextField("Enter Document Type",text: $tfDocumentType)
                    .frame(alignment: .leading)
                    .onSubmit {
                        if itemList.count > 0 {
                            itemList[currentIndex].type = tfDocumentType
                            coreDataModel.save()
                        }
                    }
            }.frame(width: calculateWidthSummary(width - 32, 2), alignment: .leading)
            
            HStack {
                DatePicker("", selection: $currentExpiredDate, displayedComponents: [.date, .hourAndMinute]).labelsHidden().environment(\.locale, Locale(identifier: "en_GB"))
                Spacer()
            }.frame(width: calculateWidthSummary(width - 32, 2), alignment: .leading)
        }.frame(height: 44)
        .onAppear {
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            if let selectedIndex = itemList.firstIndex(of: item) {
                currentIndex = selectedIndex
                tfDocumentType = itemList[currentIndex].unwrappedType
                
                if let expiredDate = dateFormatter.date(from: itemList[currentIndex].unwrappedExpiredDate) {
                    currentExpiredDate = expiredDate
                }
            }
        }
        .onChange(of: currentExpiredDate) { newValue in
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            itemList[currentIndex].expiredDate = dateFormatter.string(from: newValue)
            coreDataModel.save()
        }
    }
}

