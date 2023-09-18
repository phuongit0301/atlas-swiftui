//
//  TurbulencePopoverView.swift
//  ATLAS
//
//  Created by phuong phan on 17/09/2023.
//

import SwiftUI

struct TurbulencePopoverView: View {
    @Binding var isShowing: Bool
    @EnvironmentObject var mapIconModel: MapIconModel
    @State var selectedWaypoint: String?
    
    @State var selectedModerate: ModerateDataDropDown = ModerateDataDropDown.item1
    @State var flightLevel: String = "0000"
    @State var tfPost: String = ""
    @State private var selectionOutputFlight = "Select Flight Level"
    @State var isShowFlightModal = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Button(action: {
                    self.isShowing.toggle()
                }) {
                    Text("Cancel").font(Font.custom("SF Pro", size: 15).weight(.regular)).foregroundColor(Color.theme.azure)
                }
                Spacer()
                
                Text("Turbulence").font(Font.custom("SF Pro", size: 15).weight(.semibold)).foregroundColor(Color.black)
                
                Spacer()
                
                Button(action: {
                }) {
                    Text("Done").font(Font.custom("SF Pro", size: 15).weight(.semibold)).foregroundColor(Color.theme.azure)
                }.opacity(0)
            }.background(.white)
                .roundedCorner(12, corners: [.topLeft, .topRight])
            
            Picker("Select Waypoint", selection: $selectedWaypoint) {
                Text("Select Waypoint").tag("").font(.system(size: 15, weight: .regular)).foregroundColor(Color.theme.azure)
                ForEach(mapIconModel.dataWaypoint, id: \.self) {
                    Text($0).tag($0)
                }
            }.pickerStyle(MenuPickerStyle())
                .padding(.leading, -12)
            
            HStack {
                EnrouteButtonTimeStepper(onToggle: onFlight, value: selectionOutputFlight, index: .constant(0)).fixedSize().id(UUID())
            }
            
            HStack {
                Text("Severity").font(.system(size: 15, weight: .regular)).foregroundColor(Color.black)
                
                Spacer()
                
                Picker("", selection: $selectedModerate) {
                    ForEach(ModerateDataDropDown.allCases, id: \.self) {
                        Text($0.rawValue).tag($0.rawValue).font(.system(size: 15, weight: .regular)).foregroundColor(Color.black)
                    }
                }.pickerStyle(MenuPickerStyle())
                
                Button(action: {
                    //Todo
                }, label: {
                    Text("Post").font(.system(size: 15, weight: .regular)).foregroundColor(Color.white)
                }).padding(.vertical, 4)
                    .padding(.horizontal, 24)
                    .background(Color.theme.philippineGray3)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.theme.coralRed1, lineWidth: 0))
            }
            
        }.padding()
            .onAppear {
                selectedWaypoint = mapIconModel.dataWaypoint.first
            }
            .formSheet(isPresented: $isShowFlightModal) {
                EnrouteModalWheelAfl(isShowing: $isShowFlightModal, selectionInOut: $selectionOutputFlight, defaultValue: .constant("00"))
            }
    }
    
    func onFlight(_ index: Int) {
        self.isShowFlightModal.toggle()
    }
}
