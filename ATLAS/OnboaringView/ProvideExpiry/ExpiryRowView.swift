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
    
    @State var currentDate = ""
    @State var showModal = false
    
    @State var pickerType = "date"
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
                    Picker("", selection: $selectedType) {
                        ForEach(DataExpiryDropdown, id: \.self) {
                            Text($0).tag($0)
                        }
                    }.pickerStyle(MenuPickerStyle())
                }.frame(height: 44)
                    .padding(.horizontal)
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 1)
                            .foregroundColor(.white)
                        
                    )
                    .fixedSize(horizontal: false, vertical: true)
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
                currentDate = dateFormatter.string(from: Date())
            }
            .formSheet(isPresented: $showModal) {
                LimitationTimeModalView(isShowing: $showModal, pickerType: $pickerType, currentDate: $currentDate, header: "Expiry Date").interactiveDismissDisabled(true)
            }
            .keyboardAdaptive()
    }
    
    func onDate() {
        self.showModal.toggle()
    }
}
