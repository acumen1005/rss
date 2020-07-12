//
//  RSSDataSource.swift
//  rss
//
//  Created by 谷雷雷 on 2020/7/11.
//  Copyright © 2020 acumen. All rights reserved.
//

import CoreData

class RSSDataSource: NSObject, DataSource {
    
    var parentContext: NSManagedObjectContext
    
    var createContext: NSManagedObjectContext
    
    var updateContext: NSManagedObjectContext
    
    var fetchedResult: NSFetchedResultsController<RSS>
    
    var newObject: RSS?
    
    var updateObject: RSS?
    
    required init(parentContext: NSManagedObjectContext) {
        self.parentContext = parentContext
        createContext = parentContext.newChildContext()
        updateContext = parentContext.newChildContext()
        
        let request = Model.fetchRequest() as NSFetchRequest<RSS>
        request.sortDescriptors = []
            
        fetchedResult = .init(
            fetchRequest: request,
            managedObjectContext: parentContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        super.init()
        fetchedResult.delegate = self
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        objectWillChange.send()
    }
}

extension RSSDataSource {
    func prepareNewObject() {
        guard newObject == nil else { return }
        newObject = RSS.create(in: createContext)
    }
}
