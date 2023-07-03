//
//  ModalPicker.swift
//  ATLAS
//
//  Created by phuong phan on 01/07/2023.
//

import SwiftUI

struct ModalPicker: View {
    @Binding var selectionOutput: Int
    @Binding var isShowing: Bool
    @State var selection: Int = 0
    @Binding var target: String
    @State var items: ClosedRange<Int> = 0...120
    @State var header = ""
    
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
                    self.selectionOutput = selection
                    self.isShowing = false
                }) {
                    Text("Done").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                }
            }.padding()
                .background(.white)
                .roundedCorner(12, corners: [.topLeft, .topRight])
            
            VStack {
                Picker(selection: $selection, label: Text("")) {
                    ForEach(items, id: \.self) {
                        Text("\($0)")
                            .tag("\($0)")
                    }
                }.pickerStyle(.wheel)
                .labelsHidden()
                
                Spacer()
            }
            Spacer()
        }.background(Color.black.opacity(0.3))
            .onAppear {
                switch self.target {
                    case "IncludedTaxi":
                        self.header = "Arrival Delays"
                        self.items = 0...120
                    case "ArrDelays":
                        self.header = "Additional Taxi"
                        self.items = 0...60
                    case "TrackShortening":
                        self.header = "Track Shortening Savings"
                        self.items = -30...0
                    case "EnrouteWeather":
                        self.header = "Enroute weather deviation"
                        self.items = 0...30
                    case "ReciprocalRWY":
                        self.header = "Reciprocal rwy"
                        self.items = -15...15
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
