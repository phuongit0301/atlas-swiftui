//
//  ModalPicker.swift
//  ATLAS
//
//  Created by phuong phan on 01/07/2023.
//

import SwiftUI

struct ModalPickerMultiple: View {
//    @Binding var selectionOutput: Any
    @Binding var isShowing: Bool
    @Binding var target: String
    @State var onSelectOutput: (_ selection1: Int, _ selection2: Int) -> Void
    
    @State var selection1: Int = 0
    @State var selection2: Int = 0
    
    @State var header = ""
    @State var items1: ClosedRange<Int> = 0...120
    @State var items2: ClosedRange<Int> = 0...120
    @State var items3: ClosedRange<Int> = 0...120
    @State var suffix = ""
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Button(action: {
                    self.isShowing.toggle()
                }) {
                    Text("Cancel").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                }
                Spacer()
                
                Text(header).font(.system(size: 17, weight: .semibold)).foregroundColor(Color.black)
                
                Spacer()
                Button(action: {
                    onSelectOutput(selection1, selection2)
                    
                    self.isShowing = false
                }) {
                    Text("Done").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                }
            }.padding()
                .background(.white)
                .roundedCorner(12, corners: [.topLeft, .topRight])
            
            VStack {
                HStack {
                    Picker(selection: $selection1, label: Text("")) {
                        ForEach(items1, id: \.self) {
                            if $0 <= 0 {
                                Text("\($0)000\(suffix)")
                                    .tag("\($0)")
                            } else {
                                Text("+\($0)000\(suffix)")
                                    .tag("+\($0)")
                            }
                        }
                    }.pickerStyle(.wheel)
                    .labelsHidden()
                    
                    Picker(selection: $selection2, label: Text("")) {
                        if selection1 < 0 {
                            ForEach(items3, id: \.self) {
                                Text("\($0)00\(suffix)")
                                    .tag("\($0)")
                            }
                        } else {
                            ForEach(items2, id: \.self) {
                                Text("+\($0)00\(suffix)")
                                    .tag("+\($0)")
                            }
                        }
                    }.pickerStyle(.wheel)
                    .labelsHidden()
                }
                
                
                Spacer()
            }
            Spacer()
        }.background(Color.black.opacity(0.3))
            .onAppear {
                switch self.target {
                    case "Others":
                        self.header = "Others"
                        self.suffix = "KG"
                        self.items1 = 0...10
                        self.items2 = 0...9
                        self.items3 = 0...9
                    case "FlightLevel":
                        self.header = "Flight Level Deviation"
                        self.suffix = "ft"
                        self.items1 = -10...10
                        self.items2 = 0...9
                        self.items3 = -9...0
                    default:
                        self.header = ""
                }
            }
            
    }
}

//struct ModalPicker_Previews: PreviewProvider {
//    static var previews: some View {
//        ModalPicker(items: 0...100, selectionOutput: .constant(0), isShowing: .constant(true))
//    }
//}
