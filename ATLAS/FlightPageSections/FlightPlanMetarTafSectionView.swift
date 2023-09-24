//
//  FlightPlanMetarTafSectionView.swift
//  ATLAS
//
//  Created by phuong phan on 24/9/23.
//

import Foundation
import SwiftUI

struct FlightPlanMetarTafSectionView: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @State var showLoading = false
    
    @State private var isDepShow = true
    @State private var isEnrShow = true
    @State private var isArrShow = true
    @State private var isDestShow = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center) {
                Text("METAR & TAF")
                    .font(.system(size: 17, weight: .semibold))
                    .padding(.leading, 30)
                Spacer()
                
                Button(action: {
                    onSyncData()
                }, label: {
                    HStack {
                        if showLoading {
                            ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.white)).padding(.leading)
                        }
                        Text("Refresh").font(.system(size: 17, weight: .regular))
                            .foregroundColor(Color.white)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                    }
                }).background(Color.theme.azure)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.white, lineWidth: 0)
                    )
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .disabled(showLoading)
            }
            
            HStack {
                Text("Waypoints")
                    .font(.system(size: 17, weight: .semibold))
                    .padding(.leading, 30)
                
                Spacer()
                
                Button(action: {
                    // Todo
                }, label: {
                    Text("Direct").font(.system(size: 17, weight: .regular))
                        .foregroundColor(Color.theme.azure)
                })
            }.padding(.trailing, 16)
            
            //scrollable outer list section
            List {
                Section(content: {
                    VStack(alignment: .leading, spacing: 32) {
                        HStack {
                            Text("Departure METAR & TAF").foregroundStyle(Color.black).font(.system(size: 15, weight: .semibold))
                            
                            if isDepShow {
                                Image(systemName: "chevron.up")
                                    .foregroundColor(Color.blue)
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fit)
                            } else {
                                Image(systemName: "chevron.down")
                                    .foregroundColor(Color.blue)
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fit)
                            }
                            
                        }.contentShape(Rectangle())
                            .onTapGesture {
                                self.isDepShow.toggle()
                            }
                        
                        if isDepShow {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("[STATION NAME]: ETD DD/MM/YY HHMM").font(.system(size: 15, weight: .semibold)).foregroundColor(Color.black)
                                
                                Text("METAR").font(.system(size: 15, weight: .semibold)).foregroundColor(Color.black)
                                
                                Divider().padding(.horizontal, -16)
                                
                                Text("XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX")
                                    .font(.system(size: 15, weight: .regular)).foregroundColor(Color.black)
                                
                                Text("TAF").font(.system(size: 15, weight: .semibold)).foregroundColor(Color.black)
                                
                                Divider().padding(.horizontal, -16)
                                
                                Text("XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX")
                                    .font(.system(size: 15, weight: .regular)).foregroundColor(Color.black)
                            }
                        }
                    }
                }).listRowSeparator(.hidden)
                
                Section(content: {
                    VStack(alignment: .leading, spacing: 32) {
                        HStack {
                            Text("Enroute Alternates METAR & TAF").foregroundStyle(Color.black).font(.system(size: 15, weight: .semibold))
                            
                            if isEnrShow {
                                Image(systemName: "chevron.up")
                                    .foregroundColor(Color.blue)
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fit)
                            } else {
                                Image(systemName: "chevron.down")
                                    .foregroundColor(Color.blue)
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fit)
                            }
                            
                        }.contentShape(Rectangle())
                            .onTapGesture {
                                self.isEnrShow.toggle()
                            }
                        
                        if isEnrShow {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("[STATION NAME]: ETD DD/MM/YY HHMM").font(.system(size: 15, weight: .semibold)).foregroundColor(Color.black)
                                
                                Text("METAR").font(.system(size: 15, weight: .semibold)).foregroundColor(Color.black)
                                
                                Divider().padding(.horizontal, -16)
                                
                                Text("XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX")
                                    .font(.system(size: 15, weight: .regular)).foregroundColor(Color.black)
                                
                                Text("TAF").font(.system(size: 15, weight: .semibold)).foregroundColor(Color.black)
                                
                                Divider().padding(.horizontal, -16)
                                
                                Text("XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX")
                                    .font(.system(size: 15, weight: .regular)).foregroundColor(Color.black)
                            }
                        }
                    }
                }).listRowSeparator(.hidden)
                
                Section(content: {
                    VStack(alignment: .leading, spacing: 32) {
                        HStack {
                            Text("Arrival METAR & TAF").foregroundStyle(Color.black).font(.system(size: 15, weight: .semibold))
                            
                            if isArrShow {
                                Image(systemName: "chevron.up")
                                    .foregroundColor(Color.blue)
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fit)
                            } else {
                                Image(systemName: "chevron.down")
                                    .foregroundColor(Color.blue)
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fit)
                            }
                            
                        }.contentShape(Rectangle())
                            .onTapGesture {
                                self.isArrShow.toggle()
                            }
                        
                        if isArrShow {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("[STATION NAME]: ETD DD/MM/YY HHMM").font(.system(size: 15, weight: .semibold)).foregroundColor(Color.black)
                                
                                Text("METAR").font(.system(size: 15, weight: .semibold)).foregroundColor(Color.black)
                                
                                Divider().padding(.horizontal, -16)
                                
                                Text("XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX")
                                    .font(.system(size: 15, weight: .regular)).foregroundColor(Color.black)
                                
                                Text("TAF").font(.system(size: 15, weight: .semibold)).foregroundColor(Color.black)
                                
                                Divider().padding(.horizontal, -16)
                                
                                Text("XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX")
                                    .font(.system(size: 15, weight: .regular)).foregroundColor(Color.black)
                            }
                        }
                    }
                }).listRowSeparator(.hidden)
                
                Section(content: {
                    VStack(alignment: .leading, spacing: 32) {
                        HStack {
                            Text("Destination Alternates METAR & TAF").foregroundStyle(Color.black).font(.system(size: 15, weight: .semibold))
                            
                            if isArrShow {
                                Image(systemName: "chevron.up")
                                    .foregroundColor(Color.blue)
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fit)
                            } else {
                                Image(systemName: "chevron.down")
                                    .foregroundColor(Color.blue)
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fit)
                            }
                            
                        }.contentShape(Rectangle())
                            .onTapGesture {
                                self.isArrShow.toggle()
                            }
                        
                        if isArrShow {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("[STATION NAME]: ETD DD/MM/YY HHMM").font(.system(size: 15, weight: .semibold)).foregroundColor(Color.black)
                                
                                Text("METAR").font(.system(size: 15, weight: .semibold)).foregroundColor(Color.black)
                                
                                Divider().padding(.horizontal, -16)
                                
                                Text("XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX")
                                    .font(.system(size: 15, weight: .regular)).foregroundColor(Color.black)
                                
                                Text("TAF").font(.system(size: 15, weight: .semibold)).foregroundColor(Color.black)
                                
                                Divider().padding(.horizontal, -16)
                                
                                Text("XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX XXXXXX")
                                    .font(.system(size: 15, weight: .regular)).foregroundColor(Color.black)
                            }
                        }
                    }
                }).listRowSeparator(.hidden)
            }.padding(.top, -8)
        }
    }
    
    func onSyncData() {
        Task {
            showLoading = true
            await coreDataModel.syncDataMetarTaf()
            showLoading = false
        }
    }
}

