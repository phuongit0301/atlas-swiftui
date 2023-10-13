//
//  OnboardingTimeModalView.swift
//  ATLAS
//
//  Created by phuong phan on 01/10/2023.
//

import SwiftUI

struct OnboardingTimeModalView: View {
    @Binding var isShowing: Bool
    
    @Binding var selectionInOut: String
    @State var itemsA: ClosedRange<Int> = 0...9
    @State var itemsB: ClosedRange<Int> = 0...9
    @State var itemsC: ClosedRange<Int> = 0...9
    @State var itemsD: ClosedRange<Int> = 0...9
    @State var itemsE: ClosedRange<Int> = 0...9
    @State var itemsF: ClosedRange<Int> = 0...5
    @State var itemsG: ClosedRange<Int> = 0...9
    @State private var selectionA = 0
    @State private var selectionB = 0
    @State private var selectionC = 0
    @State private var selectionD = 0
    @State private var selectionE = 0
    @State private var selectionF = 0
    @State private var selectionG = 0
    
    var onChange: (_ value: String) -> Void
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Button(action: {
                    self.isShowing.toggle()
                }) {
                    Text("Cancel").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                }
                Spacer()
                
                Text("Onboarding").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.black)
                
                Spacer()
                Button(action: {
                    self.selectionInOut = "\(selectionA)\(selectionB)\(selectionC)\(selectionD)\(selectionE):\(selectionF)\(selectionG)"
                    onChange(selectionInOut)
                    self.isShowing = false
                }) {
                    Text("Done").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                }
            }.padding()
                .background(.white)
                .roundedCorner(12, corners: [.topLeft, .topRight])
            
            HStack {
                Picker(selection: $selectionA, label: Text("")) {
                    ForEach(itemsA, id: \.self) {
                        Text("\($0)").tag("\($0)")
                    }
                }.pickerStyle(.wheel)
                .labelsHidden()
                
                Picker(selection: $selectionB, label: Text("")) {
                    ForEach(itemsB, id: \.self) {
                        Text("\($0)").tag("\($0)")
                    }
                }.pickerStyle(.wheel)
                .labelsHidden()
                
                Picker(selection: $selectionC, label: Text("")) {
                    ForEach(itemsC, id: \.self) {
                        Text("\($0)").tag("\($0)")
                    }
                }.pickerStyle(.wheel)
                .labelsHidden()
                
                Picker(selection: $selectionD, label: Text("")) {
                    ForEach(itemsD, id: \.self) {
                        Text("\($0)").tag("\($0)")
                    }
                }.pickerStyle(.wheel)
                .labelsHidden()
                
                Picker(selection: $selectionE, label: Text("")) {
                    ForEach(itemsE, id: \.self) {
                        Text("\($0)").tag("\($0)")
                    }
                }.pickerStyle(.wheel)
                .labelsHidden()
                
                
                Text(":").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.black)
                
                Picker(selection: $selectionF, label: Text("")) {
                    ForEach(itemsF, id: \.self) {
                        Text("\($0)").tag("\($0)")
                    }
                }.pickerStyle(.wheel)
                .labelsHidden()
                
                Picker(selection: $selectionG, label: Text("")) {
                    ForEach(itemsG, id: \.self) {
                        Text("\($0)").tag("\($0)")
                    }
                }.pickerStyle(.wheel)
                .labelsHidden()
            }
            Spacer()
        }.onAppear {
            if selectionInOut.count >= 8 {
                self.selectionA = Int(selectionInOut.suffix(selectionInOut.count).prefix(1)) ?? 0
                self.selectionB = Int(selectionInOut.suffix(selectionInOut.count - 1).prefix(1)) ?? 0
                self.selectionC = Int(selectionInOut.suffix(selectionInOut.count - 2).prefix(1)) ?? 0
                self.selectionD = Int(selectionInOut.suffix(selectionInOut.count - 3).prefix(1)) ?? 0
                self.selectionE = Int(selectionInOut.suffix(selectionInOut.count - 4).prefix(1)) ?? 0
                self.selectionF = Int(selectionInOut.suffix(selectionInOut.count - 6).prefix(1)) ?? 0
                self.selectionG = Int(selectionInOut.suffix(selectionInOut.count - 7).prefix(1)) ?? 0
            }
        }
    }
}
