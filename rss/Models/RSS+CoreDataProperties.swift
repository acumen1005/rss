//
//  RSS+CoreDataProperties.swift
//  rss
//
//  Created by 谷雷雷 on 2020/6/23.
//  Copyright © 2020 acumen. All rights reserved.
//
//

import Foundation
import CoreData
import FeedKit


extension RSS {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RSS> {
        return NSFetchRequest<RSS>(entityName: "RSS")
    }

    @NSManaged public var url: String
    @NSManaged public var title: String
    @NSManaged public var desc: String
    @NSManaged public var createTime: Date!
    @NSManaged public var updateTime: Date!
    @NSManaged public var lastFetchTime: Date?
    @NSManaged public var uuid: UUID?
    @NSManaged public var image: String
    @NSManaged public var isFetched: Bool
    
    public var rssURL: URL? {
        return URL(string: url)
    }
    
    public var createTimeStr: String {
        return "Last Update: \(self.createTime?.string() ?? "")"
    }
    
    static func create(url: String = "", title: String = "", desc: String = "", image: String = "", in context: NSManagedObjectContext) -> RSS {
        let rss = RSS(context: context)
        rss.title = title
        rss.desc = desc
        rss.url = url
        rss.image = image
        rss.uuid = UUID()
        rss.createTime = Date()
        rss.updateTime = Date()
        rss.isFetched = false
        return rss
    }
    
    static func simple(image: String = "") -> RSS {
        let rss = RSS(context: Persistence.current.context)
        rss.title = "demo"
        rss.image = image
        rss.desc = "desc demo"
        rss.url = "http://images.apple.com/main/rss/hotnews/hotnews.rss"
        return rss
    }
    
    static func requestObjects() -> NSFetchRequest<RSS> {
        let request = RSS.fetchRequest() as NSFetchRequest<RSS>
        request.predicate = .init(value: true)
        request.sortDescriptors = [.init(key: #keyPath(RSS.createTime), ascending: false)]
        return request
    }
}

extension RSS {
    static func == (lhs: RSS, rhs: RSS) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}

extension RSS {
    func update(from feed: Feed) {
        let rss = self
        switch feed {
        case .atom(let atomFeed):
            rss.title = atomFeed.title ?? ""
        case .json(let jsonFeed):
            rss.title = jsonFeed.title ?? ""
            rss.desc = jsonFeed.description?.trimWhiteAndSpace ?? ""
        case .rss(let rssFeed):
            rss.title = rssFeed.title ?? ""
            rss.desc = rssFeed.description?.trimWhiteAndSpace ?? ""
        }
    }
}

extension RSS: ObjectValidatable {
    func hasChangedValues() -> Bool {
        return hasPersistentChangedValues
    }
}

