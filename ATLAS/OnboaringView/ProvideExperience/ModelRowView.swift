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
    
    @State var currentPicDay = "00000:00"
    @State var currentPicNight = "00000:00"
    @State var currentPicUsDay = "00000:00"
    @State var currentPicUsNight = "00000:00"
    @State var currentP1Day = "00000:00"
    @State var currentP1Night = "00000:00"
    @State var currentP2Day = "00000:00"
    @State var currentP2Night = "00000:00"
//    @State var currentInstr = "00:00"
//    @State var currentExam = "00:00"
    @State var currentTotal = "00000:00"
    
    @State var showPicDayModal = false
    @State var showPicNightModal = false
    @State var showPicUsDayModal = false
    @State var showPicUsNightModal = false
    @State var showP1DayModal = false
    @State var showP1NightModal = false
    @State var showP2DayModal = false
    @State var showP2NightModal = false
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
                    Text("PIC Day")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color.black)
                        .frame(width: calculateWidthSummary(width - 64, 5), alignment: .leading)
                    Text("PIC Night")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color.black)
                        .frame(width: calculateWidthSummary(width - 64, 5), alignment: .leading)
                    Text("PIC(u/us) Day")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color.black)
                        .frame(width: calculateWidthSummary(width - 64, 5), alignment: .leading)
                    Text("PIC(u/us) Night")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color.black)
                        .frame(width: calculateWidthSummary(width - 64, 5), alignment: .leading)
                    Text("")
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
                }.frame(height: 44, alignment: .leading)
                
                HStack {
                    HStack {
                        FlightTimeButtonTimeStepper(onToggle: onPicDay, value: currentPicDay)
                            .fixedSize()
                        Spacer()
                    }.frame(width: calculateWidthSummary(width - 64, 5))
                    HStack {
                        FlightTimeButtonTimeStepper(onToggle: onPicNight, value: currentPicNight)
                            .fixedSize()
                        Spacer()
                    }.frame(width: calculateWidthSummary(width - 64, 5))
                    HStack {
                        FlightTimeButtonTimeStepper(onToggle: onPicUsDay, value: currentPicUsDay)
                            .fixedSize()
                        Spacer()
                    }.frame(width: calculateWidthSummary(width - 64, 5))
                    HStack {
                        FlightTimeButtonTimeStepper(onToggle: onPicUsNight, value: currentPicUsNight)
                            .fixedSize()
                        Spacer()
                    }.frame(width: calculateWidthSummary(width - 64, 5))
                    Text("")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color.black)
                        .frame(width: calculateWidthSummary(width - 64, 5), alignment: .leading)
                }.frame(height: 44, alignment: .leading)
            }
            
            VStack(alignment: .leading) {
                HStack {
                    Text("P1 Day")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color.black)
                        .frame(width: calculateWidthSummary(width - 64, 5), alignment: .leading)
                    Text("P1 Night")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color.black)
                        .frame(width: calculateWidthSummary(width - 64, 5), alignment: .leading)
                    Text("P2 Day")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color.black)
                        .frame(width: calculateWidthSummary(width - 64, 5), alignment: .leading)
                    Text("P2 Night")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color.black)
                        .frame(width: calculateWidthSummary(width - 64, 5), alignment: .leading)
                    Text("Total Time (P1+P2)")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color.black)
                        .frame(width: calculateWidthSummary(width - 64, 5), alignment: .leading)
                }
                
                HStack {
                    HStack {
                        FlightTimeButtonTimeStepper(onToggle: onP1Day, value: currentP1Day)
                            .fixedSize()
                        Spacer()
                    }.frame(width: calculateWidthSummary(width - 64, 5))
                    HStack {
                        FlightTimeButtonTimeStepper(onToggle: onP1Night, value: currentP1Night)
                            .fixedSize()
                        Spacer()
                    }.frame(width: calculateWidthSummary(width - 64, 5))
                    HStack {
                        FlightTimeButtonTimeStepper(onToggle: onP2Day, value: currentP2Day)
                            .fixedSize()
                        Spacer()
                    }.frame(width: calculateWidthSummary(width - 64, 5))
                    HStack {
                        FlightTimeButtonTimeStepper(onToggle: onP2Night, value: currentP2Night)
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
            }
            
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
                        
                        if dataModel[matchingIndex].picDay != "" {
                            self.currentPicDay = dataModel[matchingIndex].picDay
                        }
                        
                        if dataModel[matchingIndex].picNight != "" {
                            self.currentPicNight = dataModel[matchingIndex].picNight
                        }
                        
                        if dataModel[matchingIndex].picUsDay != "" {
                            self.currentPicUsDay = dataModel[matchingIndex].picUsDay
                        }
                        
                        if dataModel[matchingIndex].picUsNight != "" {
                            self.currentPicUsNight = dataModel[matchingIndex].picUsNight
                        }
                        
                        if dataModel[matchingIndex].p1Day != "" {
                            self.currentP1Day = dataModel[matchingIndex].p1Day
                        }
                        
                        if dataModel[matchingIndex].p1Night != "" {
                            self.currentP1Night = dataModel[matchingIndex].p1Night
                        }
                        
                        if dataModel[matchingIndex].p2Day != "" {
                            self.currentP2Day = dataModel[matchingIndex].p2Day
                        }
                        
                        if dataModel[matchingIndex].p2Night != "" {
                            self.currentP2Night = dataModel[matchingIndex].p2Night
                        }
                        
                        if dataModel[matchingIndex].totalTime != "" {
                            self.currentTotal = dataModel[matchingIndex].totalTime
                        }
                    }
                }
            }
            .formSheet(isPresented: $showPicDayModal) {
                OnboardingTimeModalView(isShowing: $showPicDayModal, selectionInOut: $currentPicDay, onChange: onChangePicDay).interactiveDismissDisabled(true)
            }
            .formSheet(isPresented: $showPicNightModal) {
                OnboardingTimeModalView(isShowing: $showPicNightModal, selectionInOut: $currentPicNight, onChange: onChangePicNight).interactiveDismissDisabled(true)
            }
            .formSheet(isPresented: $showPicUsDayModal) {
                OnboardingTimeModalView(isShowing: $showPicUsDayModal, selectionInOut: $currentPicUsDay, onChange: onChangePicUsDay).interactiveDismissDisabled(true)
            }
            .formSheet(isPresented: $showPicUsNightModal) {
                OnboardingTimeModalView(isShowing: $showPicUsNightModal, selectionInOut: $currentPicUsNight, onChange: onChangePicUsNight).interactiveDismissDisabled(true)
            }
            .formSheet(isPresented: $showP1DayModal) {
                OnboardingTimeModalView(isShowing: $showP1DayModal, selectionInOut: $currentP1Day, onChange: onChangeP1Day).interactiveDismissDisabled(true)
            }
            .formSheet(isPresented: $showP1NightModal) {
                OnboardingTimeModalView(isShowing: $showP1NightModal, selectionInOut: $currentP1Night, onChange: onChangeP1Night).interactiveDismissDisabled(true)
            }
            .formSheet(isPresented: $showP2DayModal) {
                OnboardingTimeModalView(isShowing: $showP2DayModal, selectionInOut: $currentP2Day, onChange: onChangeP2Day).interactiveDismissDisabled(true)
            }
            .formSheet(isPresented: $showP2NightModal) {
                OnboardingTimeModalView(isShowing: $showP2NightModal, selectionInOut: $currentP2Night, onChange: onChangeP2Night).interactiveDismissDisabled(true)
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

    func onChangePicDay(_ value: String) {
        dataModel[currentIndex].picDay = value
    }

    func onChangePicUsDay(_ value: String) {
        dataModel[currentIndex].picUsDay = value
    }
    
    func onChangeP1Day(_ value: String) {
        dataModel[currentIndex].p1Day = value
        calculateTotalTime()
    }
    
    func onChangeP2Day(_ value: String) {
        dataModel[currentIndex].p2Day = value
        calculateTotalTime()
    }
    
    func onChangePicNight(_ value: String) {
        dataModel[currentIndex].picNight = value
    }

    func onChangePicUsNight(_ value: String) {
        dataModel[currentIndex].picUsNight = value
    }
    
    func onChangeP1Night(_ value: String) {
        dataModel[currentIndex].p1Night = value
        calculateTotalTime()
    }
    
    func onChangeP2Night(_ value: String) {
        dataModel[currentIndex].p2Night = value
        calculateTotalTime()
    }
    
    func calculateTotalTime() {
        var num1 = 0
        var num2 = 0
        
        if dataModel[currentIndex].p1Day != "" {
            let arr = dataModel[currentIndex].p1Day.components(separatedBy: ":")
            num1 += (arr[0] as NSString).integerValue
            num2 += (arr[1] as NSString).integerValue
        }
        
        if dataModel[currentIndex].p2Day != "" {
            let arr = dataModel[currentIndex].p2Day.components(separatedBy: ":")
            num1 += (arr[0] as NSString).integerValue
            num2 += (arr[1] as NSString).integerValue
        }
        
        if dataModel[currentIndex].p1Night != "" {
            let arr = dataModel[currentIndex].p1Night.components(separatedBy: ":")
            num1 += (arr[0] as NSString).integerValue
            num2 += (arr[1] as NSString).integerValue
        }
        
        if dataModel[currentIndex].p2Night != "" {
            let arr = dataModel[currentIndex].p2Night.components(separatedBy: ":")
            num1 += (arr[0] as NSString).integerValue
            num2 += (arr[1] as NSString).integerValue
        }
        
        if num2 > 59 {
            let temp = Int(num2 / 60)
            let tempMod = num2 % 60
            num1 += temp
            num2 = tempMod
            print("temp========\(temp)")
            print("tempMod========\(tempMod)")
            print("num1========\(num1)")
            print("num2========\(num2)")
        }
        let str = "\(String(format: "%05d", num1)):\(String(format: "%02d", num2))"
        dataModel[currentIndex].totalTime = str
    }
    
    func onPicDay() {
        self.showPicDayModal.toggle()
    }

    func onPicNight() {
        self.showPicNightModal.toggle()
    }
    
    func onPicUsDay() {
        self.showPicUsDayModal.toggle()
    }

    func onPicUsNight() {
        self.showPicUsNightModal.toggle()
    }
    
    func onP1Day() {
        self.showP1DayModal.toggle()
    }

    func onP1Night() {
        self.showP1NightModal.toggle()
    }
    
    func onP2Day() {
        self.showP2DayModal.toggle()
    }

    func onP2Night() {
        self.showP2NightModal.toggle()
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
