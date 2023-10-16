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
    @State private var selectedType = ""
    
    @State var currentModel = ""
    
    @State var currentRequirement = "0"
    
    @State var currentFrequency = "0"
    
    @State var currentPeriodDate = ""
    
    @State var currentCompleted = "0"
    
    @State var showModelModal = false
    @State var showRequirementModal = false
    @State var showFrequencyModal = false
    @State var showPeriodDateModal = false
    @State var showCompletedModal = false
    
    @State private var currentIndex = -1
    
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
                    Picker("", selection: $selectedType) {
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
                HStack(spacing: 10) {
                    Text("Model")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color.black)
                        .frame(width: 100, alignment: .leading)
                    Text("Requirement")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color.black)
                        .frame(width: calculateWidthSummary(width - 54, 5), alignment: .leading)
                    Text("Frequency")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color.black)
                        .frame(width: calculateWidthSummary(width - 44, 5), alignment: .leading)
                    Text("Current Period Start")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color.black)
                        .frame(width: calculateWidthSummary(width - 54, 5), alignment: .leading)
                    Text("Completed")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color.black)
                        .frame(width: calculateWidthSummary(width - 54, 5), alignment: .leading)
                }.frame(height: 44, alignment: .leading)
                
                HStack(spacing: 10) {
                    HStack(alignment: .center, spacing: 8) {
                        Picker("", selection: $currentModel) {
                            ForEach(DataModelDropdown, id: \.self) {
                                Text($0).tag($0)
                            }
                        }.pickerStyle(MenuPickerStyle())
                        Spacer()
                    }.frame(width: 100)
                    HStack(alignment: .center, spacing: 8) {
                        FlightTimeButtonTimeStepper(onToggle: onRequirement, value: "\(currentRequirement)")
                            .fixedSize()
                        Text("Landings").font(.system(size: 15, weight: .regular)).foregroundColor(Color.black)
                        Spacer()
                    }.frame(width: calculateWidthSummary(width - 44, 5))
                    HStack(alignment: .center, spacing: 8) {
                        FlightTimeButtonTimeStepper(onToggle: onFrequency, value: "\(currentFrequency)")
                            .fixedSize()
                        Text("Days").font(.system(size: 15, weight: .regular)).foregroundColor(Color.black)
                        Spacer()
                    }.frame(width: calculateWidthSummary(width - 54, 5))
                    HStack {
                        FlightTimeButtonTimeStepper(onToggle: onPeriodDate, value: currentPeriodDate)
                            .fixedSize()
                        Spacer()
                    }.frame(width: calculateWidthSummary(width - 54, 5))
                    HStack(alignment: .center, spacing: 8) {
                        FlightTimeButtonTimeStepper(onToggle: onCompleted, value: "\(currentCompleted)")
                            .fixedSize()
                        Text("Landing").font(.system(size: 15, weight: .regular)).foregroundColor(Color.black)
                        Spacer()
                    }.frame(width: calculateWidthSummary(width - 54, 5))
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
                
                if dataModel.count > 0 {
                    if let matchingIndex = dataModel.firstIndex(where: { $0.id == item.id }) {
                        self.currentIndex = matchingIndex
                        
                        if dataModel[matchingIndex].type != "" {
                            selectedType = dataModel[matchingIndex].type
                        } else {
                            selectedType = DataRecencyDropdown.first ?? ""
                        }
                        
                        if dataModel[matchingIndex].modelName != "" {
                            currentModel = dataModel[matchingIndex].modelName
                        } else {
                            currentModel = DataModelDropdown.first ?? ""
                        }
                        
                        if dataModel[matchingIndex].requirement != "" {
                            currentRequirement = dataModel[matchingIndex].requirement
                        }
                        
                        if dataModel[matchingIndex].frequency != "" {
                            currentFrequency = dataModel[matchingIndex].frequency
                        }
                        
                        if dataModel[matchingIndex].periodStart != "" {
                            currentPeriodDate = dataModel[matchingIndex].periodStart
                        } else {
                            currentPeriodDate = dateFormatter.string(from: Date())
                            dataModel[matchingIndex].periodStart = currentPeriodDate
                        }
                        
                        if dataModel[matchingIndex].completed != "" {
                            currentCompleted = dataModel[matchingIndex].completed
                        }
                    }
                }
            }
            .formSheet(isPresented: $showRequirementModal) {
                RecencyNumberModalView(isShowing: $showRequirementModal, selectionInOut: $currentRequirement, header: "Requirement", onChange: onChangeRequirement).interactiveDismissDisabled(true)
            }
            .formSheet(isPresented: $showFrequencyModal) {
                RecencyNumberModalView(isShowing: $showFrequencyModal, selectionInOut: $currentFrequency, header: "Frequency", onChange: onChangeFrequency).interactiveDismissDisabled(true)
            }
            .formSheet(isPresented: $showPeriodDateModal) {
                LimitationTimeModalView(isShowing: $showPeriodDateModal, pickerType: $pickerType, currentDate: $currentPeriodDate, header: "Period Date", onChange: onChangePeriod).interactiveDismissDisabled(true)
            }
            .formSheet(isPresented: $showCompletedModal) {
                RecencyNumberModalView(isShowing: $showCompletedModal, selectionInOut: $currentCompleted, header: "Completed", onChange: onChangeCompleted).interactiveDismissDisabled(true)
            }
            .onChange(of: currentModel) { newValue in
                dataModel[currentIndex].modelName = newValue
            }
            .onChange(of: selectedType) { newValue in
                dataModel[currentIndex].type = newValue
            }
    }
    
    func onChangeRequirement(_ value: String) {
        dataModel[currentIndex].requirement = value
    }
    
    func onChangeFrequency(_ value: String) {
        dataModel[currentIndex].frequency = value
    }
    
    func onChangePeriod(_ value: String) {
        dataModel[currentIndex].periodStart = value
    }
    
    func onChangeCompleted(_ value: String) {
        dataModel[currentIndex].completed = value
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
