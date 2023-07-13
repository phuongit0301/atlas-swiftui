//
//  FlightInformationView.swift
//  ATLAS
//
//  Created by phuong phan on 06/07/2023.
//

import SwiftUI

struct FlightInformationDetailSplitView: View {
    @State private var showUTC = true
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderViewSplit(isMenu: true, isNext: true)
            
            VStack {
                HStack(alignment: .center) {
                    Text("FLIGHT INFORMATION")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Color.black)
                    
                    Spacer()
                    
                    HStack {
                        Toggle(isOn: $showUTC) {
                            Text("Local").font(.system(size: 17, weight: .regular))
                                .foregroundStyle(Color.black)
                        }
                        Text("UTC").font(.system(size: 17, weight: .regular))
                            .foregroundStyle(Color.black)
                    }.fixedSize(horizontal: true, vertical: false)
                }
                
                List {
                    Section {
                        // grouped row using hstack
                        VStack(alignment: .leading) {
                            HStack(alignment: .center) {
                                Group {
                                    Text("Chocks Off")
                                        .font(.system(size: 17, weight: .semibold))
                                        .foregroundStyle(Color.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text("Chocks On")
                                        .font(.system(size: 17, weight: .semibold))
                                        .foregroundStyle(Color.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            Divider()
                            HStack(alignment: .center) {
                                Group {
                                    Text("XXXXXX")
                                        .font(.system(size: 17, weight: .regular))
                                        .foregroundStyle(Color.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text("XXXXXX")
                                        .font(.system(size: 17, weight: .regular))
                                        .foregroundStyle(Color.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                    }.listRowBackground(Color.theme.arsenic.opacity(0.33))
                    
                    Section {
                        // grouped row using hstack
                        VStack(alignment: .leading) {
                            HStack(alignment: .center) {
                                Group {
                                    Text("STD")
                                        .font(.system(size: 17, weight: .semibold))
                                        .foregroundStyle(Color.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text("STA")
                                        .font(.system(size: 17, weight: .semibold))
                                        .foregroundStyle(Color.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text("ETA")
                                        .font(.system(size: 17, weight: .semibold))
                                        .foregroundStyle(Color.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            Divider()
                            HStack(alignment: .center) {
                                Group {
                                    Text("XX:XX")
                                        .font(.system(size: 17, weight: .regular))
                                        .foregroundStyle(Color.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text("XX:XX")
                                        .font(.system(size: 17, weight: .regular))
                                        .foregroundStyle(Color.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text("XX:XX")
                                        .font(.system(size: 17, weight: .regular))
                                        .foregroundStyle(Color.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                    }.listRowBackground(Color.theme.arsenic.opacity(0.33))
                    
                    Section {
                        // grouped row using hstack
                        VStack(alignment: .leading) {
                            HStack(alignment: .center) {
                                Group {
                                    Text("Block Time")
                                        .font(.system(size: 17, weight: .semibold))
                                        .foregroundStyle(Color.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text("Flight Time")
                                        .font(.system(size: 17, weight: .semibold))
                                        .foregroundStyle(Color.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            Divider()
                            HStack(alignment: .center) {
                                Group {
                                    Text("XX:XX")
                                        .font(.system(size: 17, weight: .regular))
                                        .foregroundStyle(Color.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text("XX:XX")
                                        .font(.system(size: 17, weight: .regular))
                                        .foregroundStyle(Color.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                    }.listRowBackground(Color.theme.arsenic.opacity(0.33))
                    
                    Section {
                        // grouped row using hstack
                        VStack(alignment: .leading) {
                            HStack(alignment: .center) {
                                Group {
                                    Text("POB")
                                        .font(.system(size: 17, weight: .semibold))
                                        .foregroundStyle(Color.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            Divider()
                            HStack(alignment: .center) {
                                Group {
                                    Text("XXX")
                                        .font(.system(size: 17, weight: .regular))
                                        .foregroundStyle(Color.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                    }.listRowBackground(Color.theme.arsenic.opacity(0.33))
                    
                    Section {
                        // grouped row using hstack
                        VStack(alignment: .leading) {
                            HStack(alignment: .center) {
                                Group {
                                    Text("Route")
                                        .font(.system(size: 17, weight: .semibold))
                                        .foregroundStyle(Color.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            Divider()
                            HStack(alignment: .center) {
                                Group {
                                    Text("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
                                        .font(.system(size: 17, weight: .regular))
                                        .foregroundStyle(Color.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                    }.listRowBackground(Color.theme.arsenic.opacity(0.33))
                }.listStyle(.insetGrouped)
                    .padding(.leading, -16)
                    .padding(.trailing, -16)
                    .scrollContentBackground(.hidden)
            }.padding()
        }.background(Color.theme.antiFlashWhite)
            .navigationBarBackButtonHidden()
            .ignoresSafeArea()
    }
}

//struct FlightInformationDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        FlightInformationDetailView()
//    }
//}
