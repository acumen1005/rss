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


extension RSS {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RSS> {
        return NSFetchRequest<RSS>(entityName: "RSS")
    }

    @NSManaged public var url: String?
    @NSManaged public var title: String?
    @NSManaged public var desc: String?
    @NSManaged public var createTime: Date?
    @NSManaged public var updateTime: Date?
    @NSManaged public var uuid: UUID?
    @NSManaged public var isFetched: Bool
    
    public var createTimeStr: String {
        if let create = self.updateTime {
            return "Last Update: \(create.string())"
        }
        return ""
    }
    
    static func create(url: String, title: String? = nil, desc: String? = nil, in context: NSManagedObjectContext) -> RSS {
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
        let rss = RSS(context: PersistenceManager().managedObjectContext)
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
