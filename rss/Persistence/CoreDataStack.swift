//
//  CoreDataStack.swift
//  rss
//
//  Created by 谷雷雷 on 2020/6/30.
//  Copyright © 2020 acumen. All rights reserved.
//

import Foundation
import Combine
import CoreData

protocol PersistentStore {
    typealias DBOperation<Result> = (NSManagedObjectContext) throws -> Result
    
    func count<T>(_ fetchRequest: NSFetchRequest<T>) -> AnyPublisher<Int, Error>
    func fetch<T, V>(_ fetchRequest: NSFetchRequest<T>,
                     map: @escaping (T) throws -> V?) -> AnyPublisher<Array<V>, Error>
    func update<Result>(_ operation: @escaping DBOperation<Result>) -> AnyPublisher<Result, Error>
}


struct CoreDataStack: PersistentStore {
    
    private let container: NSPersistentContainer
    private let isStoreLoaded = CurrentValueSubject<Bool, Error>(false)
    private let bgQueue = DispatchQueue(label: "com.acumen.rss.coredata")
    
    private var onStoreIsReady: AnyPublisher<Void, Error> {
        return isStoreLoaded
            .filter { $0 }
            .map { _ in }
            .eraseToAnyPublisher()
    }
    
    init(directory: FileManager.SearchPathDirectory = .documentDirectory,
         domainMask: FileManager.SearchPathDomainMask = .userDomainMask,
         version vNumber: UInt) {
        let version = Version(vNumber)
        container = NSPersistentContainer(name: version.modelName)
        if let url = version.dbFileURL(directory, domainMask) {
            let store = NSPersistentStoreDescription(url: url)
            container.persistentStoreDescriptions = [store]
        }
        container.loadPersistentStores { [weak isStoreLoaded, weak container] (storeDescription, error) in
            if let error = error {
                isStoreLoaded?.send(completion: .failure(error))
            } else {
                container?.viewContext.configureAsReadOnlyContext()
                isStoreLoaded?.value = true
            }
        }
        
//        container.managedObjectModel.
//        bgQueue.async { [weak isStoreLoaded, weak container] in
//
//        }
    }
    
    func count<T>(_ fetchRequest: NSFetchRequest<T>) -> AnyPublisher<Int, Error> where T : NSFetchRequestResult {
        return onStoreIsReady
            .flatMap { [weak container] in
                Future<Int, Error> { promise in
                    do {
                        let count = try container?.viewContext.count(for: fetchRequest) ?? 0
                        promise(.success(count))
                    } catch let error {
                        promise(.failure(error))
                    }
                }
            }
            .eraseToAnyPublisher()
    }
    
    
    func fetch<T, V>(_ fetchRequest: NSFetchRequest<T>, map: @escaping (T) throws -> V?) -> AnyPublisher<Array<V>, Error> where T : NSFetchRequestResult {
        assert(Thread.isMainThread)
        let fetch = Future<Array<V>, Error> { [weak container] promise in
            guard let context = container?.viewContext else { return }
            context.performAndWait {
                do {
                    let managedObjects = try context.fetch(fetchRequest)
                    let result = managedObjects.compactMap { reqResult -> V? in
                        do {
                            let mapped = try map(reqResult)
                            if let mo = reqResult as? NSManagedObject {
                                context.refresh(mo, mergeChanges: false)
                            }
                            return mapped
                        } catch {
                            print("compactMap error: \(error)")
                            return nil
                        }
                    }
                    promise(.success(result))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        return onStoreIsReady
            .flatMap { fetch }
            .eraseToAnyPublisher()
    }
    
    func update<Result>(_ operation: @escaping DBOperation<Result>) -> AnyPublisher<Result, Error> {
        let update = Future<Result, Error> { [weak bgQueue, weak container] promise in
            bgQueue?.async {
                guard let context = container?.newBackgroundContext() else { return }
                context.configureAsUpdateContext()
                context.performAndWait {
                    do {
                        let result = try operation(context)
                        if context.hasChanges {
                            try context.save()
                        }
                        context.reset()
                        promise(.success(result))
                    } catch {
                        context.reset()
                        promise(.failure(error))
                    }
                }
            }
        }
        return onStoreIsReady
            .flatMap { update }
            .receive(on: DispatchQueue.main) // bgqueue
            .eraseToAnyPublisher()
    }
}

extension CoreDataStack.Version {
    static var actual: UInt { 1 }
}

extension CoreDataStack {
    struct Version {
        private let number: UInt
        
        init(_ number: UInt) {
            self.number = number
        }
        
        var modelName: String {
            return "RSS"
        }
        
        func dbFileURL(_ directory: FileManager.SearchPathDirectory,
                       _ domainMask: FileManager.SearchPathDomainMask) -> URL? {
            return FileManager.default
                .urls(for: directory, in: domainMask).first?
                .appendingPathComponent(subpathToDB)
        }
        
        private var subpathToDB: String {
            return "\(modelName).sql"
        }
    }
}
