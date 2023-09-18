//
//  RunwayPopoverView.swift
//  ATLAS
//
//  Created by phuong phan on 17/09/2023.
//

import SwiftUI

struct RunwayPopoverView: View {
    @Binding var isShowing: Bool
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @State var selectedStation: String?
    
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
            
            Picker("", selection: $selectedStation) {
                Text("Select Station").tag("").font(.system(size: 15, weight: .regular)).foregroundColor(Color.theme.azure)
                ForEach(coreDataModel.dataAirportColorMap, id: \.self) {
                    Text($0.airportId ?? "").tag($0.airportId)
                }
            }.pickerStyle(MenuPickerStyle())
                .padding(.leading, -12)
            
            HStack {
                Text("Dry")
                    .foregroundColor(Color.black)
                    .font(.system(size: 15))
                    .frame(height: 44)
                
                Spacer()
                
                Button(action: {
                    //Todo
                }, label: {
                    Text("Post").font(.system(size: 15, weight: .regular)).foregroundColor(Color.white)
                }).padding(.vertical, 4)
                    .padding(.horizontal, 24)
                    .background(Color.theme.philippineGray3)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.theme.coralRed1, lineWidth: 0))
            }.frame(maxWidth: .infinity)
            
            HStack {
                Text("Damp")
                    .foregroundColor(Color.black)
                    .font(.system(size: 15))
                    .frame(height: 44)
                
                Spacer()
                
                Button(action: {
                    //Todo
                }, label: {
                    Text("Post").font(.system(size: 15, weight: .regular)).foregroundColor(Color.white)
                }).padding(.vertical, 4)
                    .padding(.horizontal, 24)
                    .background(Color.theme.philippineGray3)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.theme.coralRed1, lineWidth: 0))
            }.frame(maxWidth: .infinity)
            
            HStack {
                Text("Wet")
                    .foregroundColor(Color.black)
                    .font(.system(size: 15))
                    .frame(height: 44)
                
                Spacer()
                
                Button(action: {
                    //Todo
                }, label: {
                    Text("Post").font(.system(size: 15, weight: .regular)).foregroundColor(Color.white)
                }).padding(.vertical, 4)
                    .padding(.horizontal, 24)
                    .background(Color.theme.philippineGray3)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.theme.coralRed1, lineWidth: 0))
            }.frame(maxWidth: .infinity)
            
            HStack {
                Text("Slippery")
                    .foregroundColor(Color.black)
                    .font(.system(size: 15))
                    .frame(height: 44)
                
                Spacer()
                
                Button(action: {
                    //Todo
                }, label: {
                    Text("Post").font(.system(size: 15, weight: .regular)).foregroundColor(Color.white)
                }).padding(.vertical, 4)
                    .padding(.horizontal, 24)
                    .background(Color.theme.philippineGray3)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.theme.coralRed1, lineWidth: 0))
            }.frame(maxWidth: .infinity)
        }.padding()
            .padding()
                .onAppear() {
                    if coreDataModel.dataAirportColorMap.count > 0 {
                        selectedStation = coreDataModel.dataAirportColorMap.first?.airportId
                    }
                }
    }
}
