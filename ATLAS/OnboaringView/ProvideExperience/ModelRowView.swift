//
//  ModelRowView.swift
//  ATLAS
//
//  Created by phuong phan on 02/10/2023.
//

import SwiftUI

struct ModelRowView: View {
    @Binding var dataModel: [IProvideExperience]
//    let index: Int
    var item: IProvideExperience
    let width: CGFloat
    @State private var selectedModel = ""
    
    @State var currentPic = "00000:00"
    @State var currentPicUs = "00000:00"
    @State var currentP1 = "00000:00"
    @State var currentP2 = "00000:00"
//    @State var currentInstr = "00:00"
//    @State var currentExam = "00:00"
    @State var currentTotal = "00000:00"
    
    @State var showPicModal = false
    @State var showPicUsModal = false
    @State var showP1Modal = false
    @State var showP2Modal = false
//    @State var showInstrModal = false
//    @State var showExamModal = false
    @State var showTotalModal = false
    
    @State private var currentIndex = -1
    
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
                
                Text("Model").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.black)
                
                HStack(spacing: 8) {
                    Picker("", selection: $selectedModel) {
                        ForEach(DataModelDropdown, id: \.self) {
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
                    Text("PIC")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color.black)
                        .frame(width: calculateWidthSummary(width - 64, 5), alignment: .leading)
                    Text("PIC(u/us)")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color.black)
                        .frame(width: calculateWidthSummary(width - 64, 5), alignment: .leading)
                    Text("P1")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color.black)
                        .frame(width: calculateWidthSummary(width - 64, 5), alignment: .leading)
                    Text("P2")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color.black)
                        .frame(width: calculateWidthSummary(width - 64, 5), alignment: .leading)
