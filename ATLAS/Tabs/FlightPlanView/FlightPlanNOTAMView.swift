//
//  FlightPlanNOTAMView.swift
//  ATLAS
//
//  Created by Muhammad Adil on 25/6/23.
//

import Foundation
import SwiftUI

struct FlightPlanNOTAMView: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController
    // initialise state variables

    var body: some View {
        VStack(alignment: .leading) {
            // fixed header section, todo clean up design
            HStack(alignment: .center) {
                Text("NOTAMS")
                    .font(.title)
                    .padding(.leading, 30)
            }
            .padding(.bottom, 10)
            Text("Plan \(coreDataModel.dataSummaryInfo.unwrappedPlanNo) | Last updated 0820LT")
            .padding(.leading, 30)
            .padding(.bottom, 10)
            //scrollable outer list section
            List {
                // Dep NOTAM section
                Section(header:
                    HStack {
                        Text("DEP NOTAMS").foregroundStyle(Color.black)
                        Spacer()
                        
                        Button(action: {
                            coreDataModel.dataNotams.isDepReference.toggle()
                            coreDataModel.save()
                            
                            coreDataModel.readDataNotamsList()
                        }) {
                            if coreDataModel.dataNotams.isDepReference {
                                Image(systemName: "star.fill").foregroundColor(Color.theme.azure)
                            } else {
                                Image(systemName: "star").foregroundColor(Color.theme.azure)
                            }
                        }
                    }
                ) {
                    ForEach(coreDataModel.dataNotams.unwrappedDepNotams, id: \.self) { notam in
                        Text(notam["notam"] ?? "")
                            .padding(.leading, 25)
                    }
                }
                // Enr NOTAM section
                Section(header:
                        HStack {
                            Text("ENROUTE NOTAMS").foregroundStyle(Color.black)
                            Spacer()
                            Button(action: {
                                coreDataModel.dataNotams.isEnrReference.toggle()
                                coreDataModel.save()
                                
                                coreDataModel.readDataNotamsList()
                            }) {
                                if coreDataModel.dataNotams.isEnrReference {
                                    Image(systemName: "star.fill").foregroundColor(Color.theme.azure)
                                } else {
                                    Image(systemName: "star").foregroundColor(Color.theme.azure)
                                }
                            }
                        }
                    ) {
                    ForEach(coreDataModel.dataNotams.unwrappedEnrNotams, id: \.self) { notam in
                        Text(notam["notam"] ?? "")
                            .padding(.leading, 25)
                    }
                }
                // Arr NOTAM section
                Section(header:
                        HStack {
                            Text("ARR NOTAMS").foregroundStyle(Color.black)
                            Spacer()
                            Button(action: {
                                coreDataModel.dataNotams.isArrReference.toggle()
                                coreDataModel.save()
                                
                                coreDataModel.readDataNotamsList()
                            }) {
                                if coreDataModel.dataNotams.isArrReference {
                                    Image(systemName: "star.fill").foregroundColor(Color.theme.azure)
                                } else {
                                    Image(systemName: "star").foregroundColor(Color.theme.azure)
                                }
                            }
                        }
                    ) {
                    ForEach(coreDataModel.dataNotams.unwrappedArrNotams, id: \.self) { notam in
                        Text(notam["notam"] ?? "")
                            .padding(.leading, 25)
                    }
                }
            }
        }
        .navigationTitle("NOTAMS")
        .background(Color(.systemGroupedBackground))
    }
}

