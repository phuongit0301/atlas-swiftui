//
//  Sidebar.swift
//  ATLAS
//
//  Created by phuong phan on 16/06/2023.
//

import Foundation
import SwiftUI

struct Sidebar: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var sideMenuState: SideMenuModelState
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) var presentation
    
    @State private var showUpcoming = true
    @State private var showCompleted = true
    
    @State private var isActive = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .center, spacing: 0) {
                VStack(spacing: 0) {
                    Text("\(coreDataModel.dataUser?.firstName ?? "") \(coreDataModel.dataUser?.lastName ?? "")").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.black)
                    Text(coreDataModel.dataUser?.airline ?? "").font(.system(size: 15, weight: .regular)).foregroundColor(Color.black)
                }.padding(.vertical, 8)
                    .padding(.horizontal, 14)
                    .background(Color.theme.tealDeer.opacity(0.25))
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.theme.electricBlue, lineWidth: 2))
            }.padding(.vertical)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 4)
            
            Text("Home")
                .foregroundColor(Color.theme.eerieBlack)
                .font(.system(size: 20, weight: .semibold))
                .padding(.horizontal)
                .frame(height: 44)
                .onTapGesture {
                    coreDataModel.selectedEvent = nil
                    coreDataModel.isEventActive = false
                    dismiss()
                }

            
            ScrollView {
                VStack (alignment: .leading, spacing: 8) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Upcoming Flights")
                                .foregroundColor(Color.theme.eerieBlack)
                                .font(.system(size: 20, weight: .semibold))
                            
                            Spacer()
                            
                            Image(systemName: showUpcoming ? "chevron.down" : "chevron.up")
                                .foregroundColor(Color.theme.azure)
                                .font(.system(size: 15))
                        }.frame(height: 44)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                showUpcoming.toggle()
                            }
                        
                        if showUpcoming && coreDataModel.dataEventUpcoming.count > 0 {
                            ForEach(coreDataModel.dataEventUpcoming.indices, id: \.self) { index in
                                SidebarItem(item: $coreDataModel.dataEventUpcoming[index], selectedItem: $coreDataModel.selectedEvent, isEventActive: $coreDataModel.isEventActive)
                            }
                        }
                    }.padding(.horizontal)
                        .frame(maxWidth: .infinity)
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Completed Flights")
                                .foregroundColor(Color.theme.eerieBlack)
                                .font(.system(size: 20, weight: .semibold))
                                
                            Spacer()
                            
                            Image(systemName: showCompleted ? "chevron.down" : "chevron.up")
                                .foregroundColor(Color.theme.azure)
                                .font(.system(size: 15))
                        }.frame(height: 44)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                showCompleted.toggle()
                            }
                        
                        if showCompleted && coreDataModel.dataEventCompleted.count > 0 {
                            ForEach(coreDataModel.dataEventCompleted.indices, id: \.self) { index in
                                SidebarItem(item: $coreDataModel.dataEventCompleted[index], selectedItem: $coreDataModel.selectedEvent, isEventActive: $coreDataModel.isEventActive)
                            }
                        }
                    }.padding(.horizontal)
                    
//                    VStack(alignment: .leading) {
//                        HStack {
//                            Text("Logbook")
//                                .foregroundColor(Color.theme.eerieBlack)
//                                .font(.system(size: 20, weight: .semibold))
//
//                            Spacer()
//                        }.frame(height: 44)
//                    }.padding(.horizontal)
                }
            }
        }.background(Color.theme.cultured)
//            .background(
//                NavigationLink(destination: HomeSectionView(), isActive: $isActive) { EmptyView() }
//            )
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // todo
                    }) {
                        Image(systemName: "gear").foregroundColor(Color.theme.philippineGray3).font(.system(size: 22))
                    }
                }
                ToolbarItem(placement: .principal) {
//                    Image("logo")
//                        .frame(width: 100, height: 32)
//                        .scaledToFit()
//                        .aspectRatio(contentMode: .fit)
//                        .padding(20)
                }
            }
    }
}
