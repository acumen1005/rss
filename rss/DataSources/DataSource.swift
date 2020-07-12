//
//  DataSource.swift
//  rss
//
//  Created by 谷雷雷 on 2020/7/11.
//  Copyright © 2020 acumen. All rights reserved.
//

import CoreData
import Combine

/// A protocol for object required validation.
protocol ObjectValidatable {
    
//    /// Check if object is valid to save.
//    func isValid() -> Bool
//    
//    /// Check if object has valid inputs from the user.
//    func hasValidInputs() -> Bool
    
    /// Check if the object has changed values.
    func hasChangedValues() -> Bool
}


protocol DataSource: ObservableObject, NSFetchedResultsControllerDelegate {
    
    associatedtype Model: NSManagedObject & ObjectValidatable
    
    init(parentContext: NSManagedObjectContext)
    
    var parentContext: NSManagedObjectContext { get }

    var createContext: NSManagedObjectContext { get }
    
    var updateContext: NSManagedObjectContext { get }
    
    var fetchedResult: NSFetchedResultsController<Model> { set get }
    
    var newObject: Model? { set get }
    
    var updateObject: Model? { set get }
    
    func saveNewObject() -> DataSourceSaveResult
    
    func saveUpdateObject() -> DataSourceSaveResult
}


// MARK: - Save Result Enum

enum DataSourceSaveResult {
    case saved
    case failed
    case unchanged
}


// MARK: - Default Save & Update

extension DataSource {
    
    func saveNewObject() -> DataSourceSaveResult {
//        guard let object = newObject else { return .failed }
        saveCreateContext()
        return .saved
    }
    
    func saveUpdateObject() -> DataSourceSaveResult {
        guard let object = updateObject else { return .failed }
        object.objectWillChange.send()
        if object.hasChangedValues() {
            saveUpdateContext()
            return .saved
        } else {
            discardUpdateContext()
            return .unchanged
        }
    }
}


// MARK: - Fetch Method

extension DataSource {
    
    /// Perform fetch on the `fetchController`.
    /// - Parameter request: The request to perform or `nil` to perform the current request.
    func performFetch(_ request: NSFetchRequest<Model>? = nil) {
        if let request = request {
            fetchedResult.fetchRequest.predicate = request.predicate
            fetchedResult.fetchRequest.sortDescriptors = request.sortDescriptors
            fetchedResult.fetchRequest.fetchLimit = request.fetchLimit
            fetchedResult.fetchRequest.fetchOffset = request.fetchOffset
        }
        
        do {
            try fetchedResult.performFetch()
        } catch {
            print(error)
        }
    }
    
    /// Set fetch controller section key path.
    ///
    /// - Parameter keyPath: The key path to set.
    func setFetchResultSectionKeyPath(_ keyPath: String?) {
        let request = fetchedResult.fetchRequest
        let context = fetchedResult.managedObjectContext
        fetchedResult = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: keyPath,
            cacheName: nil
        )
        fetchedResult.delegate = self
    }
}

extension DataSource {
    
    func discardNewObject() {
        guard newObject != nil else { return }
        newObject = nil
    }
    
    func prepareNewObject() {
        guard newObject == nil else { return }
        newObject = Model(context: createContext)
    }
    
    func setUpdateObject(_ object: Model?) {
        if let object = object, object.managedObjectContext === updateContext {
            updateObject = object
        } else {
            updateObject = nil
        }
    }
    
    func readObject(_ object: Model) -> Model {
        updateContext.object(with: object.objectID) as! Model
    }
    
    func delete(_ object: Model, saveContext: Bool) {
        guard let context = object.managedObjectContext else { return }
        guard context === parentContext || context === updateContext else { return }
        context.delete(object)
        
        guard saveContext else { return }
        context.quickSave()
        
        guard context === updateContext else { return }
        parentContext.quickSave()
    }
}


extension DataSource {
    
    func saveCreateContext() {
        saveContext(createContext)
    }
    
    func discardCreateContext() {
        discardContext(createContext)
    }
    
    func saveUpdateContext() {
        saveContext(updateContext)
    }
    
    func discardUpdateContext() {
        discardContext(updateContext)
    }
    
    private func saveContext(_ context: NSManagedObjectContext) {
        guard context === createContext || context === updateContext else { return }
        guard context.hasChanges else { return }
        context.quickSave()
        parentContext.quickSave()
    }
 
    private func discardContext(_ context: NSManagedObjectContext) {
        guard context === createContext || context === updateContext else { return }
        guard context.hasChanges else { return }
        context.rollback()
    }
}
