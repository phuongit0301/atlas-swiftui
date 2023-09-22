//
//  RecencySectionView.swift
//  ATLAS
//
//  Created by phuong phan on 06/09/2023.
//

import SwiftUI

struct IDataExpiringSoon: Identifiable, Hashable {
    var id = UUID()
    var item: String
    var expireDate: String
    var requirement: String
    var remark: String
}

let MOCK_DATA_EXPIRING_SOON = [
    IDataExpiringSoon(id: UUID(), item: "Instructor Rating", expireDate: "DD/MM/YY", requirement: "XXXXXXXXXXXXXXXXXXXXX", remark: "XXXXXXXXXXXXXXXXXXXXX"),
]

struct RecencySectionView: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @StateObject var recencySection = RecencySection()
    
    @State var isCollapse = false
    @State var isCollapseRecency = false
    @State var isCollapseDocument = false
    @State private var selectedPicker = ""
    @State private var selectedExpiring = ""
    @State private var selectedExpirySoon = ""
    @State private var progress = 0.8
    
    var body: some View {
        GeometryReader { proxy in
            HStack(spacing: 0) {
                List {
                    Section {
                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                HStack(alignment: .center) {
                                    Text("Expiring Soon").font(.system(size: 20, weight: .semibold)).foregroundStyle(Color.black)
                                    
                                    Button(action: {
                                        self.isCollapse.toggle()
                                    }, label: {
                                        if isCollapse {
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
                                
//                                HStack {
//                                    Picker("", selection: $selectedPicker) {
//                                        Text("Show All").tag("")
//                                        ForEach(recencySection.dataItemDropDown, id: \.self) {
//                                            Text($0).tag($0)
//                                        }
//                                    }.pickerStyle(MenuPickerStyle()).fixedSize()
//
//                                    Picker("", selection: $selectedPicker) {
//                                        Text("Show All").tag("")
//                                        ForEach(recencySection.dataExpiringDropDown, id: \.self) {
//                                            Text($0).tag($0)
//                                        }
//                                    }.pickerStyle(MenuPickerStyle()).fixedSize()
//                                }
                            }.contentShape(Rectangle())
                                .padding()
                            
                            if !isCollapse {
                                VStack(alignment: .leading) {
                                    Grid(alignment: .topLeading, horizontalSpacing: 8, verticalSpacing: 12) {
                                        GridRow {
                                            Text("Item")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundColor(Color.black)
                                                .frame(alignment: .leading)
                                            
                                            Text("Expiry Date")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundColor(Color.black)
                                                .frame(alignment: .leading)
                                            
                                            Text("Requirement")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundColor(Color.black)
                                                .frame(alignment: .leading)
                                            
                                            Text("Remarks")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundColor(Color.black)
                                                .frame(alignment: .leading)
                                        }
                                        
                                        Divider().padding(.horizontal, -16)
                                        
                                        ForEach(MOCK_DATA_EXPIRING_SOON, id: \.self) {item in
                                            GridRow {
                                                Group {
                                                    Text(item.item)
                                                        .font(.system(size: 17, weight: .regular))
                                                        .frame(alignment: .leading)
                                                    
                                                    Text(item.expireDate)
                                                        .font(.system(size: 17, weight: .regular))
                                                        .frame(alignment: .leading)
                                                    
                                                    Text(item.requirement)
                                                        .font(.system(size: 17, weight: .regular))
                                                        .frame(alignment: .leading)
                                                    
                                                    Text(item.remark)
                                                        .font(.system(size: 17, weight: .regular))
                                                        .frame(alignment: .leading)
                                                }
                                                
                                            }
                                        }
                                    }
                                }.padding()
                            }
                            
                        }.listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    } // End Section
                    
                    Section {
                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                HStack(alignment: .center) {
                                    Text("Recency").font(.system(size: 20, weight: .semibold)).foregroundStyle(Color.black)
                                    
                                    Button(action: {
                                        self.isCollapseRecency.toggle()
                                    }, label: {
                                        if isCollapseRecency {
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
                                
//                                HStack {
//                                    Picker("", selection: $selectedExpirySoon) {
//                                        Text("Expiry (Soonest)").tag("")
//                                        ForEach(recencySection.dataExpirySoonDropDown, id: \.self) {
//                                            Text($0).tag($0)
//                                        }
//                                    }.pickerStyle(MenuPickerStyle()).fixedSize()
//                                }
                            }.contentShape(Rectangle())
                                .padding()
                            
                            if !isCollapseRecency {
                                VStack(alignment: .leading) {
                                    Grid(alignment: .topLeading, horizontalSpacing: 8, verticalSpacing: 12) {
                                        GridRow {
                                            Text("Type")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundColor(Color.black)
                                                .frame(alignment: .leading)
                                            
                                            Text("Model")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundColor(Color.black)
                                                .frame(alignment: .leading)
                                            
                                            Text("Expire Date")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundColor(Color.black)
                                                .frame(alignment: .leading)
                                            
                                            Text("Requirement")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundColor(Color.black)
                                                .frame(alignment: .leading)
                                        }
                                        
                                        Divider().padding(.horizontal, -16)
                                        
                                        ForEach(coreDataModel.dataRecency.indices, id: \.self) {index in
                                            GridRow {
                                                Group {
                                                    Text(coreDataModel.dataRecency[index].unwrappedRecencyType)
                                                        .font(.system(size: 17, weight: .regular))
                                                        .frame(alignment: .leading)
                                                    
                                                    Text("B737")
                                                        .font(.system(size: 17, weight: .regular))
                                                        .frame(alignment: .leading)
                                                    
                                                    Text(coreDataModel.dataRecency[index].unwrappedExpiredDate)
                                                        .font(.system(size: 17, weight: .regular))
                                                        .frame(alignment: .leading)
                                                    
                                                    HStack(alignment: .top) {
                                                        VStack(alignment: .leading, spacing: 16) {
                                                            Text(coreDataModel.dataRecency[index].unwrappedRequirement)
                                                                .font(.system(size: 17, weight: .regular))
                                                                .frame(alignment: .leading)
                                                            Text("2/3 landings in 49/90 days")
                                                                .foregroundColor(Color.theme.azure)
                                                                .font(.system(size: 17, weight: .regular))
                                                                .frame(alignment: .leading)
                                                        }
                                                        ProgressView(value: progress).frame(width: 220).padding(.top, 8)
                                                    }
                                                    
                                                }
                                                
                                            }
                                            
                                            if index + 1 < coreDataModel.dataRecency.count {
                                                Divider().padding(.horizontal, -16)
                                            }
                                        }
                                    }
                                }.padding()
                            }
                            
                        }.listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    } // End Section
                    
                    Section {
                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                HStack {
                                    HStack(alignment: .center) {
                                        Text("Documents").font(.system(size: 20, weight: .semibold)).foregroundStyle(Color.black)
                                        
                                        Button(action: {
                                            self.isCollapseDocument.toggle()
                                        }, label: {
                                            if isCollapseDocument {
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
                                }.contentShape(Rectangle())
                                
                                HStack(spacing: 16) {
//                                    Picker("", selection: $selectedExpirySoon) {
//                                        Text("Expiry (Soonest)").tag("")
//                                        ForEach(recencySection.dataRecencyDropDown, id: \.self) {
//                                            Text($0).tag($0)
//                                        }
//                                    }.pickerStyle(MenuPickerStyle()).fixedSize()
                                    
                                    Button(action: {
                                        // ToDo
                                    }, label: {
                                        Text("Add")
                                            .font(.system(size: 17, weight: .regular)).textCase(nil)
                                            .foregroundColor(Color.white)
                                    }).padding(.vertical, 11)
                                        .padding(.horizontal)
                                        .buttonStyle(PlainButtonStyle())
                                        .background(Color.theme.azure)
                                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(.white, lineWidth: 1))
                                        .cornerRadius(8)
                                    
                                    Text("Edit")
                                        .font(.system(size: 17, weight: .regular)).textCase(nil)
                                        .foregroundColor(Color.theme.azure)
                                }
                            }.padding()
                            
                            if !isCollapseDocument {
                                VStack(alignment: .leading) {
                                    Grid(alignment: .topLeading, horizontalSpacing: 8, verticalSpacing: 12) {
                                        GridRow {
                                            Text("Type")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundColor(Color.black)
                                                .frame(alignment: .leading)
                                            
                                            Text("Expire Date")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundColor(Color.black)
                                                .frame(alignment: .leading)
                                            
                                            Text("Requirement")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundColor(Color.black)
                                                .frame(alignment: .leading)
                                            
                                            Text("Remarks")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundColor(Color.black)
                                                .frame(alignment: .leading)
                                        }
                                        
                                        Divider().padding(.horizontal, -16)
                                        
                                        ForEach(coreDataModel.dataRecencyExpiry.indices, id: \.self) {index in
                                            GridRow {
                                                Group {
                                                    Text(coreDataModel.dataRecencyExpiry[index].unwrappedName)
                                                        .font(.system(size: 17, weight: .regular))
                                                        .frame(alignment: .leading)
                                                    
                                                    Text(coreDataModel.dataRecencyExpiry[index].unwrappedExpiredDate)
                                                        .font(.system(size: 17, weight: .regular))
                                                        .frame(alignment: .leading)
                                                    
                                                    Text("XXXXXXXXXXXXXXXXXXXXX")
                                                        .font(.system(size: 17, weight: .regular))
                                                        .frame(alignment: .leading)
                                                    
                                                    Text("XXXXXXXXXXXXXXXXXXXXX")
                                                        .font(.system(size: 17, weight: .regular))
                                                        .frame(alignment: .leading)
                                                    
                                                }
                                                
                                            }
                                            
                                            if index + 1 < coreDataModel.dataRecencyExpiry.count {
                                                Divider().padding(.horizontal, -16)
                                            }
                                        }
                                    }
                                }.padding()
                            }
                            
                        }.listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    } // End Section
                }
            }
        }
    }
}

struct RecencySectionView_Previews: PreviewProvider {
    static var previews: some View {
        RecencySectionView()
    }
}
