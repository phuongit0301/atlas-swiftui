//
//  ProvideLimitationView.swift
//  ATLAS
//
//  Created by phuong phan on 01/10/2023.
//

import SwiftUI

struct ProvideLimitationView: View {
    @EnvironmentObject var onboardingModel: OnboardingModel
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(alignment: .leading) {
                    HStack(alignment: .center) {
                        Text("Provide your limitations").font(.system(size: 20, weight: .semibold)).foregroundColor(Color.black)
                        
                        Spacer()
                        
                        Button(action: {
                            let obj = IProvideLimitation(limitationFlight: "", limitation: "", duration: "", startDate: "", endDate: "", completed: "")
                            onboardingModel.dataModelLimitation.append(obj)
                        }, label: {
                            Text("Add Limitation").font(.system(size: 15, weight: .regular)).foregroundStyle(Color.theme.azure)
                        })
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        if onboardingModel.dataModelLimitation.count > 0 {
                            ForEach(onboardingModel.dataModelLimitation, id: \.self) {item in
                                LimitationRowView(dataModel: $onboardingModel.dataModelLimitation, item: item, width: proxy.size.width)
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