//                    Text("Instr")
//                        .font(.system(size: 15, weight: .medium))
//                        .foregroundColor(Color.black)
//                        .frame(width: calculateWidthSummary(width - 64, 7), alignment: .leading)
//                    Text("Exam")
//                        .font(.system(size: 15, weight: .medium))
//                        .foregroundColor(Color.black)
//                        .frame(width: calculateWidthSummary(width - 64, 7), alignment: .leading)
                    Text("Total Time (P1+P2)")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color.black)
                        .frame(width: calculateWidthSummary(width - 64, 5), alignment: .leading)
                }.frame(height: 44, alignment: .leading)
                
                HStack {
                    HStack {
                        FlightTimeButtonTimeStepper(onToggle: onPic, value: currentPic)
                            .fixedSize()
                        Spacer()
                    }.frame(width: calculateWidthSummary(width - 64, 5))
                    HStack {
                        FlightTimeButtonTimeStepper(onToggle: onPicUs, value: currentPicUs)
                            .fixedSize()
                        Spacer()
                    }.frame(width: calculateWidthSummary(width - 64, 5))
                    HStack {
                        FlightTimeButtonTimeStepper(onToggle: onP1, value: currentP1)
                            .fixedSize()
                        Spacer()
                    }.frame(width: calculateWidthSummary(width - 64, 5))
                    HStack {
                        FlightTimeButtonTimeStepper(onToggle: onP2, value: currentP2)
                            .fixedSize()
                        Spacer()
                    }.frame(width: calculateWidthSummary(width - 64, 5))
//                    HStack {
//                        FlightTimeButtonTimeStepper(onToggle: onInstr, value: currentInstr)
//                            .fixedSize()
//                        Spacer()
//                    }.frame(width: calculateWidthSummary(width - 64, 5))
//                    HStack {
//                        FlightTimeButtonTimeStepper(onToggle: onExam, value: currentExam)
//                            .fixedSize()
//                        Spacer()
//                    }.frame(width: calculateWidthSummary(width - 64, 5))
                    HStack {
                        FlightTimeButtonTimeStepper(onToggle: onTotal, value: currentTotal)
                            .fixedSize()
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
                if dataModel.count > 0 {
                    if let matchingIndex = dataModel.firstIndex(where: { $0.id == item.id }) {
                        self.currentIndex = matchingIndex
                        
                        if dataModel[matchingIndex].modelName != "" {
                            self.selectedModel = dataModel[matchingIndex].modelName
                        } else {
                            self.selectedModel = DataModelDropdown.first ?? ""
                        }
                        
                        if dataModel[matchingIndex].pic != "" {
                            self.currentPic = dataModel[matchingIndex].pic
                        }
                        
                        if dataModel[matchingIndex].picUs != "" {
                            self.currentPicUs = dataModel[matchingIndex].picUs
                        }
                        
                        if dataModel[matchingIndex].p1 != "" {
                            self.currentP1 = dataModel[matchingIndex].p1
                        }
                        
                        if dataModel[matchingIndex].p2 != "" {
                            self.currentP2 = dataModel[matchingIndex].p2
                        }
                        
                        if dataModel[matchingIndex].totalTime != "" {
                            self.currentTotal = dataModel[matchingIndex].totalTime
                        }
                    }
                }
            }
            .formSheet(isPresented: $showPicModal) {
                OnboardingTimeModalView(isShowing: $showPicModal, selectionInOut: $currentPic, onChange: onChangePic).interactiveDismissDisabled(true)
            }
            .formSheet(isPresented: $showPicUsModal) {
                OnboardingTimeModalView(isShowing: $showPicUsModal, selectionInOut: $currentPicUs, onChange: onChangePicUs).interactiveDismissDisabled(true)
            }
            .formSheet(isPresented: $showP1Modal) {
                OnboardingTimeModalView(isShowing: $showP1Modal, selectionInOut: $currentP1, onChange: onChangeP1).interactiveDismissDisabled(true)
            }
            .formSheet(isPresented: $showP2Modal) {
                OnboardingTimeModalView(isShowing: $showP2Modal, selectionInOut: $currentP2, onChange: onChangeP2).interactiveDismissDisabled(true)
            }
//            .formSheet(isPresented: $showTotalModal) {
//                OnboardingTimeModalView(isShowing: $showTotalModal, selectionInOut: $currentTotal, onChange: onChangeTotalTime)
//            }
            .onChange(of: selectedModel) { newValue in
                if dataModel[currentIndex].modelName != newValue {
                    dataModel[currentIndex].modelName = newValue
                }
            }
    }

    func onChangePic(_ value: String) {
        dataModel[currentIndex].pic = value
    }

    func onChangePicUs(_ value: String) {
        dataModel[currentIndex].picUs = value
    }
    
    func onChangeP1(_ value: String) {
        dataModel[currentIndex].p1 = value
        calculateTotalTime()
    }
    
    func onChangeP2(_ value: String) {
        dataModel[currentIndex].p2 = value
        calculateTotalTime()
    }
    
    func calculateTotalTime() {
        var num1 = 0
        var num2 = 0
        
        if dataModel[currentIndex].p1 != "" {
            let arr = dataModel[currentIndex].p1.components(separatedBy: ":")
            num1 += (arr[0] as NSString).integerValue
            num2 += (arr[1] as NSString).integerValue
        }
        
        if dataModel[currentIndex].p2 != "" {
            let arr = dataModel[currentIndex].p2.components(separatedBy: ":")
            num1 += (arr[0] as NSString).integerValue
            num2 += (arr[1] as NSString).integerValue
        }
        
        let str = "\(String(format: "%05d", num1)):\(String(format: "%02d", num2))"
        dataModel[currentIndex].totalTime = str
    }
    
    func onPic() {
        self.showPicModal.toggle()
    }
    
    func onPicUs() {
        self.showPicUsModal.toggle()
    }
    
    func onP1() {
        self.showP1Modal.toggle()
    }
    
    func onP2() {
        self.showP2Modal.toggle()
    }
    
//    func onInstr() {
//        self.showInstrModal.toggle()
//    }
//
//    func onExam() {
//        self.showExamModal.toggle()
//    }
    
    func onTotal() {
        self.showTotalModal.toggle()
    }
}
