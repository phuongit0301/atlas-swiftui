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
    @State private var selectedLimitationFlight = ""
    
    @State var currentLimitation = "0000"
    
    @State var currentDuration = "000"
    
    @State var currentStartDate = ""
    @State var currentEndDate = ""
    
    @State var currentCompleted = "0000"
    
    @State var showLimitationModal = false
    @State var showDurationModal = false
    @State var showStartDateModal = false
    @State var showEndDateModal = false
    @State var showCompletedModal = false
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
                
                Text("Limitation").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.black)
                
                HStack(spacing: 8) {
                    Picker("", selection: $selectedLimitationFlight) {
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

                if dataModel.count > 0 {
                    if let matchingIndex = dataModel.firstIndex(where: { $0.id == item.id }) {
                        self.currentIndex = matchingIndex
                        
                        if dataModel[matchingIndex].limitationFlight != "" {
                            selectedLimitationFlight = dataModel[matchingIndex].limitationFlight
                        } else {
                            selectedLimitationFlight = DataLimitationDropdown.first ?? ""
                        }
                        
                        if dataModel[matchingIndex].limitation != "" {
                            currentLimitation = dataModel[matchingIndex].limitation
                        }
                        
                        if dataModel[matchingIndex].duration != "" {
                            currentDuration = dataModel[matchingIndex].duration
                        }
                        
                        if dataModel[matchingIndex].startDate != "" {
                            currentStartDate = dataModel[matchingIndex].startDate
                        } else {
                            currentStartDate = dateFormatter.string(from: Date())
                            dataModel[matchingIndex].startDate = currentStartDate
                        }
                        
                        if dataModel[matchingIndex].endDate != "" {
                            currentEndDate = dataModel[matchingIndex].endDate
                        } else {
                            currentEndDate = dateFormatter.string(from: Date())
                            dataModel[matchingIndex].endDate = currentEndDate
                        }
                        
                        if dataModel[matchingIndex].completed != "" {
                            currentCompleted = dataModel[matchingIndex].completed
                        }
                    }
                }
            }
            .formSheet(isPresented: $showLimitationModal) {
                LimitationNumberModalView(isShowing: $showLimitationModal, selectionInOut: $currentLimitation, header: "Limitation", onChange: onChangeLimitation).interactiveDismissDisabled(true)
            }
            .formSheet(isPresented: $showDurationModal) {
                LimitationDurationModalView(isShowing: $showDurationModal, selectionInOut: $currentDuration, header: "Duration", onChange: onChangeDuration).interactiveDismissDisabled(true)
            }
            .formSheet(isPresented: $showStartDateModal) {
                LimitationTimeModalView(isShowing: $showStartDateModal, pickerType: $pickerType, currentDate: $currentStartDate, header: "Start Date", onChange: onChangeStartDate).interactiveDismissDisabled(true)
            }
            .formSheet(isPresented: $showEndDateModal) {
                LimitationTimeModalView(isShowing: $showEndDateModal, pickerType: $pickerType, currentDate: $currentEndDate, header: "End Date", onChange: onChangeEndDate).interactiveDismissDisabled(true)
            }
            .formSheet(isPresented: $showCompletedModal) {
                LimitationNumberModalView(isShowing: $showCompletedModal, selectionInOut: $currentCompleted, header: "Completed", onChange: onChangeCompleted).interactiveDismissDisabled(true)
            }
            .onChange(of: selectedLimitationFlight) { newValue in
                if dataModel[currentIndex].limitationFlight != newValue {
                    dataModel[currentIndex].limitationFlight = newValue
                }
            }
    }
    
    func onChangeLimitation(_ value: String) {
        dataModel[currentIndex].limitation = value
    }

    func onChangeDuration(_ value: String) {
        dataModel[currentIndex].duration = value
    }
    
    func onChangeStartDate(_ value: String) {
        dataModel[currentIndex].startDate = value
    }
    
    func onChangeEndDate(_ value: String) {
        dataModel[currentIndex].endDate = value
    }
    
    func onChangeCompleted(_ value: String) {
        dataModel[currentIndex].completed = value
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
