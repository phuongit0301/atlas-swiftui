//
//  HomeInformationView.swift
//  ATLAS
//
//  Created by phuong phan on 07/09/2023.
//

import SwiftUI

struct HomeInformationView: View {
    @State var isCollapseFlight = false
    @State var isCollapseExpiring = false
    @State var isCollapseLimitations = false

    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        HStack(alignment: .center) {
                            Text("Your Flights").font(.system(size: 20, weight: .semibold)).foregroundStyle(Color.black)
                            
                            Button(action: {
                                self.isCollapseFlight.toggle()
                            }, label: {
                                if isCollapseFlight {
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
                                
                            }).buttonStyle(PlainButtonStyle())
                        }
                        Spacer()
                        Button(action: {
                            self.isCollapseFlight.toggle()
                        }, label: {
                            Text("See All")
                                .font(.system(size: 17, weight: .regular)).textCase(nil)
                                .foregroundColor(Color.theme.azure)
                        }).buttonStyle(PlainButtonStyle())
                    }.contentShape(Rectangle())
                        .padding()
                    
                    if !isCollapseFlight {
                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                Text("Current COP: 234 SIN DXB LIS DXB SIN")
                                
                                Spacer()
                            }.padding(.vertical, 8)
                                .padding(.horizontal)
                                .background(Color.theme.azureishWhite1)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Group {
                                Text("UPCOMING")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(Color.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.top)
                                    .padding(.bottom, 8)
                                    .padding(.horizontal)
                                
                                
                                Divider()
                                
                                HStack {
                                    Text("29/09/23 LIS-DXB HHMM-HHMM")
                                        .font(.system(size: 17, weight: .regular))
                                        .foregroundColor(Color.black)
                                    
                                    Spacer()
                                    
                                    HStack {
                                        Text("EK424 / E-IHAL")
                                            .font(.system(size: 17, weight: .regular))
                                            .foregroundColor(Color.black)
                                        
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(Color.theme.arsenic.opacity(0.3))
                                            .frame(width: 11, height: 22)
                                            .scaledToFit()
                                            .aspectRatio(contentMode: .fit)
                                    }
                                }.padding(.vertical, 11)
                                    .padding(.horizontal)
                                
                                Divider()
                                
                                HStack {
                                    Text("01/10/23 DXB-SIN HHMM-HHMM ")
                                        .font(.system(size: 17, weight: .regular))
                                        .foregroundColor(Color.black)
                                    
                                    Spacer()
                                    
                                    HStack {
                                        Text("EK232 / S-WLW")
                                            .font(.system(size: 17, weight: .regular))
                                            .foregroundColor(Color.black)
                                        
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(Color.theme.arsenic.opacity(0.3))
                                            .frame(width: 11, height: 22)
                                            .scaledToFit()
                                            .aspectRatio(contentMode: .fit)
                                    }
                                }.padding(.vertical, 11)
                                    .padding(.horizontal)
                            }
                            
