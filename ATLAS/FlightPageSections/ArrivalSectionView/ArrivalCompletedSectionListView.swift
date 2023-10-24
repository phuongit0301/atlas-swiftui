//
//  ArrivalCompletedSectionListView.swift
//  ATLAS
//
//  Created by phuong phan on 25/09/2023.
//

import SwiftUI

struct ArrivalCompletedSectionListView: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var remoteService: RemoteService
    @EnvironmentObject var persistenceController: PersistenceController
    @EnvironmentObject var mapIconModel: MapIconModel
    
    @State var parentIndex = 0
    @State var postIndex = 0
    @State private var currentIndex: Int = -1
    @State private var showSheet: Bool = false
    @State private var showSheetRelevant: Bool = false
    @State private var isShowListNote: Bool = true
    @State private var isShowListRelevent: Bool = true
    @State private var showModalComment: Bool = false
    @State private var isLoading: Bool = false
    @State private var textNote: String = ""
    @State private var itemList = [NoteList]()
    var header: String = "Your Notes"
    
    let dateFormmater = DateFormatter()
    
    var body: some View {
        
        GeometryReader {proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .center) {
                        Text("Notes")
                            .font(.system(size: 17, weight: .semibold))
                            .padding(.leading)
                        Spacer()
                        
                        if let noteRelevant = coreDataModel.dataSectionDateUpdate?.unwrappedNoteRelevant {
                            Text("Last Update: \(noteRelevant)").foregroundColor(.black).font(.system(size: 15, weight: .regular))
                        }
                        
                        Button(action: {
                        }, label: {
                            HStack {
                                Text("Refresh").font(.system(size: 17, weight: .regular))
                                    .foregroundColor(Color.white)
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                            }
                        }).background(Color.theme.philippineGray3)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(.white, lineWidth: 0)
                            )
                            .padding(.vertical, 8)
                    }.frame(height: 52)
                    
                    ArrivalCompletedNoteItemList(
                        header: header,
                        showSheet: $showSheet,
                        currentIndex: $currentIndex,
                        itemList: $coreDataModel.arrivalArray,
                        isShowList: $isShowListNote,
                        geoWidth: proxy.size.width,
                        resetData: resetData
                    ).frame(maxHeight: .infinity)
                        .background(Color.white)
                        .cornerRadius(8)
                    
                    ArrivalNoteCompletedItemRelevantList(
                        header: "Relevant AABBA Posts",
                        showSheet: $showSheetRelevant,
                        showModalComment: $showModalComment,
                        currentIndex: $currentIndex,
                        itemList: $coreDataModel.dataPostArrival,
                        isShowList: $isShowListRelevent,
                        postIndex: $postIndex,
                        geoWidth: proxy.size.width,
                        resetData: resetData
                    ).frame(maxHeight: .infinity)
                        .background(Color.white)
                        .cornerRadius(8)
                }.padding(.horizontal, 16)
                    .background(Color.theme.antiFlashWhite)
                    .padding(.bottom)
            }.overlay(Group {
                if isLoading {
                    VStack {
                        ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.black))
                    }.frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.3))
                }
            })
            .onAppear {
                resetData()
            }
        }
    }
    
    private func resetData() {
        coreDataModel.arrivalArray = coreDataModel.read("arrival")
        coreDataModel.arrivalRefArray = coreDataModel.readClipBoard("arrival")
        
        coreDataModel.dataPostArrival = coreDataModel.readDataPostList("arrival", "")
        coreDataModel.dataPostArrivalRef = coreDataModel.readDataPostList("arrival", "ref")
        
        coreDataModel.dataNoteAabbaArrival = coreDataModel.readDataNoteAabbaPostList("arrival")

        if self.currentIndex > -1 {
            self.currentIndex = -1
        }
    }
    
    func onSyncData() {
        if let overviewList = coreDataModel.selectedEvent?.flightOverviewList?.allObjects as? [FlightOverviewList] {
            let dataFlightOverview = overviewList.first
            var payloadEnrouteMap: [String] = []
            var payloadDestinationMap: [String] = []
            
            let (enrouteAlternates, destinationAlternates) = coreDataModel.prepareRouteAlternateByType()
            
            if enrouteAlternates.count > 0 {
                for item in enrouteAlternates {
                    payloadEnrouteMap.append(item.altn ?? "")
                }
            }
            
            if destinationAlternates.count > 0 {
                for item in destinationAlternates {
                    payloadDestinationMap.append(item.altn ?? "")
                }
            }
            
            let payloadAabbaNote: [String: Any] = [
                "depAirport": dataFlightOverview?.unwrappedDep ?? "",
                "arrAirport": dataFlightOverview?.unwrappedDest ?? "",
                "enrALTNS": payloadEnrouteMap,
                "destALTNS": payloadDestinationMap,
            ]
            
            handleAabbaNote(payloadAabbaNote)
        }
    }
    
    func handleAabbaNote(_ payload: [String: Any]) {
        Task {
            print("handle aabba note")
            isLoading = true
            let responseAabbaNote = await remoteService.getAabbaNoteData(payload)
            
            if let responseAabbaNote = responseAabbaNote, responseAabbaNote.count > 0, let eventList = coreDataModel.selectedEvent {
                await coreDataModel.deleteAllAabbaNoteList(eventList)
//                await coreDataModel.deleteAllAabbaNotePostList(eventList)
//                await coreDataModel.deleteAllAabbaNoteCommentList()
                coreDataModel.initDataMapAabbaNotes(responseAabbaNote, eventList)
            }
            print("end aabba note")
            resetData()
            
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            if let newObj = coreDataModel.dataSectionDateUpdate {
                newObj.noteRelevant = dateFormatter.string(from: Date())
            } else {
                let newObj = SectionDateUpdateList(context: persistenceController.container.viewContext)
                newObj.noteRelevant = dateFormatter.string(from: Date())
            }
            coreDataModel.save()
            coreDataModel.dataSectionDateUpdate = coreDataModel.readSectionDateUpdate()
            
            isLoading = false
        }
    }
}
