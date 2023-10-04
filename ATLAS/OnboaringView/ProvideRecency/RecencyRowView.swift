//
//  RecencyRowView.swift
//  ATLAS
//
//  Created by phuong phan on 02/10/2023.
//

import SwiftUI

struct RecencyRowView: View {
    @Binding var dataModel: [IProvideRecency]
    let item: IProvideRecency
    let width: CGFloat
    @State private var selectedRecency = ""
    
    @State var currentModel = ""
    
    @State var currentRequirement = "00"
    
    @State var currentFrequency = "00"
    
    @State var currentPeriodDate = ""
    
    @State var currentCompleted = "00"
    
    @State var showModelModal = false
    @State var showRequirementModal = false
    @State var showFrequencyModal = false
    @State var showPeriodDateModal = false
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
                
                Text("Type").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.black)
                
                HStack(spacing: 8) {
                    Picker("", selection: $selectedRecency) {
                        ForEach(DataRecencyDropdown, id: \.self) {
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
                    Text("Model")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color.black)
                        .frame(width: calculateWidthSummary(width - 64, 5), alignment: .leading)
                    Text("Requirement")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color.black)
                        .frame(width: calculateWidthSummary(width - 64, 5), alignment: .leading)
                    Text("Frequency")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color.black)
                        .frame(width: calculateWidthSummary(width - 64, 5), alignment: .leading)
                    Text("Current Period Start")
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
                        FlightTimeButtonTimeStepper(onToggle: onModel, value: currentModel)
                            .fixedSize()
                        Spacer()
                    }.frame(width: calculateWidthSummary(width - 64, 5))
                    HStack(alignment: .center, spacing: 8) {
                        FlightTimeButtonTimeStepper(onToggle: onRequirement, value: "\(currentRequirement)")
                            .fixedSize()
                        Text("Landings").font(.system(size: 15, weight: .regular)).foregroundColor(Color.black)
                        Spacer()
                    }.frame(width: calculateWidthSummary(width - 64, 5))
                    HStack(alignment: .center, spacing: 8) {
                        FlightTimeButtonTimeStepper(onToggle: onFrequency, value: "\(currentFrequency)")
                            .fixedSize()
                        Text("Days").font(.system(size: 15, weight: .regular)).foregroundColor(Color.black)
                        Spacer()
                    }.frame(width: calculateWidthSummary(width - 64, 5))
                    HStack {
                        FlightTimeButtonTimeStepper(onToggle: onPeriodDate, value: currentPeriodDate)
                            .fixedSize()
                        Spacer()
                    }.frame(width: calculateWidthSummary(width - 64, 5))
                    HStack(alignment: .center, spacing: 8) {
                        FlightTimeButtonTimeStepper(onToggle: onCompleted, value: "\(currentCompleted)")
                            .fixedSize()
                        Text("Landing").font(.system(size: 15, weight: .regular)).foregroundColor(Color.black)
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
                currentPeriodDate = dateFormatter.string(from: Date())
            }
            .formSheet(isPresented: $showModelModal) {
                RecencyModelView(isShowing: $showModelModal, currentItem: $currentModel, data: DataRecencyModelDropdown, header: "Model").interactiveDismissDisabled(true)
            }
            .formSheet(isPresented: $showRequirementModal) {
                LimitationNumberModalView(isShowing: $showRequirementModal, selectionInOut: $currentRequirement, header: "Requirement").interactiveDismissDisabled(true)
            }
            .formSheet(isPresented: $showFrequencyModal) {
                RecencyNumberModalView(isShowing: $showFrequencyModal, selectionInOut: $currentFrequency, header: "Frequency").interactiveDismissDisabled(true)
            }
            .formSheet(isPresented: $showPeriodDateModal) {
                LimitationTimeModalView(isShowing: $showPeriodDateModal, pickerType: $pickerType, currentDate: $currentPeriodDate, header: "Period Date").interactiveDismissDisabled(true)
            }
            .formSheet(isPresented: $showCompletedModal) {
                RecencyNumberModalView(isShowing: $showCompletedModal, selectionInOut: $currentCompleted, header: "Completed").interactiveDismissDisabled(true)
            }
    }
    
    func onModel() {
        self.showModelModal.toggle()
    }
    
    func onRequirement() {
        self.showRequirementModal.toggle()
    }
    
    func onFrequency() {
        self.showFrequencyModal.toggle()
    }
    
    func onPeriodDate() {
        self.showPeriodDateModal.toggle()
    }
    
    func onCompleted() {
        self.showCompletedModal.toggle()
    }
}
