//
//  CoreDataManager.swift
//  LocationSearch-EC
//
//  Created by Mac Mini 2 on 10/25/20.
//

import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()

    private var persistentContainer: NSPersistentContainer
    
    init() {
        let container = NSPersistentContainer(name: "LocalData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        persistentContainer = container
    }

    // MARK: - Core Data Saving support

    func saveContext(_ completion: ((_ error: NSError?)->())?) {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                completion?(nserror)
            }
        }
    }
}

extension CoreDataManager {
    func saveLocation(_ latitude: Double, _ longitude: Double, _ accuracy: Double, completion: ((_ error: NSError?)->Void)?) {
        guard let entity = NSEntityDescription.entity(
            forEntityName: "CurrentLocation",
            in: CoreDataManager.shared.persistentContainer.viewContext) else { return }
        let fetchRequest = NSFetchRequest<CurrentLocation>(entityName: "CurrentLocation")
        do {
            let locations = try CoreDataManager.shared.persistentContainer.viewContext.fetch(fetchRequest)
            if let location = locations.first {
                location.setValue(latitude, forKey: "latitude")
                location.setValue(longitude, forKey: "longitude")
                location.setValue(accuracy, forKey: "accuracy")
            } else {
                let location = NSManagedObject(entity: entity,
                                           insertInto: CoreDataManager.shared.persistentContainer.viewContext)
                location.setValue(latitude, forKey: "latitude")
                location.setValue(longitude, forKey: "longitude")
                location.setValue(accuracy, forKey: "accuracy")
            }
            CoreDataManager.shared.saveContext(completion)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func retrieveLocation() -> CurrentLocation? {
        let managedContext = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<CurrentLocation>(entityName: "CurrentLocation")
        do {
            let location = try managedContext.fetch(fetchRequest)
            return location.first
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
}
