//
//  SCoreDataManager.swift
//  TopAnime
//
//  Created by Jenny on 2022/5/20.
//

import UIKit
import CoreData

extension NSManagedObject {
    static var entityName: String {
        return String(describing: self)
    }
    
    static var entityDescription: NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext)!
    }
    
    static var managedObjectContext: NSManagedObjectContext {
        return SCoreDataManager.shared.managedObjectContext
    }
    
    static func createObject() -> Self {
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedObjectContext) as! Self
    }
    
    static func deleteAll() {
        for result in self.findAll() {
            managedObjectContext.delete(result)
        }
        
        SCoreDataManager.saveContext()
    }
    
    static func deleteBy(for predicate: NSPredicate? = nil) {
        for result in self.findBy(for: predicate) {
            managedObjectContext.delete(result)
        }
        
        SCoreDataManager.saveContext()
    }
    
    static func findAll<T: NSManagedObject>(sortedBy: String? = nil, ascending: Bool = true) -> [T] {
        let request = fetchRequest(sortedBy: sortedBy,
                                   ascending: ascending)
        
        do {
            return try managedObjectContext.fetch(request) as! [T]
        } catch (let error) {
            fatalError("\(error)")
        }
    }
    
    static func findBy<T: NSManagedObject>(for predicate: NSPredicate? = nil,
                                           sortedBy: String? = nil,
                                           ascending: Bool = true,
                                           fetchLimit: Int = 0) -> [T] {
        let request = fetchRequest(predicate: predicate,
                                   sortedBy: sortedBy,
                                   ascending: ascending,
                                   fetchLimit: fetchLimit)
        
        do {
            return try managedObjectContext.fetch(request) as! [T]
        } catch (let error) {
            fatalError("\(error)")
        }
    }
    
    private static func fetchRequest(predicate: NSPredicate? = nil,
                                     sortedBy: String? = nil,
                                     ascending: Bool = true,
                                     fetchLimit: Int = 0) -> NSFetchRequest<NSManagedObject> {
        let sortDescriptors: [NSSortDescriptor]? = sortedBy != nil ? [NSSortDescriptor(key: sortedBy!, ascending: ascending)] : nil
        
        return fetchRequest(predicate: predicate, sortDescriptors: sortDescriptors, fetchLimit: fetchLimit)
    }
    
    private static func fetchRequest(predicate: NSPredicate? = nil,
                                     sortDescriptors: [NSSortDescriptor]?,
                                     fetchLimit: Int = 0) -> NSFetchRequest<NSManagedObject> {
        let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        request.fetchLimit = fetchLimit
        
        return request
    }
}

struct SCoreDataManager {
    static let shared = SCoreDataManager()
    static let modelName = "TopAnime"
    
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("\(error)")
            }
        }
        
        return container
    }()
    
    var managedObjectContext: NSManagedObjectContext {
        get {
            return SCoreDataManager.shared.persistentContainer.viewContext
        }
    }
    
    static func newId() -> String {
        return "\(UUID().uuidString)"
    }
    
    static func saveContext() {
        do {
            try SCoreDataManager.shared.managedObjectContext.save()
        } catch (let error) {
            fatalError("\(error)")
        }
    }
}
