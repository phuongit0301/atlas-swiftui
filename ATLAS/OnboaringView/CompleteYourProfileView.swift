//
//  CompleteYourProfileView.swift
//  ATLAS
//
//  Created by phuong phan on 01/10/2023.
//

import SwiftUI

struct CompleteYourProfileView: View {
    @EnvironmentObject var onboardingModel: OnboardingModel
    @AppStorage("email") var email: String = ""
    
    @State private var selected: Int = 0
    @State private var username = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var phone = ""
    @State private var selectedAirline = ""
    @State private var selectedMobile = ""
    @State private var showUTC = true
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Complete your profile").font(.system(size: 20, weight: .semibold)).foregroundColor(Color.black)
                
                VStack(alignment: .leading, spacing: 8) {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(spacing: 16) {
                            Text("Username").font(.system(size: 15, weight: .semibold))
                        }.frame(height: 44)
                        
                        HStack(alignment: .center, spacing: 8) {
                            HStack(spacing: 0) {
                                TextField("Enter your preferred username", text: $username)
                                    .font(.system(size: 15, weight: .regular))
                                    .onChange(of: username) { newValue in
                                        onboardingModel.dataYourProfile.userName = username
                                    }
                            }.frame(height: 44)
                                .padding(.horizontal)
                                .background(Color.white)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(lineWidth: 1)
                                        .foregroundColor(.white)
                                    
                                )
                            
//                            Button {
//                                //Todo
//                            } label: {
//                                Text("Check Availability")
//                                    .foregroundColor(.white)
//                                    .font(.system(size: 15, weight: .semibold))
//                                    .frame(height: 20)
//                                    .padding(.vertical, 12)
//                                    .padding(.horizontal)
//                                    .background(
//                                        RoundedRectangle(cornerRadius: 8)
//                                            .fill(Color.theme.philippineGray3)
//                                    )
//                                
//                            }
                        }.frame(height: 44)
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(spacing: 16) {
                            Text("First Name").font(.system(size: 15, weight: .semibold))
                        }.frame(height: 44)
                        
                        HStack(spacing: 8) {
                            TextField("Enter your first name", text: $firstName)
                                .font(.system(size: 15, weight: .regular))
                                .onChange(of: firstName) { newValue in
                                    onboardingModel.dataYourProfile.firstName = newValue
                                }
                        }.frame(height: 44)
                            .padding(.horizontal)
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(lineWidth: 1)
                                    .foregroundColor(.white)
                                
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(spacing: 16) {
                            Text("Last Name").font(.system(size: 15, weight: .semibold))
                        }.frame(height: 44)
                        
                        HStack(spacing: 8) {
                            TextField("Enter your last name", text: $lastName)
                                .font(.system(size: 15, weight: .regular))
                                .onChange(of: lastName) { newValue in
                                    onboardingModel.dataYourProfile.lastName = newValue
                                }
                        }.frame(height: 44)
                            .padding(.horizontal)
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(lineWidth: 1)
                                    .foregroundColor(.white)
                                
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(spacing: 16) {
                            Text("Airline").font(.system(size: 15, weight: .semibold))
                        }.frame(height: 44)
                        
                        HStack(spacing: 8) {
                            Picker("", selection: $selectedAirline) {
                                ForEach(ALTN_DROP_DOWN, id: \.self) {
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
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(spacing: 16) {
                            Text("Mobile").font(.system(size: 15, weight: .semibold))
                        }.frame(height: 44)
                        
                        HStack(spacing: 8) {
                            HStack(spacing: 0) {
                                Picker("", selection: $selectedMobile) {
                                    ForEach(DataCountryDropdown, id: \.self) {
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
                            
                            HStack(spacing: 8) {
                                TextField("Enter your mobile", text: $phone)
                                    .font(.system(size: 15, weight: .regular))
                                    .onChange(of: phone) { newValue in
                                        onboardingModel.dataYourProfile.mobile.number = newValue
                                    }
                            }.frame(height: 44)
                                .padding(.horizontal)
                                .background(Color.white)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(lineWidth: 1)
                                        .foregroundColor(.white)
                                    
                                )
                        }.frame(height: 44)
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(spacing: 16) {
                            Text("Email").font(.system(size: 15, weight: .semibold))
                        }.frame(height: 44)
                        
                        HStack(spacing: 8) {
                            TextField("", text: $email).font(.system(size: 15, weight: .regular)).foregroundColor(Color.black).disabled(true)
                        }.frame(height: 44)
                            .padding(.horizontal)
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(lineWidth: 1)
                                    .foregroundColor(.white)
                                
                            )
                    }
                    
                    HStack(alignment: .center) {
                        Text("Subscribe to Atlas update emails").font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(Color.black)
                        Text("Get the latest news about Atlas features and product updates.").font(.system(size: 13, weight: .regular))
                            .foregroundStyle(Color.black)
                        
                        Spacer()
                        
                        Toggle(isOn: $showUTC) {
                            Text("").font(.system(size: 15, weight: .regular))
                                .foregroundStyle(Color.black)
                        }.fixedSize(horizontal: true, vertical: false)
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
        }.onAppear {
            selectedAirline = ALTN_DROP_DOWN.first ?? ""
            selectedMobile = DataCountryDropdown.first ?? ""
            onboardingModel.dataYourProfile.email = email
            onboardingModel.dataYourProfile.airline = selectedAirline
            onboardingModel.dataYourProfile.mobile.country = selectedMobile
        }
        .onChange(of: selectedAirline) { newValue in
            onboardingModel.dataYourProfile.airline = newValue
        }
        .onChange(of: selectedMobile) { newValue in
            onboardingModel.dataYourProfile.mobile.country = newValue
        }
        .onChange(of: showUTC) { newValue in
            onboardingModel.dataYourProfile.subscribe = newValue ? "1" : "0"
        }
    }
}
