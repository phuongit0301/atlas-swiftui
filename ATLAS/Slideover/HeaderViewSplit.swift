//
//  HeaderViewSplit.swift
//  ATLAS
//
//  Created by phuong phan on 18/06/2023.
//

import Foundation
import SwiftUI

struct HeaderViewSplit: View {
    @EnvironmentObject var sideMenuState: SideMenuModelState
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @Environment(\.dismiss) private var dismiss
    var viewInformationModel = ListReferenceModel()
    
    @State var searchText: String = ""
    var isBack: Bool = false
    var isMenu: Bool = false
    var isNext: Bool = false
    @State var item: ListFlightInformationItem?
    @State private var isActive: Bool = false
    @State private var selectedEvent: EventList?
    @State private var dataEvents: [EventList] = []
    
    @State var currentIndex = 0 {
        didSet {
            selectedEvent = dataEvents[currentIndex]
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading) {
                Rectangle().fill(.clear).frame(height: 30)
                
                HStack(spacing: 0) {
                    if isBack {
                        Button(action: {
                            dismiss()
                        }) {
                            HStack(spacing: 0) {
                                Image(systemName: "chevron.left")
                                    .frame(width: 17, height: 22)
                                    .foregroundColor(Color.theme.azure)
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fit)
                                Text("Back")
                                    .font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                            }
                        }
                    }
                    
                    if isMenu {
                        Button(action: {
                            dismiss()
                        }) {
                            Text("Clipboard").foregroundColor(Color.theme.azure).font(.system(size: 17, weight: .regular))
                        }
                    }
                    
                    HStack(alignment: .center, spacing: 0) {
                        Picker("", selection: $selectedEvent) {
                            ForEach(dataEvents, id: \.self) { item in
                                Text("\(item.unwrappedName) \(item.unwrappedStartDate)").tag(item as EventList?)
                            }
                        }.labelsHidden()
                            .id(UUID())
                    }.frame(maxWidth: .infinity)
                        .Print("currentIndex======\(currentIndex)")
                    
                    if isNext {
                        if let screen = item {
                            NavigationLink(destination: NoteDestinationSplit(item: screen)) {
                                Text("Next").foregroundColor(Color.theme.azure).font(.system(size: 17, weight: .semibold))
                            }
                            //                                NavigationLink(destination: getDestinationNextSplit(screen, viewInformationModel.ListItem)) {
                            //                                    Text("Next").foregroundColor(Color.theme.azure).font(.system(size: 17, weight: .semibold))
                            //                                }
                        }
                    }
                }
                //                ZStack(alignment: .leading) {
                //                    HStack {
                //                        Image(systemName: "magnifyingglass").resizable().frame(width: 22, height: 22).aspectRatio(contentMode: .fit).foregroundColor(Color.theme.arsenic.opacity(0.6))
                //
                //                        TextField("Can this be AI Search?", text: $searchText)
                //
                //                        Image(systemName: "mic.fill").resizable().frame(width: 17, height: 22).aspectRatio(contentMode: .fit).foregroundColor(Color.theme.arsenic.opacity(0.6))
                //                    }.padding()
                //                        .background(Color.theme.sonicSilver.opacity(0.12))
                //                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                //                }
                
            }.padding()
        }.background(.white)
            .onAppear {
                dataEvents = coreDataModel.readEvents()
                coreDataModel.selectedEvent = dataEvents.first
                selectedEvent = dataEvents.first
            }
            .onChange(of: selectedEvent) {newValue in
                coreDataModel.selectedEvent = newValue
            }
        Rectangle().fill(Color.black.opacity(0.3)).frame(height: 1)
    }
}
