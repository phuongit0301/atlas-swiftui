//
//  EnrouteModalWheel.swift
//  ATLAS
//
//  Created by phuong phan on 01/07/2023.
//

import SwiftUI

struct EnrouteModalWheelTime: View {
    @Binding var isShowing: Bool
    @Binding var selectionOutput: Date
    @State private var selection = Date()
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Button(action: {
                    self.isShowing.toggle()
                }) {
                    Text("Cancel").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                }
                Spacer()
                
                Text("Update").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.black)
                
                Spacer()
                Button(action: {
                    self.selectionOutput = selection
                    self.isShowing = false
                }) {
                    Text("Done").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                }
            }.padding()
                .background(.white)
                .roundedCorner(12, corners: [.topLeft, .topRight])
            
            HStack {
                DatePicker("", selection: $selection, displayedComponents: [.hourAndMinute]).labelsHidden().datePickerStyle(WheelDatePickerStyle())
                    .environment(\.locale, Locale(identifier: "en_GB"))
            }.Print("hour=======\(selection)")
            Spacer()
        }.onAppear {
            self.selection = selectionOutput
        }
    }
}

// for afl: 2 wheel - A|B - A from 0 to 5, B from 0 to 90, increments of 10 (you can refer to ModalPickerMultiple for reference)
// todo check default value can render if the selection is ""
struct EnrouteModalWheelAfl: View {
    @Binding var isShowing: Bool
    @Binding var selectionInOut: String
    var defaultValue: String
    @State var itemsA: ClosedRange<Int> = 0...5
    @State var itemsB: ClosedRange<Int> = 0...9
    @State private var selectionA = 0
    @State private var selectionB = 0
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Button(action: {
                    self.isShowing.toggle()
                }) {
                    Text("Cancel").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                }
                Spacer()
                
                Text("Update").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.black)
                
                Spacer()
                Button(action: {
                    self.selectionInOut = "\(selectionA)\(selectionB)0"
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
                        Text("\($0 * 10)").tag("\($0 * 10)")
                    }
                }.pickerStyle(.wheel)
                .labelsHidden()
            }
            Spacer()
        }.onAppear {
            if selectionInOut.count > 1 {
                self.selectionA = Int(selectionInOut.suffix(selectionInOut.count).prefix(1)) ?? 0
                self.selectionB = Int(selectionInOut.suffix(selectionInOut.count - 1).prefix(1)) ?? 0
            } else {
                self.selectionA = Int(defaultValue.suffix(defaultValue.count).prefix(1)) ?? 0
                self.selectionB = Int(defaultValue.suffix(defaultValue.count - 1).prefix(1)) ?? 0
            }
        }
    }
}

// for oat: 2 digit wheel A|B, - A from -9 to 9, B from 0 to 9.
// todo check the modal split if correct
struct EnrouteModalWheelOat: View {
    @Binding var isShowing: Bool
    @Binding var selectionInOut: String
    @State var itemsA: ClosedRange<Int> = -9...9
    @State var itemsB: ClosedRange<Int> = 0...9
    @State private var selectionA = 0
    @State private var selectionB = 0
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Button(action: {
                    self.isShowing.toggle()
                }) {
                    Text("Cancel").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                }
                Spacer()
                
                Text("Update").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.black)
                
                Spacer()
                Button(action: {
                    self.selectionInOut = "\(selectionA)\(selectionB)"
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
            }
            Spacer()
        }.onAppear {
            if selectionInOut.count > 1 {
                self.selectionA = Int(selectionInOut.suffix(selectionInOut.count).prefix(1)) ?? 0
                self.selectionB = Int(selectionInOut.suffix(selectionInOut.count - 1).prefix(1)) ?? 0
            }
        }
    }
}

// for awind: 6 digit wheel A|B|C|D|E|F|G - A from 0 to 3, B from 0 to 6, C from 0 to 9, D,E,F,G each from 0 to 9
// todo check default value can render if the selection is ""
struct EnrouteModalWheelAWind: View {
    @Binding var isShowing: Bool
    @Binding var selectionInOut: String
    var defaultValue: String
    @State var itemsA: ClosedRange<Int> = 0...3
    @State var itemsB: ClosedRange<Int> = 0...6
    @State var itemsC: ClosedRange<Int> = 0...9
    @State var itemsD: ClosedRange<Int> = 0...9
    @State var itemsE: ClosedRange<Int> = 0...9
    @State var itemsF: ClosedRange<Int> = 0...9
    @State private var selectionA = 0
    @State private var selectionB = 0
    @State private var selectionC = 0
    @State private var selectionD = 0
    @State private var selectionE = 0
    @State private var selectionF = 0
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Button(action: {
                    self.isShowing.toggle()
                }) {
                    Text("Cancel").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                }
                Spacer()
                
