//
//  ExpiryRowView.swift
//  ATLAS
//
//  Created by phuong phan on 02/10/2023.
//

import SwiftUI

struct ExpiryRowView: View {
    @Binding var dataModel: [IProvideExpiry]
    let item: IProvideExpiry
    let width: CGFloat
    @State private var selectedType = ""
    @State private var txtRequirement = ""
    @State private var currentDocumentType = ""
    
    @State var currentDate = ""
    @State var showModal = false
    
    @State var pickerType = "date"
    @State private var currentIndex = -1
    let dateFormatterTime = DateFormatter()
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center, spacing: 8) {
                Button(action: {
                    dataModel.removeAll(where: {$0.id == item.id})
                }, label: {
                    Image(systemName: "minus.circle")
                        .foregroundColor(Color.theme.azure)
                        .font(.system(size: 22))
                }).buttonStyle(PlainButtonStyle())
                
                Text("Document Type").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.black)
                
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
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Expiry Date")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color.black)
                        .frame(width: calculateWidthSummary(width - 64, 2), alignment: .leading)
                    Text("Requirement (Optional)")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color.black)
                        .frame(width: calculateWidthSummary(width - 64, 2), alignment: .leading)
                }.frame(height: 44, alignment: .leading)
                
                HStack {
                    HStack(alignment: .center, spacing: 8) {
                        FlightTimeButtonTimeStepper(onToggle: onDate, value: currentDate)
                            .fixedSize()
                        Spacer()
                    }.frame(width: calculateWidthSummary(width - 64, 2))
                    HStack(alignment: .center, spacing: 8) {
                        TextField("Enter Requirement", text: $txtRequirement)
                            .onSubmit {
                                dataModel[currentIndex].requirement = txtRequirement
                            }
                    }.frame(width: calculateWidthSummary(width - 64, 2))
                }.frame(height: 44, alignment: .leading)
            }.frame(maxWidth: .infinity)
            
        }.padding()
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 0)
                    .foregroundColor(.white)
            )
            .onAppear {
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                if dataModel.count > 0 {
                    if let matchingIndex = dataModel.firstIndex(where: { $0.id == item.id }) {
                        self.currentIndex = matchingIndex
                        
                        if dataModel[matchingIndex].expiredDate != "" {
                            currentDate = dataModel[matchingIndex].expiredDate
                        } else {
                            currentDate = dateFormatter.string(from: Date())
                            dataModel[matchingIndex].expiredDate = currentDate
                        }
                        
                        if dataModel[currentIndex].documentType != "" {
                            currentDocumentType = dataModel[currentIndex].documentType
                        } else {
                            currentDocumentType = DataDocumentTypeDropdown.first ?? ""
                        }
                        
                        if dataModel[currentIndex].requirement != "" {
                            txtRequirement = dataModel[currentIndex].requirement
                        }
                    }
                }
            }
            .formSheet(isPresented: $showModal) {
                LimitationTimeModalView(isShowing: $showModal, pickerType: $pickerType, currentDate: $currentDate, header: "Expiry Date", onChange: onChangeCurrentDate).interactiveDismissDisabled(true)
            }
            .onChange(of: currentDocumentType) { newValue in
                dataModel[currentIndex].documentType = newValue
            }
    }
    
    func onChangeCurrentDate(_ value: String) {
        dataModel[currentIndex].expiredDate = value
    }
    
    func onDate() {
        self.showModal.toggle()
    }
}
