//
//  WeatherPopoverView.swift
//  ATLAS
//
//  Created by phuong phan on 17/09/2023.
//

import SwiftUI

struct WeatherPopoverView: View {
    @Binding var isShowing: Bool
    @EnvironmentObject var mapIconModel: MapIconModel
    @State var selectedWaypoint: String = ""
    @State var selectedWaypointIndex: Int = 0
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
                
                Text("Weather").font(Font.custom("SF Pro", size: 15).weight(.semibold)).foregroundColor(Color.theme.azure)
                
                Spacer()
                Button(action: {
                    self.isShowing = false
                }) {
                    Text("Done").font(Font.custom("SF Pro", size: 15).weight(.semibold)).foregroundColor(Color.theme.azure)
                }
            }.background(.white)
                .roundedCorner(12, corners: [.topLeft, .topRight])
            
            Picker(selection: $selectedWaypointIndex, label: Text(selectedWaypoint).font(.system(size: 15, weight: .regular)).foregroundColor(Color.theme.azure)) {
                Text("Select Waypoint").tag("").font(.system(size: 15, weight: .regular)).foregroundColor(Color.theme.azure)
                ForEach(mapIconModel.dataWaypoint, id: \.self) {
                    Text($0).tag($0).font(.system(size: 15, weight: .regular)).foregroundColor(Color.theme.azure)
                }
            }.pickerStyle(MenuPickerStyle())
            .padding(.leading, -12)
        
            HStack {
                FlightLevelButtonTimeStepper(onToggle: onFlight, value: selectionOutputFlight, index: .constant(0)).fixedSize().id(UUID())
            }
            
            HStack {
                TextField("Write Post", text: $tfPost)
                    .font(.system(size: 15)).frame(maxWidth: .infinity)
                    .frame(height: 44)
                
                Button(action: {
                    //Todo
                }, label: {
                    Text("Post").font(.system(size: 15, weight: .regular)).foregroundColor(Color.white)
                }).padding(.vertical, 4)
                    .padding(.horizontal, 24)
                    .background(Color.theme.philippineGray3)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.theme.coralRed1, lineWidth: 0))
                    .cornerRadius(12)
            }
            
        }.padding()
            .onAppear {
                selectedWaypoint = mapIconModel.dataWaypoint.first ?? ""
            }
            .formSheet(isPresented: $isShowFlightModal) {
                EnrouteModalWheelAfl(isShowing: $isShowFlightModal, selectionInOut: $selectionOutputFlight, defaultValue: .constant("00"))
            }
    }
    
    func onFlight(_ index: Int) {
        self.isShowFlightModal.toggle()
    }
}