                Text("Update").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.black)
                
                Spacer()
                Button(action: {
                    self.selectionInOut = "\(selectionA)\(selectionB)\(selectionC)\(selectionD)\(selectionE)\(selectionF)"
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
                
                Picker(selection: $selectionF, label: Text("")) {
                    ForEach(itemsF, id: \.self) {
                        Text("\($0)").tag("\($0)")
                    }
                }.pickerStyle(.wheel)
                .labelsHidden()
            }
            Spacer()
        }.onAppear {
            if selectionInOut != "N.A" && selectionInOut.count > 1 {
                self.selectionA = Int(selectionInOut.suffix(selectionInOut.count).prefix(1)) ?? 0
                self.selectionB = Int(selectionInOut.suffix(selectionInOut.count - 1).prefix(1)) ?? 0
                self.selectionC = Int(selectionInOut.suffix(selectionInOut.count - 2).prefix(1)) ?? 0
                self.selectionD = Int(selectionInOut.suffix(selectionInOut.count - 3).prefix(1)) ?? 0
                self.selectionE = Int(selectionInOut.suffix(selectionInOut.count - 4).prefix(1)) ?? 0
                self.selectionF = Int(selectionInOut.suffix(selectionInOut.count - 5).prefix(1)) ?? 0
            } else {
                self.selectionA = Int(defaultValue.suffix(defaultValue.count).prefix(1)) ?? 0
                self.selectionB = Int(defaultValue.suffix(defaultValue.count - 1).prefix(1)) ?? 0
                self.selectionC = Int(defaultValue.suffix(defaultValue.count - 2).prefix(1)) ?? 0
                self.selectionD = Int(defaultValue.suffix(defaultValue.count - 3).prefix(1)) ?? 0
                self.selectionE = Int(defaultValue.suffix(defaultValue.count - 4).prefix(1)) ?? 0
                self.selectionF = Int(defaultValue.suffix(defaultValue.count - 5).prefix(1)) ?? 0
            }
        }
    }
}

// for afrm: 6 digit wheel A|B|C|D|E|F|G - A,B,C,D,E,F,G from 0 to 9
struct EnrouteModalWheelAfrm: View {
    @Binding var isShowing: Bool
    @Binding var selectionInOut: String
    @State var itemsA: ClosedRange<Int> = 0...9
    @State private var selectionA = 0
    @State private var selectionB = 0
    @State private var selectionC = 0
    @State private var selectionD = 0
//    @State private var selectionE = 0
//    @State private var selectionF = 0
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Button(action: {
                    self.isShowing.toggle()
                }) {
                    Text("Cancel").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                }
                Spacer()
                
                Text("Update").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.black)
                
                Spacer()
                Button(action: {
                    self.selectionInOut = "\(selectionA)\(selectionB)\(selectionC).\(selectionD)"
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
                    ForEach(itemsA, id: \.self) {
                        Text("\($0)").tag("\($0)")
                    }
                }.pickerStyle(.wheel)
                .labelsHidden()
                
                Picker(selection: $selectionC, label: Text("")) {
                    ForEach(itemsA, id: \.self) {
                        Text("\($0)").tag("\($0)")
                    }
                }.pickerStyle(.wheel)
                .labelsHidden()
                
                // decimal point
                Text(".")
                
                Picker(selection: $selectionD, label: Text("")) {
                    ForEach(itemsA, id: \.self) {
                        Text("\($0)").tag("\($0)")
                    }
                }.pickerStyle(.wheel)
                .labelsHidden()
                
//                Picker(selection: $selectionE, label: Text("")) {
//                    ForEach(itemsA, id: \.self) {
//                        Text("\($0)").tag("\($0)")
//                    }
//                }.pickerStyle(.wheel)
//                .labelsHidden()
//
//                Picker(selection: $selectionF, label: Text("")) {
//                    ForEach(itemsA, id: \.self) {
//                        Text("\($0)").tag("\($0)")
//                    }
//                }.pickerStyle(.wheel)
//                .labelsHidden()
            }
            Spacer()
        }.onAppear {
            if selectionInOut != "N.A" && selectionInOut.count > 1 {
                self.selectionA = Int(selectionInOut.suffix(selectionInOut.count).prefix(1)) ?? 0
                self.selectionB = Int(selectionInOut.suffix(selectionInOut.count - 1).prefix(1)) ?? 0
                self.selectionC = Int(selectionInOut.suffix(selectionInOut.count - 2).prefix(1)) ?? 0
                self.selectionD = Int(selectionInOut.suffix(selectionInOut.count - 4).prefix(1)) ?? 0
//                self.selectionE = Int(selectionInOut.suffix(selectionInOut.count - 4).prefix(1)) ?? 0
//                self.selectionF = Int(selectionInOut.suffix(selectionInOut.count - 5).prefix(1)) ?? 0
            }
        }
    }
}
