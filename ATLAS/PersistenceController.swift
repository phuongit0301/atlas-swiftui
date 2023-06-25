//
//  PersistenceController.swift
//  ATLAS
//
//  Created by phuong phan on 21/06/2023.
//

import CoreData

class PersistenceController: ObservableObject {
    static let shared = PersistenceController()
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
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
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.localizedDescription)")
            }
        })
    }
    
    func read(_ target: String = "departure", predicateFormat: String? = "target = %@", fetchLimit: Int? = nil) -> [NoteList] {
        // create a temp array to save fetched notes
        var results: [NoteList] = []
        // initialize the fetch request
        let request: NSFetchRequest<NoteList> = NoteList.fetchRequest()
        
        // define filter and/or limit if needed
        if predicateFormat != nil {
            request.predicate = NSPredicate(format: "target == %@", target)
        }
        if fetchLimit != nil {
            request.fetchLimit = fetchLimit!
        }

        // fetch with the request
        do {
            results = try container.viewContext.fetch(request)
        } catch {
            print("Could not fetch notes from Core Data.")
        }

        // return results
        return results
    }
    
    func readTag() -> [TagList] {
        // create a temp array to save fetched notes
        var results: [TagList] = []
        // initialize the fetch request
        let request: NSFetchRequest<TagList> = TagList.fetchRequest()

        // fetch with the request
        do {
            results = try container.viewContext.fetch(request)
        } catch {
            print("Could not fetch tag from Core Data.")
        }

        // return results
        return results
    }
    
    func save() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            }
            catch {
                fatalError("Unable to save data: \(error.localizedDescription)")
            }
        }
    }

    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
    }
    
    func initData() {
        let newTags1 = TagList(context: container.viewContext)
        newTags1.id = UUID()
        newTags1.name = "Dispatch"

        let newTags2 = TagList(context: container.viewContext)
        newTags2.id = UUID()
        newTags2.name = "Terrain"

        let newTags3 = TagList(context: container.viewContext)
        newTags3.id = UUID()
        newTags3.name = "Weather"

        let newTags4 = TagList(context: container.viewContext)
        newTags4.id = UUID()
        newTags4.name = "Approach"

        let newTags5 = TagList(context: container.viewContext)
        newTags5.id = UUID()
        newTags5.name = "Airport"

        let newTags6 = TagList(context: container.viewContext)
        newTags6.id = UUID()
        newTags6.name = "ATC"

        let newTags7 = TagList(context: container.viewContext)
        newTags7.id = UUID()
        newTags7.name = "Aircraft"

        let newTags8 = TagList(context: container.viewContext)
        newTags8.id = UUID()
        newTags8.name = "Environment"
        
        let newDep1 = NoteList(context: container.viewContext)
        newDep1.id = UUID()
        newDep1.name = "All crew to be simulator-qualified for RNP approach"
        newDep1.tags = [newTags1]
        newDep1.isDefault = false
        newDep1.canDelete = false
        newDep1.fromParent = false
        newDep1.target = "departure"

       let newDep2 = NoteList(context: container.viewContext)
        newDep2.id = UUID()
        newDep2.name = "Note digital clearance requirements 10mins before pushback"
        newDep2.tags = [newTags5]
        newDep2.isDefault = false
        newDep2.canDelete = false
        newDep2.fromParent = false
        newDep2.target = "departure"

        let newDep3 = NoteList(context: container.viewContext)
        newDep3.id = UUID()
        newDep3.name = "Reduce ZFW by 1 ton for preliminary fuel"
        newDep3.tags = [newTags1]
        newDep3.isDefault = false
        newDep3.canDelete = false
        newDep3.fromParent = false
        newDep3.target = "departure"
        
        let newDep4 = NoteList(context: container.viewContext)
        newDep4.id = UUID()
        newDep4.name = "Expected POB: 315"
        newDep4.tags = [newTags1]
        newDep4.isDefault = false
        newDep4.canDelete = false
        newDep4.fromParent = false
        newDep4.target = "departure"
        
        let newDep5 = NoteList(context: container.viewContext)
        newDep5.id = UUID()
        newDep5.name = "Hills to the north of aerodrome"
        newDep5.tags = [newTags2]
        newDep5.isDefault = false
        newDep5.canDelete = false
        newDep5.fromParent = false
        newDep5.target = "departure"
        
        let newEnroute1 = NoteList(context: container.viewContext)
        newEnroute1.id = UUID()
        newEnroute1.name = "Non-standard levels when large scale weather deviation in progress"
        newEnroute1.tags = [newTags6]
        newEnroute1.isDefault = false
        newEnroute1.canDelete = false
        newEnroute1.fromParent = false
        newEnroute1.target = "enroute"
        
        let newArrival1 = NoteList(context: container.viewContext)
        newArrival1.id = UUID()
        newArrival1.name = "Birds in vicinity"
        newArrival1.tags = [newTags8]
        newArrival1.isDefault = false
        newArrival1.canDelete = false
        newArrival1.fromParent = false
        newArrival1.target = "arrival"
        
        let newArrival2 = NoteList(context: container.viewContext)
        newArrival2.id = UUID()
        newArrival2.name = "Any +TS expected to last 15mins"
        newArrival2.tags = [newTags3]
        newArrival2.isDefault = false
        newArrival2.canDelete = false
        newArrival2.fromParent = false
        newArrival2.target = "arrival"
        
        container.viewContext.performAndWait {
            do {
                // Persist the data in this managed object context to the underlying store
                try container.viewContext.save()
                print("saved successfully")
            } catch {
                // Something went wrong 😭
                print("Failed to save: \(error)")
                // Rollback any changes in the managed object context
                container.viewContext.rollback()
                
            }
        }
    }
    
    func checkAndSyncData() async {
        let response = read()

        if response.count == 0 {
            initData()
        }
//        do {
//            let request: NSFetchRequest<NSFetchRequestResult> = NoteList.fetchRequest()
//            let result = try container.viewContext.fetch(request)
//            if result.isEmpty {
//                initData()
//            }
//        } catch {
//            fatalError("Unable to fetch data: \(error.localizedDescription)")
//        }
    }
}

