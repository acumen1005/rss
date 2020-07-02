//
//  PersistenceManager.swift
//  rss
//
//  Created by 谷雷雷 on 2020/6/23.
//  Copyright © 2020 acumen. All rights reserved.
//

import Foundation
import CoreData
import Combine

class Persistence {
    
    static private(set) var current = Persistence(version: 1)
    
    var context: NSManagedObjectContext {
        return container.viewContext
    }
    var container: NSPersistentContainer
    
    private let isStoreLoaded = CurrentValueSubject<Bool, Error>(false)
    
    init(directory: FileManager.SearchPathDirectory = .documentDirectory,
         domainMask: FileManager.SearchPathDomainMask = .userDomainMask,
         version vNumber: UInt) {
        let version = Version(vNumber)
        container = NSPersistentContainer(name: version.modelName)
        if let url = version.dbFileURL(directory, domainMask) {
            let store = NSPersistentStoreDescription(url: url)
            container.persistentStoreDescriptions = [store]
        }
        container.loadPersistentStores { [weak isStoreLoaded] (storeDescription, error) in
            if let error = error {
                isStoreLoaded?.send(completion: .failure(error))
            } else {
                isStoreLoaded?.value = true
            }
        }
        
    }
}

extension Persistence {
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
