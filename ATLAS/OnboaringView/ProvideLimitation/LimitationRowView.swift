//
//  LimitationRowView.swift
//  ATLAS
//
//  Created by phuong phan on 02/10/2023.
//

import SwiftUI

struct LimitationRowView: View {
    @Binding var dataModel: [IProvideLimitation]
    let item: IProvideLimitation
    let width: CGFloat
    @State private var selectedLimitation = ""
    
    @State var currentLimitation = 0
    @State var minLimitation = 0
    @State var maxLimitation = 900
    
    @State var currentDuration = 0
    @State var minDuration = 0
    @State var maxDuration = 365
    
    @State var currentStartDate = ""
    @State var currentEndDate = ""
    
    @State var currentCompleted = 0
    @State var minCompleted = 0
    @State var maxCompleted = 900
    
    @State var showLimitationModal = false
    @State var showDurationModal = false
    @State var showStartDateModal = false
    @State var showEndDateModal = false
    @State var showCompletedModal = false
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
                
                Text("Limitation").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.black)
                
                HStack(spacing: 8) {
                    Picker("", selection: $selectedLimitation) {
                        ForEach(DataLimitationDropdown, id: \.self) {
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
                    Text("Limitation")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color.black)
                        .frame(width: calculateWidthSummary(width - 64, 5), alignment: .leading)
                    Text("Duration")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color.black)
                        .frame(width: calculateWidthSummary(width - 64, 5), alignment: .leading)
                    Text("Start Date")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color.black)
                        .frame(width: calculateWidthSummary(width - 64, 5), alignment: .leading)
                    Text("End Date")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color.black)
                        .frame(width: calculateWidthSummary(width - 64, 5), alignment: .leading)
                    Text("Completed")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color.black)
                        .frame(width: calculateWidthSummary(width - 64, 5), alignment: .leading)
                }.frame(height: 44, alignment: .leading)
                
                HStack {
                    HStack(alignment: .center, spacing: 8) {
                        FlightTimeButtonTimeStepper(onToggle: onLimitation, value: "\(currentLimitation)")
                            .fixedSize()
                        Text("Hours").font(.system(size: 15, weight: .regular)).foregroundColor(Color.black)
                        Spacer()
                    }.frame(width: calculateWidthSummary(width - 64, 5))
                    HStack(alignment: .center, spacing: 8) {
                        FlightTimeButtonTimeStepper(onToggle: onDuration, value: "\(currentDuration)")
                            .fixedSize()
                        Text("Days").font(.system(size: 15, weight: .regular)).foregroundColor(Color.black)
                        Spacer()
                    }.frame(width: calculateWidthSummary(width - 64, 5))
                    HStack {
                        FlightTimeButtonTimeStepper(onToggle: onStartDate, value: currentStartDate)
                            .fixedSize()
                        Spacer()
                    }.frame(width: calculateWidthSummary(width - 64, 5))
                    HStack {
                        FlightTimeButtonTimeStepper(onToggle: onEndDate, value: currentEndDate)
                            .fixedSize()
                        Spacer()
                    }.frame(width: calculateWidthSummary(width - 64, 5))
                    HStack(alignment: .center, spacing: 8) {
                        FlightTimeButtonTimeStepper(onToggle: onCompleted, value: "\(currentCompleted)")
                            .fixedSize()
                        Text("Hours").font(.system(size: 15, weight: .regular)).foregroundColor(Color.black)
                        Spacer()
                    }.frame(width: calculateWidthSummary(width - 64, 5))
                }.frame(height: 44, alignment: .leading)
            }.frame(maxWidth: .infinity)
            
        }.id(UUID())
            .padding()
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
                currentStartDate = dateFormatter.string(from: Date())
                currentEndDate = dateFormatter.string(from: Date())
            }
            .formSheet(isPresented: $showLimitationModal) {
                LimitationNumberModalView(isShowing: $showLimitationModal, currentNumber: $currentLimitation, header: "Limitation", minNumber: minLimitation, maxNumber: maxLimitation).interactiveDismissDisabled(true)
            }
            .formSheet(isPresented: $showDurationModal) {
                LimitationNumberModalView(isShowing: $showDurationModal, currentNumber: $currentDuration, header: "Duration", minNumber: minDuration, maxNumber: maxDuration).interactiveDismissDisabled(true)
            }
            .formSheet(isPresented: $showStartDateModal) {
                LimitationTimeModalView(isShowing: $showStartDateModal, pickerType: $pickerType, currentDate: $currentStartDate, header: "Start Date").interactiveDismissDisabled(true)
            }
            .formSheet(isPresented: $showEndDateModal) {
                LimitationTimeModalView(isShowing: $showEndDateModal, pickerType: $pickerType, currentDate: $currentEndDate, header: "End Date").interactiveDismissDisabled(true)
            }
            .formSheet(isPresented: $showCompletedModal) {
                LimitationNumberModalView(isShowing: $showCompletedModal, currentNumber: $currentCompleted, header: "Completed", minNumber: minCompleted, maxNumber: maxCompleted).interactiveDismissDisabled(true)
            }
    }
    
    func onLimitation() {
        self.showLimitationModal.toggle()
    }
    
    func onDuration() {
        self.showDurationModal.toggle()
    }
    
    func onStartDate() {
        self.showStartDateModal.toggle()
    }
    
    func onEndDate() {
        self.showEndDateModal.toggle()
    }
    
    func onCompleted() {
        self.showCompletedModal.toggle()
    }
}
