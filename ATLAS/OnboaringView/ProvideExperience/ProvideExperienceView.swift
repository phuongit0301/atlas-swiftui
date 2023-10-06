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
    
    @State var currentPic = "0000:00"
    @State var currentPicUs = "0000:00"
    @State var currentP1 = "0000:00"
    @State var currentP2 = "0000:00"
    @State var currentInstr = "0000:00"
    @State var currentExam = "0000:00"
    @State var currentTotal = "0000:00"
    
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
                            let obj = IProvideExperience(modelName: "", pic: "", picUs: "", p1: "", p2: "", instr: "", exam: "", totalTime: "")
                            onboardingModel.dataModelExperience.append(obj)
                        }, label: {
                            Text("Add Model").font(.system(size: 15, weight: .regular)).foregroundStyle(Color.theme.azure)
                        })
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        if onboardingModel.dataModelExperience.count > 0 {
                            ForEach(onboardingModel.dataModelExperience, id: \.self) {item in
                                ModelRowView(dataModel: $onboardingModel.dataModelExperience, item: item, width: proxy.size.width).id(UUID())
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
        }
    }
}

struct ProvideExperienceView_Previews: PreviewProvider {
    static var previews: some View {
        ProvideExperienceView()
    }
}
