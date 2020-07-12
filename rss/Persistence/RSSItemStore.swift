//
//  RSSItemStore.swift
//  rss
//
//  Created by 谷雷雷 on 2020/6/29.
//  Copyright © 2020 acumen. All rights reserved.
//

import Foundation
import Combine
import CoreData
import FeedKit

class RSSItemStore: NSObject {
    
    private let persistence = Persistence.current

    private lazy var fetchedResultsController: NSFetchedResultsController<RSSItem> = {
        let fetchRequest: NSFetchRequest<RSSItem> = RSSItem.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createTime", ascending: false)]
        
        let fetechedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: persistence.context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        fetechedResultsController.delegate = self
        return fetechedResultsController
    }()
    
    var context: NSManagedObjectContext {
        return persistence.context
    }
    
    let didChange = PassthroughSubject<RSSItemStore, Never>()
    
    override init() {
        super.init()
        fetchRSS()
    }
    
    public func createAndSave(rss uuid: UUID, tilte: String, desc: String, author: String, url: String, createTime: Date) -> RSSItem {
        let item = RSSItem.create(uuid: uuid, title: tilte, desc: desc, author: author, url: url, createTime: createTime,
                                  in: persistence.context)
        saveChanges()
        return item
    }
    
    public func batchInsert(items: [RSSItem]) {
        items.forEach { item in
            item.didSave()
        }
    }
    
    public func fetchRSSItem(RSS item: RSS, start: Int, limit: Int = 20) throws -> [RSSItem] {
        guard let uuid = item.uuid else {
            throw RSSError.invalidParameter
        }
        let fetchRequest: NSFetchRequest<RSSItem> = RSSItem.fetchRequest()
        let predicate = NSPredicate(format: "rssUUID = %@", argumentArray: [uuid])
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createTime", ascending: false)]
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = limit
        fetchRequest.fetchOffset = start
        do {
            let rs = try fetchedResultsController.managedObjectContext.fetch(fetchRequest)
            rs.forEach { item in
                print("item created time = \(item.createTime)")
            }
            return rs
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
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch { fatalError() }
    }
}

extension RSSItemStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        didChange.send(self)
    }
}
