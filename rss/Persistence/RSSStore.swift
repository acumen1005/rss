//
//  RSSStore.swift
//  rss
//
//  Created by 谷雷雷 on 2020/6/23.
//  Copyright © 2020 acumen. All rights reserved.
//

import Foundation
import Combine
import CoreData
import FeedKit

class RSSStore: NSObject {
    
    private let persistenceManager = PersistenceManager()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<RSS> = {
        let fetchRequest: NSFetchRequest<RSS> = RSS.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createTime", ascending: false)]
        
        let fetechedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.persistenceManager.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        fetechedResultsController.delegate = self
        return fetechedResultsController
    }()
    
    let didChange = PassthroughSubject<RSSStore, Never>()
    
    public var items: [RSS] {
        return fetchedResultsController.fetchedObjects ?? []
    }
    
    public var rssSrouces: [RSS] = []
    
    override init() {
        super.init()
        fetchRSS()
        rssSrouces = items;
    }
    
    public func createAndSave(url: String, title: String? = nil) -> RSS {
        let rss = RSS.create(
            url: url,
            title: title,
            in: persistenceManager.managedObjectContext
        )
        fetchNewRSS(model: rss, url: URL(string: url)!) { result in
            switch result {
            case .success(let rss):
                do {
                    try self.update(RSS: rss)
                } catch let error {
                    print("error = \(error)")
                }
            case .failure(let error):
                print("error = \(error)")
            }
        }
        saveChanges()
        return rss
    }
    
    public func delete(_ object: RSS) {
        rssSrouces.removeAll { object.uuid == $0.uuid }
        persistenceManager.managedObjectContext.delete(object)
        saveChanges()
    }
    
    public func update(_ item: RSS) {
        do {
            try update(RSS: item)
        } catch let error {
            print("error = \(error)")
        }
    }
    
    private func update(RSS item: RSS) throws {
        guard let uuid = item.uuid else {
            return
        }
        let fetchRequest: NSFetchRequest<RSS> = RSS.fetchRequest()
        let predicate = NSPredicate(format: "uuid = %@", argumentArray: [uuid])
        fetchRequest.predicate = predicate
        do {
            let rs = try fetchedResultsController.managedObjectContext.fetch(fetchRequest)
            if let rss = rs.first {
                rss.title = item.title
                rss.desc = item.desc
                rss.url = item.url
                rss.lastFetchTime = item.lastFetchTime
                rss.createTime = item.createTime
                rss.updateTime = Date()
                saveChanges()
            } else {
                // TODO: throw Error
            }
        } catch let error {
            throw error
        }
    }
    
    private func fetchRSS() {
        do {
            try fetchedResultsController.performFetch()
            dump(fetchedResultsController.sections)
        } catch {
            fatalError()
        }
    }
    
    private func saveChanges() {
        guard persistenceManager.managedObjectContext.hasChanges else { return }
        do {
            try persistenceManager.managedObjectContext.save()
        } catch { fatalError() }
    }
}

extension RSSStore: ObservableObject {
    
}

extension RSSStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        didChange.send(self)
    }
}
