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
    @EnvironmentObject var persistenceController: PersistenceController
    
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
                                    "user_id": onboardingModel.dataYourProfile.user_id,
                                    "username": onboardingModel.dataYourProfile.userName,
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
                                let newObjectUser = UserProfileList(context: persistenceController.container.viewContext)
                                newObjectUser.id = UUID()
                                newObjectUser.userId = onboardingModel.dataYourProfile.user_id
                                newObjectUser.username = onboardingModel.dataYourProfile.userName
                                newObjectUser.firstName = onboardingModel.dataYourProfile.firstName
                                newObjectUser.lastName = onboardingModel.dataYourProfile.lastName
                                newObjectUser.airline = onboardingModel.dataYourProfile.airline
                                newObjectUser.mobileCountry = onboardingModel.dataYourProfile.mobile.country
                                newObjectUser.mobileNumber = onboardingModel.dataYourProfile.mobile.number
                                newObjectUser.email = onboardingModel.dataYourProfile.email
                                newObjectUser.isSubscribe = onboardingModel.dataYourProfile.subscribe == "1" ? true : false
                                
                                coreDataModel.save()
                                
                                var payloadExperience: [Any] = []
                                for item in onboardingModel.dataModelExperience {
                                    payloadExperience.append([
                                        "model": item.modelName,
                                        "picDay": item.picDay,
                                        "picUsDay": item.picUsDay,
                                        "p1Day": item.p1Day,
                                        "p2Day": item.p2Day,
                                        "picNight": item.picNight,
                                        "picUsNight": item.picUsNight,
                                        "p1Night": item.p1Night,
                                        "p2Night": item.p2Night,
                                        "totalTime": item.totalTime
                                    ])
                                    
                                    let newObject = RecencyExperienceList(context: persistenceController.container.viewContext)
                                    newObject.id = UUID()
                                    newObject.model = item.modelName
                                    newObject.picDay = item.picDay
                                    newObject.picUsDay = item.picUsDay
                                    newObject.p1Day = item.p1Day
                                    newObject.p2Day = item.p2Day
                                    newObject.picNight = item.picNight
                                    newObject.picUsNight = item.picUsNight
                                    newObject.p1Night = item.p1Night
                                    newObject.p2Night = item.p2Night
                                    newObject.totalTime = item.totalTime
                                    
                                    coreDataModel.save()
                                }
                                
                                var payloadLimitation: [Any] = []
                                for item in onboardingModel.dataModelLimitation {
                                    payloadLimitation.append([
                                        "limitationFlight": item.limitationFlight,
                                        "limitation": item.limitation,
                                        "duration": item.duration,
                                        "startDate": item.startDate,
                                        "endDate": item.endDate,
                                        "completed": item.completed
                                    ])
                                    
                                    let newObj = LogbookLimitationList(context: persistenceController.container.viewContext)
                                    
                                    newObj.id = UUID()
                                    newObj.remoteId = UUID().uuidString
                                    newObj.type = item.limitationFlight
                                    newObj.requirement = ""
                                    newObj.limit = item.limitation
                                    newObj.start = item.startDate
                                    newObj.end = item.endDate
                                    newObj.text = ""
                                    newObj.status = item.completed
                                    newObj.colour = "black"
                                    newObj.periodText = "\(item.startDate) to \(item.endDate)"
                                    newObj.statusText = "\(item.completed) / "
                                    coreDataModel.save()
                                }
                                
                                var payloadRecency: [Any] = []
                                for item in onboardingModel.dataModelRecency {
                                    payloadRecency.append([
                                        "type": item.type,
                                        "model": item.modelName,
                                        "requirement": item.requirement,
                                        "frequency": item.frequency,
                                        "periodStart": item.periodStart,
                                        "completed": item.completed
                                    ])
                                    
                                    let newObject = RecencyList(context: persistenceController.container.viewContext)
                                    newObject.id = UUID()
                                    newObject.type = item.type
                                    newObject.model = item.modelName
                                    newObject.requirement = item.requirement
                                    newObject.limit = item.frequency
                                    newObject.periodStart = item.periodStart
                                    newObject.status = item.completed
                                    newObject.text = "\(item.requirement) in \(item.frequency) days"
                                    newObject.percentage = "\(item.requirement) in \(item.frequency) days"
                                    newObject.blueText = "\(item.completed)/\(item.requirement) in \(item.frequency) days"
                                    
                                    coreDataModel.save()
                                }
                                
                                var payloadExpiry: [Any] = []
                                for item in onboardingModel.dataModelExpiry {
                                    let key = item.documentType.lowercased().replacingOccurrences(of: " ", with:
                                    "_")
                                    
                                    payloadExpiry.append([
                                        "expiryDate": item.expiredDate,
//                                        "requirement": item.requirement,
                                        "type": key
                                    ])
                                    
                                    let newObject = RecencyExpiryList(context: persistenceController.container.viewContext)
                                    newObject.id = UUID()
                                    newObject.type = item.documentType
                                    newObject.expiredDate = item.expiredDate
                                    newObject.requirement = item.requirement
                                    
                                    coreDataModel.save()
                                }
                                
                                let payload: [String: Any] = [
                                    "yourProfile": payloadProfile,
                                    "experience": payloadExperience,
                                    "limitations": payloadLimitation,
                                    "recencies": payloadRecency,
                                    "expiry": payloadExpiry
                                ]
                                
                                print("=======start post======")
                                print("=======payload======\(payload)")
                                await remoteService.postUserData(payload, completion: { success in
                                    print("=======success======\(success)")
                                    isLoading = false
                                    coreDataModel.loading = false
                                    coreDataModel.loadingInit = false
                                    
                                    if success {
                                        isOnboarding = "0"
                                        isBoardingCompleted = "1"
                                    }
                                })
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
            if item.modelName != "" && item.picDay != "" && item.picUsDay != "" && item.p1Day != "" && item.p2Day != "" && item.picNight != "" && item.picUsNight != "" && item.p1Night != "" && item.p2Night != "" && item.totalTime != "" {
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
