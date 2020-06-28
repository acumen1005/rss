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
        self.rssSrouces = items;
    }
    
    public func create(url: String, title: String? = nil) -> RSS {
        let rss = RSS.create(
            url: url,
            title: title,
            in: persistenceManager.managedObjectContext
        )
        let aUrl = URL(string: url)!
        let parser = FeedParser(URL: aUrl)
        parser.parseAsync(queue: DispatchQueue.global()) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let feed):
                    print(feed)
                    rss.title = feed.rssFeed?.title
                    rss.desc = feed.rssFeed?.description
                    do {
                        try self.update(RSS: rss)
                    } catch let error {
                        print("error = \(error)")
                    }
                case .failure(let error):
                    print(error)
                }
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
                rss.createTime = Date()
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
