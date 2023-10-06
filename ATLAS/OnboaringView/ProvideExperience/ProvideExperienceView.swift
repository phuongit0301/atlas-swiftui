//
//  ProvideExperienceView.swift
//  ATLAS
//
//  Created by phuong phan on 01/10/2023.
//

import SwiftUI

struct ProvideExperienceView: View {
    @EnvironmentObject var onboardingModel: OnboardingModel
    @State private var selectedModel = ""
    
    @State var currentPic = "00:00"
    @State var currentPicUs = "00:00"
    @State var currentP1 = "00:00"
    @State var currentP2 = "00:00"
    @State var currentInstr = "00:00"
    @State var currentExam = "00:00"
    @State var currentTotal = "00:00"
    
    @State var showPicModal = false
    @State var showPicUsModal = false
    @State var showP1Modal = false
    @State var showP2Modal = false
    @State var showInstrModal = false
    @State var showExamModal = false
    @State var showTotalModal = false
    
    @State var dataModel = [IProvideExperience]()
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(alignment: .leading) {
                    HStack(alignment: .center) {
                        Text("Provide your flying experience").font(.system(size: 20, weight: .semibold)).foregroundColor(Color.black)
                        
                        Spacer()
                        
                        Button(action: {
                            let obj = IProvideExperience(modelName: "00:00", pic: "00:00", picUs: "00:00", p1: "00:00", p2: "00:00", instr: "00:00", exam: "00:00", totalTime: "00:00")
                            onboardingModel.dataModelExperience.append(obj)
                        }, label: {
                            Text("Add Model").font(.system(size: 15, weight: .regular)).foregroundStyle(Color.theme.azure)
                        })
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        if onboardingModel.dataModelExperience.count > 0 {
                            ForEach(onboardingModel.dataModelExperience, id: \.self) {item in
                                ModelRowView(dataModel: $onboardingModel.dataModelExperience, item: item, width: proxy.size.width)
                            }
                        }
                    }
                }.padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 0)
                            .foregroundColor(.white)
                    )
            }
//            .formSheet(isPresented: $showPicModal) {
//                OnboardingTimeModalView(isShowing: $showPicModal, currentDate: $currentPic)
//            }
//            .formSheet(isPresented: $showPicUsModal) {
//                OnboardingTimeModalView(isShowing: $showPicUsModal, currentDate: $currentPicUs)
//            }
//            .formSheet(isPresented: $showP1Modal) {
//                OnboardingTimeModalView(isShowing: $showP1Modal, currentDate: $currentP1)
//            }
//            .formSheet(isPresented: $showP2Modal) {
//                OnboardingTimeModalView(isShowing: $showP2Modal, currentDate: $currentP2)
//            }
//            .formSheet(isPresented: $showInstrModal) {
//                OnboardingTimeModalView(isShowing: $showInstrModal, currentDate: $currentInstr)
//            }
//            .formSheet(isPresented: $showExamModal) {
//                OnboardingTimeModalView(isShowing: $showExamModal, currentDate: $currentExam)
//            }
//            .formSheet(isPresented: $showTotalModal) {
//                OnboardingTimeModalView(isShowing: $showTotalModal, currentDate: $currentTotal)
//            }
        }
    }

//    func onPic() {
//        self.showPicModal.toggle()
//    }
//    
//    func onPicUs() {
//        self.showPicUsModal.toggle()
//    }
//    
//    func onP1() {
//        self.showP1Modal.toggle()
//    }
//    
//    func onP2() {
//        self.showP2Modal.toggle()
//    }
//    
//    func onInstr() {
//        self.showInstrModal.toggle()
//    }
//    
//    func onExam() {
//        self.showExamModal.toggle()
//    }
//    
//    func onTotal() {
//        self.showTotalModal.toggle()
//    }
}

struct ProvideExperienceView_Previews: PreviewProvider {
    static var previews: some View {
        ProvideExperienceView()
    }
}
