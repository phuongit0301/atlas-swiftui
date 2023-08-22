//
//  FuelModal.swift
//  ATLAS
//
//  Created by phuong phan on 22/08/2023.
//

import SwiftUI

struct FuelModal: View {
    @EnvironmentObject var flightPlanDetailModel: FlightPlanDetailModel
    @Binding var isShowing: Bool
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Spacer()
                
                Text("Fuel Statistics").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.black)
                
                Spacer()
                Button(action: {
                    self.isShowing.toggle()
                }) {
                    Text("Done").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                }
            }.padding()
                .background(.white)
                .roundedCorner(12, corners: [.topLeft, .topRight])
            
            FuelView()
        }.onAppear {
            flightPlanDetailModel.isModal = true
        }.onDisappear {
            flightPlanDetailModel.isModal = false
        }
    }
    
    func dismiss() {
        // Call this function to dismiss the modal todo add dismiss function
    }
}

struct FuelModal_Previews: PreviewProvider {
    static var previews: some View {
        FuelModal(isShowing: .constant(true))
    }
}
