//
//  CompleteYourProfileView.swift
//  ATLAS
//
//  Created by phuong phan on 01/10/2023.
//

import SwiftUI

struct CompleteYourProfileView: View {
    @State private var selected: Int = 0
    @State private var username = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var phone = ""
    @State private var email = ""
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
                                TextField("Enter your preferred username", text: $username).font(.system(size: 15, weight: .regular))
                            }.frame(height: 44)
                                .padding(.horizontal)
                                .background(Color.white)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(lineWidth: 1)
                                        .foregroundColor(.white)
                                    
                                )
                            
                            Button {
                                //Todo
                            } label: {
                                Text("Check Availability")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15, weight: .semibold))
                                    .frame(height: 20)
                                    .padding(.vertical, 12)
                                    .padding(.horizontal)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.theme.philippineGray3)
                                    )
                                
                            }
                        }.frame(height: 44)
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(spacing: 16) {
                            Text("First Name").font(.system(size: 15, weight: .semibold))
                        }.frame(height: 44)
                        
                        HStack(spacing: 8) {
                            TextField("Enter your first name", text: $firstName).font(.system(size: 15, weight: .regular))
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
                            TextField("Enter your last name", text: $firstName).font(.system(size: 15, weight: .regular))
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
                                ForEach(DataAirlineDropdown, id: \.self) {
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
                                TextField("Enter your mobile", text: $firstName).font(.system(size: 15, weight: .regular))
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
                            TextField("adil@accumulus.sg", text: $firstName).font(.system(size: 15, weight: .regular)).disabled(true)
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
        }
    }
}
