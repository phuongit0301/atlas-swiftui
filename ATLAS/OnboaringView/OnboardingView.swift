//
//  OnboardingView.swift
//  ATLAS
//
//  Created by phuong phan on 01/10/2023.
//

import SwiftUI

struct OnboardingView: View {
    @State private var selected: Int = 0
    
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
                        //Todo
                    } label: {
                        Text("Complete Onboarding")
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
                                    Image(systemName: "checkmark.circle").font(.system(size: 20)).foregroundColor(selected == index ? Color.white : Color.black)
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
                    }
                    
                }
            }.padding(.horizontal)
        }.background(Color.theme.antiFlashWhite)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
