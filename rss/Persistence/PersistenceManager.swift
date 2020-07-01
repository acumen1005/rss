//
//  PersistenceManager.swift
//  rss
//
//  Created by 谷雷雷 on 2020/6/23.
//  Copyright © 2020 acumen. All rights reserved.
//

import Foundation
import CoreData

class PersistenceManager {
    lazy var managedObjectContext: NSManagedObjectContext = {
        let context = self.persistentContainer.viewContext
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }()
    
    lazy var persistentContainer: NSPersistentContainer  = {
        let container = NSPersistentContainer(name: "RSS")
        container.loadPersistentStores { (persistentStoreDescription, error) in
            if let error = error {
                fatalError(error.localizedDescription)
            }
        }
        return container
    }()
}
