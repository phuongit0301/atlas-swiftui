//
//  ProvideRecencyView.swift
//  ATLAS
//
//  Created by phuong phan on 01/10/2023.
//

import SwiftUI

struct ProvideRecencyView: View {
    @EnvironmentObject var onboardingModel: OnboardingModel
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(alignment: .leading) {
                    HStack(alignment: .center) {
                        Text("Provide your recencies").font(.system(size: 20, weight: .semibold)).foregroundColor(Color.black)
                        
                        Spacer()
                        
                        Button(action: {
                            let obj = IProvideRecency(remoteId: UUID().uuidString, type: "", modelName: "", requirement: "", frequency: "", periodStart: "", completed: "")
                            onboardingModel.dataModelRecency.append(obj)
                        }, label: {
                            Text("Add Item").font(.system(size: 15, weight: .regular)).foregroundStyle(Color.theme.azure)
                        })
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        if onboardingModel.dataModelRecency.count > 0 {
                            ForEach(onboardingModel.dataModelRecency, id: \.self) {item in
                                RecencyRowView(dataModel: $onboardingModel.dataModelRecency, item: item, width: proxy.size.width)
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
