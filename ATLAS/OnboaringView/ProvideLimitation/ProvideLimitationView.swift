//
//  ProvideLimitationView.swift
//  ATLAS
//
//  Created by phuong phan on 01/10/2023.
//

import SwiftUI

struct ProvideLimitationView: View {
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
    
    @State var dataModel = [IProvideLimitation]()
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(alignment: .leading) {
                    HStack(alignment: .center) {
                        Text("Provide your limitations").font(.system(size: 20, weight: .semibold)).foregroundColor(Color.black)
                        
                        Spacer()
                        
                        Button(action: {
                            let obj = IProvideLimitation(limitation: 0, duration: 0, startDate: "", endDate: "", completed: 0)
                            dataModel.append(obj)
                        }, label: {
                            Text("Add Limitation").font(.system(size: 15, weight: .regular)).foregroundStyle(Color.theme.azure)
                        })
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        if dataModel.count > 0 {
                            ForEach(dataModel, id: \.self) {item in
                                LimitationRowView(dataModel: $dataModel, item: item, width: proxy.size.width)
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
