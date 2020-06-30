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
    
    enum PersistenceEntity: String {
        case RSS = "RSS"
        case RSSItem = "RSSItem"
    }
    
    let entity: PersistenceEntity
    
    init(entity: PersistenceEntity) {
        self.entity = .RSS
    }
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let context = self.persistentContainer.viewContext
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }()
    
    lazy var persistentContainer: NSPersistentContainer  = {
        let container = NSPersistentContainer(name: self.entity.rawValue)
        container.loadPersistentStores { (persistentStoreDescription, error) in
            if let error = error {
                fatalError(error.localizedDescription)
            }
        }
        return container
    }()
}
