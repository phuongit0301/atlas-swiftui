//
//  OnboardingView.swift
//  ATLAS
//
//  Created by phuong phan on 01/10/2023.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var onboardingModel: OnboardingModel
    @EnvironmentObject var remoteService: RemoteService
    @AppStorage("isOnboarding") var isOnboarding: String = ""
    @AppStorage("isBoardingCompleted") var isBoardingCompleted: String = ""
    
    @State private var selected: Int = 0
    @State private var isProfileValid = false
    @State private var isExperienceValid = false
    @State private var isLimitationValid = false
    @State private var isRecencyValid = false
    @State private var isExpiryValid = false
    @State private var isLoading = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image("logo")
                    .frame(width: 100, height: 32)
                    .scaledToFit()
                    .aspectRatio(contentMode: .fit)
            }.padding(.bottom, 24)
            
            VStack(spacing: 0) {
                HStack(alignment: .center) {
                    VStack(spacing: 8) {
                        Text("Onboarding checklist").font(.system(size: 28, weight: .semibold)).foregroundColor(Color.black)
                        Text("Please follow these steps to get started with Atlas").font(.system(size: 15, weight: .regular)).foregroundColor(Color.black)
                    }
                    
                    Spacer()
                    
                    Button {
                        if isProfileValid && isExperienceValid && isLimitationValid && isRecencyValid && isExpiryValid {
                            Task {
                                coreDataModel.loadingInit = true
                                isLoading = true
                                let payloadProfile = [
                                    "id": onboardingModel.dataYourProfile.id,
                                    "user_id": onboardingModel.dataYourProfile.user_id,
                                    "userName": onboardingModel.dataYourProfile.userName,
                                    "firstName": onboardingModel.dataYourProfile.firstName,
                                    "lastName": onboardingModel.dataYourProfile.lastName,
                                    "airline": onboardingModel.dataYourProfile.airline,
                                    "mobile": [
                                        "country": onboardingModel.dataYourProfile.mobile.country,
                                        "number": onboardingModel.dataYourProfile.mobile.number
                                    ],
                                    "email": onboardingModel.dataYourProfile.email,
                                    "subscribe": onboardingModel.dataYourProfile.subscribe
                                ] as [String : Any]
                                
                                var payloadExperience: [Any] = []
                                for item in onboardingModel.dataModelExperience {
                                    payloadExperience.append([
                                        "id": item.id,
                                        "modelName": item.modelName,
                                        "pic": item.pic,
                                        "picUs": item.picUs,
                                        "p1": item.p1,
                                        "p2": item.p2,
                                        "instr": item.instr,
                                        "exam": item.exam,
                                        "totalTime": item.totalTime
                                    ])
                                }
                                
                                var payloadLimitation: [Any] = []
                                for item in onboardingModel.dataModelLimitation {
                                    payloadLimitation.append([
                                        "id": item.id,
                                        "limitationFlight": item.limitationFlight,
                                        "limitation": item.limitation,
                                        "duration": item.duration,
                                        "startDate": item.startDate,
                                        "endDate": item.endDate,
                                        "completed": item.completed
                                    ])
                                }
                                
                                var payloadRecency: [Any] = []
                                for item in onboardingModel.dataModelRecency {
                                    payloadRecency.append([
                                        "id": item.id,
                                        "type": item.type,
                                        "modelName": item.modelName,
                                        "requirement": item.requirement,
                                        "frequency": item.frequency,
                                        "periodStart": item.periodStart,
                                        "completed": item.completed
                                    ])
                                }
                                
                                var payloadExpiry: [Any] = []
                                for item in onboardingModel.dataModelExpiry {
                                    payloadExpiry.append([
                                        "id": item.id,
                                        "expiredDate": item.expiredDate,
                                        "requirement": item.requirement,
                                        "documentType": item.documentType
                                    ])
                                }
                                
                                let payload: [String: Any] = [
                                    "yourProfile": payloadProfile,
                                    "experience": payloadExperience,
                                    "limitations": payloadLimitation,
                                    "recencies": payloadRecency,
                                    "expiry": payloadExpiry
                                ]
                                
                                await remoteService.postUserData(payload)
                                isLoading = false
                                coreDataModel.loadingInit = false
                                isOnboarding = "0"
                                isBoardingCompleted = "1"
                            }
                        }
                    } label: {
                        HStack(alignment: .center, spacing: 16) {
                            if isLoading {
                                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                            }
                            Text("Complete Onboarding")
                                .foregroundColor(.white)
                                .font(.system(size: 15, weight: .semibold))
                                .frame(height: 20)
                                .padding(.vertical, 12)
                                .padding(.horizontal)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill((isProfileValid && isExperienceValid && isLimitationValid && isRecencyValid && isExpiryValid) ? Color.theme.azure : Color.theme.philippineGray3)
                                )
                        }
                    }.disabled(isLoading)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 0)
                        .foregroundColor(.white)
                )
                .padding(.bottom, 8)
                
                HStack(spacing: 8) {
                    VStack(spacing: 0) {
                        VStack(alignment: .leading) {
                            ForEach(DataCheckList.indices, id: \.self) {index in
                                HStack(spacing: 16) {
                                    if index == 0 && isProfileValid {
                                        Image(systemName: "checkmark.circle.fill").font(.system(size: 20)).foregroundStyle(Color.black, Color.theme.tealDeer)
                                    } else if index == 1 && isExperienceValid {
                                        Image(systemName: "checkmark.circle.fill").font(.system(size: 20)).foregroundStyle(Color.black, Color.theme.tealDeer)
                                    } else if index == 2 && isLimitationValid {
                                        Image(systemName: "checkmark.circle.fill").font(.system(size: 20)).foregroundStyle(Color.black, Color.theme.tealDeer)
                                    } else if index == 3 && isRecencyValid {
                                        Image(systemName: "checkmark.circle.fill").font(.system(size: 20)).foregroundStyle(Color.black, Color.theme.tealDeer)
                                    } else if index == 4 && isExpiryValid {
                                        Image(systemName: "checkmark.circle.fill").font(.system(size: 20)).foregroundStyle(Color.black, Color.theme.tealDeer)
                                    } else {
                                        Image(systemName: "checkmark.circle").font(.system(size: 20)).foregroundColor(selected == index ? Color.white : Color.black)
                                    }
                                    
                                    Text(DataCheckList[index].name).font(.system(size: 15, weight: selected == index ? .semibold : .regular)).foregroundColor(selected == index ? Color.white : Color.black)
                                }.padding(.vertical, 12)
                                    .padding(.horizontal, 16)
                                    .background(selected == index ? Color.theme.azure : Color.white)
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(lineWidth: 0)
                                            .foregroundColor(.white)
                                    ).onTapGesture {
                                        self.selected = index
                                    }
                            }
                        }
                        .padding()
                        .frame(width: 332)
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(lineWidth: 0)
                                .foregroundColor(.white)
                        )
                        
                        Spacer()
                    }
                    
                    if selected == 0 {
                        CompleteYourProfileView()
                    } else if selected == 1 {
                        ProvideExperienceView()
                    } else if selected == 2 {
                        ProvideLimitationView()
                    } else if selected == 3 {
                        ProvideRecencyView()
                    } else {
                        ProvideExpiryView()
                    }
                    
                }
            }.padding(.horizontal)
        }.background(Color.theme.antiFlashWhite)
            .onChange(of: onboardingModel.dataYourProfile) { _ in
                isProfileValid = validateYourProfile()
            }
            .onChange(of: onboardingModel.dataModelExperience) { _ in
                isExperienceValid = validateExperience()
            }
            .onChange(of: onboardingModel.dataModelLimitation) { _ in
                isLimitationValid = validateLimitation()
            }
            .onChange(of: onboardingModel.dataModelRecency) { _ in
                isRecencyValid = validateRecency()
            }
            .onChange(of: onboardingModel.dataModelExpiry) { _ in
                isExpiryValid = validateExpiry()
            }
    }
    
    func validateYourProfile() -> Bool {
        let data = onboardingModel.dataYourProfile
        return data.userName != "" && data.firstName != "" && data.lastName != "" && data.airline != "" && data.mobile.country != "" && data.mobile.number != "" && data.email != ""
    }
    
    func validateExperience() -> Bool {
        var bool = false
        
        for item in onboardingModel.dataModelExperience {
            if item.modelName != "" && item.pic != "" && item.picUs != "" && item.p1 != "" && item.p2 != "" && item.totalTime != "" {
                bool = true
            } else {
                bool = false
                break
            }
        }
        
        return bool
    }
    
    func validateLimitation() -> Bool {
        var bool = false
        
        for item in onboardingModel.dataModelLimitation {
            if item.limitationFlight != "" && item.limitation != "" && item.duration != "" && item.startDate != "" && item.endDate != "" && item.completed != "" {
                bool = true
            } else {
                bool = false
                break
            }
        }
        
        return bool
    }
    
    func validateRecency() -> Bool {
        var bool = false
        
        for item in onboardingModel.dataModelRecency {
            if item.type != "" && item.modelName != "" && item.requirement != "" && item.frequency != "" && item.periodStart != "" && item.completed != "" {
                bool = true
            } else {
                bool = false
                break
            }
        }
        
        return bool
    }
    
    func validateExpiry() -> Bool {
        var bool = false
        
        for item in onboardingModel.dataModelExpiry {
            if item.documentType != "" && item.expiredDate != "" {
                bool = true
            } else {
                bool = false
                break
            }
        }
        
        return bool
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
