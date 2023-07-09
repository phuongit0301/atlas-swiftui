//
//  FlightInformationView.swift
//  ATLAS
//
//  Created by phuong phan on 06/07/2023.
//

import SwiftUI

struct FlightInformationDetailView: View {
    var body: some View {
        VStack(alignment: .leading) {
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
            }
        }.padding(.top, 32)
    }
}

struct FlightInformationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FlightInformationDetailView()
    }
}
