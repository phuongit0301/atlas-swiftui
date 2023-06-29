//
//  CustomStepper.swift
//  ATLAS
//
//  Created by phuong phan on 28/06/2023.
//

import SwiftUI

struct CustomButton<Label: View>: View {
    let onPress: (() -> Void)
    @ViewBuilder var label: Label
    
    var body: some View {
        Button(action: { onPress() }, label: {
            label
        }).buttonStyle(.plain)
    }
}

struct CustomStepper: View {
    @ObservedObject var stepperObj = StepperObject()
    @Binding var value: String
    @State var color: Color = Color.theme.azure
    
    var body: some View {
        HStack {
            Text("\(pad(stepperObj.hours)):\(pad(stepperObj.minutes))").foregroundColor(color).font(.system(size: 17, weight: .regular))
            
            VStack(spacing: 5) {
                CustomButton(onPress: increment, label: {
                    Image(systemName: "chevron.up").foregroundColor(Color.theme.azure)
                })

                CustomButton(onPress: decrement, label: {
                    Image(systemName: "chevron.down").foregroundColor(Color.theme.azure)
                })
            }.onAppear {
                if value.contains(":") {
                    let array = value.components(separatedBy: ":")
                    if array.count >= 0 {
                        self.stepperObj.hours = Int(array[0]) ?? 0
                    }
                    
                    if array.count >= 1 {
                        self.stepperObj.minutes = Int(array[1]) ?? 0
                    }
                }
            }
        }
    }
    
    func increment() {        
        if (self.stepperObj.minutes + 1 == 60) {
            self.stepperObj.minutes = 0
            self.stepperObj.hours += 1
        } else {
            self.stepperObj.minutes += self.stepperObj.step
        }
    }
    
    func decrement() {
        if self.stepperObj.hours == 0 && self.stepperObj.minutes == 0 {
            return
        }
        
        if (self.stepperObj.minutes - 1 == 0) {
            self.stepperObj.minutes = 59
            self.stepperObj.hours -= 1
        } else {
            self.stepperObj.minutes += self.stepperObj.step
        }
    }
    
    func pad(_ t: Int) -> String {
        return t < 10 ? "0\(t)" : "\(t)";
    }
}
