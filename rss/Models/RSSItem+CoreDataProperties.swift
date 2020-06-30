//
//  RSSItem+CoreDataProperties.swift
//  rss
//
//  Created by 谷雷雷 on 2020/6/29.
//  Copyright © 2020 acumen. All rights reserved.
//
//

import Foundation
import CoreData

extension RSSItem: Identifiable {
    
}

extension RSSItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RSSItem> {
        return NSFetchRequest<RSSItem>(entityName: "RSSItem")
    }

    @NSManaged public var createTime: Date?
    @NSManaged public var desc: String?
    @NSManaged public var progress: Double
    @NSManaged public var rssUUID: UUID?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var uuid: UUID?
    @NSManaged public var author: String?
    
    
    static func create(uuid: UUID, title: String?, desc: String? = nil, author: String?, url: String?, createTime: Date?, progress: Double = 0, in context: NSManagedObjectContext) -> RSSItem {
        let item = RSSItem(context: context)
        item.rssUUID = uuid
        item.uuid = UUID()
        item.title = title
        item.desc = desc
        item.author = author
        item.url = url
        item.createTime = createTime
        item.progress = 0
        return item
    }
}
