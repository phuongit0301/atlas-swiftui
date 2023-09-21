//
//  EntriesSubSectionView.swift
//  ATLAS
//
//  Created by phuong phan on 21/09/2023.
//

import SwiftUI

struct IDataSub: Identifiable, Hashable {
    var id = UUID()
    var date: String
    var aircraftType: String
    var aircraft: String
    var dep: String
    var dest: String
    var picDay: String
    var picUsDay: String
    var p1Day: String
    var p2Day: String
    var picNight: String
    var picUsNight: String
    var p1Night: String
    var p2Night: String
    var comments: String
    var signature: String
}

let MOCK_DATA_SUB = [
    IDataSub(id: UUID(), date: "DD/MM/YY", aircraftType: "XXXX-XXXXXXXX", aircraft: "XXXXXXXX", dep: "XXX", dest: "XXX", picDay: "XX:XX:XX", picUsDay: "XX:XX:XX", p1Day: "XX:XX:XX", p2Day: "XX:XX:XX", picNight: "XX:XX:XX", picUsNight: "XX:XX:XX", p1Night: "XX:XX:XX", p2Night: "XX:XX:XX", comments: "XXXXXXXXXXXXXXXXXXXXXXXXX", signature: "Not Signed"),
    IDataSub(id: UUID(), date: "DD/MM/YY", aircraftType: "XXXX-XXXXXXXX", aircraft: "XXXXXXXX", dep: "XXX", dest: "XXX", picDay: "XX:XX:XX", picUsDay: "XX:XX:XX", p1Day: "XX:XX:XX", p2Day: "XX:XX:XX", picNight: "XX:XX:XX", picUsNight: "XX:XX:XX", p1Night: "XX:XX:XX", p2Night: "XX:XX:XX", comments: "XXXXXXXXXXXXXXXXXXXXXXXXX", signature: "Signed"),
    IDataSub(id: UUID(), date: "DD/MM/YY", aircraftType: "XXXX-XXXXXXXX", aircraft: "XXXXXXXX", dep: "XXX", dest: "XXX", picDay: "XX:XX:XX", picUsDay: "XX:XX:XX", p1Day: "XX:XX:XX", p2Day: "XX:XX:XX", picNight: "XX:XX:XX", picUsNight: "XX:XX:XX", p1Night: "XX:XX:XX", p2Night: "XX:XX:XX", comments: "XXXXXXXXXXXXXXXXXXXXXXXXX", signature: "Signed"),
    IDataSub(id: UUID(), date: "DD/MM/YY", aircraftType: "XXXX-XXXXXXXX", aircraft: "XXXXXXXX", dep: "XXX", dest: "XXX", picDay: "XX:XX:XX", picUsDay: "XX:XX:XX", p1Day: "XX:XX:XX", p2Day: "XX:XX:XX", picNight: "XX:XX:XX", picUsNight: "XX:XX:XX", p1Night: "XX:XX:XX", p2Night: "XX:XX:XX", comments: "XXXXXXXXXXXXXXXXXXXXXXXXX", signature: "Signed"),
]

struct EntriesSubSectionView: View {
    
    @State var isCollapse = false
    @State private var isShowDateModal: Bool = false
    @State private var selectedDate: String = "Selected Date"
    
