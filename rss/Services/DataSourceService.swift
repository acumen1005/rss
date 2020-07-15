//
//  DataSourceService.swift
//  rss
//
//  Created by 谷雷雷 on 2020/7/15.
//  Copyright © 2020 acumen. All rights reserved.
//

import UIKit

class DataSourceService: NSObject {
    
    static let current = DataSourceService()
    
    var rss = RSSDataSource(parentContext: Persistence.current.context)
    var rssItem = RSSItemDataSource(parentContext: Persistence.current.context)

}
