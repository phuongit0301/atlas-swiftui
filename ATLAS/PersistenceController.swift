//
//  PersistenceController.swift
//  ATLAS
//
//  Created by phuong phan on 21/06/2023.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
//        ITagStorage(name: "Dispatch"),
//        ITagStorage(name: "Terrain"),
//        ITagStorage(name: "Weather"),
//        ITagStorage(name: "Approach"),
//        ITagStorage(name: "Airport"),
//        ITagStorage(name: "ATC"),
//        ITagStorage(name: "Aircraft"),
//        ITagStorage(name: "Environment"),
//        newTags = CommonTags().TagList
//        let newTags1 = Tag(context: viewContext)
//        newTags1.name = "Dispatch"
//
//        let newTags2 = Tag(context: viewContext)
//        newTags2.name = "Terrain"
//
//        let newTags3 = Tag(context: viewContext)
//        newTags3.name = "Weather"
//
//        let newTags4 = Tag(context: viewContext)
//        newTags4.name = "Approach"
//
//        let newTags5 = Tag(context: viewContext)
//        newTags5.name = "Airport"
//
//        let newTags6 = Tag(context: viewContext)
//        newTags6.name = "ATC"
//
//        let newTags7 = Tag(context: viewContext)
//        newTags7.name = "Aircraft"
//
//        let newTags8 = Tag(context: viewContext)
//        newTags8.name = "Environment"
        
        
        let newDep1 = Note(context: viewContext)
        newDep1.id = UUID()
        newDep1.name = "All crew to be simulator-qualified for RNP approach"
//        newDep1.tags = newTags1
        newDep1.isDefault = false
//        newDep1.canDelete = false
//        newDep1.fromParent = false
        
        let newDep2 = Note(context: viewContext)
        newDep1.id = UUID()
        newDep2.name = "Note digital clearance requirements 10mins before pushback"
//        newDep2.tags = newTags5
        newDep2.isDefault = false
//        newDep2.canDelete = false
//        newDep2.fromParent = false
//
//        newNote = IFlightInfoStorageModel(name: "Reduce ZFW by 1 ton for preliminary fuel", tags: [ITagStorage(name: "Dispatch")], isDefault: false, canDelete: false, fromParent: false)
//        newNote = IFlightInfoStorageModel(name: "Expected POB: 315", tags: [ITagStorage(name: "Dispatch")], isDefault: false, canDelete: false, fromParent: false)
//        newNote = IFlightInfoStorageModel(name: "Hills to the north of aerodrome", tags: [ITagStorage(name: "Terrain")], isDefault: false, canDelete: false, fromParent: false)
        
        do {
            try viewContext.save()
        } catch {
            fatalError("Unable to load sample data: \(error.localizedDescription)")
        }
        
        return result
    }()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Notes")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.localizedDescription)")
            }
        })
    }
}