    var body: some View {
        GeometryReader { proxy in
            HStack(spacing: 0) {
                List {
                    Section {
                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                HStack(alignment: .center) {
                                    Text("All Logbook Entries").font(.system(size: 20, weight: .semibold)).foregroundStyle(Color.black)
                                }
                                Spacer()
                                
                                HStack {
                                    CommonStepper(onToggle: onToggleDate, value: $selectedDate, suffix: "").fixedSize()
                                    
                                    Button(action: {
                                        //Todo
                                    }, label: {
                                        Text("Extract").font(.system(size: 15, weight: .regular)).foregroundColor(Color.white)
                                    }).padding(.vertical, 11)
                                        .padding(.horizontal)
                                        .background(Color.theme.azure)
                                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(.white, lineWidth: 1))
                                        .cornerRadius(8)
                                        .buttonStyle(PlainButtonStyle())
                                }
                            }.contentShape(Rectangle())
                                .padding()
                            
                            if !isCollapse {
                                VStack {
                                    Grid(alignment: .topLeading, horizontalSpacing: 8, verticalSpacing: 2) {
                                        GridRow {
                                            Group {
                                                Text("Date")
                                                    .font(.system(size: 15, weight: .medium))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                                
                                                Text("Aircraft Type")
                                                    .font(.system(size: 15, weight: .medium))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                                
                                                Text("Aircraft")
                                                    .font(.system(size: 15, weight: .medium))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                                
                                                Text("Dep.")
                                                    .font(.system(size: 15, weight: .medium))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                                
                                                Text("Dest.")
                                                    .font(.system(size: 15, weight: .medium))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                                
                                                Text("PIC Day")
                                                    .font(.system(size: 15, weight: .medium))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                            }.frame(height: 44)
                                            
                                            Group {
                                                Text("PIC(u/us) Day")
                                                    .font(.system(size: 15, weight: .medium))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                                
                                                Text("P1 Day")
                                                    .font(.system(size: 15, weight: .medium))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                                
                                                Text("P2 Day")
                                                    .font(.system(size: 15, weight: .medium))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                                
                                                Text("PIC Night")
                                                    .font(.system(size: 15, weight: .medium))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                                
                                                Text("PIC(u/us) Night")
                                                    .font(.system(size: 15, weight: .medium))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                                
                                                Text("P1 Night")
                                                    .font(.system(size: 15, weight: .medium))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                                
                                                Text("P2 Night")
                                                    .font(.system(size: 15, weight: .medium))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                            }.frame(height: 44, alignment: .center)
                                        }
                                        GridRow {
                                            Group {
                                                Text("Comments")
                                                    .font(.system(size: 15, weight: .medium))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                                    .gridCellColumns(7)
                                                Text("Signature")
                                                    .font(.system(size: 15, weight: .medium))
                                                    .foregroundColor(Color.black)
                                                    .frame(alignment: .leading)
                                                    .gridCellColumns(6)
                                            }.frame(height: 44, alignment: .center)
                                            
                                        }
                                        
                                        Divider().padding(.horizontal, -16)
                                        
                                        ForEach(MOCK_DATA_SUB.indices, id: \.self) {index in
                                            GridRow {
                                                Group {
                                                    Text(MOCK_DATA_SUB[index].date)
                                                        .font(.system(size: 15, weight: .regular))
                                                        .frame(alignment: .leading)
                                                    
                                                    Text(MOCK_DATA_SUB[index].aircraftType)
                                                        .font(.system(size: 15, weight: .regular))
                                                        .frame(alignment: .leading)
                                                    
                                                    Text(MOCK_DATA_SUB[index].aircraft)
                                                        .font(.system(size: 15, weight: .regular))
                                                        .frame(alignment: .leading)
                                                    
                                                    Text(MOCK_DATA_SUB[index].dep)
                                                        .font(.system(size: 15, weight: .regular))
                                                        .frame(alignment: .leading)
                                                    
                                                    Text(MOCK_DATA_SUB[index].dest)
                                                        .font(.system(size: 15, weight: .regular))
                                                        .frame(alignment: .leading)
                                                    
                                                    Text(MOCK_DATA_SUB[index].picDay)
                                                        .font(.system(size: 15, weight: .regular))
                                                        .frame(alignment: .leading)
                                                }.frame(height: 44, alignment: .center)
                                                
                                                Group {
                                                    Text(MOCK_DATA_SUB[index].picUsDay)
                                                        .font(.system(size: 15, weight: .regular))
                                                        .frame(alignment: .leading)
                                                    
                                                    Text(MOCK_DATA_SUB[index].p1Day)
                                                        .font(.system(size: 15, weight: .regular))
                                                        .frame(alignment: .leading)
                                                    
                                                    Text(MOCK_DATA_SUB[index].p2Day)
                                                        .font(.system(size: 15, weight: .regular))
                                                        .frame(alignment: .leading)
                                                    
                                                    Text(MOCK_DATA_SUB[index].picNight)
                                                        .font(.system(size: 15, weight: .regular))
                                                        .frame(alignment: .leading)
                                                    
                                                    Text(MOCK_DATA_SUB[index].picUsNight)
                                                        .font(.system(size: 15, weight: .regular))
                                                        .frame(alignment: .leading)
                                                    
                                                    Text(MOCK_DATA_SUB[index].p1Night)
                                                        .font(.system(size: 15, weight: .regular))
                                                        .frame(alignment: .leading)
                                                    
                                                    Text(MOCK_DATA_SUB[index].p2Night)
                                                        .font(.system(size: 15, weight: .regular))
                                                        .frame(alignment: .leading)
                                                }.frame(height: 44, alignment: .center)
                                            }
                                            
                                            GridRow {
                                                Group {
                                                    Text(MOCK_DATA_SUB[index].comments)
                                                        .font(.system(size: 15, weight: .regular))
                                                        .frame(alignment: .leading)
                                                        .gridCellColumns(7)
                                                    
                                                    Text(MOCK_DATA_SUB[index].signature)
                                                        .font(.system(size: 15, weight: .regular))
                                                        .frame(alignment: .leading)
                                                        .gridCellColumns(6)
                                                }.frame(height: 44, alignment: .center)
                                            }
                                            
                                            if index + 1 < MOCK_DATA_SUB.count {
                                                Divider().padding(.horizontal, -16)
                                            }
                                        }
                                    }
                                    
                                }//End VStack
                                .padding(.vertical)
                                .padding(.horizontal, 8)
                            }//End if
                            
                        }.listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    } // End Section
                }
            }.sheet(isPresented: $isShowDateModal) {
                ModalDateRangeView(isShowing: $isShowDateModal, selectedDate: $selectedDate)
            }
        }
    }
    
    func onToggleDate() {
        self.isShowDateModal.toggle()
    }
}

struct EntriesSubSectionView_Previews: PreviewProvider {
    static var previews: some View {
        EntriesSubSectionView()
    }
}