                            Group {
                                Text("COMPLETED")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(Color.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.top)
                                    .padding(.bottom, 8)
                                    .padding(.horizontal)
                                
                                
                                Divider()
                                
                                HStack {
                                    Text("29/09/23 LIS-DXB HHMM-HHMM")
                                        .font(.system(size: 17, weight: .regular))
                                        .foregroundColor(Color.black)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        //TODO
                                    }, label: {
                                        Text("Complete Report")
                                            .font(.system(size: 15, weight: .regular))
                                            .foregroundColor(Color.white)
                                            .padding(.vertical, 8)
                                            .padding(.horizontal)
                                    }).background(Color.theme.azure)
                                        .cornerRadius(8)
                                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 0))
                                        .buttonStyle(PlainButtonStyle())
                                    
                                }// End HStack
                                .padding(.vertical, 4)
                                .padding(.horizontal)
                                
                                Divider()
                                
                                HStack {
                                    Text("29/09/23 LIS-DXB HHMM-HHMM")
                                        .font(.system(size: 17, weight: .regular))
                                        .foregroundColor(Color.black)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        //TODO
                                    }, label: {
                                        Text("Report Submitted")
                                            .font(.system(size: 15, weight: .regular))
                                            .foregroundColor(Color.white)
                                            .padding(.vertical, 8)
                                            .padding(.horizontal, 16)
                                    }).background(Color.theme.philippineGray3)
                                        .cornerRadius(8)
                                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 0))
                                        .buttonStyle(PlainButtonStyle())
                                    
                                }// End HStack
                                .padding(.vertical, 4)
                                .padding(.horizontal)
                            }
                            
                        }.frame(maxWidth: .infinity)
                            .padding(.bottom)
                        
                    }
                    
                } // End View
                .background(Color.white)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.theme.gainsboro, lineWidth: 0.5))
                
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        HStack(alignment: .center) {
                            Text("Expiring Soon").font(.system(size: 20, weight: .semibold)).foregroundStyle(Color.black)
                            
                            Button(action: {
                                self.isCollapseExpiring.toggle()
                            }, label: {
                                if isCollapseExpiring {
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
                                
                            }).buttonStyle(PlainButtonStyle())
                        }
                        Spacer()
                        Button(action: {
                            self.isCollapseExpiring.toggle()
                        }, label: {
                            Text("See All")
                                .font(.system(size: 17, weight: .regular)).textCase(nil)
                                .foregroundColor(Color.theme.azure)
                        }).buttonStyle(PlainButtonStyle())
                    }.contentShape(Rectangle())
                        .padding()
                    
                    if !isCollapseExpiring {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Licence")
                                    .font(.system(size: 17, weight: .regular))
                                    .foregroundColor(Color.black)
                                
                                Spacer()
                                
                                HStack {
                                    Text("01/10/23")
                                        .font(.system(size: 17, weight: .regular))
                                        .foregroundColor(Color.black)
                                }
                            }.padding(.vertical, 8)
                                .padding(.horizontal)
                            
                            Divider()
                            
                            HStack {
                                Text("Base Check")
                                    .font(.system(size: 17, weight: .regular))
                                    .foregroundColor(Color.black)
                                
                                Spacer()
                                
                                HStack {
                                    Text("05/10/23")
                                        .font(.system(size: 17, weight: .regular))
                                        .foregroundColor(Color.black)
                                }
                            }.padding(.vertical, 8)
                                .padding(.horizontal)
                        }.frame(maxWidth: .infinity)
                            .padding(.bottom)
                        
                    }
                    
                }.background(Color.white)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.theme.gainsboro, lineWidth: 0.5))
                
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        HStack(alignment: .center) {
                            Text("Approaching Limitations").font(.system(size: 20, weight: .semibold)).foregroundStyle(Color.black)
                            
                            Button(action: {
                                self.isCollapseLimitations.toggle()
                            }, label: {
                                if isCollapseLimitations {
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
                                
                            }).buttonStyle(PlainButtonStyle())
                        }
                        Spacer()
                        Button(action: {
                            self.isCollapseLimitations.toggle()
                        }, label: {
                            Text("See All")
                                .font(.system(size: 17, weight: .regular)).textCase(nil)
                                .foregroundColor(Color.theme.azure)
                        }).buttonStyle(PlainButtonStyle())
                    }.contentShape(Rectangle())
                        .padding()
                    
                    if !isCollapseLimitations {
                        VStack(alignment: .leading) {
                            Grid(alignment: .topLeading) {
                                GridRow {
                                    Text("Max 900 flight hours in 365 days ")
                                        .font(.system(size: 17, weight: .regular))
                                        .foregroundColor(Color.theme.coralRed1)
                                    
                                    Text("DD/MM/YY to DD/MM/YY")
                                        .font(.system(size: 17, weight: .regular))
                                        .foregroundColor(Color.theme.coralRed1)
                                    
                                    Text("922:47 / 900:00")
                                        .font(.system(size: 17, weight: .regular))
                                        .foregroundColor(Color.theme.coralRed1)
                                }.padding(.vertical, 8)
                                    .padding(.horizontal)
                                    .frame(alignment: .leading)
                                
                                Divider()
                                
                                GridRow {
                                    Text("Max 20 flight hours in 30 days")
                                        .font(.system(size: 17, weight: .regular))
                                        .foregroundColor(Color.theme.vividGamboge)
                                    
                                    Text("DD/MM/YY to DD/MM/YY")
                                        .font(.system(size: 17, weight: .regular))
                                        .foregroundColor(Color.theme.vividGamboge)
                                    
                                    Text("922:47 / 900:00")
                                        .font(.system(size: 17, weight: .regular))
                                        .foregroundColor(Color.theme.vividGamboge)
                                }.padding(.vertical, 8)
                                    .padding(.horizontal)
                                    .frame(alignment: .leading)
                            }
                        }.frame(maxWidth: .infinity)
                            .padding(.bottom)
                        
                    }
                    
                }.background(Color.white)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.theme.gainsboro, lineWidth: 0.5))
            }.padding(.leading, 8)
        } // End VStack
    }
}

struct HomeInformationView_Previews: PreviewProvider {
    static var previews: some View {
        HomeInformationView()
    }
}
