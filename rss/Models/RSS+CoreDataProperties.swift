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
    @NSManaged public var isFetched: Bool
    
    public var rssURL: URL? {
        return URL(string: url)
    }
    
    public var createTimeStr: String {
        return "Last Update: \(self.createTime?.string() ?? "")"
    }
    
    static func create(url: String, title: String = "", desc: String = "", in context: NSManagedObjectContext) -> RSS {
        let rss = RSS(context: context)
        rss.title = title
        rss.desc = desc
        rss.url = url
        rss.uuid = UUID()
        rss.createTime = Date()
        rss.updateTime = Date()
        rss.isFetched = false
        return rss
    }
    
    static func simple() -> RSS {
        let rss = RSS(context: Persistence.current.context)
        rss.title = "demo"
        rss.desc = "desc demo"
        rss.url = "http://images.apple.com/main/rss/hotnews/hotnews.rss"
        return rss
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

