//
//  DepartureCardContainer.swift
//  ATLAS
//
//  Created by phuong phan on 23/05/2023.
//

import Foundation
import SwiftUI
import CoreData

struct DepartureCardContainer: View {
    @ObservedObject var viewModel: FlightNoteModelState
    @ObservedObject var viewModel: CoreDataModelState
//    @EnvironmentObject var persistenceController: PersistenceController
    
    @State private var currentIndex: Int = -1
    @State private var showSheet: Bool = false
    @State private var textNote: String = ""
    var header: String = "Departure Status"
    var target: String = "departure"
    
    var geoWidth: Double = 0
    
    @Environment(\.managedObjectContext) private var viewContext
    @State var notes: [NoteList] = []
    @ObservedObject var depTags: [TagList] = 

    var body: some View {
//        VStack {
//            List{
//                ForEach(notes, id: \.self) { note in
//                    HStack {
//                        Text(note.name ?? "-").foregroundColor(.black)
//                        Spacer()
//                        Text(String(note.isDefault))
//
//                        Text(String(note.tags?.name ?? ""))
//                    }
//                }
//            }.Print("data=====\(notes)")
//
//            Button(action: {
//                let product = NoteList(context: viewContext)
//                product.name = "Hello World"
//                product.isDefault = false
//
//                saveContext()
//            }) {
//                Text("Add New").foregroundColor(.black)
//            }
//        }
        ItemList(
            header: header,
            showSheet: $showSheet,
            currentIndex: $currentIndex,
            itemList: $notes,
            geoWidth: geoWidth,
            remove: remove,
            addQR: addQR,
            removeQR: removeQR
        ).frame(maxHeight: .infinity)
            .padding()
            .background(Color.white)
            .cornerRadius(8)
            .sheet(isPresented: $showSheet) {
                NoteForm(
                    textNote: $textNote,
                    tagList: $depTags,
                    itemList: $notes,
                    currentIndex: $currentIndex,
                    showSheet: $showSheet,
                    target: target,
                    resetData: self.resetData
                ).keyboardAdaptive()
                    .interactiveDismissDisabled(true)
            }
            .onAppear {
                let results = persistenceController.read("departure")
                let tags = persistenceController.readTag()
                self.notes = results
                self.depTags = tags
//                let request: NSFetchRequest<NoteList> = NoteList.fetchRequest()
//                request.predicate = NSPredicate(format: "target=%@", "depature")
//                do {
//                    let results = try persistenceController.container.viewContext.fetch(request)
//                    self.notes = results
//                } catch {
//                    print("Unable to Fetch Workouts, (\(error))")
//                }
                
            }
    }
    
    private func remove(_ index: Int) {
        viewModel.removeDeparture(item: viewModel.departureArray[index])
    }
    
    private func addQR(_ index: Int) {
        var item = viewModel.departureArray[index]
        item.fromParent = true
        item.canDelete = true
        viewModel.addDepartureQR(item: item)
    }
    
    private func removeQR(_ index: Int) {
        viewModel.removeDepartureQR(item: viewModel.departureArray[index])
    }
    
    private func resetData() {
//        self.depTags = CommonTags().TagList
        
        if self.currentIndex > -1 {
            self.currentIndex = -1
        }
    }
    
    private func saveContext() {
            do {
                try viewContext.save()
            } catch {
                let error = error as NSError
                fatalError("An error occured: \(error)")
            }
        }
}

//struct DepartureCardContainer_Previews: PreviewProvider {
//    static var previews: some View {
//        DepartureCardContainer(viewModel: FlightNoteModelState())
//            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
//    }
//}