class CoreDataModelState: ObservableObject {
    @Published var tagList: [TagList] = []
    @Published var airCraftArray: [NoteList] = []
    @Published var departureArray: [NoteList] = []
    @Published var enrouteArray: [NoteList] = []
    @Published var arrivalArray: [NoteList] = []
    
    init() {
        readTag()
        airCraftArray = read("aircraft")
        departureArray = read("departure")
        enrouteArray = read("enroute")
        arrivalArray = read("arrival")
    }
    
    func readTag() -> [TagList] {
        // create a temp array to save fetched notes
        var results: [TagList] = []
        // initialize the fetch request
        let request: NSFetchRequest<TagList> = TagList.fetchRequest()

        // fetch with the request
        do {
            tagList = try container.viewContext.fetch(request)
        } catch {
            print("Could not fetch tag from Core Data.")
        }

        // return results
        return tagList
    }
    
    func read(_ target: String = "departure", predicateFormat: String? = "target = %@", fetchLimit: Int? = nil) -> [NoteList] {
        // create a temp array to save fetched notes
        var results: [NoteList] = []
        // initialize the fetch request
        let request: NSFetchRequest<NoteList> = NoteList.fetchRequest()
        
        // define filter and/or limit if needed
        if predicateFormat != nil {
            request.predicate = NSPredicate(format: "target == %@", target)
        }
        if fetchLimit != nil {
            request.fetchLimit = fetchLimit!
        }

        // fetch with the request
        do {
            results = try container.viewContext.fetch(request)
        } catch {
            print("Could not fetch notes from Core Data.")
        }

        // return results
        return results
    }
}
